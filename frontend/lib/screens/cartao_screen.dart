import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/formatters.dart';

class CartaoScreen extends StatefulWidget {
  const CartaoScreen({super.key});

  @override
  State<CartaoScreen> createState() => _CartaoScreenState();
}

class _CartaoScreenState extends State<CartaoScreen>
    with SingleTickerProviderStateMixin {
  bool _loading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // Dados mockados — TODO: integrar com API de cartão quando disponível
  final double _limiteTotal = 5000.0;
  final double _limiteUsado = 1850.0;
  final double _faturaAtual = 1850.0;
  final String _melhorDataCompra = '15 de cada mês';
  final String _vencimentoFatura = '10 de cada mês';

  final List<Map<String, dynamic>> _compras = [
    {'nome': 'Mercado Extra', 'valor': -387.45, 'data': '28/05/2026', 'icone': Icons.shopping_cart_outlined},
    {'nome': 'Netflix', 'valor': -55.90, 'data': '25/05/2026', 'icone': Icons.play_circle_outline},
    {'nome': 'Posto Shell', 'valor': -180.00, 'data': '22/05/2026', 'icone': Icons.local_gas_station_outlined},
    {'nome': 'iFood', 'valor': -67.80, 'data': '20/05/2026', 'icone': Icons.fastfood_outlined},
    {'nome': 'Amazon', 'valor': -259.90, 'data': '18/05/2026', 'icone': Icons.shopping_bag_outlined},
    {'nome': 'Farmácia', 'valor': -45.60, 'data': '15/05/2026', 'icone': Icons.local_pharmacy_outlined},
    {'nome': 'Cinema', 'valor': -54.00, 'data': '12/05/2026', 'icone': Icons.movie_outlined},
    {'nome': 'Uber', 'valor': -32.90, 'data': '10/05/2026', 'icone': Icons.directions_car_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  double get _limiteDisponivel => _limiteTotal - _limiteUsado;
  double get _percentoUsado => _limiteUsado / _limiteTotal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Cartão de Crédito', style: AppTextStyles.headlineMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryLight),
            onPressed: () {
              // TODO: integrar com API de cartão quando disponível
              setState(() => _loading = true);
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) setState(() => _loading = false);
              });
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCartaoVisual(),
              const SizedBox(height: 24),
              _buildLimiteCard(),
              const SizedBox(height: 16),
              _buildFaturaCard(),
              const SizedBox(height: 16),
              _buildInfoCards(),
              const SizedBox(height: 24),
              _buildHistoricoCompras(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartaoVisual() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC62828), Color(0xFF8E0000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Círculos decorativos
          Positioned(
            right: -30, top: -30,
            child: Container(
              width: 150, height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            right: 30, bottom: -40,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('RubiBank',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                    const Icon(Icons.credit_card_rounded,
                        color: Colors.white70, size: 32),
                  ],
                ),
                const Spacer(),
                Text('•••• •••• •••• 4321',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 2,
                    )),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TITULAR', style: AppTextStyles.caption
                            .copyWith(color: Colors.white54)),
                        Text('PEDRO ANDRADE',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            )),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('VALIDADE', style: AppTextStyles.caption
                            .copyWith(color: Colors.white54)),
                        Text('12/28',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimiteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Limite disponível', style: AppTextStyles.titleMedium),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGlow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(_percentoUsado * 100).toStringAsFixed(0)}% usado',
                  style: AppTextStyles.caption.copyWith(color: AppColors.primaryLight),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(AppFormatters.formatBRL(_limiteDisponivel),
              style: AppTextStyles.moneyLarge),
          const SizedBox(height: 4),
          Text('de ${AppFormatters.formatBRL(_limiteTotal)} no total',
              style: AppTextStyles.bodySmall),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _percentoUsado,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                _percentoUsado > 0.8 ? AppColors.error : AppColors.primary,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaturaCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceLight, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.receipt_outlined,
                color: AppColors.warning, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fatura atual', style: AppTextStyles.bodySmall),
                Text(AppFormatters.formatBRL(_faturaAtual),
                    style: AppTextStyles.moneyMedium),
                Text('Vencimento: $_vencimentoFatura',
                    style: AppTextStyles.caption),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: integrar pagamento de fatura
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              textStyle: const TextStyle(fontSize: 13),
            ),
            child: const Text('Pagar'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(
            icon: Icons.calendar_today_outlined,
            label: 'Melhor data\nde compra',
            value: _melhorDataCompra,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoItem(
            icon: Icons.credit_score_outlined,
            label: 'Limite\ntotal',
            value: AppFormatters.formatBRL(_limiteTotal),
            color: AppColors.info,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }

  Widget _buildHistoricoCompras() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Histórico de compras', style: AppTextStyles.titleLarge),
            Text('${_compras.length} itens', style: AppTextStyles.caption),
          ],
        ),
        const SizedBox(height: 12),
        ..._compras.map((c) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceLight, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(c['icone'] as IconData,
                    color: AppColors.primaryLight, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c['nome'] as String, style: AppTextStyles.titleMedium),
                    Text(c['data'] as String, style: AppTextStyles.caption),
                  ],
                ),
              ),
              Text(
                AppFormatters.formatBRL((c['valor'] as double).abs()),
                style: AppTextStyles.titleMedium
                    .copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
