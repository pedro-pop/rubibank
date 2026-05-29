import 'package:my_app/models/user.dart';
import 'package:my_app/repositories/user_repository.dart';

class UserService{
  final UserRepository userRepository;
  UserService(this.userRepository);

  User registerUser(String name, String email, String password, String cpf, String telefone, int saldo_conta){
    var user = this.userRepository.createUser(name, email, password, cpf, telefone);
    return user;
  }

  List<Map<String, dynamic>> findAllUsers(){
    var users = this.userRepository.listUsers();
    return users;
  }

}