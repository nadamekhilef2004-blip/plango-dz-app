import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'utils/theme.dart';

void main() {
  runApp(const PlangoDZ());
}

class PlangoDZ extends StatelessWidget {
  const PlangoDZ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlanGo Dz',
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}
