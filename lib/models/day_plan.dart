class DayPlan {
  final int dayNumber;
  String morningActivity;
  String afternoonActivity;
  String eveningActivity;
  String restaurant;
  bool isLocked;
  String? notes;

  DayPlan({
    required this.dayNumber,
    required this.morningActivity,
    required this.afternoonActivity,
    required this.eveningActivity,
    required this.restaurant,
    this.isLocked = false,
    this.notes,
  });

  DayPlan copyWith({
    int? dayNumber,
    String? morningActivity,
    String? afternoonActivity,
    String? eveningActivity,
    String? restaurant,
    bool? isLocked,
    String? notes,
  }) {
    return DayPlan(
      dayNumber: dayNumber ?? this.dayNumber,
      morningActivity: morningActivity ?? this.morningActivity,
      afternoonActivity: afternoonActivity ?? this.afternoonActivity,
      eveningActivity: eveningActivity ?? this.eveningActivity,
      restaurant: restaurant ?? this.restaurant,
      isLocked: isLocked ?? this.isLocked,
      notes: notes ?? this.notes,
    );
  }
}