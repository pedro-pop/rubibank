import 'package:my_app/models/user.dart';
import 'package:my_app/repositories/transactions_repository.dart';
import 'package:my_app/repositories/transfer_repository.dart';
import 'package:my_app/repositories/user_repository.dart';

class TransfersService {
  final UserRepository _userRepository;
  final TransferRepository _transferRepository;
  final TransactionsRepository _transactionsRepository;

  TransfersService(
    this._userRepository,
    this._transactionsRepository,
    this._transferRepository
    );

  Future<int?> Transfer(int id_remetente, String email_destinatario, int valor, String password) async{
    User? user_destinatario = await _userRepository.findByEmail(email_destinatario);

    if (user_destinatario == null){
      return null;
    }

    final saldo_conta_remetente = await _userRepository.subtractSaldoConta(id_remetente, valor);

    if (saldo_conta_remetente == null){
      return null;
    }

    final saldo_conta_destinatario = await _userRepository.addSaldoConta(user_destinatario.id, valor);

    final transfer = await _transferRepository.createTransfer(id_remetente, user_destinatario.id, valor);

    await _transactionsRepository.createTransaction(id_remetente, 'transferencia_enviada', valor, transfer.id);

    await _transactionsRepository.createTransaction(user_destinatario.id, 'transferencia_recebida', valor, transfer.id);

    return saldo_conta_remetente;
  }
}