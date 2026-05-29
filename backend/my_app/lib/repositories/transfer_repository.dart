import 'package:my_app/database/connection.dart';
import 'package:my_app/models/transfer.dart';
import 'package:postgres/postgres.dart';

class TransferRepository {
  Future<Transfer> createTransfer(
    int id_remetente,
    int id_destinatario,
    int valor,
    ) async{

    DateTime create_at = DateTime.now();

    final result = await db.execute(
      Sql(r'''
          INSERT INTO transfers(
            id_remetente,
            id_destinatario,
            valor,
            create_at
            )
            VALUES($1, $2, $3, $4)
            RETURNING id;
      '''),
      parameters: [
        id_remetente,
        id_destinatario,
        valor,
        create_at
      ]
    );

    final int id_trasfer = result.first[0] as int;

    return Transfer(
      id: id_trasfer,
      id_remetente: id_remetente,
      id_destinatario: id_destinatario,
      valor: valor,
      create_at: create_at);
  }
}