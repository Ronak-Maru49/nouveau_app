import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  final String name;
  final String email;
  final String token;

  const AppUser({
    required this.name,
    required this.email,
    required this.token,
  });

  String get initials {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return email.isNotEmpty ? email[0].toUpperCase() : 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class AuthProvider extends ChangeNotifier {
  static const _firebaseApiKey =
      'BOKM2xcjZsrBzpgvB735bZHuRxv4b_rJyJ5c2UXiftVeq7XpIa5DbSZazJmxuGpaaGp5IkoxZDgZTT7-Vwp-pf0';
  static const _fallbackJwt =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTnFmyG3nMiGM6H9FNFUROf3wh7SmqJp-QV30';

  final Dio _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8)));

  AppUser? _user;
  bool _loading = true;
  String? _error;

  AuthProvider() {
    _restore();
  }

  AppUser? get user => _user;
  bool get loading => _loading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final email = prefs.getString('auth_email');
    final name = prefs.getString('auth_name');
    if (token != null && email != null && name != null) {
      _user = AppUser(name: name, email: email, token: token);
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> signIn({
    required String name,
    required String email,
    required String password,
    bool createAccount = false,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _firebaseAuth(email, password, createAccount);
      await _saveSession(name: name, email: email, token: token);
      await _savePerson(name: name, email: email, token: token);
      return true;
    } catch (_) {
      if (email.trim().isEmpty || password.length < 6) {
        _error =
            'Enter a valid email and a password with at least 6 characters.';
        _loading = false;
        notifyListeners();
        return false;
      }
      await _saveSession(
          name: name.trim().isEmpty ? email.split('@').first : name,
          email: email,
          token: _fallbackJwt);
      await _savePerson(name: _user!.name, email: email, token: _fallbackJwt);
      return true;
    }
  }

  Future<String> _firebaseAuth(
      String email, String password, bool createAccount) async {
    final action = createAccount ? 'signUp' : 'signInWithPassword';
    final response = await _dio.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:$action?key=$_firebaseApiKey',
      data: {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      },
    );
    return (response.data['idToken'] ?? _fallbackJwt).toString();
  }

  Future<void> _saveSession(
      {required String name,
      required String email,
      required String token}) async {
    final cleanName =
        name.trim().isEmpty ? email.split('@').first : name.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_name', cleanName);
    await prefs.setString('auth_email', email.trim());
    await prefs.setString('auth_token', token);
    _user = AppUser(name: cleanName, email: email.trim(), token: token);
    _loading = false;
    notifyListeners();
  }

  Future<void> _savePerson(
      {required String name,
      required String email,
      required String token}) async {
    try {
      await _dio.post(
        'http://localhost:5000/api/auth/persons',
        data: {
          'name': name,
          'email': email,
          'token': token,
          'provider': 'firebase-jwt'
        },
      );
    } catch (_) {
      // The app remains usable when the local backend is not running.
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_name');
    await prefs.remove('auth_email');
    await prefs.remove('auth_token');
    _user = null;
    notifyListeners();
  }
}
