import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço de autenticação integrado com a API JWT.
/// Backend: dart_frog rodando em localhost:8080
/// No emulador Android, localhost = 10.0.2.2
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  // URL base da API — no emulador Android usar 10.0.2.2 no lugar de localhost
  static const String _baseUrl = 'http://localhost:8080';
  static const String _tokenKey = 'jwt_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  bool _isLoggedIn = false;
  String? _token;
  String? _userEmail;
  String? _userName;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  String? get userEmail => _userEmail;
  String? get userName => _userName;

  /// Verifica se há token salvo e faz login automático
  Future<bool> checkSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString(_tokenKey);
    if (savedToken != null) {
      _token = savedToken;
      _userEmail = prefs.getString(_userEmailKey);
      _userName = prefs.getString(_userNameKey);
      _isLoggedIn = true;
      return true;
    }
    return false;
  }

  /// Login com email e senha via API JWT
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final token = data['token'] as String;

        // Salva token localmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        await prefs.setString(_userEmailKey, email);

        _token = token;
        _userEmail = email;
        _isLoggedIn = true;

        return AuthResult.success();
      } else if (response.statusCode == 401) {
        return AuthResult.error('Email ou senha inválidos.');
      } else {
        return AuthResult.error('Erro no servidor. Tente novamente.');
      }
    } catch (e) {
      return AuthResult.error('Erro de conexão com o servidor.');
    }
  }

  /// Cadastro de novo usuário via API
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String cpf,
    required String telefone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'cpf': cpf,
          'telefone': telefone,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return AuthResult.success();
      } else if (response.statusCode == 409) {
        return AuthResult.error('CPF ou email já cadastrados.');
      } else {
        return AuthResult.error('Erro ao realizar cadastro.');
      }
    } catch (e) {
      return AuthResult.error('Erro de conexão com o servidor.');
    }
  }

  /// Logout — remove token salvo
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    _isLoggedIn = false;
    _token = null;
    _userEmail = null;
    _userName = null;
  }

  /// Retorna headers com token JWT para requisições autenticadas
  Map<String, String> get authHeaders => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  /// TODO: Integrar com local_auth para biometria real
  Future<bool> authenticateWithBiometrics() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}

class AuthResult {
  final bool success;
  final String? errorMessage;

  const AuthResult._({required this.success, this.errorMessage});

  factory AuthResult.success() => const AuthResult._(success: true);
  factory AuthResult.error(String message) =>
      AuthResult._(success: false, errorMessage: message);
}
