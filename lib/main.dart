import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/database_helper.dart';
import 'services/auth_service.dart';
import 'services/trip_storage.dart';
import 'services/favorites_service.dart';
import 'screens/home_page.dart';

// ═══════════════════════════════════════════════════════════════
//  MAIN  —  initialise DB and services before app starts
// ═══════════════════════════════════════════════════════════════
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 1. Open the SQLite database (creates tables if first launch)
  await DatabaseHelper.instance.database;

  // 2. Restore user session (reads saved user_id from shared_preferences,
  //    then fetches the full user row from SQLite)
  await AuthService.instance.load();

  // 3. Load saved trips and favorites for the restored user (if any)
  await TripStorageService.instance.load();
  await FavoritesService.instance.load();

  runApp(const PlanGoApp());
}

class PlanGoApp extends StatelessWidget {
  const PlanGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:        'PlanGo DZ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily:       'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF5ECD7),
        colorScheme:      ColorScheme.fromSeed(seedColor: const Color(0xFFC1440E)),
        useMaterial3:     true,
      ),
      home: const HomePage(),
    );
  }
}