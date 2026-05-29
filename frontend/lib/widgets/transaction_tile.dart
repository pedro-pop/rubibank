import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/formatters.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.amount > 0;
    final amountColor = isPositive ? AppColors.success : AppColors.textPrimary;
    final amountPrefix = isPositive ? '+' : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight, width: 0.5),
      ),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: AppTextStyles.titleMedium),
                const SizedBox(height: 2),
                Text(transaction.description, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amountPrefix${AppFormatters.formatBRL(transaction.amount.abs())}',
                style: AppTextStyles.titleMedium.copyWith(color: amountColor),
              ),
              const SizedBox(height: 2),
              Text(
                AppFormatters.formatShortDate(transaction.date),
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon;
    Color bgColor;

    switch (transaction.type) {
      case TransactionType.income:
        icon = Icons.arrow_downward_rounded;
        bgColor = AppColors.success.withOpacity(0.15);
        break;
      case TransactionType.transfer:
        icon = Icons.swap_horiz_rounded;
        bgColor = AppColors.info.withOpacity(0.15);
        break;
      default:
        icon = Icons.arrow_upward_rounded;
        bgColor = AppColors.primary.withOpacity(0.15);
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Icon(
        icon,
        color: transaction.type == TransactionType.income
            ? AppColors.success
            : transaction.type == TransactionType.transfer
                ? AppColors.info
                : AppColors.primaryLight,
        size: 20,
      ),
    );
  }
}
