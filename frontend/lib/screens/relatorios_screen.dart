import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/formatters.dart';

class RelatoriosScreen extends StatefulWidget {
  const RelatoriosScreen({super.key});

  @override
  State<RelatoriosScreen> createState() => _RelatoriosScreenState();
}

class _RelatoriosScreenState extends State<RelatoriosScreen> {
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _loading = true;
  String? _error;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() { _loading = true; _error = null; });
    final result = await ApiService.instance.getTransactions();
    if (!mounted) return;
    if (result.success) {
      setState(() {
        _transactions = result.data ?? [];
        _filtered = _transactions;
        _loading = false;
      });
    } else {
      setState(() {
        _error = result.errorMessage;
        _loading = false;
      });
    }
  }

  void _applyFilter() {
    setState(() {
      _filtered = _transactions.where((t) {
        final date = DateTime.tryParse(t['created_at'] ?? '');
        if (date == null) return true;
        if (_startDate != null && date.isBefore(_startDate!)) return false;
        if (_endDate != null && date.isAfter(_endDate!.add(const Duration(days: 1)))) return false;
        return true;
      }).toList();
    });
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startDate = picked;
        else _endDate = picked;
      });
      _applyFilter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Relatórios', style: AppTextStyles.headlineMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: _loading
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                    ),
                  )
                : const Icon(Icons.refresh_rounded, color: AppColors.primaryLight),
            onPressed: _loading ? null : _loadTransactions,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
                : _error != null
                    ? _buildError()
                    : _filtered.isEmpty
                        ? _buildEmpty()
                        : _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.surface,
      child: Row(
        children: [
          const Icon(Icons.filter_list_rounded, color: AppColors.primaryLight, size: 20),
          const SizedBox(width: 8),
          Text('Filtrar:', style: AppTextStyles.bodySmall),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _pickDate(true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _startDate != null
                      ? AppFormatters.formatDate(_startDate!)
                      : 'Data início',
                  style: AppTextStyles.caption.copyWith(color: AppColors.primaryLight),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text('—', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _pickDate(false),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _endDate != null
                      ? AppFormatters.formatDate(_endDate!)
                      : 'Data fim',
                  style: AppTextStyles.caption.copyWith(color: AppColors.primaryLight),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          if (_startDate != null || _endDate != null)
            IconButton(
              icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary, size: 18),
              onPressed: () {
                setState(() { _startDate = null; _endDate = null; _filtered = _transactions; });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (ctx, i) {
        final t = _filtered[i];
        final valor = (t['value'] as num?)?.toDouble() ?? 0;
        final isPositive = valor > 0;
        final date = DateTime.tryParse(t['created_at'] ?? '');

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceLight, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppColors.success.withOpacity(0.15)
                      : AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPositive ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: isPositive ? AppColors.success : AppColors.primaryLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t['type'] ?? 'Transação', style: AppTextStyles.titleMedium),
                    if (date != null)
                      Text(AppFormatters.formatDateTime(date),
                          style: AppTextStyles.caption),
                  ],
                ),
              ),
              Text(
                '${isPositive ? '+' : ''}${AppFormatters.formatBRL(valor)}',
                style: AppTextStyles.titleMedium.copyWith(
                  color: isPositive ? AppColors.success : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long_outlined,
              color: AppColors.surfaceLight, size: 52),
          const SizedBox(height: 16),
          Text('Nenhum dado encontrado.', style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          Text('Tente ajustar os filtros.', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.error, size: 52),
          const SizedBox(height: 16),
          Text(_error ?? 'Erro ao carregar relatórios.',
              style: AppTextStyles.titleMedium),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadTransactions,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
