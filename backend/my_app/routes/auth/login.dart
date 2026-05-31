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
   final body = await context.request.json() as Map<String, dynamic>;
   final email = body["email"] as String;
   final password = body["password"] as String;

   if (email == '' || password == ''){
    return Response.json(statusCode: HttpStatus.badRequest,body: {'message': 'Informe E-mail e senha'} );
   } 

   final  authenticator = await context.read<Future<AuthService>>();

   final user = await authenticator.findByEmailAndPassword(email, password);

   if (user == null){
    return Response(statusCode: HttpStatus.unauthorized);
   } else {
    return Response.json(
      body: {'token':  await authenticator.generateToken(email, user)});
   }
}

