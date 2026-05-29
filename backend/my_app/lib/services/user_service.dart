import 'package:my_app/models/user.dart';
import 'package:my_app/repositories/user_repository.dart';

class UserService{
  final UserRepository userRepository;
  UserService(this.userRepository);

  Future<User> registerUser(String name, String email, String password, String cpf, String telefone, int saldo_conta) async{
    var user = await userRepository.createUser(name, email, password, cpf, telefone);
    return user;
  }

  Future<List<Map<String, dynamic>>> findAllUsers() async{
    var users = await this.userRepository.listUsers();
    return users;
  }

}