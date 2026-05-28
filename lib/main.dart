import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/trip_storage.dart';
import 'services/favorites_service.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Restore session
  await AuthService.instance.load();

  // Load data if logged in
  if (AuthService.instance.isLoggedIn) {
    await TripStorageService.instance.load();
    await FavoritesService.instance.load();
  }

  runApp(const PlanGoApp());
}

class PlanGoApp extends StatelessWidget {
  const PlanGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanGo DZ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF5ECD7),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFC1440E)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}