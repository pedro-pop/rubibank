import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../utils/app_text_styles.dart';
import '../widgets/rubi_button.dart';
import '../widgets/rubi_logo.dart';
import '../widgets/rubi_text_field.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  String _formatCPF(String cpf) => cpf.replaceAll(RegExp(r'[^0-9]'), '');
  String _formatTelefone(String tel) => tel.replaceAll(RegExp(r'[^0-9]'), '');

  bool _validarCPF(String cpf) {
    cpf = _formatCPF(cpf);
    if (cpf.length != 11) return false;
    if (cpf.split('').every((d) => d == cpf[0])) return false;
    return true;
  }

  Future<void> _handleCadastro() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final result = await AuthService.instance.register(
      name: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      password: _senhaController.text,
      cpf: _formatCPF(_cpfController.text),
      telefone: _formatTelefone(_telefoneController.text),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      _showSuccess();
    } else {
      _showError(result.errorMessage ?? 'Erro ao realizar cadastro.');
    }
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 40),
            ),
            const SizedBox(height: 16),
            Text('Cadastro realizado!', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text('Sua conta foi criada com sucesso.',
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context); // volta para login
                },
                child: const Text('Fazer login'),
              ),
            ),
          ],
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const RubiLogo(size: 60),
                      const SizedBox(height: 32),
                      Text('Criar conta', style: AppTextStyles.headlineLarge),
                      const SizedBox(height: 6),
                      Text('Preencha seus dados para começar',
                          style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 32),
                      RubiTextField(
                        label: 'Nome completo',
                        hint: 'Seu nome',
                        controller: _nomeController,
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Informe seu nome'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      RubiTextField(
                        label: 'E-mail',
                        hint: 'seu@email.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Informe o e-mail';
                          if (!v.contains('@')) return 'E-mail inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      RubiTextField(
                        label: 'Senha',
                        hint: 'Mínimo 6 caracteres',
                        controller: _senhaController,
                        obscureText: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Informe a senha';
                          if (v.length < 6) return 'Mínimo 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      RubiTextField(
                        label: 'CPF',
                        hint: '000.000.000-00',
                        controller: _cpfController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.badge_outlined,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Informe o CPF';
                          if (!_validarCPF(v)) return 'CPF inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      RubiTextField(
                        label: 'Telefone',
                        hint: '(00) 00000-0000',
                        controller: _telefoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Informe o telefone';
                          if (_formatTelefone(v).length < 10) return 'Telefone inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      RubiButton(
                        text: 'Criar conta',
                        onPressed: _handleCadastro,
                        isLoading: _isLoading,
                        icon: Icons.person_add_rounded,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Já tem conta? ', style: AppTextStyles.bodyMedium),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Fazer login',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
