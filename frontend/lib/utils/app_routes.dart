import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/cotacao_screen.dart';
import '../screens/transferencia_screen.dart';
import '../screens/perfil_screen.dart';
import '../models/transfer_args.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String cotacao = '/cotacao';
  static const String transferencia = '/transferencia';
  static const String perfil = '/perfil';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _buildRoute(const LoginScreen(), settings);

      case home:
        return _buildRoute(const HomeScreen(), settings);

      case cotacao:
        return _buildRoute(const CotacaoScreen(), settings);

      case transferencia:
        // Rota com argumentos (TransferArgs pode ser passado opcionalmente)
        final args = settings.arguments as TransferArgs?;
        return _buildRoute(TransferenciaScreen(args: args), settings);

      case perfil:
        return _buildRoute(const PerfilScreen(), settings);

      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('Rota não encontrada: ${settings.name}',
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
          settings,
        );
    }
  }

  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
