import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../utils/app_text_styles.dart';
import '../widgets/rubi_button.dart';
import '../widgets/rubi_logo.dart';
import '../widgets/rubi_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _biometricLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final result = await AuthService.instance.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      _showError(result.errorMessage ?? 'Erro ao fazer login.');
    }
  }

  Future<void> _handleBiometric() async {
    setState(() => _biometricLoading = true);
    final success = await AuthService.instance.authenticateWithBiometrics();
    if (!mounted) return;
    setState(() => _biometricLoading = false);
    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      const SizedBox(height: 60),
                      const RubiLogo(size: 72),
                      const SizedBox(height: 52),
                      _buildWelcomeText(),
                      const SizedBox(height: 36),
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
                        controller: _passwordController,
                        obscureText: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Informe a senha';
                          if (v.length < 6) return 'Senha muito curta';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Esqueci minha senha',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.primaryLight)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      RubiButton(
                        text: 'Entrar',
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 16),
                      _buildDivider(),
                      const SizedBox(height: 16),
                      _buildBiometricButton(),
                      const SizedBox(height: 32),
                      _buildRegisterButton(),
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

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text('Bem-vindo de volta', style: AppTextStyles.headlineLarge),
        const SizedBox(height: 6),
        Text('Acesse sua conta para continuar',
            style: AppTextStyles.bodyMedium),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.surfaceLight)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('ou', style: AppTextStyles.caption),
        ),
        const Expanded(child: Divider(color: AppColors.surfaceLight)),
      ],
    );
  }

  Widget _buildBiometricButton() {
    return GestureDetector(
      onTap: _handleBiometric,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceLight, width: 1),
        ),
        child: _biometricLoading
            ? const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.fingerprint,
                      color: AppColors.primaryLight, size: 26),
                  const SizedBox(width: 10),
                  Text('Entrar com biometria',
                      style: AppTextStyles.labelLarge
                          .copyWith(color: AppColors.primaryLight)),
                ],
              ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Não tem conta? ', style: AppTextStyles.bodyMedium),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.cadastro),
          child: Text(
            'Criar conta',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
