import 'dart:ffi';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:my_app/database/connection.dart';
import 'package:my_app/models/user.dart';
import 'package:sqlite3/common.dart';

class UserRepository {
  User createUser(String name, String email, String password, String cpf, String telefone){
    final user = db.execute('''
INSERT INTO users(name, email, password, cpf, telefone)
VALUES (?, ?, ?, ?, ?)''',[name, email, password, cpf, telefone]);

  int id = db.lastInsertRowId;

  User userCreate = User(id: id, name: name, password: password, email: email, cpf: cpf, telefone: telefone, saldo_conta: 0);

  return userCreate;
  }

  List<Map<String, dynamic>> listUsers(){
    String sql = '''
SELECT * FROM users;''';

    final ResultSet resultSet = db.select(sql);
    List<Map<String, dynamic>> userList = [];

    for (var userRow in resultSet){
      Map<String, dynamic> user = {"id": userRow["id"], "name": userRow["name"], "email": userRow["email"]};
      userList.add(user);
    }

    return userList;
  }
  
  User? findByEmailAndPassword(String email, String password){
    String sql = '''
SELECT *
FROM users
WHERE email = ?;
''';
    final user = db.select(sql, [email]);
    if (user.isEmpty){
      return null;
    }
    if (user[0]["password"] == password){
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

    return null;

  }

  User? verifyToken(String token){
    try{    
        final payload = JWT.verify(token, SecretKey('123'));

        final payloadData = payload.payload as Map<String, dynamic>;

        final email = payloadData["email"] as String;

        final user = this.findByEmail(email);

        return user;
    } catch (e){
      return null;
    }
  }

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