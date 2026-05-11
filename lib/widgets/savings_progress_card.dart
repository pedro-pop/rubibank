import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/formatters.dart';

class SavingsProgressCard extends StatefulWidget {
  final double current;
  final double target;

  const SavingsProgressCard({
    super.key,
    required this.current,
    required this.target,
  });

  @override
  State<SavingsProgressCard> createState() => _SavingsProgressCardState();
}

class _SavingsProgressCardState extends State<SavingsProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _progressAnim = Tween<double>(begin: 0, end: widget.current / widget.target)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = ((widget.current / widget.target) * 100).toStringAsFixed(0);

    return Container(
      width: double.infinity,
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
              Row(children: [
                const Icon(Icons.savings_outlined, color: AppColors.primaryLight, size: 20),
                const SizedBox(width: 8),
                Text('Meta de economia', style: AppTextStyles.titleMedium),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGlow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('$percent%',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _progressAnim,
            builder: (context, child) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _progressAnim.value,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 8,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppFormatters.formatBRL(widget.current),
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
              Text('de ${AppFormatters.formatBRL(widget.target)}',
                  style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
