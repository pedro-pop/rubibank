import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/repositories/transactions_repository.dart';
import 'package:my_app/repositories/user_repository.dart';
import 'package:my_app/services/transaction_service.dart';

Handler middleware(Handler handler) {
  final transactionsRepository = TransactionsRepository();

  return handler
      .use(
        bearerAuthentication<User>(
          authenticator: (context, token) async {
            final authenticator = context.read<UserRepository>();

            return authenticator.verifyToken(token);
          },
        ),
      )
      .use(
        provider<Future<TransactionService>>(
          (context) async => TransactionService(
            context.read<TransactionsRepository>(),
          ),
        ),
      )
      .use(
        provider<TransactionsRepository>(
          (_) => transactionsRepository,
        ),
      );
}