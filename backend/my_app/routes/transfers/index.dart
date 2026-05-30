import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/services/transfers_service.dart';

Future<Response> onRequest(RequestContext context) async{
  return switch (context.request.method){
    HttpMethod.post => _onPost(context),
    _ => Future.value(
      Response(statusCode: HttpStatus.methodNotAllowed)
    )
  };
}

Future<Response> _onPost(RequestContext context) async{
  final transfersService = context.read<TransfersService>();
  final user = context.read<User>();

  final body = await context.request.json() as Map<String, dynamic>;

  final email_destinatario = body["email_destinatario"] as String ;
  final valor_transferencia = body["valor_transferencia"] as int;
  final password = body["password"] as String;

  final saldo_conta =  await transfersService.Transfer(user.id, email_destinatario, valor_transferencia, password);

  return Response.json(statusCode: HttpStatus.ok, body: {"saldo_conta":saldo_conta});
}