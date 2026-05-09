import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'log.dart';
import 'log_input_page.dart';
import 'splash_page.dart'; // ← ここが重要（lib直下）

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(LogAdapter());
  await Hive.openBox<Log>('logs');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const neonPurple = Color(0xFF9D4EDD);
    const neonPink = Color(0xFFFF4FD8);
    const darkBg = Color(0xFF121212);
    const cardBg = Color(0xFF1E1E1E);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GrooveTracks',

      // ★ スプラッシュ → ホームのルーティング
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashPage(),
        '/home': (_) => const LogInputPage(),
      },

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBg,

        colorScheme: const ColorScheme.dark(
          primary: neonPurple,
          secondary: neonPink,
          surface: cardBg,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF18122B),
          centerTitle: true,
          elevation: 4,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        cardTheme: CardThemeData(
          color: cardBg,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: neonPurple,
            foregroundColor: Colors.white,
            elevation: 6,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: neonPurple,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: neonPurple.withOpacity(0.4),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: neonPink,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(14),
            ),
          ),
          labelStyle: const TextStyle(
            color: Colors.white70,
          ),
        ),

        chipTheme: ChipThemeData(
          backgroundColor: neonPurple.withOpacity(0.25),
          selectedColor: neonPink,
          labelStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: neonPink,
            ),
          ),
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: neonPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      ),
    );
  }
}
