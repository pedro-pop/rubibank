// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  id: (json['id'] as num).toInt(),
  id_user: (json['id_user'] as num).toInt(),
  tipo: json['tipo'] as String,
  valor: (json['valor'] as num).toInt(),
  id_transfer: (json['id_transfer'] as num).toInt(),
  create_at: DateTime.parse(json['create_at'] as String),
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_user': instance.id_user,
      'tipo': instance.tipo,
      'valor': instance.valor,
      'id_transfer': instance.id_transfer,
      'create_at': instance.create_at.toIso8601String(),
    };
