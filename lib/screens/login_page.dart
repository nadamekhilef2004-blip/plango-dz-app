import 'package:flutter/material.dart';
import '../utils/luxury_theme.dart';

// ═══════════════════════════════════════════════════════════════
//  LOGIN PAGE  —  Clean & Simple
// ═══════════════════════════════════════════════════════════════
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure       = true;
  bool _loading       = false;

  late final AnimationController _ctrl;
  late final List<Animation<double>> _fades;
  late final List<Animation<Offset>>  _slides;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _fades = List.generate(5, (i) {
      final s = (i * 0.15).clamp(0.0, 0.7);
      final e = (s + 0.55).clamp(0.0, 1.0);
      return CurvedAnimation(parent: _ctrl, curve: Interval(s, e, curve: Curves.easeOut));
    });
    _slides = List.generate(5, (i) {
      final s = (i * 0.15).clamp(0.0, 0.7);
      final e = (s + 0.55).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
          .animate(CurvedAnimation(parent: _ctrl, curve: Interval(s, e, curve: Curves.easeOut)));
    });

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      setState(() => _loading = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Back button ──
              const SizedBox(height: 16),
              PressScale(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: LuxTheme.cream,
                    borderRadius: LuxTheme.radius10,
                    boxShadow: LuxTheme.cardShadow,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: LuxTheme.mocha),
                ),
              ),

              const SizedBox(height: 40),

              // ── Logo & title ──
              _Reveal(fade: _fades[0], slide: _slides[0],
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [LuxTheme.terracotta, LuxTheme.gold],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: LuxTheme.radius14,
                      boxShadow: LuxTheme.terrShadow,
                    ),
                    child: const Icon(Icons.explore_rounded, color: Colors.white, size: 26),
                  ),
                  const SizedBox(height: 24),
                  const Text('Welcome\nback', style: LuxTheme.displayLg),
                  const SizedBox(height: 8),
                  Text('Sign in to continue your journey.', style: LuxTheme.body),
                ]),
              ),

              const SizedBox(height: 44),

              // ── Email ──
              _Reveal(fade: _fades[1], slide: _slides[1],
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Email', style: LuxTheme.caption),
                  const SizedBox(height: 8),
                  _Field(
                    controller: _emailCtrl,
                    hint: 'you@example.com',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ]),
              ),

              const SizedBox(height: 18),

              // ── Password ──
              _Reveal(fade: _fades[2], slide: _slides[2],
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Password', style: LuxTheme.caption),
                  const SizedBox(height: 8),
                  _Field(
                    controller: _passwordCtrl,
                    hint: '••••••••',
                    icon: Icons.lock_outline_rounded,
                    obscure: _obscure,
                    suffix: PressScale(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: LuxTheme.latte, size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('Forgot password?',
                        style: TextStyle(fontSize: 13, color: LuxTheme.terracotta, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),

              const SizedBox(height: 36),

              // ── Sign in button ──
              _Reveal(fade: _fades[3], slide: _slides[3],
                child: SizedBox(
                  width: double.infinity,
                  child: LuxButton(
                    label: 'Sign In',
                    icon: Icons.login_rounded,
                    isLoading: _loading,
                    onTap: _loading ? null : _login,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Divider ──
              _Reveal(fade: _fades[3], slide: _slides[3],
                child: const GoldDivider(label: 'OR CONTINUE WITH'),
              ),

              const SizedBox(height: 24),

              // ── Social buttons ──
              _Reveal(fade: _fades[3], slide: _slides[3],
                child: Row(children: [
                  Expanded(child: _SocialBtn(icon: Icons.g_mobiledata_rounded, label: 'Google')),
                  const SizedBox(width: 14),
                  Expanded(child: _SocialBtn(icon: Icons.apple_rounded, label: 'Apple')),
                ]),
              ),

              const SizedBox(height: 40),

              // ── Sign up link ──
              _Reveal(fade: _fades[4], slide: _slides[4],
                child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Don't have an account?  ",
                      style: LuxTheme.body.copyWith(height: 1, fontSize: 13)),
                  PressScale(
                    onTap: () {},
                    child: const Text('Create one',
                        style: TextStyle(fontSize: 13, color: LuxTheme.terracotta, fontWeight: FontWeight.w700)),
                  ),
                ])),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Text Field ────────────────────────────────────────────────
class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: LuxTheme.espresso),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: LuxTheme.latte, fontSize: 14),
        prefixIcon: Icon(icon, color: LuxTheme.latte, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: LuxTheme.cream,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: LuxTheme.radius14,
          borderSide: const BorderSide(color: LuxTheme.sandDark, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: LuxTheme.radius14,
          borderSide: const BorderSide(color: LuxTheme.gold, width: 1.8),
        ),
      ),
    );
  }
}

// ── Social Button ─────────────────────────────────────────────
class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SocialBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: () {},
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: LuxTheme.cream,
          borderRadius: LuxTheme.radius14,
          border: Border.all(color: LuxTheme.sandDark, width: 1.2),
          boxShadow: LuxTheme.cardShadow,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 22, color: LuxTheme.mocha),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: LuxTheme.mocha)),
        ]),
      ),
    );
  }
}

// ── Fade + Slide reveal ───────────────────────────────────────
class _Reveal extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;
  final Widget child;
  const _Reveal({required this.fade, required this.slide, required this.child});

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: fade,
    child: SlideTransition(position: slide, child: child),
  );
}