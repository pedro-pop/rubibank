import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/formatters.dart';

class BalanceCard extends StatefulWidget {
  final double brl;
  final double usd;
  final double eur;

  const BalanceCard({
    super.key,
    required this.brl,
    required this.usd,
    required this.eur,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard>
    with SingleTickerProviderStateMixin {
  bool _showBalance = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnim =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animController);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1C1C1C), Color(0xFF242424)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceLight, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Saldo disponível', style: AppTextStyles.bodySmall),
              GestureDetector(
                onTap: () => setState(() => _showBalance = !_showBalance),
                child: Icon(
                  _showBalance ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FadeTransition(
            opacity: _fadeAnim,
            child: Text(
              _showBalance
                  ? AppFormatters.formatBRL(widget.brl)
                  : 'R\$ •••••',
              style: AppTextStyles.moneyLarge,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.surfaceLight, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CurrencyItem(
                  flag: '🇺🇸',
                  currency: 'USD',
                  value: _showBalance
                      ? AppFormatters.formatUSD(widget.usd)
                      : 'US\$ •••',
                ),
              ),
              Container(width: 1, height: 32, color: AppColors.surfaceLight),
              Expanded(
                child: _CurrencyItem(
                  flag: '🇪🇺',
                  currency: 'EUR',
                  value: _showBalance
                      ? AppFormatters.formatEUR(widget.eur)
                      : '€ •••',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CurrencyItem extends StatelessWidget {
  final String flag;
  final String currency;
  final String value;

  const _CurrencyItem({
    required this.flag,
    required this.currency,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(currency, style: AppTextStyles.caption),
              Text(value,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
