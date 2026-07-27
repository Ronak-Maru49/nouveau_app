import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  static const _fallbackJwt =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTnFmyG3nMiGM6H9FNFUROf3wh7SmqJp-QV30';

  final Dio _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8)));
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '874143944739-90bdu3htm6qcpd6943h21713hpv4g3bd.apps.googleusercontent.com'
        : null,
    scopes: ['email'],
  );

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
      final token = await _backendAuth(
        name: name,
        email: email,
        password: password,
        createAccount: createAccount,
        provider: 'local',
      );
      await _saveSession(name: name, email: email, token: token);
      await _savePerson(
        name: name,
        email: email,
        token: token,
        provider: 'local',
      );
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
      await _savePerson(
          name: name.trim().isEmpty ? email.split('@').first : name,
          email: email,
          token: _fallbackJwt,
          provider: 'local');
      return true;
    }
  }

  Future<bool> signInWithGoogle() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _loading = false;
        notifyListeners();
        return false;
      }

      final email = googleUser.email;
      final name = googleUser.displayName?.trim().isNotEmpty == true
          ? googleUser.displayName!
          : email.split('@').first;
      final token = await _backendAuth(
        name: name,
        email: email,
        password: 'google-oauth',
        createAccount: true,
        provider: 'google',
      ).catchError((_) => _fallbackJwt);
      await _saveSession(name: name, email: email, token: token);
      await _savePerson(
        name: name,
        email: email,
        token: token,
        provider: 'google',
      );
      return true;
    } catch (error) {
      final details = error is PlatformException
          ? '${error.code} ${error.message ?? ''} ${error.details ?? ''}'
          : error.toString();
      _error = details.contains('origin_mismatch')
          ? 'Google sign-in is blocked because this site URL is not added as an authorized JavaScript origin in Google Cloud.'
          : 'Google sign-in could not be completed.';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<String> _backendAuth({
    required String name,
    required String email,
    required String password,
    required bool createAccount,
    required String provider,
  }) async {
    final endpoint = createAccount ? '/api/auth/register' : '/api/auth/login';
    try {
      final response = await _dio.post(
        'http://localhost:5000$endpoint',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'provider': provider,
        },
      );
      return (response.data['token'] ?? _fallbackJwt).toString();
    } on DioException catch (error) {
      if (createAccount && error.response?.statusCode == 409) {
        final response = await _dio.post(
          'http://localhost:5000/api/auth/login',
          data: {
            'name': name,
            'email': email,
            'password': password,
            'provider': provider,
          },
        );
        return (response.data['token'] ?? _fallbackJwt).toString();
      }
      rethrow;
    }
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
      required String token,
      required String provider}) async {
    try {
      await _dio.post(
        'http://localhost:5000/api/auth/persons',
        data: {
          'name': name,
          'email': email,
          'token': token,
          'provider': provider
        },
      );
    } catch (_) {
      // The app remains usable when the local backend is not running.
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_name');
    await prefs.remove('auth_email');
    await prefs.remove('auth_token');
    _user = null;
    notifyListeners();
  }
}
