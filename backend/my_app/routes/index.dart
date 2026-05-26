import 'package:dart_frog/dart_frog.dart';

import 'package:my_app/models/user.dart';

Future<Response> onRequest(RequestContext context) async {

  final request = context.request;

  // final method = request.method.value;

  // final headers = request.headers;

  // final params = request.uri.queryParameters;

  // final name = params['name'] ?? 'there';

  // final body = await request.json();
  // Map<dynamic, dynamic> data = {"name": "Paulo", "email":"paulo@gmail.com"};

  return Response.json(statusCode: 200, body: {"a":"a"});
}
