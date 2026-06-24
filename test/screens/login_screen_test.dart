import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:porto_certo/data/passageiro_mock_db.dart';
import 'package:porto_certo/models/passageiro.dart';
import 'package:porto_certo/notifiers/auth_notifier.dart';
import 'package:porto_certo/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  late AuthNotifier authNotifier;

  Widget buildSubject() {
    return ChangeNotifierProvider<AuthNotifier>.value(
      value: authNotifier,
      child: const MaterialApp(home: LoginScreen()),
    );
  }

  setUp(() {
    authNotifier = AuthNotifier(
      authenticationDelay: const Duration(milliseconds: 250),
      passageiroDB: PassageiroMockDB(
        passageiros: const [
          Passageiro(
            idPassageiro: 1,
            nome: 'Ana Beatriz Costa',
            email: 'ana.costa@email.com',
            telefone: '(92) 99999-1001',
            cpf: '123.456.789-10',
            senha: 'senha123',
          ),
        ],
      ),
    );
  });

  group('LoginScreen', () {
    testWidgets('renderiza campos de email, senha e botao de entrar', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(buildSubject());

      // Act
      final emailField = find.byKey(const Key('login_email_field'));
      final passwordField = find.byKey(const Key('login_password_field'));
      final submitButton = find.byKey(const Key('login_submit_button'));

      // Assert
      expect(find.text('Porto Certo'), findsOneWidget);
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(submitButton, findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('alterna visibilidade da senha ao tocar no suffixIcon', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(buildSubject());
      EditableText passwordEditableText() {
        return tester.widget<EditableText>(
          find.descendant(
            of: find.byKey(const Key('login_password_field')),
            matching: find.byType(EditableText),
          ),
        );
      }

      // Act
      final initiallyObscure = passwordEditableText().obscureText;
      await tester.tap(find.byKey(const Key('toggle_password_visibility')));
      await tester.pump();
      final visibleAfterTap = passwordEditableText().obscureText;

      // Assert
      expect(initiallyObscure, isTrue);
      expect(visibleAfterTap, isFalse);
    });

    testWidgets('exibe loading e autentica com credenciais validas', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(buildSubject());
      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'ana.costa@email.com',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'senha123',
      );

      // Act
      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pump();

      // Assert
      expect(find.byKey(const Key('login_loading_indicator')), findsOneWidget);

      await tester.pumpAndSettle();
      expect(authNotifier.isLoggedIn, isTrue);
      expect(authNotifier.passageiroLogado?.email, 'ana.costa@email.com');
    });

    testWidgets('exibe SnackBar quando credenciais sao invalidas', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(buildSubject());
      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'ana.costa@email.com',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'senha-incorreta',
      );

      // Act
      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pumpAndSettle();

      // Assert
      expect(authNotifier.isLoggedIn, isFalse);
      expect(
        find.text('Credenciais invalidas. Verifique email e senha.'),
        findsOneWidget,
      );
    });

    testWidgets('valida campos obrigatorios antes de submeter', (tester) async {
      // Arrange
      await tester.pumpWidget(buildSubject());

      // Act
      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pump();

      // Assert
      expect(find.text('Informe seu email'), findsOneWidget);
      expect(find.text('Informe sua senha'), findsOneWidget);
      expect(authNotifier.isLoggedIn, isFalse);
    });
  });
}
