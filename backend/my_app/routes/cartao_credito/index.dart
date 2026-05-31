import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/services/cartao_credito_service.dart';

Future<Response> onRequest(RequestContext context) async{
  return switch(context.request.method){
    HttpMethod.get =>  findCartaoCredito(context),

    HttpMethod.post => createCartaoCredito(context),

    _ => Future.value(
      Response(statusCode: HttpStatus.methodNotAllowed)
    )
  };
}

Future<Response> createCartaoCredito(RequestContext context) async{
  try{
    final cartaoCreditoService= context.read<CartaoCreditoService>();

    final user = context.read<User>();

    final cartaoCredito = await cartaoCreditoService.createCartaoCredito(user);

  return Response.json(statusCode: HttpStatus.created, body: cartaoCredito );

  }catch (e, stackTrace){
    print(e);
    print(stackTrace);
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

}

Future<Response> findCartaoCredito(RequestContext context) async{
  try{
    final cartaoCreditoService = context.read<CartaoCreditoService>();
    final user_id = context.read<User>().id;
    final cartaoCredito = await cartaoCreditoService.findCartaoCredito(user_id);

  return Response.json(body: cartaoCredito);

  }catch (e, stackTrace){
    print(e);
    print(stackTrace);
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}