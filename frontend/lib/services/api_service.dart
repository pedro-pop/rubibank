import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

/// Serviço central para chamadas à API do backend.
/// Backend: dart_frog em localhost:8080
/// No emulador Android usar 10.0.2.2 no lugar de localhost
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  static const String _baseUrl = 'http://localhost:8080';

  /// GET /transactions — busca transações do usuário logado
  Future<ApiResult<List<Map<String, dynamic>>>> getTransactions() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/transactions'),
        headers: AuthService.instance.authHeaders,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return ApiResult.success(data.cast<Map<String, dynamic>>());
      }
      return ApiResult.error('Erro ao carregar transações.');
    } catch (e) {
      return ApiResult.error('Erro de conexão com o servidor.');
    }
  }

  /// GET saldo do usuário via token JWT
  Future<ApiResult<int>> getSaldo() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/'),
        headers: AuthService.instance.authHeaders,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final saldo = data['saldo_conta'] as int? ?? 0;
        return ApiResult.success(saldo);
      }
      return ApiResult.error('Erro ao carregar saldo.');
    } catch (e) {
      return ApiResult.error('Erro de conexão com o servidor.');
    }
  }

  /// POST /transfers — realiza transferência
  Future<ApiResult<int>> transfer({
    required String emailDestinatario,
    required int valor,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/transfers'),
        headers: AuthService.instance.authHeaders,
        body: jsonEncode({
          'email_destinatario': emailDestinatario,
          'valor_transferencia': valor,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final novoSaldo = data['saldo_conta'] as int? ?? 0;
        return ApiResult.success(novoSaldo);
      } else if (response.statusCode == 400) {
        return ApiResult.error('Saldo insuficiente.');
      } else if (response.statusCode == 404) {
        return ApiResult.error('Conta de destino não encontrada.');
      }
      return ApiResult.error('Erro ao realizar transferência.');
    } catch (e) {
      return ApiResult.error('Erro de conexão com o servidor.');
    }
  }
}

class ApiResult<T> {
  final bool success;
  final T? data;
  final String? errorMessage;

  const ApiResult._({required this.success, this.data, this.errorMessage});

  factory ApiResult.success(T data) =>
      ApiResult._(success: true, data: data);
  factory ApiResult.error(String message) =>
      ApiResult._(success: false, errorMessage: message);
}
