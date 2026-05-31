import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ═══════════════════════════════════════════════════════════════
//  USER MODEL
// ═══════════════════════════════════════════════════════════════
class AppUser {
  final String uid;
  final String name;
  final String email;
  final DateTime joinedAt;
  final String? photoUrl;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.joinedAt,
    this.photoUrl,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String get firstName => name.trim().split(' ').first;

  String get avatarColor {
    const colors = ['C1440E', 'C9A84C', '2E86AB', '4E7C59', '8B4513', '6B4226'];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  factory AppUser.fromFirebase(User user) => AppUser(
    uid:      user.uid,
    name:     user.displayName ?? user.email?.split('@').first ?? 'Traveller',
    email:    user.email ?? '',
    joinedAt: user.metadata.creationTime ?? DateTime.now(),
    photoUrl: user.photoURL,
  );
}

// ═══════════════════════════════════════════════════════════════
//  AUTH SERVICE
// ═══════════════════════════════════════════════════════════════
class AuthService extends ChangeNotifier {
  static AuthService? _instance;
  static AuthService get instance {
    _instance ??= AuthService._();
    return _instance!;
  }
  AuthService._();

  final _auth         = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  AppUser? _user;
  AppUser? get user       => _user;
  bool     get isLoggedIn => _user != null;

  // ── Restore session ────────────────────────────────────────
  Future<void> load() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      _user = AppUser.fromFirebase(firebaseUser);
      notifyListeners();
    }

    _auth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        _user = AppUser.fromFirebase(firebaseUser);
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  // ── Register ───────────────────────────────────────────────
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().length < 2)
      return AuthResult.error('Name must be at least 2 characters.');
    if (!email.contains('@') || !email.contains('.'))
      return AuthResult.error('Please enter a valid email address.');
    if (password.length < 6)
      return AuthResult.error('Password must be at least 6 characters.');

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email:    email.trim(),
        password: password,
      );

      // Update name — don't fail if this doesn't work immediately
      try {
        await credential.user?.updateDisplayName(name.trim());
        await credential.user?.reload();
      } catch (_) {
        // Name update failed but account was created — that's fine
      }

      // Use the name we have even if Firebase didn't save it yet
      _user = AppUser(
        uid:      credential.user!.uid,
        name:     name.trim(),  // ← use the name directly, don't wait for Firebase
        email:    email.trim(),
        joinedAt: DateTime.now(),
        photoUrl: null,
      );

      notifyListeners();
      return AuthResult.success();

    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_firebaseError(e.code));
    } catch (e) {
      debugPrint('=== REGISTER ERROR: ${e.runtimeType} | ${e.toString()}');
      return AuthResult.error(e.toString());
    }
  }
  // ── Login ──────────────────────────────────────────────────
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email:    email.trim(),
        password: password,
      );
      _user = AppUser.fromFirebase(_auth.currentUser!);
      notifyListeners();
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_firebaseError(e.code));
    } catch (e) {
      debugPrint('=== LOGIN ERROR: ${e.runtimeType} | ${e.toString()}');
      return AuthResult.error(e.toString());
    }
  }

  // ── Google Sign-In ─────────────────────────────────────────
  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return AuthResult.error('Sign in cancelled.');

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken:     googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      _user = AppUser.fromFirebase(_auth.currentUser!);
      notifyListeners();
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_firebaseError(e.code));
    } catch (e) {
      return AuthResult.error('Google sign in failed. Please try again.');
    }
  }

  // ── Forgot password ────────────────────────────────────────
  Future<AuthResult> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_firebaseError(e.code));
    }
  }

  // ── Update name ────────────────────────────────────────────
  Future<void> updateName(String name) async {
    if (_auth.currentUser == null) return;
    await _auth.currentUser!.updateDisplayName(name.trim());
    await _auth.currentUser!.reload();
    _user = AppUser.fromFirebase(_auth.currentUser!);
    notifyListeners();
  }

  // ── Update email ───────────────────────────────────────────
  Future<AuthResult> updateEmail(String email) async {
    try {
      await _auth.currentUser!.verifyBeforeUpdateEmail(email.trim());
      notifyListeners();
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_firebaseError(e.code));
    }
  }

  // ── Update password ────────────────────────────────────────
  Future<AuthResult> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user       = _auth.currentUser!;
      final credential = EmailAuthProvider.credential(
        email:    user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_firebaseError(e.code));
    }
  }

  // ── Logout ─────────────────────────────────────────────────
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  // ── Delete account ─────────────────────────────────────────
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
    _user = null;
    notifyListeners();
  }

  // ── Error messages ─────────────────────────────────────────
  String _firebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':   return 'An account with this email already exists.';
      case 'invalid-email':          return 'Please enter a valid email address.';
      case 'weak-password':          return 'Password is too weak. Use at least 6 characters.';
      case 'user-not-found':         return 'No account found with this email.';
      case 'wrong-password':         return 'Incorrect password. Please try again.';
      case 'invalid-credential':     return 'Incorrect email or password.';
      case 'too-many-requests':      return 'Too many attempts. Please try again later.';
      case 'network-request-failed': return 'Network error. Check your connection.';
      case 'requires-recent-login':  return 'Please sign out and sign in again.';
      default:                       return 'Something went wrong. Please try again.';
    }
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