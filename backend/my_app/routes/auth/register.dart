import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/services/user_service.dart';
import 'package:my_app/repositories/user_repository.dart';

Future<Response> onRequest(RequestContext context) async{
  UserRepository userRepository = UserRepository();
  UserService userService = UserService(userRepository);

  final body =  await context.request.json();
  String name = body['name'] as String;
  String email = body['email'] as String;
  String password = body['password'] as String;
  String cpf = body['cpf'] as String;
  String telefone = body['telefone'] as String;
  
  switch (context.request.method){
    case HttpMethod.post:
      User user = await userService.registerUser(name, email, password, cpf, telefone, 0);
      return Response.json(statusCode: 201, body: user.UserToUserResponse());
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

