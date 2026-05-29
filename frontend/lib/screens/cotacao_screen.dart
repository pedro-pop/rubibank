import 'package:flutter/material.dart';
import '../models/cotacao_model.dart';
import '../services/cotacao_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/formatters.dart';

class CotacaoScreen extends StatefulWidget {
  const CotacaoScreen({super.key});

  @override
  State<CotacaoScreen> createState() => _CotacaoScreenState();
}

class _CotacaoScreenState extends State<CotacaoScreen>
    with SingleTickerProviderStateMixin {
  CotacaoModel? _cotacao;
  bool _loading = false;
  bool _initialLoad = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _loadCotacao();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadCotacao() async {
    setState(() => _loading = true);
    // TODO: CotacaoService.instance.getCotacao() chamará a API real futuramente
    final data = await CotacaoService.instance.getCotacao();
    if (!mounted) return;
    setState(() {
      _cotacao = data;
      _loading = false;
      _initialLoad = false;
    });
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Cotações', style: AppTextStyles.headlineMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                    ),
                  )
                : const Icon(Icons.refresh_rounded, color: AppColors.primaryLight),
            onPressed: _loading ? null : _loadCotacao,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _initialLoad
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primary)))
          : FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderBanner(),
                      const SizedBox(height: 28),
                      Text('Câmbio hoje', style: AppTextStyles.titleLarge),
                      const SizedBox(height: 16),
                      if (_cotacao != null) ...[
                        _buildCurrencyCard(
                          flag: '🇺🇸',
                          currency: 'Dólar Americano',
                          code: 'USD/BRL',
                          value: _cotacao!.usdBrl,
                          variation: _cotacao!.usdVariation,
                        ),
                        const SizedBox(height: 14),
                        _buildCurrencyCard(
                          flag: '🇪🇺',
                          currency: 'Euro',
                          code: 'EUR/BRL',
                          value: _cotacao!.eurBrl,
                          variation: _cotacao!.eurVariation,
                        ),
                        const SizedBox(height: 14),
                        _buildCurrencyCard(
                          flag: '🇬🇧',
                          currency: 'Libra Esterlina',
                          code: 'GBP/BRL',
                          value: 6.48,
                          variation: 0.12,
                          isMock: true,
                        ),
                        const SizedBox(height: 14),
                        _buildCurrencyCard(
                          flag: '🇦🇷',
                          currency: 'Peso Argentino',
                          code: 'ARS/BRL',
                          value: 0.0055,
                          variation: -1.34,
                          isMock: true,
                        ),
                      ],
                      const SizedBox(height: 28),
                      _buildLastUpdateInfo(),
                      const SizedBox(height: 12),
                      _buildApiNotice(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Taxa de câmbio',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: Colors.white70)),
              const SizedBox(height: 4),
              Text('Atualizado agora',
                  style: AppTextStyles.headlineMedium
                      .copyWith(color: Colors.white)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.trending_up_rounded, color: Colors.white, size: 40),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard({
    required String flag,
    required String currency,
    required String code,
    required double value,
    required double variation,
    bool isMock = false,
  }) {
    final isPositive = variation >= 0;
    final variationColor = isPositive ? AppColors.success : AppColors.error;
    final variationIcon = isPositive
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceLight, width: 0.5),
      ),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currency, style: AppTextStyles.titleMedium),
                Text(code, style: AppTextStyles.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormatters.formatBRL(value),
                style: AppTextStyles.moneyMedium,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(variationIcon, color: variationColor, size: 12),
                  const SizedBox(width: 2),
                  Text(
                    '${variation.abs().toStringAsFixed(2)}%',
                    style: AppTextStyles.caption.copyWith(color: variationColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdateInfo() {
    if (_cotacao == null) return const SizedBox.shrink();
    return Row(
      children: [
        const Icon(Icons.access_time_rounded,
            color: AppColors.textHint, size: 14),
        const SizedBox(width: 6),
        Text(
          'Atualizado: ${AppFormatters.formatDateTime(_cotacao!.lastUpdate)}',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildApiNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.info, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              // TODO: Remover após integração com API real
              'Dados simulados. API real será integrada (ex: AwesomeAPI).',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.info.withOpacity(0.8)),
            ),
          ),
        ],
      ),
    );
  }
}
