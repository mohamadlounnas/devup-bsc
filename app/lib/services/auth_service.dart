import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Service responsible for handling user authentication
class AuthService extends ChangeNotifier {
  static AuthService? _instance;
  final PocketBase _pb;
  User? _currentUser;
  bool _loading = false;
  String? _error;

  // Private constructor
  AuthService._internal(this._pb);

  /// Factory constructor to maintain singleton instance
  factory AuthService(PocketBase pb) {
    _instance ??= AuthService._internal(pb);
    return _instance!;
  }

  /// Get the singleton instance
  static AuthService get instance {
    assert(_instance != null,
        'AuthService must be initialized with PocketBase instance first');
    return _instance!;
  }

  /// Current authenticated user
  User? get currentUser => _currentUser;

  /// Loading state
  bool get loading => _loading;

  /// Error message if any
  String? get error => _error;

  /// Authentication state
  bool get isAuthenticated => _currentUser != null;

  /// Handle various error types and return user-friendly messages
  String _handleError(dynamic error) {
    if (error is ClientException) {
      if (error.response['message'] != null) {
        return error.response['message'];
      }
      if (error.statusCode == 400) {
        return 'Invalid credentials. Please check your phone number and try again.';
      }
      if (error.statusCode == 403) {
        return 'Access denied. Please check your credentials.';
      }
      if (error.statusCode == 404) {
        return 'User not found. Please register first.';
      }
    }

    if (error is FormatException) {
      return 'Invalid response from server. Please try again.';
    }

    return 'An unexpected error occurred. Please try again.';
  }

  /// Register a new user
  Future<User> register({
    required String phone,
    required String firstName,
    required String lastName,
    String? email,
    String? address,
  }) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final body = {
        'phone': phone,
        'firstName': firstName,
        'lastName': lastName,
        if (email != null) 'email': email,
        if (address != null) 'address': address,
      };

      final record = await _pb.collection('users').create(body: body);
      _currentUser = User.fromJson(record.toJson());

      _loading = false;
      notifyListeners();
      return _currentUser!;
    } catch (e) {
      _loading = false;
      _error = _handleError(e);
      notifyListeners();
      throw _error!;
    }
  }

  /// Login with phone number and verification code
  Future<User> loginWithPhone(String phone, String verificationCode) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final authData = await _pb.collection('users').authWithPassword(
        phone,
        verificationCode,
      );

      if (authData.record != null) {
        _currentUser = User.fromJson(authData.record!.toJson());
        await _saveAuthState(phone, verificationCode);

        _loading = false;
        notifyListeners();
        return _currentUser!;
      } else {
        throw const FormatException('Invalid response from server');
      }
    } catch (e) {
      _loading = false;
      _error = _handleError(e);
      notifyListeners();
      throw _error!;
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    try {
      _loading = true;
      notifyListeners();

      _pb.authStore.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_phone');
      await prefs.remove('auth_code');
      _currentUser = null;

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = _handleError(e);
      notifyListeners();
      throw _error!;
    }
  }

  /// Check and update the current authentication state
  Future<void> checkAuthState() async {
    try {
      if (_pb.authStore.isValid) {
        final record = await _pb.collection('users').getOne(
          _pb.authStore.model.id,
        );
        _currentUser = User.fromJson(record.toJson());
        _error = null;
      } else {
        _currentUser = null;
      }
    } catch (e) {
      _currentUser = null;
      _error = _handleError(e);
      if (kDebugMode) {
        print('Auth state check error: $_error');
      }
    }
    notifyListeners();
  }

  /// Save authentication state
  Future<void> _saveAuthState(String phone, String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_phone', phone);
    await prefs.setString('auth_code', code);
  }

  /// Get saved authentication state
  Future<Map<String, String>?> getSavedAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('auth_phone');
    final code = prefs.getString('auth_code');

    if (phone != null && code != null) {
      return {
        'phone': phone,
        'code': code,
      };
    }
    return null;
  }
} 