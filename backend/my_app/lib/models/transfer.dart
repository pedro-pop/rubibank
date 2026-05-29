import 'package:json_annotation/json_annotation.dart';
part 'transfer.g.dart';


@JsonSerializable()
class Transfer {
  const Transfer({
    required this.id,
    required this.id_remetente,
    required this.id_destinatario,
    required this.valor,
    required this.create_at,
  });

  final int id;
  final int id_remetente;
  final int id_destinatario;
  final int valor;
  final DateTime create_at;

}