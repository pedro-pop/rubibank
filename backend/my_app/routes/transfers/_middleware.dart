import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/repositories/transactions_repository.dart';
import 'package:my_app/repositories/transfer_repository.dart';
import 'package:my_app/repositories/user_repository.dart';
import 'package:my_app/services/transfers_service.dart';

Handler middleware(Handler handler) {
  final userRepository = UserRepository();
  final transactionsRepository = TransactionsRepository();
  final transferRepository = TransferRepository();

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
        provider(
          (context) => TransfersService(
            context.read<UserRepository>(),
            context.read<TransactionsRepository>(),
            context.read<TransferRepository>(),
          ),
        ),
      )
      .use(
        provider<TransferRepository>(
          (_) => transferRepository,
        ),
      )
      .use(
        provider<TransactionsRepository>(
          (_) => transactionsRepository,
        ),
      )
      .use(
        provider<UserRepository>(
          (_) => userRepository,
        ),
      );
}