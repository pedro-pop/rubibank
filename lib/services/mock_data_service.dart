import '../models/transaction.dart';
import '../models/user_model.dart';
import '../models/cotacao_model.dart';

/// Serviço de dados mockados para desenvolvimento do front-end.
/// TODO: Substituir por chamadas reais ao Firebase/backend quando integrado.
class MockDataService {
  MockDataService._();

  static UserModel get currentUser => UserModel(
        id: 'usr_001',
        name: 'Carlos Oliveira',
        email: 'carlos.oliveira@email.com',
        cpf: '123.456.789-00',
        balance: 12850.75,
        createdAt: DateTime(2024, 1, 15),
      );

  static CotacaoModel get cotacao => CotacaoModel.mock;

  static double get balanceUSD => currentUser.balance / cotacao.usdBrl;
  static double get balanceEUR => currentUser.balance / cotacao.eurBrl;

  static double get savingsGoalCurrent => 7200.0;
  static double get savingsGoalTarget => 15000.0;

  static List<Transaction> get transactions => [
        Transaction(
          id: 'txn_001',
          title: 'Salário',
          description: 'Pagamento mensal',
          amount: 5000.00,
          date: DateTime.now().subtract(const Duration(days: 1)),
          type: TransactionType.income,
          icon: 'salary',
        ),
        Transaction(
          id: 'txn_002',
          title: 'Mercado Extra',
          description: 'Compras do mês',
          amount: -387.45,
          date: DateTime.now().subtract(const Duration(days: 2)),
          type: TransactionType.expense,
          icon: 'shopping',
        ),
        Transaction(
          id: 'txn_003',
          title: 'Transferência',
          description: 'Para Ana Lima',
          amount: -250.00,
          date: DateTime.now().subtract(const Duration(days: 3)),
          type: TransactionType.transfer,
          recipient: 'Ana Lima',
          icon: 'transfer',
        ),
        Transaction(
          id: 'txn_004',
          title: 'Netflix',
          description: 'Assinatura mensal',
          amount: -55.90,
          date: DateTime.now().subtract(const Duration(days: 4)),
          type: TransactionType.expense,
          icon: 'subscription',
        ),
        Transaction(
          id: 'txn_005',
          title: 'Freelance Design',
          description: 'Projeto website',
          amount: 1200.00,
          date: DateTime.now().subtract(const Duration(days: 6)),
          type: TransactionType.income,
          icon: 'work',
        ),
        Transaction(
          id: 'txn_006',
          title: 'Combustível',
          description: 'Posto Shell',
          amount: -180.00,
          date: DateTime.now().subtract(const Duration(days: 8)),
          type: TransactionType.expense,
          icon: 'fuel',
        ),
      ];

  // Dados para o gráfico de gastos semanal
  static List<double> get weeklyExpenses => [
        320.0,
        150.0,
        480.0,
        220.0,
        390.0,
        560.0,
        280.0,
      ];

  static List<String> get weekDays => ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];
}
