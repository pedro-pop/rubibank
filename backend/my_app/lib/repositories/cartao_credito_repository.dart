import 'package:my_app/database/connection.dart';
import 'package:my_app/models/cartao_credito.dart';
import 'package:postgres/postgres.dart';

class CartaoCreditoRepository {
  
  Future<CartaoCredito> createCartaoCredito (
    int id_user,
    String numero_cartao,
    String nome_titular,
    String data_validade,
    String cvv,
    int limite
    ) async {
    final result = await db.execute(
      Sql(r'''
        INSERT INTO cartoes_credito(
          id_user,
          numero_cartao,
          nome_titular,
          data_validade,
          cvv,
          limite
        )
        VALUES($1, $2, $3, $4, $5, $6)
        RETURNING id;
      '''),
      parameters: [
        id_user,
        numero_cartao,
        nome_titular,
        data_validade,
        cvv,
        limite
      ]
    );

    final id = result.first[0] as int;

    return CartaoCredito(
      id: id,
      id_user: id_user,
      numeroCartao: numero_cartao,
      nomeTitular: nome_titular,
      dataValidade: data_validade,
      cvv: cvv,
      limite: limite
      );
  }

  Future<CartaoCredito> findUserCard(int id_user) async{
    final result = await db.execute(
      Sql(r'''
        SELECT *
        FROM cartoes_credito
        WHERE id_user = $1
      '''),
      parameters: [id_user]
    );

    final data = result.first.toColumnMap();

    return CartaoCredito(
      id: data['id'] as int,
      id_user: data['id_user'] as int,
      numeroCartao: data['numero_cartao'] as String,
      nomeTitular: data['nome_titular'] as String,
      dataValidade: data['data_validade'] as String,
      cvv: data['cvv'] as String,
      limite: data['limite'] as int
    );
  }
}