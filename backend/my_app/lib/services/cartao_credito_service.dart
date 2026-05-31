import 'package:my_app/models/cartao_credito.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/repositories/cartao_credito_repository.dart';

class CartaoCreditoService {
  final CartaoCreditoRepository _cartaoCreditoRepository;

  CartaoCreditoService(this._cartaoCreditoRepository);

  Future<CartaoCredito> createCartaoCredito(User user) async{
    final data_validade = '12/29';
    final numero_cartao = '0111022203330444';
    final cvv = '123';
    final limite = 1000;

    final cartaoCredito = _cartaoCreditoRepository.createCartaoCredito(user.id, numero_cartao, user.name, data_validade, cvv, limite);

    return cartaoCredito;
  }

  Future<CartaoCredito> findCartaoCredito(int id_user) async{
    final cartaoCredito = _cartaoCreditoRepository.findUserCard(id_user);
    return cartaoCredito;
  }

}