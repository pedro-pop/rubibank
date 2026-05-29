import 'package:my_app/models/transaction.dart';
import 'package:my_app/repositories/transactions_repository.dart';

class TransactionService {
  final TransactionsRepository _transactionsRepository;

  TransactionService(this._transactionsRepository);

  Future<List<Transaction>> findTransactionsByUser(int id_user){
    final transactions = _transactionsRepository.findTransactionsByUserId(id_user);

    return transactions;
  }
}