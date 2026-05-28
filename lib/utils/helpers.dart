class Helpers {
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  // lib/utils/constants.dart
  class AppConstants {
  static const String appName    = 'PlanGo DZ';
  static const String appTagline = "Votre Guide de l'Algérie";
  static const String userToken  = 'user_token';
  static const String userEmail  = 'user_email';
  static const String userName   = 'user_name';
  static const String isLoggedIn = 'is_logged_in';
  }
}