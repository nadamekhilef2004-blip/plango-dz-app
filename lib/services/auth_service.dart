import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';

// ═══════════════════════════════════════════════════════════════
//  USER MODEL
// ═══════════════════════════════════════════════════════════════
class AppUser {
  final int    id;
  final String name;
  final String email;
  final String password;
  final String avatarColor;
  final DateTime joinedAt;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.avatarColor,
    required this.joinedAt,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String get firstName => name.trim().split(' ').first;

  factory AppUser.fromMap(Map<String, dynamic> m) => AppUser(
    id:          m['id']          as int,
    name:        m['name']        as String,
    email:       m['email']       as String,
    password:    m['password']    as String,
    avatarColor: m['avatar_color'] as String? ?? 'C1440E',
    joinedAt:    DateTime.parse(m['joined_at'] as String),
  );
}

// ═══════════════════════════════════════════════════════════════
//  AUTH SERVICE  —  SQLite-backed singleton
// ═══════════════════════════════════════════════════════════════
class AuthService extends ChangeNotifier {
  static const _sessionKey = 'logged_in_user_id';

  static AuthService? _instance;
  static AuthService get instance {
    _instance ??= AuthService._();
    return _instance!;
  }
  AuthService._();

  AppUser? _user;
  AppUser? get user       => _user;
  bool     get isLoggedIn => _user != null;

  final _db = DatabaseHelper.instance;

  // ── Restore session on app start ──────────────────────────
  Future<void> load() async {
    try {
      final prefs  = await SharedPreferences.getInstance();
      final userId = prefs.getInt(_sessionKey);
      if (userId != null) {
        final row = await _db.getUserById(userId);
        if (row != null) {
          _user = AppUser.fromMap(row);
          notifyListeners();
        }
      }
    } catch (_) {}
  }

  // ── Register ───────────────────────────────────────────────
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Basic validation
    if (name.trim().length < 2)
      return AuthResult.error('Name must be at least 2 characters.');
    if (!email.contains('@') || !email.contains('.'))
      return AuthResult.error('Please enter a valid email address.');
    if (password.length < 6)
      return AuthResult.error('Password must be at least 6 characters.');

    final now = DateTime.now();
    final id  = await _db.insertUser({
      'name':         name.trim(),
      'email':        email.trim().toLowerCase(),
      'password':     password,
      'avatar_color': _pickColor(name),
      'joined_at':    now.toIso8601String(),
    });

    if (id == -1) return AuthResult.error('An account with this email already exists.');

    final row = await _db.getUserById(id);
    if (row == null) return AuthResult.error('Something went wrong. Please try again.');

    _user = AppUser.fromMap(row);
    await _saveSession(_user!.id);
    notifyListeners();
    return AuthResult.success();
  }

  // ── Login ──────────────────────────────────────────────────
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final row = await _db.getUserByEmail(email.trim());
    if (row == null)               return AuthResult.error('No account found with this email.');
    if (row['password'] != password) return AuthResult.error('Incorrect password.');

    _user = AppUser.fromMap(row);
    await _saveSession(_user!.id);
    notifyListeners();
    return AuthResult.success();
  }

  // ── Update name ────────────────────────────────────────────
  Future<void> updateName(String name) async {
    if (_user == null || name.trim().length < 2) return;
    await _db.updateUser(_user!.id, {'name': name.trim()});
    final row = await _db.getUserById(_user!.id);
    if (row != null) _user = AppUser.fromMap(row);
    notifyListeners();
  }

  // ── Update email ───────────────────────────────────────────
  Future<AuthResult> updateEmail(String email) async {
    if (_user == null) return AuthResult.error('Not logged in.');
    if (!email.contains('@')) return AuthResult.error('Invalid email.');

    // Check not already taken by another account
    final existing = await _db.getUserByEmail(email.trim());
    if (existing != null && existing['id'] != _user!.id) {
      return AuthResult.error('This email is already in use.');
    }

    await _db.updateUser(_user!.id, {'email': email.trim().toLowerCase()});
    final row = await _db.getUserById(_user!.id);
    if (row != null) _user = AppUser.fromMap(row);
    notifyListeners();
    return AuthResult.success();
  }

  // ── Update password ────────────────────────────────────────
  Future<AuthResult> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_user == null)                  return AuthResult.error('Not logged in.');
    if (_user!.password != currentPassword) return AuthResult.error('Current password is incorrect.');
    if (newPassword.length < 6)         return AuthResult.error('New password must be at least 6 characters.');

    await _db.updateUser(_user!.id, {'password': newPassword});
    final row = await _db.getUserById(_user!.id);
    if (row != null) _user = AppUser.fromMap(row);
    notifyListeners();
    return AuthResult.success();
  }

  // ── Delete account ─────────────────────────────────────────
  Future<void> deleteAccount() async {
    if (_user == null) return;
    await _db.deleteUser(_user!.id);
    await _clearSession();
    _user = null;
    notifyListeners();
  }

  // ── Logout ─────────────────────────────────────────────────
  Future<void> logout() async {
    _user = null;
    await _clearSession();
    notifyListeners();
  }

  // ── Session helpers ────────────────────────────────────────
  Future<void> _saveSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionKey, userId);
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  // ── Avatar color picker ────────────────────────────────────
  String _pickColor(String name) {
    const colors = ['C1440E', 'C9A84C', '2E86AB', '4E7C59', '8B4513', '6B4226'];
    return colors[name.codeUnitAt(0) % colors.length];
  }
}

// ── Result wrapper ────────────────────────────────────────────
class AuthResult {
  final bool    ok;
  final String? errorMessage;
  const AuthResult._(this.ok, this.errorMessage);
  factory AuthResult.success()         => const AuthResult._(true, null);
  factory AuthResult.error(String msg) => AuthResult._(false, msg);
}