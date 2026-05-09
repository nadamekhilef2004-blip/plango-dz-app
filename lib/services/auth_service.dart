import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════
//  USER MODEL
// ═══════════════════════════════════════════════════════════════
class AppUser {
  final String name;
  final String email;
  final String password; // hashed in a real app
  final DateTime joinedAt;
  final String? avatarColor; // stored as hex string

  const AppUser({
    required this.name,
    required this.email,
    required this.password,
    required this.joinedAt,
    this.avatarColor,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String get firstName => name.trim().split(' ').first;

  Map<String, dynamic> toJson() => {
    'name':        name,
    'email':       email,
    'password':    password,
    'joinedAt':    joinedAt.toIso8601String(),
    'avatarColor': avatarColor,
  };

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
    name:        j['name']        as String,
    email:       j['email']       as String,
    password:    j['password']    as String,
    joinedAt:    DateTime.parse(j['joinedAt'] as String),
    avatarColor: j['avatarColor'] as String?,
  );

  AppUser copyWith({String? name, String? email, String? password, String? avatarColor}) => AppUser(
    name:        name        ?? this.name,
    email:       email       ?? this.email,
    password:    password    ?? this.password,
    joinedAt:    joinedAt,
    avatarColor: avatarColor ?? this.avatarColor,
  );
}

// ═══════════════════════════════════════════════════════════════
//  AUTH SERVICE  (singleton ChangeNotifier)
// ═══════════════════════════════════════════════════════════════
class AuthService extends ChangeNotifier {
  static const _userKey = 'current_user';
  static AuthService? _instance;

  AppUser? _user;
  AppUser? get user      => _user;
  bool     get isLoggedIn => _user != null;

  AuthService._();
  static AuthService get instance {
    _instance ??= AuthService._();
    return _instance!;
  }

  // ── Load saved session ─────────────────────────────────────
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw   = prefs.getString(_userKey);
      if (raw != null) {
        _user = AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (_) {}
  }

  // ── Register ───────────────────────────────────────────────
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900)); // simulate network
    if (name.trim().length < 2)    return AuthResult.error('Name must be at least 2 characters.');
    if (!email.contains('@'))      return AuthResult.error('Please enter a valid email address.');
    if (password.length < 6)       return AuthResult.error('Password must be at least 6 characters.');

    _user = AppUser(
      name:        name.trim(),
      email:       email.trim().toLowerCase(),
      password:    password,
      joinedAt:    DateTime.now(),
      avatarColor: _pickColor(name),
    );
    await _persist();
    notifyListeners();
    return AuthResult.success();
  }

  // ── Login ──────────────────────────────────────────────────
  Future<AuthResult> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (_user == null)                                   return AuthResult.error('No account found. Please create one first.');
    if (_user!.email != email.trim().toLowerCase())      return AuthResult.error('Email not found.');
    if (_user!.password != password)                     return AuthResult.error('Incorrect password.');
    notifyListeners();
    return AuthResult.success();
  }

  // ── Update profile ─────────────────────────────────────────
  Future<void> updateName(String name) async {
    if (_user == null) return;
    _user = _user!.copyWith(name: name.trim());
    await _persist();
    notifyListeners();
  }

  Future<void> updateEmail(String email) async {
    if (_user == null) return;
    _user = _user!.copyWith(email: email.trim().toLowerCase());
    await _persist();
    notifyListeners();
  }

  // ── Logout ─────────────────────────────────────────────────
  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    notifyListeners();
  }

  // ── Helpers ────────────────────────────────────────────────
  Future<void> _persist() async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
  }

  String _pickColor(String name) {
    final colors = ['C1440E', 'C9A84C', '2E86AB', '4E7C59', '8B4513', '6B4226'];
    return colors[name.codeUnitAt(0) % colors.length];
  }
}

// ── Result wrapper ─────────────────────────────────────────────
class AuthResult {
  final bool   ok;
  final String? errorMessage;
  const AuthResult._(this.ok, this.errorMessage);
  factory AuthResult.success()          => const AuthResult._(true,  null);
  factory AuthResult.error(String msg)  => AuthResult._(false, msg);
}