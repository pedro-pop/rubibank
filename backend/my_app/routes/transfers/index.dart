import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_app/models/user.dart';

Future<Response> onRequest(RequestContext context) async{
  final user = context.read<User>();
  return Response.json(statusCode: HttpStatus.ok, body: user);
}