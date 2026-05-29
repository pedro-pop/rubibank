// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  password: json['password'] as String,
  email: json['email'] as String,
  cpf: json['cpf'] as String,
  telefone: json['telefone'] as String,
  saldo_conta: (json['saldo_conta'] as num).toInt(),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'password': instance.password,
  'email': instance.email,
  'cpf': instance.cpf,
  'telefone': instance.telefone,
  'saldo_conta': instance.saldo_conta,
};

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  cpf: json['cpf'] as String,
  telefone: json['telefone'] as String,
  saldo_conta: (json['saldo_conta'] as num).toInt(),
);

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'cpf': instance.cpf,
      'telefone': instance.telefone,
      'saldo_conta': instance.saldo_conta,
    };
