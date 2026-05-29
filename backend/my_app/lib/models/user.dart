import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  const User({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.cpf,
    required this.telefone,
    required this.saldo_conta
    });
  
  final int id;
  final String name;
  final String password;
  final String email;
  final String cpf;
  final String telefone;
  final int saldo_conta;

  Map<String, dynamic> toJson() => _$UserToJson(this);

  UserResponse UserToUserResponse(){
    return UserResponse(id: this.id, name: this.name, email: this.email, cpf: this.cpf, telefone: this.telefone, saldo_conta: this.saldo_conta);
  }
}

@JsonSerializable()
class UserResponse {
  const UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.cpf,
    required this.telefone,
    required this.saldo_conta
  });

  final int id;
  final String name;
  final String email;
  final String cpf;
  final String telefone;
  final int saldo_conta;

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}