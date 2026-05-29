import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:postgres/postgres.dart';

import 'package:my_app/database/connection.dart';
import 'package:my_app/models/user.dart';

class UserRepository {

  Future<User> createUser(
    String name,
    String email,
    String password,
    String cpf,
    String telefone,
  ) async {

    final result = await db.execute(
      Sql(r'''
        INSERT INTO users(
          name,
          email,
          password,
          cpf,
          telefone,
          saldo_conta
        )
        VALUES($1, $2, $3, $4, $5, $6)
        RETURNING id;
      '''),
      parameters: [
        name,
        email,
        password,
        cpf,
        telefone,
        0,
      ],
    );

    final id = result.first[0] as int;

    return User(
      id: id,
      name: name,
      password: password,
      email: email,
      cpf: cpf,
      telefone: telefone,
      saldo_conta: 0,
    );
  }

  Future<List<Map<String, dynamic>>> listUsers() async {

    final result = await db.execute(
      Sql('SELECT * FROM users'),
    );

    return result.map((row) {
      final data = row.toColumnMap();

      return {
        "id": data["id"],
        "name": data["name"],
        "email": data["email"],
      };
    }).toList();
  }

  Future<User?> findByEmailAndPassword(
    String email,
    String password,
  ) async {

    final result = await db.execute(
      Sql(r'''
        SELECT *
        FROM users
        WHERE email = $1;
      '''),
      parameters: [email],
    );

    if (result.isEmpty) {
      return null;
    }

    final userData = result.first.toColumnMap();

    if (userData["password"] != password) {
      return null;
    }

    return User(
      id: userData["id"] as int,
      name: userData["name"] as String,
      password: userData["password"] as String,
      email: userData["email"] as String,
      cpf: userData["cpf"] as String,
      telefone: userData["telefone"] as String,
      saldo_conta: userData["saldo_conta"] as int,
    );
  }

  Future<User?> findByEmail(String email) async {

    final result = await db.execute(
      Sql(r'''
        SELECT *
        FROM users
        WHERE email = $1;
      '''),
      parameters: [email],
    );

    if (result.isEmpty) {
      return null;
    }

    final userData = result.first.toColumnMap();

    return User(
      id: userData["id"] as int,
      name: userData["name"] as String,
      password: userData["password"] as String,
      email: userData["email"] as String,
      cpf: userData["cpf"] as String,
      telefone: userData["telefone"] as String,
      saldo_conta: userData["saldo_conta"] as int,
    );
  }

  Future<User?> verifyToken(String token) async {

    try {

      final payload = JWT.verify(
        token,
        SecretKey('123'),
      );

      final payloadData = payload.payload as Map<String, dynamic>;

      final email = payloadData["email"] as String;

      final user = await findByEmail(email);

      return user;

    } catch (e) {
      return null;
    }
  }

<<<<<<< HEAD
  String generateToken( String email, User user){
    final jwt = JWT({
      'id':user.id,
      'name':user.name,
      'email':email
    });

    return jwt.sign(SecretKey('123'));
  }

  User? findByEmail(String email){
    String sql = '''
SELECT * FROM users WHERE email = ?''';
    final user = db.select(sql, [email]);

    if (user.isEmpty){
      return null;
    }
    return  User(
      id: user.first["id"] as int,
      name: user.first["name"] as String,
      password: user.first["password"] as String,
      email: user.first["email"] as String,
      cpf: user.first["cpf"] as String,
      telefone: user.first["telefone"] as String,
      saldo_conta: user.first["saldo_conta"] as int
      );
  }
}
=======
  String generateToken(String email, User user) {

    final jwt = JWT({
      'id': user.id,
      'name': user.name,
      'email': email,
    });

    return jwt.sign(
      SecretKey('123'),
    );
  }

  Future<int?> findSaldoConta(id_user) async {
    final result = await db.execute(
      Sql(r'''
        SELECT saldo_conta
        FROM users
        WHERE id = $1;
      '''),
      parameters: [id_user],
    );

    if (result.isEmpty) {
      return null;
    }

    final userData = result.first.toColumnMap();

    return userData["saldo_contas"] as int;
  }

  Future<int?> subtractSaldoConta(int id_user, int valor) async {
    final result = await db.execute(
      Sql(r'''
        UPDATE users
        SET saldo_conta = saldo_conta - $1
        WHERE id = $2
        AND saldo_conta >= $1
        RETURNING saldo_conta;
      '''),
      parameters: [valor, id_user]
    );

    if(result.isEmpty){
      return null;
    }

    final newBalance = result.first[0] as int;
    return newBalance;
  }

  Future<int?> addSaldoConta(int id_user, int valor) async {
    final result = await db.execute(
      Sql(r'''
        UPDATE users
        SET saldo_conta = saldo_conta + $1
        WHERE id = $2
        RETURNING saldo_conta;
      '''),
      parameters: [valor, id_user]
    );

    if(result.isEmpty){
      return null;
    }

    final newBalance = result.first[0] as int;
    return newBalance;
  }
}
>>>>>>> feat/alteracao_bd
