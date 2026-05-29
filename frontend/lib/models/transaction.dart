enum TransactionType { income, expense, transfer }

class Transaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String? icon;
  final String? recipient;

  const Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    this.icon,
    this.recipient,
  });

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  // TODO: Implementar fromJson/toJson quando backend for integrado
  // factory Transaction.fromJson(Map<String, dynamic> json) { ... }
  // Map<String, dynamic> toJson() { ... }
}
