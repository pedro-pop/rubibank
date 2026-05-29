import '../models/cotacao_model.dart';

/// Serviço de cotação - preparado para integração futura com API de câmbio.
/// TODO: Integrar com API real (ex: AwesomeAPI, ExchangeRate-API, etc.)
/// Endpoint sugerido: https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL
class CotacaoService {
  CotacaoService._();
  static final CotacaoService instance = CotacaoService._();

  /// TODO: Substituir por chamada real à API:
  /// final response = await http.get(Uri.parse('https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL'));
  Future<CotacaoModel> getCotacao() async {
    // Simulando delay de rede
    await Future.delayed(const Duration(milliseconds: 800));

    // Retornando dados mockados com pequena variação aleatória para simular atualização
    return CotacaoModel(
      usdBrl: 5.10 + (DateTime.now().millisecond % 30) / 100,
      eurBrl: 5.55 + (DateTime.now().millisecond % 25) / 100,
      usdVariation: 0.45,
      eurVariation: -0.23,
      lastUpdate: DateTime.now(),
    );
  }
}
