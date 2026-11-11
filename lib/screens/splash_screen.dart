library flutter_app_365.screens.splash_screen;

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameConstants.cardTableGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.card_giftcard, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              '365',
              style: TextStyle(
                                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: GameConstants.textGold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Card Game',
              style: TextStyle(
                fontSize: 18,
                color: GameConstants.textWhite.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(GameConstants.textGold),
            ),
          ],
        ),
      ),
    );
  }
}



