import 'package:dart_frog/dart_frog.dart';

import 'package:my_app/database/connection.dart';
import 'package:my_app/repositories/user_repository.dart';

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
        .call(context);
  };
}