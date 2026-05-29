import 'package:json_annotation/json_annotation.dart';
part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  Transaction({
    required this.id,
    required this.id_user,
    required this.tipo,
    required this.valor,
    required this.id_transfer,
    required this.create_at,
  });

  final int id;
  final int id_user;
  final String tipo;
  final int valor;
  final int id_transfer;
  final DateTime create_at;

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}