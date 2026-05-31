import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/luxury_theme.dart';
import '../services/auth_service.dart';
import 'login_page.dart';


// ═══════════════════════════════════════════════════════════════
//  REGISTER PAGE  —  Full account creation
// ═══════════════════════════════════════════════════════════════
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {

  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();
  final _confirmCtrl  = TextEditingController();

  bool _obscurePass    = true;
  bool _obscureConfirm = true;
  bool _loading        = false;
  String? _error;

  // Field-level validation messages
  String? _nameError;
  String? _emailError;
  String? _passError;
  String? _confirmError;

  // Password strength
  int get _passStrength {
    final p = _passCtrl.text;
    int score = 0;
    if (p.length >= 6)                          score++;
    if (p.length >= 10)                         score++;
    if (p.contains(RegExp(r'[A-Z]')))           score++;
    if (p.contains(RegExp(r'[0-9]')))           score++;
    if (p.contains(RegExp(r'[!@#\$%^&*]')))    score++;
    return score;
  }

  Color get _strengthColor {
    if (_passStrength <= 1) return Colors.red.shade400;
    if (_passStrength <= 3) return LuxTheme.gold;
    return const Color(0xFF4CAF50);
  }

  String get _strengthLabel {
    if (_passStrength <= 1) return 'Weak';
    if (_passStrength <= 3) return 'Fair';
    return 'Strong';
  }

  late final AnimationController _ctrl;
  late final List<Animation<double>> _fades;
  late final List<Animation<Offset>>  _slides;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fades = List.generate(7, (i) {
      final s = (i * 0.10).clamp(0.0, 0.65);
      final e = (s + 0.50).clamp(0.0, 1.0);
      return CurvedAnimation(parent: _ctrl, curve: Interval(s, e, curve: Curves.easeOut));
    });
    _slides = List.generate(7, (i) {
      final s = (i * 0.10).clamp(0.0, 0.65);
      final e = (s + 0.50).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
          .animate(CurvedAnimation(parent: _ctrl, curve: Interval(s, e, curve: Curves.easeOut)));
    });
    _ctrl.forward();
    _passCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ── Validate ───────────────────────────────────────────────
  bool _validate() {
    bool ok = true;
    setState(() {
      _nameError    = null;
      _emailError   = null;
      _passError    = null;
      _confirmError = null;
      _error        = null;

      if (_nameCtrl.text.trim().length < 2) {
        _nameError = 'Name must be at least 2 characters.';
        ok = false;
      }
      if (!_emailCtrl.text.contains('@') || !_emailCtrl.text.contains('.')) {
        _emailError = 'Please enter a valid email address.';
        ok = false;
      }
      if (_passCtrl.text.length < 6) {
        _passError = 'Password must be at least 6 characters.';
        ok = false;
      }
      if (_confirmCtrl.text != _passCtrl.text) {
        _confirmError = 'Passwords do not match.';
        ok = false;
      }
    });
    return ok;
  }

  // ── Register ───────────────────────────────────────────────
  Future<void> _register() async {
    HapticFeedback.lightImpact();
    if (!_validate()) {
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() { _loading = true; _error = null; });

    final result = await AuthService.instance.register(
      name:     _nameCtrl.text,
      email:    _emailCtrl.text,
      password: _passCtrl.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.ok) {
      HapticFeedback.mediumImpact();
      // Pop back to profile (closes both login & register)
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      HapticFeedback.heavyImpact();
      setState(() => _error = result.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            const SizedBox(height: 16),

            // Back
            PressScale(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: LuxTheme.cream, borderRadius: LuxTheme.radius10, boxShadow: LuxTheme.cardShadow),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: LuxTheme.mocha),
              ),
            ),

            const SizedBox(height: 36),

            // Title
            _R(fade: _fades[0], slide: _slides[0], child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 54, height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.terracotta], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: LuxTheme.radius14,
                  boxShadow: LuxTheme.goldShadow,
                ),
                child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 22),
              const Text('Create your\naccount', style: LuxTheme.displayLg),
              const SizedBox(height: 8),
              Text('Join PlanGo DZ and start planning.', style: LuxTheme.body),
            ])),

            const SizedBox(height: 36),

            // Global error
            if (_error != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: LuxTheme.radius14, border: Border.all(color: Colors.red.shade200)),
                child: Row(children: [
                  Icon(Icons.error_outline_rounded, color: Colors.red.shade400, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_error!, style: TextStyle(fontSize: 13, color: Colors.red.shade700, fontWeight: FontWeight.w500))),
                ]),
              ),

            // ── Full Name ──
            _R(fade: _fades[1], slide: _slides[1], child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Full Name', style: LuxTheme.caption),
              const SizedBox(height: 8),
              _LuxField(
                controller: _nameCtrl,
                hint: 'e.g. Youssef Benali',
                icon: Icons.person_outline_rounded,
                error: _nameError,
                textCapitalization: TextCapitalization.words,
              ),
            ])),

            const SizedBox(height: 18),

            // ── Email ──
            _R(fade: _fades[2], slide: _slides[2], child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Email Address', style: LuxTheme.caption),
              const SizedBox(height: 8),
              _LuxField(
                controller: _emailCtrl,
                hint: 'you@example.com',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                error: _emailError,
              ),
            ])),

            const SizedBox(height: 18),

            // ── Password ──
            _R(fade: _fades[3], slide: _slides[3], child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Password', style: LuxTheme.caption),
              const SizedBox(height: 8),
              _LuxField(
                controller: _passCtrl,
                hint: 'Min. 6 characters',
                icon: Icons.lock_outline_rounded,
                obscure: _obscurePass,
                error: _passError,
                suffix: PressScale(
                  onTap: () => setState(() => _obscurePass = !_obscurePass),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: LuxTheme.latte, size: 20),
                  ),
                ),
              ),
              // Strength bar
              if (_passCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: ClipRRect(
                    borderRadius: LuxTheme.radiusPill,
                    child: LinearProgressIndicator(
                      value: _passStrength / 5,
                      minHeight: 5,
                      backgroundColor: LuxTheme.sandDark,
                      valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
                    ),
                  )),
                  const SizedBox(width: 10),
                  Text(_strengthLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _strengthColor)),
                ]),
              ],
            ])),

            const SizedBox(height: 18),

            // ── Confirm Password ──
            _R(fade: _fades[4], slide: _slides[4], child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Confirm Password', style: LuxTheme.caption),
              const SizedBox(height: 8),
              _LuxField(
                controller: _confirmCtrl,
                hint: 'Re-enter your password',
                icon: Icons.lock_outline_rounded,
                obscure: _obscureConfirm,
                error: _confirmError,
                suffix: PressScale(
                  onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: LuxTheme.latte, size: 20),
                  ),
                ),
              ),
            ])),

            const SizedBox(height: 36),

            // Create button
            _R(fade: _fades[5], slide: _slides[5], child: SizedBox(
              width: double.infinity,
              child: LuxButton(
                label: 'Create Account',
                icon: Icons.arrow_forward_rounded,
                isLoading: _loading,
                onTap: _loading ? null : _register,
              ),
            )),

            const SizedBox(height: 28),

            // Sign in link
            _R(fade: _fades[6], slide: _slides[6], child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Already have an account?  ', style: LuxTheme.body.copyWith(height: 1, fontSize: 13)),
              PressScale(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                child: const Text('Sign in', style: TextStyle(fontSize: 13, color: LuxTheme.terracotta, fontWeight: FontWeight.w700)),
              ),
            ]))),

            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }
}

