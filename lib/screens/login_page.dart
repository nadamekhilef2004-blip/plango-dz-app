import 'package:flutter/material.dart';
import '../utils/luxury_theme.dart';

// ═══════════════════════════════════════════════════════════════
//  LOGIN PAGE  —  Luxury Edition
// ═══════════════════════════════════════════════════════════════
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _fades;
  late final List<Animation<Offset>>  _slides;
  bool _obscure = true;

  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fades = List.generate(5, (i) {
      final s = (i * 0.14).clamp(0.0, 0.7);
      final e = (s + 0.5).clamp(0.0, 1.0);
      return CurvedAnimation(parent: _ctrl, curve: Interval(s, e, curve: Curves.easeOut));
    });
    _slides = List.generate(5, (i) {
      final s = (i * 0.14).clamp(0.0, 0.7);
      final e = (s + 0.5).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.22), end: Offset.zero)
          .animate(CurvedAnimation(parent: _ctrl, curve: Interval(s, e, curve: Curves.easeOut)));
    });
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); _emailCtrl.dispose(); _passwordCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            // ── Hero top panel ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 50),
              decoration: const BoxDecoration(
                gradient: LuxTheme.terracottaGrad,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: Column(children: [
                // Logo
                FadeSlideIn(fade: _fades[0], slide: _slides[0],
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: LuxTheme.goldLight, width: 1.5),
                    ),
                    child: Center(child: RichText(text: const TextSpan(children: [
                      TextSpan(text: 'P', style: TextStyle(fontFamily: 'Georgia', fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                      TextSpan(text: 'G', style: TextStyle(fontFamily: 'Georgia', fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFFE8C97A))),
                    ]))),
                  ),
                ),
                const SizedBox(height: 20),
                FadeSlideIn(fade: _fades[0], slide: _slides[0],
                  child: const Text('Welcome Back', style: TextStyle(fontFamily: 'Georgia', fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
                const SizedBox(height: 6),
                FadeSlideIn(fade: _fades[1], slide: _slides[1],
                  child: Text('Sign in to continue your journey', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                ),
              ]),
            ),

            // ── Form panel ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                FadeSlideIn(fade: _fades[2], slide: _slides[2],
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const GoldDivider(label: 'YOUR CREDENTIALS'),
                    const SizedBox(height: 24),
                    // Email
                    Text('Email', style: LuxTheme.caption),
                    const SizedBox(height: 8),
                    LuxTextField(
                      hint: 'you@example.com',
                      prefixIcon: Icons.mail_outline_rounded,
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ]),
                ),

                const SizedBox(height: 16),

                FadeSlideIn(fade: _fades[3], slide: _slides[3],
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Password', style: LuxTheme.caption),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordCtrl,
                      obscureText: _obscure,
                      style: LuxTheme.titleMd.copyWith(color: LuxTheme.espresso, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: LuxTheme.body.copyWith(color: LuxTheme.latte, height: 1),
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: LuxTheme.latte, size: 20),
                        suffixIcon: PressScale(
                          onTap: () => setState(() => _obscure = !_obscure),
                          child: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: LuxTheme.latte, size: 20),
                        ),
                        filled: true,
                        fillColor: LuxTheme.cream,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        enabledBorder: OutlineInputBorder(borderRadius: LuxTheme.radius14, borderSide: BorderSide(color: LuxTheme.sandDark, width: 1.2)),
                        focusedBorder: OutlineInputBorder(borderRadius: LuxTheme.radius14, borderSide: const BorderSide(color: LuxTheme.gold, width: 1.8)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('Forgot password?', style: TextStyle(fontSize: 13, color: LuxTheme.terracotta, fontWeight: FontWeight.w600)),
                    ),
                  ]),
                ),

                const SizedBox(height: 32),

                FadeSlideIn(fade: _fades[4], slide: _slides[4],
                  child: Column(children: [
                    SizedBox(width: double.infinity, child: LuxButton(
                      label: 'Sign In',
                      icon: Icons.login_rounded,
                      onTap: () => Navigator.pop(context),
                    )),
                    const SizedBox(height: 20),
                    const GoldDivider(label: 'OR'),
                    const SizedBox(height: 20),
                    // Social login buttons
                    Row(children: [
                      Expanded(child: _SocialButton(label: 'Google', icon: Icons.g_mobiledata_rounded)),
                      const SizedBox(width: 12),
                      Expanded(child: _SocialButton(label: 'Apple', icon: Icons.apple_rounded)),
                    ]),
                    const SizedBox(height: 28),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Don't have an account? ", style: LuxTheme.body.copyWith(height: 1)),
                      PressScale(
                        onTap: () {},
                        child: Text('Create one', style: TextStyle(fontSize: 14, color: LuxTheme.terracotta, fontWeight: FontWeight.w700)),
                      ),
                    ]),
                  ]),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SocialButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) => PressScale(
    onTap: () {},
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        color: LuxTheme.cream,
        borderRadius: LuxTheme.radius14,
        border: Border.all(color: LuxTheme.sandDark, width: 1.2),
        boxShadow: LuxTheme.cardShadow,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 22, color: LuxTheme.mocha),
        const SizedBox(width: 8),
        Text(label, style: LuxTheme.titleMd.copyWith(color: LuxTheme.mocha)),
      ]),
    ),
  );
}