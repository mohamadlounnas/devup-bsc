import 'dart:io';
import 'package:admin_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service responsible for handling authentication using PocketBase
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
    }

    if (error is ClientException) {
      if (error.statusCode == 0) {
        if (error.originalError is SocketException) {
          // Check specific socket error types
          final socketError = error.originalError as SocketException;
          if (socketError.osError?.errorCode == 1) {
            return 'Network access denied. Please check your internet permissions and connection.';
          }
          return 'Connection failed. Please check your internet connection and try again.';
        }
        return 'Unable to connect to server. Please check if the server is accessible.';
      }
      if (error.response != null && error.response is Map) {
        if (error.response['message'] != null) {
          return error.response['message'].toString();
        }
      }
      return 'Server error: ${error.statusCode}';
    }

    if (error is SocketException) {
      return 'Network error. Please check your internet connection and server accessibility.';
    }

    if (error is FormatException) {
      return 'Invalid response from server. Please try again.';
    }

    return 'An unexpected error occurred. Please try again.';
  }

  /// Login with email and password
  Future<User> loginWithCredentials(String email, String password) async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        _loading = true;
        _error = null;
        notifyListeners();

        if (kDebugMode) {
          print(
              'Attempting login for email: $email (Attempt ${retryCount + 1})');
        }

        final authData = await _pb.collection('users').authWithPassword(
              email,
              password,
            );

        if (authData.record != null) {
          _currentUser = User.fromJson(authData.record!.toJson());
          await saveCredentials(email, password);

          _loading = false;
          notifyListeners();
          return _currentUser!;
        } else {
          throw const FormatException('Invalid response from server');
        }
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          _loading = false;
          _error = _handleError(e);
          notifyListeners();
          throw _error!;
        }
        // Wait before retrying
        await Future.delayed(Duration(seconds: retryCount));
      }
    }
    throw 'Maximum retry attempts reached';
  }

  /// Logout the current user
  Future<void> logoutUser() async {
    try {
      _loading = true;
      notifyListeners();

      _pb.authStore.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('saved_username');
      await prefs.remove('saved_password');
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

  Future<void> saveCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_username', username);
    await prefs.setString('saved_password', password);
  }

  Future<Map<String, String>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('saved_username');
    final password = prefs.getString('saved_password');

    if (username != null && password != null) {
      return {
        'username': username,
        'password': password,
      };
    }
    return null;
  }
}

class PermissionService extends ChangeNotifier {
  PermissionService._();
  static final PermissionService _instance = PermissionService._();
  static PermissionService get instance => _instance;

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  bool hasHostelPermission = false;
  bool hasEventPermission = false;

  Future<void> checkPermission(String permission) async {
    try {
      var userHostels = await pb.collection('hostels').getFirstListItem(
            'admin = "${pb.authStore.model.id}"',
          );
      if (userHostels.data['admin'] == pb.authStore.model.id) {
        hasHostelPermission = true;
        notifyListeners();
        return;
      }
    } catch (e) {}

    try {
      var userEvents = await pb.collection('facilities').getFirstListItem(
            'manager = "${pb.authStore.model.id}"',
          );

      if (userEvents.data['manager'] == pb.authStore.model.id) {
        hasEventPermission = true;
        notifyListeners();
        return;
      }
    } catch (e) {}
  }
}
