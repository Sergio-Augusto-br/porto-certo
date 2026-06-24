import 'package:flutter/material.dart';
import 'package:porto_certo/app_router.dart';
import 'package:porto_certo/notifiers/auth_notifier.dart';
import 'package:porto_certo/services/api_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(PortoCertoApp(authNotifier: AuthNotifier(apiService: ApiService())));
}

class PortoCertoApp extends StatelessWidget {
  const PortoCertoApp({required this.authNotifier, super.key});

  final AuthNotifier authNotifier;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: authNotifier,
      child: MaterialApp.router(
        title: 'Porto Certo',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        routerConfig: createAppRouter(authNotifier),
      ),
    );
  }

  ThemeData _buildTheme() {
    const navyBlue = Color(0xFF0D47A1);
    const ctaOrange = Color(0xFFFF8F00);
    final subtleBorder = BorderSide(color: Colors.grey.shade200);

    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: navyBlue,
        primary: navyBlue,
        secondary: ctaOrange,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      fontFamily: 'Roboto',
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
    );

    return baseTheme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: navyBlue,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: subtleBorder,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: subtleBorder,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: navyBlue, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: navyBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: navyBlue),
      dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey.shade900,
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
