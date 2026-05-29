import 'package:my_app/database/connection.dart';
import 'package:my_app/models/transaction.dart';
import 'package:postgres/postgres.dart';

class TransactionsRepository{

  Future<Transaction> createTransaction(
    int id_user,
    String tipo,
    int valor,
    int transfer_id,
  ) async{

    DateTime create_at = DateTime.now();

    final result = await db.execute(
      Sql(r'''
        INSERT INTO transactions(
          id_user,
          tipo,
          valor,
          id_transfer,
          create_at
          )
          VALUES($1, $2, $3, $4, $5)
          RETURNING id;
      '''),
      parameters: [
        id_user,
        tipo,
        valor,
        transfer_id,
        create_at
      ]
    );

  final int id_transfer = result.first[0] as int;

  return Transaction(
    id: id_transfer,
    id_user: id_user,
    tipo: tipo, valor: valor,
    id_transfer: id_transfer,
    create_at: create_at);
  }

  Future<List<Transaction>> findTransactionsByUserId(int id) async{
    final result = await db.execute(
      Sql(r'''
        SELECT *
        FROM transactions
        WHERE id_user = $1;
      '''),
      parameters: [id]
    );

    

    final transactionsList = result.map((row){
      final transaction = row.toColumnMap();
      return Transaction(
        id: transaction["id"] as int,
        id_user: transaction["id_user"] as int,
        tipo: transaction["tipo"] as String,
        valor: transaction["valor"] as int,
        id_transfer: transaction["id_transfer"] as int,
        create_at: transaction["create_at"] as DateTime
      );
    }).toList();

    return transactionsList;
  }
}