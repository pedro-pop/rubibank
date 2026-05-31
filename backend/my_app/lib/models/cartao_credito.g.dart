// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartao_credito.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartaoCredito _$CartaoCreditoFromJson(Map<String, dynamic> json) =>
    CartaoCredito(
      id: (json['id'] as num).toInt(),
      id_user: (json['id_user'] as num).toInt(),
      numeroCartao: json['numeroCartao'] as String,
      nomeTitular: json['nomeTitular'] as String,
      dataValidade: json['dataValidade'] as String,
      cvv: json['cvv'] as String,
      limite: (json['limite'] as num).toInt(),
    );

Map<String, dynamic> _$CartaoCreditoToJson(CartaoCredito instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_user': instance.id_user,
      'numeroCartao': instance.numeroCartao,
      'nomeTitular': instance.nomeTitular,
      'dataValidade': instance.dataValidade,
      'cvv': instance.cvv,
      'limite': instance.limite,
    };
