import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._();

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  static String get geminiApiKey {
    final key = dotenv.env['GEMINI_API_KEY'];
    assert(key != null && key.isNotEmpty,
    'GEMINI_API_KEY manquante dans .env');
    return key!;
  }
}