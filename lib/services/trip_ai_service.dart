import 'dart:math';
import '../data/wilaya_data.dart';
import '../models/day_plan.dart';
import '../models/trip_plan.dart';

class TripAIService {
  static final Random _random = Random();

  TripPlan generateTrip({
    required String category,
    WilayaData? selectedWilaya,
    required int duration,
    required String budgetMode,
    int? manualBudget,
    required String luxuryLevel,
    List<String>? selectedActivities,
  }) {
    WilayaData wilaya = selectedWilaya ?? _selectBestWilaya(category, duration, budgetMode, manualBudget, luxuryLevel);
    
    int totalBudget = _calculateTotalBudget(wilaya, duration, budgetMode, manualBudget, luxuryLevel);
    int dailyBudget = totalBudget ~/ duration;
    
    List<DayPlan> days = _generateDays(wilaya, duration, selectedActivities ?? []);
    
    return TripPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      wilaya: wilaya,
      duration: duration,
      totalBudget: totalBudget,
      dailyBudget: dailyBudget,
      days: days,
      createdAt: DateTime.now(),
    );
  }
  
  WilayaData _selectBestWilaya(String category, int duration, String budgetMode, int? manualBudget, String luxuryLevel) {
    List<WilayaData> filtered = allWilayas.where((w) => w.categories.contains(category)).toList();
    
    int estimatedBudget = _estimateBudgetForScoring(duration, budgetMode, manualBudget, luxuryLevel);
    
    WilayaData best = filtered.reduce((a, b) {
      int scoreA = _calculateScore(a, category, estimatedBudget, duration);
      int scoreB = _calculateScore(b, category, estimatedBudget, duration);
      return scoreA > scoreB ? a : b;
    });
    
    return best;
  }
  
  int _calculateScore(WilayaData wilaya, String category, int budget, int duration) {
    int score = 0;
    if (wilaya.categories.contains(category)) score += 3;
    if (wilaya.attractions.length >= 3) score += 2;
    else if (wilaya.attractions.length >= 2) score += 1;
    
    int dailyBudget = (budget / duration).round();
    if (wilaya.defaultPricePerDay <= dailyBudget) score += 2;
    else if (wilaya.defaultPricePerDay <= dailyBudget * 1.2) score += 1;
    
    return score;
  }
  
  int _estimateBudgetForScoring(int duration, String budgetMode, int? manualBudget, String luxuryLevel) {
    if (budgetMode == 'manual' && manualBudget != null) return manualBudget;
    
    int defaultBudget = 50000;
    double multiplier = _getBudgetMultiplier(luxuryLevel);
    return (defaultBudget * multiplier).round();
  }
  
  double _getBudgetMultiplier(String luxuryLevel) {
    switch (luxuryLevel) {
      case 'Économique': return 0.7;
      case 'Normal': return 1.0;
      case 'Luxe': return 1.8;
      default: return 1.0;
    }
  }
  
  int _calculateTotalBudget(WilayaData wilaya, int duration, String budgetMode, int? manualBudget, String luxuryLevel) {
    if (budgetMode == 'manual' && manualBudget != null) return manualBudget;
    
    double multiplier = _getBudgetMultiplier(luxuryLevel);
    return (wilaya.defaultPricePerDay * duration * multiplier).round();
  }
  
  List<DayPlan> _generateDays(WilayaData wilaya, int duration, List<String> selectedActivities) {
    List<DayPlan> days = [];
    
    List<String> activities = selectedActivities.isNotEmpty ? selectedActivities : List.of(wilaya.activities);
    List<String> attractions = List.of(wilaya.attractions);
    List<String> restaurants = List.of(wilaya.restaurants);
    
    activities.shuffle(_random);
    attractions.shuffle(_random);
    restaurants.shuffle(_random);
    
    for (int day = 1; day <= duration; day++) {
      int actIndex = (day - 1) % activities.length;
      int attrIndex = (day - 1) % attractions.length;
      int restIndex = (day - 1) % restaurants.length;
      
      days.add(DayPlan(
        dayNumber: day,
        morningActivity: activities[actIndex],
        afternoonActivity: attractions[attrIndex],
        eveningActivity: restaurants[restIndex],
        restaurant: restaurants[restIndex],
        isLocked: false,
      ));
    }
    
    return days;
  }
  
  DayPlan regenerateDay(WilayaData wilaya, int dayNumber, List<String> existingMorningActivities) {
    List<String> availableActivities = List.of(wilaya.activities);
    availableActivities.removeWhere((a) => existingMorningActivities.contains(a));
    if (availableActivities.isEmpty) availableActivities = List.of(wilaya.activities);
    
    List<String> attractions = List.of(wilaya.attractions);
    List<String> restaurants = List.of(wilaya.restaurants);
    
    return DayPlan(
      dayNumber: dayNumber,
      morningActivity: availableActivities[_random.nextInt(availableActivities.length)],
      afternoonActivity: attractions[_random.nextInt(attractions.length)],
      eveningActivity: restaurants[_random.nextInt(restaurants.length)],
      restaurant: restaurants[_random.nextInt(restaurants.length)],
      isLocked: false,
    );
  }
}