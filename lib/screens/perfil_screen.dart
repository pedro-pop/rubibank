import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/mock_data_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../utils/app_text_styles.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Meu Perfil', style: AppTextStyles.headlineMedium),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, user.name, user.email),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildAccountCard(user.cpf),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Segurança',
                    items: [
                      _SettingItem(
                        icon: Icons.lock_outline_rounded,
                        label: 'Alterar senha',
                        onTap: () {
                          // TODO: Implementar alteração de senha
                        },
                      ),
                      _SettingItem(
                        icon: Icons.fingerprint_rounded,
                        label: 'Biometria',
                        trailing: _buildSwitch(true),
                        onTap: () {
                          // TODO: Integrar com local_auth
                        },
                      ),
                      _SettingItem(
                        icon: Icons.notifications_outlined,
                        label: 'Notificações',
                        trailing: _buildSwitch(true),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Preferências',
                    items: [
                      _SettingItem(
                        icon: Icons.camera_alt_outlined,
                        label: 'Alterar foto de perfil',
                        onTap: () {
                          // TODO: Integrar image_picker / camera plugin
                          _showCameraDialog(context);
                        },
                      ),
                      _SettingItem(
                        icon: Icons.share_outlined,
                        label: 'Compartilhar app',
                        onTap: () {
                          // TODO: Integrar share_plus plugin
                        },
                      ),
                      _SettingItem(
                        icon: Icons.help_outline_rounded,
                        label: 'Ajuda e suporte',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Conta',
                    items: [
                      _SettingItem(
                        icon: Icons.info_outline_rounded,
                        label: 'Sobre o RubiBank',
                        onTap: () => _showAboutDialog(context),
                      ),
                      _SettingItem(
                        icon: Icons.logout_rounded,
                        label: 'Sair da conta',
                        labelColor: AppColors.error,
                        iconColor: AppColors.error,
                        onTap: () => _confirmLogout(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, String name, String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1C1212), Color(0xFF121212)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    name[0].toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showCameraDialog(context),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: AppColors.primaryLight, size: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(name, style: AppTextStyles.headlineLarge),
          const SizedBox(height: 4),
          Text(email, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.success.withOpacity(0.3), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Text('Conta verificada',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.success)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(String cpf) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceLight, width: 0.5),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.badge_outlined, 'CPF', cpf),
          const Divider(color: AppColors.surfaceLight, height: 24),
          _buildInfoRow(Icons.account_balance_outlined, 'Agência', '0001'),
          const Divider(color: AppColors.surfaceLight, height: 24),
          _buildInfoRow(Icons.numbers_rounded, 'Conta', '12345-6'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 18),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.bodyMedium),
        const Spacer(),
        Text(value,
            style: AppTextStyles.titleMedium
                .copyWith(color: AppColors.primaryLight)),
      ],
    );
  }

  Widget _buildSection(
      {required String title, required List<_SettingItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 2),
          child: Text(title, style: AppTextStyles.bodySmall),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.surfaceLight, width: 0.5),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              return Column(
                children: [
                  _buildSettingTile(entry.value),
                  if (!isLast)
                    const Divider(
                        color: AppColors.surfaceLight,
                        height: 1,
                        indent: 52),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(_SettingItem item) {
    return ListTile(
      onTap: item.onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: (item.iconColor ?? AppColors.textSecondary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(item.icon,
            color: item.iconColor ?? AppColors.textSecondary, size: 18),
      ),
      title: Text(item.label,
          style: AppTextStyles.titleMedium
              .copyWith(color: item.labelColor ?? AppColors.textPrimary)),
      trailing: item.trailing ??
          Icon(Icons.chevron_right_rounded,
              color: AppColors.textHint, size: 20),
    );
  }

  Widget _buildSwitch(bool value) {
    return Switch(
      value: value,
      onChanged: (_) {},
      activeColor: AppColors.primary,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showCameraDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Alterar foto', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: AppColors.primaryLight),
              title: Text('Câmera', style: AppTextStyles.titleMedium),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: Integrar camera plugin
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.primaryLight),
              title:
                  Text('Galeria', style: AppTextStyles.titleMedium),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: Integrar image_picker plugin
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('RubiBank', style: AppTextStyles.headlineMedium),
        content: Text(
          'Versão 1.0.0\nBanco digital moderno e seguro.\n\nDesenvolvido com Flutter.',
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

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Sair da conta?', style: AppTextStyles.headlineMedium),
        content: Text(
          'Tem certeza que deseja sair?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar',
                style:
                    TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              // TODO: Chamar Firebase Auth signOut
              await AuthService.instance.logout();
              if (!ctx.mounted) return;
              Navigator.of(ctx).pushNamedAndRemoveUntil(
                  AppRoutes.login, (route) => false);
            },
            child: const Text('Sair',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? labelColor;

  const _SettingItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.iconColor,
    this.labelColor,
  });
}
