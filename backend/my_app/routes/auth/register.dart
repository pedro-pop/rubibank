import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_app/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async{
  return switch (context.request.method){
    HttpMethod.post => _onPost(context),
    _ => Future.value(
      Response(statusCode: HttpStatus.methodNotAllowed)
    )
  };
}

Future<Response> _onPost(RequestContext context) async{
  final userService = await context.read<Future<AuthService>>();

  final body =  await context.request.json();
  final name = body['name'] as String;
  final email = body['email'] as String;
  final password = body['password'] as String;
  final cpf = body['cpf'] as String;
  final telefone = body['telefone'] as String;

  final user = await userService.registerUser(name, email, password, cpf, telefone, 0);
  return Response.json(statusCode: 201, body: user.UserToUserResponse());

}

