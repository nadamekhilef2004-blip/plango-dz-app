import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ═══════════════════════════════════════════════════════════════
//  DATABASE HELPER  —  SQLite for PlanGo DZ
//
//  Tables:
//    users       → account data
//    trips       → saved itinerary headers
//    trip_days   → day-by-day breakdown per trip
//    favorites   → bookmarked wilayas per user
// ═══════════════════════════════════════════════════════════════

class DatabaseHelper {
  static const _dbName    = 'plango_dz.db';
  static const _dbVersion = 1;

  // ── Table names ───────────────────────────────────────────
  static const tUsers     = 'users';
  static const tTrips     = 'trips';
  static const tTripDays  = 'trip_days';
  static const tFavorites = 'favorites';

  // ── Singleton ─────────────────────────────────────────────
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  // ── Init ──────────────────────────────────────────────────
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path   = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) => db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // ── Create tables ─────────────────────────────────────────
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tUsers (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        name         TEXT    NOT NULL,
        email        TEXT    NOT NULL UNIQUE,
        password     TEXT    NOT NULL,
        avatar_color TEXT    NOT NULL DEFAULT 'C1440E',
        joined_at    TEXT    NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tTrips (
        id           TEXT    PRIMARY KEY,
        user_id      INTEGER NOT NULL,
        wilaya_name  TEXT    NOT NULL,
        wilaya_image TEXT    NOT NULL,
        category     TEXT    NOT NULL,
        days         INTEGER NOT NULL,
        total_budget INTEGER NOT NULL,
        budget_mode  TEXT    NOT NULL,
        created_at   TEXT    NOT NULL,
        FOREIGN KEY (user_id) REFERENCES $tUsers(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tTripDays (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        trip_id     TEXT    NOT NULL,
        day_number  INTEGER NOT NULL,
        morning     TEXT    NOT NULL,
        lunch       TEXT    NOT NULL,
        afternoon   TEXT    NOT NULL,
        evening     TEXT    NOT NULL,
        hotel       TEXT    NOT NULL,
        budget_day  INTEGER NOT NULL,
        FOREIGN KEY (trip_id) REFERENCES $tTrips(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tFavorites (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id      INTEGER NOT NULL,
        wilaya_name  TEXT    NOT NULL,
        wilaya_image TEXT    NOT NULL,
        category     TEXT    NOT NULL,
        rating       REAL    NOT NULL DEFAULT 4.8,
        added_at     TEXT    NOT NULL,
        UNIQUE(user_id, wilaya_name),
        FOREIGN KEY (user_id) REFERENCES $tUsers(id) ON DELETE CASCADE
      )
    ''');

    // Index for fast lookups
    await db.execute('CREATE INDEX idx_trips_user    ON $tTrips(user_id)');
    await db.execute('CREATE INDEX idx_tripdays_trip ON $tTripDays(trip_id)');
    await db.execute('CREATE INDEX idx_fav_user      ON $tFavorites(user_id)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Add migration logic here when you bump _dbVersion
  }

  // ══════════════════════════════════════════════════════════
  //  USERS
  // ══════════════════════════════════════════════════════════

  /// Insert a new user. Returns the new row id, or -1 if email exists.
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    try {
      return await db.insert(tUsers, user, conflictAlgorithm: ConflictAlgorithm.fail);
    } catch (_) {
      return -1; // email already exists
    }
  }

  /// Find a user by email (case-insensitive).
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db   = await database;
    final rows = await db.query(
      tUsers,
      where: 'LOWER(email) = ?',
      whereArgs: [email.toLowerCase()],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  /// Find a user by id.
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db   = await database;
    final rows = await db.query(tUsers, where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

  /// Update user fields.
  Future<void> updateUser(int id, Map<String, dynamic> fields) async {
    final db = await database;
    await db.update(tUsers, fields, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete a user and all their data (cascade).
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(tUsers, where: 'id = ?', whereArgs: [id]);
  }

  // ══════════════════════════════════════════════════════════
  //  TRIPS
  // ══════════════════════════════════════════════════════════

  /// Save a full trip with its day breakdown inside a transaction.
  Future<bool> saveTrip({
    required Map<String, dynamic> trip,
    required List<Map<String, dynamic>> days,
  }) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        // Upsert trip header
        await txn.insert(tTrips, trip, conflictAlgorithm: ConflictAlgorithm.replace);
        // Delete old days then re-insert (clean upsert)
        await txn.delete(tTripDays, where: 'trip_id = ?', whereArgs: [trip['id']]);
        for (final day in days) {
          await txn.insert(tTripDays, day);
        }
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Get all trips for a user (newest first), with their days loaded.
  Future<List<Map<String, dynamic>>> getTripsForUser(int userId) async {
    final db    = await database;
    final trips = await db.query(
      tTrips,
      where:   'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    final result = <Map<String, dynamic>>[];
    for (final trip in trips) {
      final days = await db.query(
        tTripDays,
        where:   'trip_id = ?',
        whereArgs: [trip['id']],
        orderBy: 'day_number ASC',
      );
      result.add({...trip, 'days': days});
    }
    return result;
  }

  /// Delete a single trip (days cascade automatically).
  Future<void> deleteTrip(String tripId) async {
    final db = await database;
    await db.delete(tTrips, where: 'id = ?', whereArgs: [tripId]);
  }

  /// Delete all trips for a user.
  Future<void> deleteAllTrips(int userId) async {
    final db = await database;
    await db.delete(tTrips, where: 'user_id = ?', whereArgs: [userId]);
  }

  /// Count trips for a user.
  Future<int> countTrips(int userId) async {
    final db  = await database;
    final res = await db.rawQuery('SELECT COUNT(*) as c FROM $tTrips WHERE user_id = ?', [userId]);
    return (res.first['c'] as int?) ?? 0;
  }

  // ══════════════════════════════════════════════════════════
  //  FAVORITES
  // ══════════════════════════════════════════════════════════

  /// Add a wilaya to favorites. Returns true on success.
  Future<bool> addFavorite(Map<String, dynamic> fav) async {
    final db = await database;
    try {
      await db.insert(tFavorites, fav, conflictAlgorithm: ConflictAlgorithm.ignore);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Remove a wilaya from favorites.
  Future<void> removeFavorite({required int userId, required String wilayaName}) async {
    final db = await database;
    await db.delete(
      tFavorites,
      where:     'user_id = ? AND wilaya_name = ?',
      whereArgs: [userId, wilayaName],
    );
  }

  /// Check if a wilaya is already favorited.
  Future<bool> isFavorite({required int userId, required String wilayaName}) async {
    final db  = await database;
    final res = await db.query(
      tFavorites,
      where:     'user_id = ? AND wilaya_name = ?',
      whereArgs: [userId, wilayaName],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  /// Get all favorites for a user (newest first).
  Future<List<Map<String, dynamic>>> getFavoritesForUser(int userId) async {
    final db = await database;
    return db.query(
      tFavorites,
      where:   'user_id = ?',
      whereArgs: [userId],
      orderBy: 'added_at DESC',
    );
  }

  /// Count favorites for a user.
  Future<int> countFavorites(int userId) async {
    final db  = await database;
    final res = await db.rawQuery('SELECT COUNT(*) as c FROM $tFavorites WHERE user_id = ?', [userId]);
    return (res.first['c'] as int?) ?? 0;
  }

  // ══════════════════════════════════════════════════════════
  //  DEV UTILITIES
  // ══════════════════════════════════════════════════════════

  /// Wipe everything — useful during development.
  Future<void> clearAll() async {
    final db = await database;
    await db.delete(tFavorites);
    await db.delete(tTripDays);
    await db.delete(tTrips);
    await db.delete(tUsers);
  }

  /// Close the database connection.
  Future<void> close() async {
    final db = await database;
    await db.close();
    _db = null;
  }
}