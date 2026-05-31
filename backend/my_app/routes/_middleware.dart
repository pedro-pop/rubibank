import 'package:dart_frog/dart_frog.dart';

import 'package:my_app/database/connection.dart';
import 'package:my_app/repositories/user_repository.dart';
 import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;

bool initialized = false;

Handler middleware(Handler handler) {
  return (context) async {

    if (!initialized) {
      await initDatabase();
      initialized = true;
    }

    final repo = UserRepository();

    return handler
        .use(provider<UserRepository>((_) => repo))
        .use(
          fromShelfMiddleware(
            shelf.corsHeaders(
              headers: {
                shelf.ACCESS_CONTROL_ALLOW_ORIGIN: '*',
                shelf.ACCESS_CONTROL_ALLOW_METHODS:
                  'GET, POST, PUT, PATCH, DELETE, OPTIONS',
                shelf.ACCESS_CONTROL_ALLOW_HEADERS: 
                  'Origin, Content-Type, Authorization',
              },
            ),
          ),
        )
        .call(context);
  };
}