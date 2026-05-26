import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/repositories/user_repository.dart';

Handler middleware(Handler handler){
  return handler.use(
    bearerAuthentication<User>(
      authenticator: (context, token) async{
        final authenticator = context.read<UserRepository>();
        return authenticator.verifyToken(token);
      }
    )
  );
}