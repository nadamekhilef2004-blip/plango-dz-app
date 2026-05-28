import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

// ═══════════════════════════════════════════════════════════════
//  FAVORITE MODEL
// ═══════════════════════════════════════════════════════════════
class FavoriteWilaya {
  final String   id;
  final String   userId;
  final String   wilayaName;
  final String   wilayaImage;
  final String   category;
  final double   rating;
  final DateTime addedAt;

  const FavoriteWilaya({
    required this.id,
    required this.userId,
    required this.wilayaName,
    required this.wilayaImage,
    required this.category,
    required this.rating,
    required this.addedAt,
  });

  factory FavoriteWilaya.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return FavoriteWilaya(
      id:          doc.id,
      userId:      d['userId']      as String,
      wilayaName:  d['wilayaName']  as String,
      wilayaImage: d['wilayaImage'] as String,
      category:    d['category']    as String,
      rating:      (d['rating']     as num).toDouble(),
      addedAt:     (d['addedAt']    as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId':      userId,
    'wilayaName':  wilayaName,
    'wilayaImage': wilayaImage,
    'category':    category,
    'rating':      rating,
    'addedAt':     Timestamp.fromDate(addedAt),
  };
}

// ═══════════════════════════════════════════════════════════════
//  FAVORITES SERVICE
// ═══════════════════════════════════════════════════════════════
class FavoritesService extends ChangeNotifier {
  static FavoritesService? _instance;
  static FavoritesService get instance {
    _instance ??= FavoritesService._();
    return _instance!;
  }
  FavoritesService._();

  final _db = FirebaseFirestore.instance;

  List<FavoriteWilaya> _favorites = [];
  List<FavoriteWilaya> get favorites    => List.unmodifiable(_favorites);
  bool                 get hasFavorites => _favorites.isNotEmpty;
  int                  get count        => _favorites.length;

  CollectionReference get _col => _db.collection('favorites');

  // ── Load ───────────────────────────────────────────────────
  Future<void> load() async {
    final user = AuthService.instance.user;
    if (user == null) { _favorites = []; notifyListeners(); return; }

    try {
      final snap = await _col
          .where('userId', isEqualTo: user.uid)
          .get();

      _favorites = snap.docs.map(FavoriteWilaya.fromFirestore).toList()
        ..sort((a, b) => b.addedAt.compareTo(a.addedAt));

      _favorites = snap.docs.map(FavoriteWilaya.fromFirestore).toList();
      notifyListeners();
    } catch (_) {
      _favorites = [];
    }
  }

  // ── Toggle ─────────────────────────────────────────────────
  Future<bool> toggle({
    required String wilayaName,
    required String wilayaImage,
    required String category,
    double rating = 4.8,
  }) async {
    final user = AuthService.instance.user;
    if (user == null) return false;

    if (isFavorite(wilayaName)) {
      final existing = _favorites.firstWhere((f) => f.wilayaName == wilayaName);
      await _col.doc(existing.id).delete();
      _favorites.removeWhere((f) => f.wilayaName == wilayaName);
      notifyListeners();
      return false;
    } else {
      final doc = _col.doc();
      final fav = FavoriteWilaya(
        id:          doc.id,
        userId:      user.uid,
        wilayaName:  wilayaName,
        wilayaImage: wilayaImage,
        category:    category,
        rating:      rating,
        addedAt:     DateTime.now(),
      );
      await doc.set(fav.toMap());
      _favorites.insert(0, fav);
      notifyListeners();
      return true;
    }
  }

  // ── Remove ─────────────────────────────────────────────────
  Future<void> remove(String wilayaName) async {
    try {
      final existing = _favorites.firstWhere((f) => f.wilayaName == wilayaName);
      await _col.doc(existing.id).delete();
      _favorites.removeWhere((f) => f.wilayaName == wilayaName);
      notifyListeners();
    } catch (_) {}
  }

  // ── Check ──────────────────────────────────────────────────
  bool isFavorite(String wilayaName) =>
      _favorites.any((f) => f.wilayaName == wilayaName);

  void clear() { _favorites = []; notifyListeners(); }
}