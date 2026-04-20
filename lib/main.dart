import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const PlanGoApp());
}

class PlanGoApp extends StatelessWidget {
  const PlanGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlanGo Dz',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),   // ⬅️ Premier écran
    );
  }
}