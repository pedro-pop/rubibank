import 'package:my_app/models/user.dart';
import 'package:my_app/repositories/user_repository.dart';

class AuthService{
  final UserRepository _userRepository;

  AuthService(this._userRepository);

  Future<User?> findByEmailAndPassword(String email, String password) async{
    final user = await _userRepository.findByEmailAndPassword(email, password);
    return user;
  }

  Future<User> registerUser(String name, String email, String password, String cpf, String telefone, int saldo_conta) async{
    var user = await _userRepository.createUser(name, email, password, cpf, telefone);
    return user;
  }

  Future<String> generateToken(String email, User user) async{
    return await _userRepository.generateToken(email, user);
  }
}