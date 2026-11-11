import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/score_screen.dart';
import 'screens/rules_screen.dart';
import 'providers/game_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        title: '365 Card Game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1B5E20),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF1B5E20),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/game': (context) => const GameScreen(),
          '/score': (context) => const ScoreScreen(),
          '/rules': (context) => const RulesScreen(),
        },
        builder: (context, child) {
          // Initialize game provider after first frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<GameProvider>().init();
          });
          return child!;
        },
      ),
    );
  }
}