// ── Field widget with inline error ───────────────────────────
class _LuxField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final Widget? suffix;
  final String? error;

  const _LuxField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.suffix,
    this.error,
  });

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: LuxTheme.espresso),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: LuxTheme.latte, fontSize: 14),
        prefixIcon: Icon(icon, color: error != null ? Colors.red.shade400 : LuxTheme.latte, size: 20),
        suffixIcon: suffix,
        filled: true, fillColor: error != null ? Colors.red.shade50 : LuxTheme.cream,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: LuxTheme.radius14,
          borderSide: BorderSide(color: error != null ? Colors.red.shade300 : LuxTheme.sandDark, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: LuxTheme.radius14,
          borderSide: BorderSide(color: error != null ? Colors.red.shade400 : LuxTheme.gold, width: 1.8),
        ),
      ),
    ),
    if (error != null) ...[
      const SizedBox(height: 6),
      Row(children: [
        Icon(Icons.info_outline_rounded, size: 13, color: Colors.red.shade400),
        const SizedBox(width: 5),
        Text(error!, style: TextStyle(fontSize: 12, color: Colors.red.shade600, fontWeight: FontWeight.w500)),
      ]),
    ],
  ]);
}

class _R extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;
  final Widget child;
  const _R({required this.fade, required this.slide, required this.child});
  @override
  Widget build(BuildContext context) => FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child));
}