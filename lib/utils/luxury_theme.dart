import 'package:flutter/material.dart';

/// PLANGO DZ — Luxury Design System
/// Palette: Warm Sand · Terracotta · Champagne Gold
class LuxTheme {
  LuxTheme._();

  // ── Palette ──────────────────────────────────────────────────
  static const Color sand         = Color(0xFFF5ECD7);
  static const Color sandLight    = Color(0xFFFAF6EE);
  static const Color sandDark     = Color(0xFFE8D5B0);
  static const Color terracotta   = Color(0xFFC1440E);
  static const Color terracottaL  = Color(0xFFD4602E);
  static const Color gold         = Color(0xFFC9A84C);
  static const Color goldLight    = Color(0xFFE8C97A);
  static const Color espresso     = Color(0xFF1C1109);
  static const Color mocha        = Color(0xFF5C3D2E);
  static const Color latte        = Color(0xFF9C7B5E);
  static const Color cream        = Color(0xFFFFFFFF);

  // ── Gradients ─────────────────────────────────────────────────
  static const LinearGradient goldGrad = LinearGradient(
    colors: [Color(0xFFC9A84C), Color(0xFFE8C97A), Color(0xFFC9A84C)],
  );
  static const LinearGradient terracottaGrad = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFC1440E), Color(0xFFD4602E)],
  );
  static const LinearGradient heroOverlay = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xDD1C1109)],
  );
  static const LinearGradient sandGrad = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Color(0xFFFAF6EE), Color(0xFFF5ECD7)],
  );

  // ── Shadows ───────────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
    BoxShadow(color: const Color(0xFF1C1109).withOpacity(0.10), blurRadius: 24, offset: const Offset(0, 8)),
    BoxShadow(color: const Color(0xFF1C1109).withOpacity(0.04), blurRadius: 6,  offset: const Offset(0, 2)),
  ];
  static List<BoxShadow> get goldShadow =>
      [BoxShadow(color: gold.withOpacity(0.45), blurRadius: 16, offset: const Offset(0, 4))];
  static List<BoxShadow> get terrShadow =>
      [BoxShadow(color: terracotta.withOpacity(0.38), blurRadius: 20, offset: const Offset(0, 6))];

  // ── Border radius ─────────────────────────────────────────────
  static const radius4  = BorderRadius.all(Radius.circular(4));
  static const radius10 = BorderRadius.all(Radius.circular(10));
  static const radius12 = BorderRadius.all(Radius.circular(12));
  static const radius14 = BorderRadius.all(Radius.circular(14));
  static const radius20 = BorderRadius.all(Radius.circular(20));
  static const radius28 = BorderRadius.all(Radius.circular(28));
  static const radiusPill = BorderRadius.all(Radius.circular(99));

  // ── Text styles ───────────────────────────────────────────────
  static const TextStyle displayLg = TextStyle(
    fontFamily: 'Georgia', fontSize: 34, fontWeight: FontWeight.w700,
    color: espresso, letterSpacing: -0.5, height: 1.15,
  );
  static const TextStyle displayMd = TextStyle(
    fontFamily: 'Georgia', fontSize: 26, fontWeight: FontWeight.w700,
    color: espresso, letterSpacing: -0.3, height: 1.2,
  );
  static const TextStyle titleLg = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w700, color: espresso,
  );
  static const TextStyle titleMd = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600, color: espresso,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, color: mocha, height: 1.65,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w600, color: latte, letterSpacing: 0.6,
  );
  static const TextStyle goldCap = TextStyle(
    fontSize: 10, fontWeight: FontWeight.w700, color: gold, letterSpacing: 1.4,
  );
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

/// Gold shimmer divider
class GoldDivider extends StatelessWidget {
  final String? label;
  const GoldDivider({super.key, this.label});
  @override
  Widget build(BuildContext context) {
    final line = Container(height: 1, decoration: const BoxDecoration(gradient: LuxTheme.goldGrad));
    if (label == null) return line;
    return Row(children: [
      Expanded(child: line),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Text(label!, style: LuxTheme.goldCap),
      ),
      Expanded(child: line),
    ]);
  }
}

