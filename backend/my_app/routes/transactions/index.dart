import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/services/transaction_service.dart';

Future<Response> onRequest(RequestContext context) async{
  return switch (context.request.method){
      HttpMethod.get => _onGet(context),
      _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed)
      )
    };
}

Future<Response> _onGet(RequestContext context) async{
  final idUser = context.read<User>().id;
  final transactionService = await context.read<Future<TransactionService>>();
  final transactions = await transactionService.findTransactionsByUser(idUser);
  final transactionList = transactions.map((t)=> t.toJson()).toList();
  return Response.json(body: transactionList);
}