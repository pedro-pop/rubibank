import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/repositories/transactions_repository.dart';
import 'package:my_app/repositories/transfer_repository.dart';
import 'package:my_app/repositories/user_repository.dart';
import 'package:my_app/services/transfers_service.dart';

Future<Response> onRequest(RequestContext context) async{
  final userRepository = context.read<UserRepository>();
  final transactionsRepository = TransactionsRepository();
  final transferRepository = TransferRepository();
  final transfersService = TransfersService(userRepository, transactionsRepository, transferRepository);
  final user = context.read<User>();

  final body = await context.request.json() as Map<String, dynamic>;

  final email_destinatario = body["email_destinatario"] as String ;
  final valor_transferencia = body["valor_transferencia"] as int;
  final password = body["password"] as String;

  final saldo_conta =  await transfersService.Transfer(user.id, email_destinatario, valor_transferencia, password);


  return Response.json(statusCode: HttpStatus.ok, body: {"saldo_conta":saldo_conta});
}