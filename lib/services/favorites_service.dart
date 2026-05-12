import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'auth_service.dart';

// ═══════════════════════════════════════════════════════════════
//  FAVORITE MODEL
// ═══════════════════════════════════════════════════════════════
class FavoriteWilaya {
  final int    id;
  final int    userId;
  final String wilayaName;
  final String wilayaImage;
  final String category;
  final double rating;
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

  factory FavoriteWilaya.fromMap(Map<String, dynamic> m) => FavoriteWilaya(
    id:          m['id']           as int,
    userId:      m['user_id']      as int,
    wilayaName:  m['wilaya_name']  as String,
    wilayaImage: m['wilaya_image'] as String,
    category:    m['category']     as String,
    rating:      (m['rating']  as num).toDouble(),
    addedAt:     DateTime.parse(m['added_at'] as String),
  );
}

// ═══════════════════════════════════════════════════════════════
//  FAVORITES SERVICE  —  SQLite-backed singleton
// ═══════════════════════════════════════════════════════════════
class FavoritesService extends ChangeNotifier {
  static FavoritesService? _instance;
  static FavoritesService get instance {
    _instance ??= FavoritesService._();
    return _instance!;
  }
  FavoritesService._();

  final _db = DatabaseHelper.instance;

  List<FavoriteWilaya> _favorites = [];
  List<FavoriteWilaya> get favorites  => List.unmodifiable(_favorites);
  bool                 get hasFavorites => _favorites.isNotEmpty;
  int                  get count      => _favorites.length;

  // ── Load favorites for current user ────────────────────────
  Future<void> load() async {
    final user = AuthService.instance.user;
    if (user == null) { _favorites = []; notifyListeners(); return; }

    try {
      final rows = await _db.getFavoritesForUser(user.id);
      _favorites = rows.map(FavoriteWilaya.fromMap).toList();
      notifyListeners();
    } catch (_) {
      _favorites = [];
    }
  }

  // ── Toggle (add or remove) ─────────────────────────────────
  Future<bool> toggle({
    required String wilayaName,
    required String wilayaImage,
    required String category,
    double rating = 4.8,
  }) async {
    final user = AuthService.instance.user;
    if (user == null) return false;

    if (isFavorite(wilayaName)) {
      await _db.removeFavorite(userId: user.id, wilayaName: wilayaName);
      _favorites.removeWhere((f) => f.wilayaName == wilayaName);
      notifyListeners();
      return false; // removed
    } else {
      final ok = await _db.addFavorite({
        'user_id':      user.id,
        'wilaya_name':  wilayaName,
        'wilaya_image': wilayaImage,
        'category':     category,
        'rating':       rating,
        'added_at':     DateTime.now().toIso8601String(),
      });
      if (ok) await load(); // reload to get auto-generated id
      return true; // added
    }
  }

  // ── Remove by name ─────────────────────────────────────────
  Future<void> remove(String wilayaName) async {
    final user = AuthService.instance.user;
    if (user == null) return;
    await _db.removeFavorite(userId: user.id, wilayaName: wilayaName);
    _favorites.removeWhere((f) => f.wilayaName == wilayaName);
    notifyListeners();
  }

  // ── Check ──────────────────────────────────────────────────
  bool isFavorite(String wilayaName) =>
      _favorites.any((f) => f.wilayaName == wilayaName);
}