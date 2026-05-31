import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/transfer_args.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../utils/app_text_styles.dart';
import '../widgets/rubi_button.dart';
import '../widgets/rubi_text_field.dart';

class TransferenciaScreen extends StatefulWidget {
  final TransferArgs? args;

  const TransferenciaScreen({super.key, this.args});

  @override
  State<TransferenciaScreen> createState() => _TransferenciaScreenState();
}

class _TransferenciaScreenState extends State<TransferenciaScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _destinatarioController = TextEditingController();
  final _valorController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _isLoading = false;

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
    _animController.forward();

    if (widget.args != null) {
      _destinatarioController.text = widget.args!.destinatario ?? '';
      _valorController.text = widget.args!.valor?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _destinatarioController.dispose();
    _valorController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _handleTransfer() async {
    if (!_formKey.currentState!.validate()) return;
    final confirmed = await _showConfirmationModal();
    if (!confirmed) return;

    final biometricOk = await _showBiometricDialog();
    if (!biometricOk || !mounted) return;

    setState(() => _isLoading = true);

    final valor = int.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0;

    final result = await ApiService.instance.transfer(
      emailDestinatario: _destinatarioController.text.trim(),
      valor: valor,
      password: _senhaController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      _showSuccessSheet(result.data ?? 0);
    } else {
      _showError(result.errorMessage ?? 'Erro ao realizar transferência.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<bool> _showConfirmationModal() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryGlow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.swap_horiz_rounded,
                  color: AppColors.primaryLight, size: 32),
            ),
            const SizedBox(height: 20),
            Text('Confirmar transferência', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 24),
            _buildConfirmRow('Destinatário', _destinatarioController.text),
            const Divider(color: AppColors.surfaceLight, height: 24),
            _buildConfirmRow('Valor', 'R\$ ${_valorController.text}'),
            const SizedBox(height: 20),
            // Campo de senha para confirmar
            RubiTextField(
              label: 'Sua senha',
              hint: 'Digite sua senha para confirmar',
              controller: _senhaController,
              obscureText: true,
              prefixIcon: Icons.lock_outline_rounded,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.surfaceLight),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Confirmar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    return result ?? false;
  }

  Widget _buildConfirmRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(value, style: AppTextStyles.titleMedium
            .copyWith(color: AppColors.primaryLight)),
      ],
    );
  }

  Future<bool> _showBiometricDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _BiometricDialog(
        onAuthenticated: () => Navigator.pop(ctx, true),
        onCancelled: () => Navigator.pop(ctx, false),
      ),
    );
    return result ?? false;
  }

  void _showSuccessSheet(int novoSaldo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 42),
            ),
            const SizedBox(height: 20),
            Text('Transferência realizada!', style: AppTextStyles.headlineLarge),
            const SizedBox(height: 8),
            Text('Seu dinheiro foi enviado com sucesso.',
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Novo saldo: R\$ $novoSaldo',
                style: AppTextStyles.titleMedium
                    .copyWith(color: AppColors.primaryLight)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
                child: const Text('Voltar ao início'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Transferência', style: AppTextStyles.headlineMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContactsRow(),
                  const SizedBox(height: 28),
                  Text('Dados da transferência', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 16),
                  RubiTextField(
                    label: 'Email do destinatário',
                    hint: 'email@exemplo.com',
                    controller: _destinatarioController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe o destinatário';
                      if (!v.contains('@')) return 'Email inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  RubiTextField(
                    label: 'Valor (R\$)',
                    hint: '0',
                    controller: _valorController,
                    prefixIcon: Icons.attach_money_rounded,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe o valor';
                      final amount = int.tryParse(v);
                      if (amount == null || amount <= 0) return 'Valor inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  RubiButton(
                    text: 'Transferir',
                    onPressed: _handleTransfer,
                    isLoading: _isLoading,
                    icon: Icons.swap_horiz_rounded,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactsRow() {
    final contacts = ['Ana L.', 'João P.', 'Maria S.', 'Carlos R.'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contatos recentes', style: AppTextStyles.titleLarge),
        const SizedBox(height: 14),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: contacts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _destinatarioController.text = contacts[index];
                },
                child: Column(
                  children: [
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(contacts[index][0],
                            style: AppTextStyles.titleLarge),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(contacts[index].split(' ')[0],
                        style: AppTextStyles.caption),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BiometricDialog extends StatefulWidget {
  final VoidCallback onAuthenticated;
  final VoidCallback onCancelled;

  const _BiometricDialog({
    required this.onAuthenticated,
    required this.onCancelled,
  });

  @override
  State<_BiometricDialog> createState() => _BiometricDialogState();
}

class _BiometricDialogState extends State<_BiometricDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  bool _authenticated = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      setState(() => _authenticated = true);
      _pulseController.stop();
      Future.delayed(const Duration(milliseconds: 600), widget.onAuthenticated);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Autenticação', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text('Confirme sua identidade', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 36),
            ScaleTransition(
              scale: _authenticated
                  ? const AlwaysStoppedAnimation(1.0)
                  : _pulseAnim,
              child: Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: _authenticated
                      ? AppColors.success.withOpacity(0.15)
                      : AppColors.primaryGlow,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _authenticated ? AppColors.success : AppColors.primary,
                    width: 2,
                  ),
                ),
                child: Icon(
                  _authenticated ? Icons.check_rounded : Icons.fingerprint_rounded,
                  color: _authenticated ? AppColors.success : AppColors.primaryLight,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _authenticated ? 'Identidade confirmada!' : 'Toque no sensor',
              style: AppTextStyles.titleMedium.copyWith(
                color: _authenticated ? AppColors.success : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 28),
            if (!_authenticated)
              TextButton(
                onPressed: widget.onCancelled,
                child: const Text('Cancelar',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
          ],
        ),
      ),
    );
  }
}
