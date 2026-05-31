import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'auth_service.dart';

// ═══════════════════════════════════════════════════════════════
//  SAVED TRIP MODEL
// ═══════════════════════════════════════════════════════════════
class SavedTrip {
  final String id;
  final String userId;
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

  factory SavedTrip.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return SavedTrip(
      id:          doc.id,
      userId:      d['userId']      as String,
      wilayaName:  d['wilayaName']  as String,
      wilayaImage: d['wilayaImage'] as String,
      category:    d['category']    as String,
      days:        d['days']        as int,
      totalBudget: d['totalBudget'] as int,
      budgetMode:  d['budgetMode']  as String,
      createdAt:   (d['createdAt'] as Timestamp).toDate(),
      itinerary:   (d['itinerary'] as List)
          .map((e) => SavedTripDay.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId':      userId,
    'wilayaName':  wilayaName,
    'wilayaImage': wilayaImage,
    'category':    category,
    'days':        days,
    'totalBudget': totalBudget,
    'budgetMode':  budgetMode,
    'createdAt':   Timestamp.fromDate(createdAt),
    'itinerary':   itinerary.map((d) => d.toMap()).toList(),
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
    dayNumber:  m['dayNumber']  as int,
    morning:    m['morning']    as String,
    lunch:      m['lunch']      as String,
    afternoon:  m['afternoon']  as String,
    evening:    m['evening']    as String,
    hotel:      m['hotel']      as String,
    budgetDay:  m['budgetDay']  as int,
  );

  Map<String, dynamic> toMap() => {
    'dayNumber':  dayNumber,
    'morning':    morning,
    'lunch':      lunch,
    'afternoon':  afternoon,
    'evening':    evening,
    'hotel':      hotel,
    'budgetDay':  budgetDay,
  };
}

// ═══════════════════════════════════════════════════════════════
//  TRIP STORAGE SERVICE
// ═══════════════════════════════════════════════════════════════
class TripStorageService extends ChangeNotifier {
  static TripStorageService? _instance;
  static TripStorageService get instance {
    _instance ??= TripStorageService._();
    return _instance!;
  }
  TripStorageService._();

  final _db   = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  List<SavedTrip> _trips = [];
  List<SavedTrip> get trips    => List.unmodifiable(_trips);
  bool            get hasTrips => _trips.isNotEmpty;
  int             get count    => _trips.length;

  CollectionReference get _col => _db.collection('trips');

  // ── Load trips ─────────────────────────────────────────────
  Future<void> load() async {
    final user = AuthService.instance.user;
    if (user == null) { _trips = []; notifyListeners(); return; }

    try {
      final snap = await _col
          .where('userId', isEqualTo: user.uid)
          .get();

// Then sort in Dart instead:
      _trips = snap.docs.map(SavedTrip.fromFirestore).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      notifyListeners();
    } catch (_) {
      _trips = [];
    }
  }

  // ── Save a trip ────────────────────────────────────────────
  Future<bool> save({
    required String wilayaName,
    required String wilayaImage,
    required String category,
    required int    days,
    required int    totalBudget,
    required String budgetMode,
    required List<SavedTripDay> itinerary,
  }) async {
    final user = AuthService.instance.user;
    if (user == null) return false;

    try {
      final tripId = _uuid.v4();
      final trip   = SavedTrip(
        id:          tripId,
        userId:      user.uid,
        wilayaName:  wilayaName,
        wilayaImage: wilayaImage,
        category:    category,
        days:        days,
        totalBudget: totalBudget,
        budgetMode:  budgetMode,
        itinerary:   itinerary,
        createdAt:   DateTime.now(),
      );
      await _col.doc(tripId).set(trip.toMap());
      _trips.insert(0, trip);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Delete a trip ──────────────────────────────────────────
  Future<void> delete(String tripId) async {
    try {
      await _col.doc(tripId).delete();
      _trips.removeWhere((t) => t.id == tripId);
      notifyListeners();
    } catch (_) {}
  }

  // ── Clear all ──────────────────────────────────────────────
  Future<void> clearAll() async {
    final user = AuthService.instance.user;
    if (user == null) return;
    try {
      final snap  = await _col.where('userId', isEqualTo: user.uid).get();
      final batch = _db.batch();
      for (final doc in snap.docs) batch.delete(doc.reference);
      await batch.commit();
      _trips = [];
      notifyListeners();
    } catch (_) {}
  }

  void clear() { _trips = []; notifyListeners(); }
}