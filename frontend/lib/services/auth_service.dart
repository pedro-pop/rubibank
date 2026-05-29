/// Serviço de autenticação - preparado para integração futura com Firebase Auth.
/// TODO: Substituir métodos mock por chamadas reais do Firebase Auth.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  bool _isLoggedIn = false;
  String? _currentUserId;

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserId => _currentUserId;

  /// TODO: Integrar com Firebase Auth - signInWithEmailAndPassword
  Future<AuthResult> login(String email, String password) async {
    // Simulando delay de rede
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mock: qualquer email/senha funciona para demo
    if (email.isNotEmpty && password.length >= 6) {
      _isLoggedIn = true;
      _currentUserId = 'usr_001';
      return AuthResult.success();
    }
    return AuthResult.error('Email ou senha inválidos.');
  }

  /// TODO: Integrar com Firebase Auth - createUserWithEmailAndPassword
  Future<AuthResult> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    _isLoggedIn = true;
    _currentUserId = 'usr_new';
    return AuthResult.success();
  }

  /// TODO: Integrar com Firebase Auth - signOut
  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUserId = null;
  }

  /// TODO: Integrar com local_auth para biometria real
  Future<bool> authenticateWithBiometrics() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true; // Mock: sempre sucesso
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