/// Animated press-scale wrapper
class PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scale;
  const PressScale({super.key, required this.child, required this.onTap, this.scale = 0.95});
  @override
  State<PressScale> createState() => _PressScaleState();
}
class _PressScaleState extends State<PressScale> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _s = Tween<double>(begin: 1.0, end: widget.scale).animate(_c);
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => _c.forward(),
    onTapCancel: () => _c.reverse(),
    onTap: () { _c.reverse(); widget.onTap(); },
    child: ScaleTransition(scale: _s, child: widget.child),
  );
}

/// Fade + slide-up reveal
class FadeSlideIn extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;
  final Widget child;
  const FadeSlideIn({super.key, required this.fade, required this.slide, required this.child});
  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: fade,
    child: SlideTransition(position: slide, child: child),
  );
}

/// Luxury primary button with shimmer
class LuxButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool outlined;
  const LuxButton({super.key, required this.label, this.icon, this.onTap, this.isLoading = false, this.outlined = false});
  @override
  State<LuxButton> createState() => _LuxButtonState();
}
class _LuxButtonState extends State<LuxButton> with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer;
  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();
  }
  @override void dispose() { _shimmer.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    if (widget.outlined) {
      return PressScale(
        onTap: widget.onTap ?? () {},
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            borderRadius: LuxTheme.radius14,
            border: Border.all(color: LuxTheme.gold, width: 1.5),
            color: Colors.transparent,
          ),
          child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (widget.icon != null) ...[Icon(widget.icon, color: LuxTheme.gold, size: 18), const SizedBox(width: 8)],
            Text(widget.label, style: const TextStyle(color: LuxTheme.gold, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
          ])),
        ),
      );
    }
    return PressScale(
      scale: 0.97,
      onTap: widget.onTap ?? () {},
      child: AnimatedBuilder(
        animation: _shimmer,
        builder: (_, __) => Container(
          height: 58,
          decoration: BoxDecoration(
            borderRadius: LuxTheme.radius14,
            gradient: LinearGradient(
              begin: Alignment(-2.0 + _shimmer.value * 4, 0),
              end:   Alignment( 0.5 + _shimmer.value * 4, 0),
              colors: const [Color(0xFFC1440E), Color(0xFFD4602E), Color(0xFFC9A84C), Color(0xFFC1440E)],
              stops: const [0.0, 0.35, 0.65, 1.0],
            ),
            boxShadow: LuxTheme.terrShadow,
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : Row(mainAxisSize: MainAxisSize.min, children: [
                    if (widget.icon != null) ...[Icon(widget.icon, color: Colors.white, size: 20), const SizedBox(width: 10)],
                    Text(widget.label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                  ]),
          ),
        ),
      ),
    );
  }
}

/// Gold badge
class GoldBadge extends StatelessWidget {
  final String label;
  const GoldBadge({super.key, required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]),
      borderRadius: LuxTheme.radiusPill,
    ),
    child: Text(label.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
  );
}

/// Star rating row
class StarRating extends StatelessWidget {
  final double rating;
  final int reviews;
  const StarRating({super.key, required this.rating, required this.reviews});
  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(Icons.star_rounded, size: 13, color: LuxTheme.gold),
    const SizedBox(width: 3),
    Text(rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: LuxTheme.espresso)),
    const SizedBox(width: 4),
    Text('($reviews)', style: const TextStyle(fontSize: 11, color: LuxTheme.latte)),
  ]);
}

/// Luxury text field
class LuxTextField extends StatelessWidget {
  final String hint;
  final IconData? prefixIcon;
  final bool obscure;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  const LuxTextField({super.key, required this.hint, this.prefixIcon, this.obscure = false, this.controller, this.onChanged, this.keyboardType});
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    obscureText: obscure,
    onChanged: onChanged,
    keyboardType: keyboardType,
    style: LuxTheme.titleMd.copyWith(color: LuxTheme.espresso, fontWeight: FontWeight.w500),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: LuxTheme.body.copyWith(color: LuxTheme.latte, height: 1),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: LuxTheme.latte, size: 20) : null,
      filled: true,
      fillColor: LuxTheme.cream,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: LuxTheme.radius14,
        borderSide: BorderSide(color: LuxTheme.sandDark, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: LuxTheme.radius14,
        borderSide: const BorderSide(color: LuxTheme.gold, width: 1.8),
      ),
    ),
  );
}