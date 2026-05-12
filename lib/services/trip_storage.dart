import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'database_helper.dart';
import 'auth_service.dart';

// ═══════════════════════════════════════════════════════════════
//  SAVED TRIP MODEL
// ═══════════════════════════════════════════════════════════════
class SavedTrip {
  final String id;
  final int    userId;
  final String wilayaName;
  final String wilayaImage;
  final String category;
  final int    days;
  final int    totalBudget;
  final String budgetMode;
  final List<SavedTripDay> itinerary;
  final DateTime createdAt;

  const SavedTrip({
    required this.id,
    required this.userId,
    required this.wilayaName,
    required this.wilayaImage,
    required this.category,
    required this.days,
    required this.totalBudget,
    required this.budgetMode,
    required this.itinerary,
    required this.createdAt,
  });

  factory SavedTrip.fromMap(Map<String, dynamic> m) => SavedTrip(
    id:          m['id']           as String,
    userId:      m['user_id']      as int,
    wilayaName:  m['wilaya_name']  as String,
    wilayaImage: m['wilaya_image'] as String,
    category:    m['category']     as String,
    days:        m['days']         as int,
    totalBudget: m['total_budget'] as int,
    budgetMode:  m['budget_mode']  as String,
    createdAt:   DateTime.parse(m['created_at'] as String),
    itinerary:   (m['days_data'] as List<Map<String, dynamic>>? ?? [])
        .map(SavedTripDay.fromMap)
        .toList(),
  );

  Map<String, dynamic> toTripMap() => {
    'id':           id,
    'user_id':      userId,
    'wilaya_name':  wilayaName,
    'wilaya_image': wilayaImage,
    'category':     category,
    'days':         days,
    'total_budget': totalBudget,
    'budget_mode':  budgetMode,
    'created_at':   createdAt.toIso8601String(),
  };
}

class SavedTripDay {
  final int    dayNumber;
  final String morning;
  final String lunch;
  final String afternoon;
  final String evening;
  final String hotel;
  final int    budgetDay;

  const SavedTripDay({
    required this.dayNumber,
    required this.morning,
    required this.lunch,
    required this.afternoon,
    required this.evening,
    required this.hotel,
    required this.budgetDay,
  });

  factory SavedTripDay.fromMap(Map<String, dynamic> m) => SavedTripDay(
    dayNumber:  m['day_number'] as int,
    morning:    m['morning']    as String,
    lunch:      m['lunch']      as String,
    afternoon:  m['afternoon']  as String,
    evening:    m['evening']    as String,
    hotel:      m['hotel']      as String,
    budgetDay:  m['budget_day'] as int,
  );

  Map<String, dynamic> toDayMap(String tripId) => {
    'trip_id':    tripId,
    'day_number': dayNumber,
    'morning':    morning,
    'lunch':      lunch,
    'afternoon':  afternoon,
    'evening':    evening,
    'hotel':      hotel,
    'budget_day': budgetDay,
  };
}

// ═══════════════════════════════════════════════════════════════
//  TRIP STORAGE SERVICE  —  SQLite-backed singleton
// ═══════════════════════════════════════════════════════════════
class TripStorageService extends ChangeNotifier {
  static TripStorageService? _instance;
  static TripStorageService get instance {
    _instance ??= TripStorageService._();
    return _instance!;
  }
  TripStorageService._();

  final _db   = DatabaseHelper.instance;
  final _uuid = const Uuid();

  List<SavedTrip> _trips = [];
  List<SavedTrip> get trips   => List.unmodifiable(_trips);
  bool            get hasTrips => _trips.isNotEmpty;
  int             get count    => _trips.length;

  // ── Load trips for current user ────────────────────────────
  Future<void> load() async {
    final user = AuthService.instance.user;
    if (user == null) { _trips = []; notifyListeners(); return; }

    try {
      final rows = await _db.getTripsForUser(user.id);
      _trips = rows.map((row) {
        final days = (row['days'] as List)
            .map((d) => SavedTripDay.fromMap(d as Map<String, dynamic>))
            .toList();
        return SavedTrip(
          id:          row['id']           as String,
          userId:      row['user_id']      as int,
          wilayaName:  row['wilaya_name']  as String,
          wilayaImage: row['wilaya_image'] as String,
          category:    row['category']     as String,
          days:        row['days_count'] ?? (row['days'] as List).length,
          totalBudget: row['total_budget'] as int,
          budgetMode:  row['budget_mode']  as String,
          createdAt:   DateTime.parse(row['created_at'] as String),
          itinerary:   days,
        );
      }).toList();
      notifyListeners();
    } catch (_) {
      _trips = [];
    }
  }

  // ── Save a trip ────────────────────────────────────────────
  Future<bool> save({
    required String    wilayaName,
    required String    wilayaImage,
    required String    category,
    required int       days,
    required int       totalBudget,
    required String    budgetMode,
    required List<SavedTripDay> itinerary,
  }) async {
    final user = AuthService.instance.user;
    if (user == null) return false;

    final tripId = _uuid.v4();
    final trip   = SavedTrip(
      id:          tripId,
      userId:      user.id,
      wilayaName:  wilayaName,
      wilayaImage: wilayaImage,
      category:    category,
      days:        days,
      totalBudget: totalBudget,
      budgetMode:  budgetMode,
      itinerary:   itinerary,
      createdAt:   DateTime.now(),
    );

    final ok = await _db.saveTrip(
      trip: trip.toTripMap(),
      days: itinerary.map((d) => d.toDayMap(tripId)).toList(),
    );

    if (ok) {
      _trips.insert(0, trip);
      notifyListeners();
    }
    return ok;
  }

  // ── Delete a trip ──────────────────────────────────────────
  Future<void> delete(String tripId) async {
    await _db.deleteTrip(tripId);
    _trips.removeWhere((t) => t.id == tripId);
    notifyListeners();
  }

  // ── Clear all trips for current user ───────────────────────
  Future<void> clearAll() async {
    final user = AuthService.instance.user;
    if (user == null) return;
    await _db.deleteAllTrips(user.id);
    _trips = [];
    notifyListeners();
  }

  // ── Check if a trip id is saved ────────────────────────────
  bool isSaved(String tripId) => _trips.any((t) => t.id == tripId);
}