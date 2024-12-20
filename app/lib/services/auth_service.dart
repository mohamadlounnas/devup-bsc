import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared/models/user.dart';

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
    if (kDebugMode) {
      print('Auth Error: $error');
      if (error is ClientException) {
        print('Response data: ${error.response}');
      }
    }

    if (error is ClientException) {
      if (error.response['message'] != null) {
        return error.response['message'];
      }
      if (error.statusCode == 400) {
        // Check for validation errors
        if (error.response['data'] != null) {
          final data = error.response['data'] as Map<String, dynamic>;
          final errors = data.entries.map((e) => '${e.key}: ${(e.value as Map)['message']}').join('\n');
          return 'Validation errors:\n$errors';
        }
        return 'Invalid credentials. Please check your email and password.';
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
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstname,
    required String lastname,
    required String phone,
    required Gender gender,
    required UserType type,
    String? nationalId,
    DateTime? dateOfBirth,
    String? placeOfBirth,
  }) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final body = {
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'gander': gender.name,
        'type': type.name,
        if (nationalId != null) 'national_id': nationalId,
        if (dateOfBirth != null) 'date_of_birth': dateOfBirth.toIso8601String(),
        if (placeOfBirth != null) 'place_of_birth': placeOfBirth,
      };

      final record = await _pb.collection('users').create(body: body);
      _currentUser = User.fromJson({
        'id': record.id,
        'email': email,
        ...record.toJson(),
        'created': record.created,
        'updated': record.updated,
      });

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

  /// Login with email and password
  Future<User> login(String email, String password) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final authData = await _pb.collection('users').authWithPassword(
        email,
        password,
      );

      if (authData.record != null) {
        _currentUser = User.fromJson(authData.record!.toJson());
        await _saveAuthState(email, password);

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
      await prefs.remove('auth_email');
      await prefs.remove('auth_password');
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
  Future<void> _saveAuthState(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_email', email);
    await prefs.setString('auth_password', password);
  }

  /// Get saved authentication state
  Future<Map<String, String>?> getSavedAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('auth_email');
    final password = prefs.getString('auth_password');

    if (email != null && password != null) {
      return {
        'email': email,
        'password': password,
      };
    }
    return null;
  }
} 