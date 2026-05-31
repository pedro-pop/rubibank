import 'package:json_annotation/json_annotation.dart';
part 'cartao_credito.g.dart';

@JsonSerializable()
class CartaoCredito{

  CartaoCredito({
    required this.id,
    required this.id_user,
    required this.numeroCartao,
    required this.nomeTitular,
    required this.dataValidade,
    required this.cvv,
    required this.limite
  });

  final int id;
  final int id_user;
  final String numeroCartao;
  final String nomeTitular;
  final String dataValidade;
  final String cvv;
  final int limite;

  Map<String, dynamic> toJson() => _$CartaoCreditoToJson(this);
}
