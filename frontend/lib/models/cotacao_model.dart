class CotacaoModel {
  final double usdBrl;
  final double eurBrl;
  final double usdVariation;
  final double eurVariation;
  final DateTime lastUpdate;

  const CotacaoModel({
    required this.usdBrl,
    required this.eurBrl,
    required this.usdVariation,
    required this.eurVariation,
    required this.lastUpdate,
  });

  // TODO: Implementar fromJson quando API for integrada
  // factory CotacaoModel.fromJson(Map<String, dynamic> json) { ... }

  // Dados mockados para desenvolvimento
  static CotacaoModel get mock => CotacaoModel(
        usdBrl: 5.12,
        eurBrl: 5.58,
        usdVariation: 0.45,
        eurVariation: -0.23,
        lastUpdate: DateTime.now(),
      );
}

