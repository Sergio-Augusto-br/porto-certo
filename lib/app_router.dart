import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:porto_certo/data/viagem_mock_db.dart';
import 'package:porto_certo/models/viagem.dart';
import 'package:porto_certo/notifiers/auth_notifier.dart';
import 'package:porto_certo/screens/cadastro_screen.dart';
import 'package:porto_certo/screens/compra_passagem_screen.dart';
import 'package:porto_certo/screens/detalhes_viagem_screen.dart';
import 'package:porto_certo/screens/home_screen.dart';
import 'package:porto_certo/screens/login_screen.dart';
import 'package:porto_certo/screens/perfil_usuario_screen.dart';
import 'package:porto_certo/screens/resultados_busca_screen.dart';
import 'package:porto_certo/services/api_service.dart';

GoRouter createAppRouter(AuthNotifier authNotifier) {
  CustomTransitionPage<void> fadeTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoginRoute = state.matchedLocation == '/login';
      final isCadastroRoute = state.matchedLocation == '/cadastro';

      if (!authNotifier.isLoggedIn && !isLoginRoute && !isCadastroRoute) {
        return '/login';
      }

      if (authNotifier.isLoggedIn && (isLoginRoute || isCadastroRoute)) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return fadeTransitionPage(state: state, child: const LoginScreen());
        },
      ),
      GoRoute(
        path: '/cadastro',
        pageBuilder: (context, state) {
          return fadeTransitionPage(
            state: state,
            child: const CadastroScreen(),
          );
        },
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) {
          return fadeTransitionPage(state: state, child: const HomeScreen());
        },
      ),
      GoRoute(
        path: '/perfil',
        pageBuilder: (context, state) {
          return fadeTransitionPage(
            state: state,
            child: const PerfilUsuarioScreen(),
          );
        },
      ),
      GoRoute(
        path: '/viagens',
        pageBuilder: (context, state) {
          final params = state.uri.queryParameters;

          return fadeTransitionPage(
            state: state,
            child: ResultadosBuscaScreen(
              origem: params['origem'] ?? '',
              destino: params['destino'] ?? '',
              dataBusca: params['data'] ?? '',
            ),
          );
        },
      ),
      GoRoute(
        path: '/viagens/:id',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          final viagem = id == null ? null : ViagemMockDB.buscarViagemPorId(id);

          if (viagem == null) {
            return fadeTransitionPage(
              state: state,
              child: Scaffold(
                appBar: AppBar(title: const Text('Viagem não encontrada')),
                body: const Center(
                  child: Text('Não foi possível localizar a viagem.'),
                ),
              ),
            );
          }

          return fadeTransitionPage(
            state: state,
            child: _DetalhesViagemRoute(idViagem: viagem.idViagem),
          );
        },
      ),
      GoRoute(
        path: '/checkout',
        pageBuilder: (context, state) {
          final args = state.extra;

          if (args is! CompraPassagemArgs) {
            return fadeTransitionPage(
              state: state,
              child: Scaffold(
                appBar: AppBar(title: const Text('Revisão e Pagamento')),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.info_outline, size: 56),
                        const SizedBox(height: 12),
                        const Text(
                          'Selecione uma viagem antes de iniciar a compra.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: () => context.go('/home'),
                          child: const Text('Voltar para a Home'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return fadeTransitionPage(
            state: state,
            child: CompraPassagemScreen(args: args),
          );
        },
      ),
    ],
  );
}

class _DetalhesViagemRoute extends StatelessWidget {
  const _DetalhesViagemRoute({required this.idViagem});

  final int idViagem;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _buscarViagem(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detalhes da viagem')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final viagem = snapshot.data;
        if (viagem == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Viagem não encontrada')),
            body: const Center(
              child: Text('Não foi possível localizar a viagem.'),
            ),
          );
        }

        return DetalhesViagemScreen(viagem: viagem);
      },
    );
  }

  Future<Viagem?> _buscarViagem() async {
    try {
      return await ApiService().buscarViagemPorId(idViagem);
    } catch (_) {
      return ViagemMockDB.buscarViagemPorId(idViagem);
    }
  }
}
