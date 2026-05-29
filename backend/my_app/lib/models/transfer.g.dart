// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transfer _$TransferFromJson(Map<String, dynamic> json) => Transfer(
  id: (json['id'] as num).toInt(),
  id_remetente: (json['id_remetente'] as num).toInt(),
  id_destinatario: (json['id_destinatario'] as num).toInt(),
  valor: (json['valor'] as num).toInt(),
  create_at: DateTime.parse(json['create_at'] as String),
);

Map<String, dynamic> _$TransferToJson(Transfer instance) => <String, dynamic>{
  'id': instance.id,
  'id_remetente': instance.id_remetente,
  'id_destinatario': instance.id_destinatario,
  'valor': instance.valor,
  'create_at': instance.create_at.toIso8601String(),
};
