import 'package:dart_frog/dart_frog.dart';
import 'package:my_app/repositories/user_repository.dart';
import 'package:my_app/services/auth_service.dart';

Handler middleware(Handler handler) {
  final userRepository = UserRepository();

  return handler
  .use(
    provider<Future<AuthService>>(
      (context) async => AuthService(context.read<UserRepository>()),
    ),
  )
  .use(
    provider<Future<UserRepository>>((_) async => userRepository)
  );
}