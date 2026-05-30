import 'package:my_app/models/user.dart';
import 'package:my_app/repositories/user_repository.dart';

class UserService{
  final UserRepository userRepository;
  UserService(this.userRepository);

  Future<List<Map<String, dynamic>>> findAllUsers() async{
    var users = await this.userRepository.listUsers();
    return users;
  }

}