import 'package:my_app/models/user.dart';
import 'package:my_app/repositories/user_repository.dart';

class TransfersService {
  final UserRepository userRepository;

  TransfersService(this.userRepository);

  void Transfer(String email, int valor, String password){
    User? target_user = userRepository.findByEmail(email);

    if (target_user == null){
      return null;
    }

    

  }
}