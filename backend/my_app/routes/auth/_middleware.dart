import 'package:dart_frog/dart_frog.dart';
import 'package:my_app/repositories/user_repository.dart';

Handler middleware(Handler handler) {
  return handler.use(
    provider<UserRepository>(
      (_) => UserRepository(),
    ),
  );
}