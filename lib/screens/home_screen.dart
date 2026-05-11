import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/transaction.dart';
import '../services/mock_data_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../utils/app_text_styles.dart';
import '../utils/formatters.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/savings_progress_card.dart';
import '../widgets/transaction_tile.dart';
import '../models/transfer_args.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final _user = MockDataService.currentUser;
  final _cotacao = MockDataService.cotacao;
  final _transactions = MockDataService.transactions;
  final _weekExpenses = MockDataService.weeklyExpenses;
  final _weekDays = MockDataService.weekDays;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          _buildPlaceholderTab(Icons.bar_chart_rounded, 'Relatórios'),
          _buildPlaceholderTab(Icons.credit_card_rounded, 'Cartões'),
          const _PerfilTabShell(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeTab() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                BalanceCard(
                  brl: _user.balance,
                  usd: MockDataService.balanceUSD,
                  eur: MockDataService.balanceEUR,
                ),
                const SizedBox(height: 24),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildInsightCard(),
                const SizedBox(height: 24),
                SavingsProgressCard(
                  current: MockDataService.savingsGoalCurrent,
                  target: MockDataService.savingsGoalTarget,
                ),
                const SizedBox(height: 24),
                _buildWeeklyChart(),
                const SizedBox(height: 24),
                _buildTransactionsList(),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      floating: true,
      snap: true,
      expandedHeight: 0,
      toolbarHeight: 70,
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Olá, ${_user.firstName} 👋',
                    style: AppTextStyles.headlineLarge),
                Text(AppFormatters.formatDate(DateTime.now()),
                    style: AppTextStyles.bodySmall),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.perfil),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    _user.firstName[0].toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ações rápidas', style: AppTextStyles.titleLarge),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            QuickActionButton(
              icon: Icons.swap_horiz_rounded,
              label: 'Transferir',
              isPrimary: true,
              onTap: () => Navigator.pushNamed(context, AppRoutes.transferencia),
            ),
            QuickActionButton(
              icon: Icons.trending_up_rounded,
              label: 'Cotação',
              onTap: () => Navigator.pushNamed(context, AppRoutes.cotacao),
            ),
            QuickActionButton(
              icon: Icons.share_rounded,
              label: 'Compartilhar',
              onTap: () {
                // TODO: Integrar plugin share_plus
                _showShareDialog();
              },
            ),
            QuickActionButton(
              icon: Icons.qr_code_rounded,
              label: 'Pix',
              onTap: () {
                // TODO: Implementar Pix
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGlow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.lightbulb_outline_rounded,
                color: AppColors.primaryLight, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Insight da semana',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.primaryLight)),
                const SizedBox(height: 2),
                Text('Você gastou mais essa semana comparado à anterior.',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
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
              Text('Gastos da semana', style: AppTextStyles.titleMedium),
              Text('Esta semana',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.primaryLight)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 130,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 700,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.surfaceCard,
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        'R\$ ${rod.toY.toStringAsFixed(0)}',
                        AppTextStyles.caption
                            .copyWith(color: AppColors.primaryLight),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < _weekDays.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(_weekDays[idx],
                                style: AppTextStyles.caption),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 200,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.surfaceLight,
                    strokeWidth: 0.5,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _weekExpenses.asMap().entries.map((e) {
                  final isMax = e.value ==
                      _weekExpenses.reduce((a, b) => a > b ? a : b);
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value,
                        gradient: isMax
                            ? AppColors.primaryGradient
                            : LinearGradient(
                                colors: [
                                  AppColors.surfaceLight,
                                  AppColors.surfaceCard
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                        width: 22,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Transações recentes', style: AppTextStyles.titleLarge),
            TextButton(
              onPressed: () {},
              child: Text('Ver todas',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.primaryLight)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._transactions.map((t) => TransactionTile(transaction: t)),
      ],
    );
  }

  Widget _buildPlaceholderTab(IconData icon, String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.surfaceLight, size: 52),
          const SizedBox(height: 16),
          Text(label, style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          Text('Em breve', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  void _showShareDialog() {
    // TODO: Substituir por share_plus plugin
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Compartilhar', style: AppTextStyles.headlineMedium),
        content: Text(
          'Plugin de compartilhamento será integrado aqui.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fechar',
                style: TextStyle(color: AppColors.primaryLight)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
            top: BorderSide(color: AppColors.surfaceLight, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w400),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded), label: 'Relatórios'),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card_rounded), label: 'Cartões'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }
}

// Shell que navega para a tela de perfil real
class _PerfilTabShell extends StatelessWidget {
  const _PerfilTabShell();

  @override
  Widget build(BuildContext context) {
    return const _PerfilTabEmbed();
  }
}

class _PerfilTabEmbed extends StatelessWidget {
  const _PerfilTabEmbed();

  @override
  Widget build(BuildContext context) {
    // Embed inline para não quebrar o IndexedStack
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_rounded,
              color: AppColors.surfaceLight, size: 52),
          const SizedBox(height: 16),
          Text('Perfil', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.perfil),
            icon: const Icon(Icons.open_in_new_rounded,
                color: AppColors.primaryLight, size: 18),
            label: Text('Abrir perfil completo',
                style: TextStyle(color: AppColors.primaryLight)),
          ),
        ],
      ),
    );
  }
}
