class UserModel {
  final String id;
  final String name;
  final String email;
  final String cpf;
  final double balance;
  final String? avatarUrl;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.cpf,
    required this.balance,
    this.avatarUrl,
    required this.createdAt,
  });

  String get firstName => name.split(' ').first;

  // TODO: Implementar fromJson/toJson quando Firebase for integrado
  // factory UserModel.fromJson(Map<String, dynamic> json) { ... }
  // Map<String, dynamic> toJson() { ... }
}
