import '../data/wilaya_data.dart';
import 'day_plan.dart';

class TripPlan {
  final String id;
  final WilayaData wilaya;
  final int duration;
  final int totalBudget;
  final int dailyBudget;
  final List<DayPlan> days;
  final DateTime createdAt;
  bool isSaved;

  TripPlan({
    required this.id,
    required this.wilaya,
    required this.duration,
    required this.totalBudget,
    required this.dailyBudget,
    required this.days,
    required this.createdAt,
    this.isSaved = false,
  });
}