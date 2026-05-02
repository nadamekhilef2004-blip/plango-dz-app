// lib/utils/luxury_theme.dart
// Drop this file into lib/utils/ and replace AppTheme references with LuxTheme.
import 'package:flutter/material.dart';

class LuxTheme {
  LuxTheme._();

  // ── Palette ──────────────────────────────────────────────
  static const Color sand         = Color(0xFFF7EDD8); // page background
  static const Color sandLight    = Color(0xFFFCF8F0); // card / surface
  static const Color sandDark     = Color(0xFFEDD9B0); // border / divider
  static const Color terracotta   = Color(0xFFB94020); // primary
  static const Color terracottaLt = Color(0xFFD05535); // hover / lighter
  static const Color gold         = Color(0xFFC9A84C); // accent
  static const Color goldLight    = Color(0xFFE2C06A); // shimmer highlight
  static const Color goldPale     = Color(0xFFF5E9C5); // chip background
  static const Color espresso     = Color(0xFF1C1109); // primary text
  static const Color mocha        = Color(0xFF5C3D2E); // secondary text
  static const Color latte        = Color(0xFF9C7B5E); // hint / muted
  static const Color white        = Color(0xFFFFFFFF);

  // ── Gradients ────────────────────────────────────────────
  static const LinearGradient primaryGrad = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFB94020), Color(0xFFD05535)],
  );
  static const LinearGradient goldGrad = LinearGradient(
    colors: [Color(0xFFC9A84C), Color(0xFFE2C06A), Color(0xFFC9A84C)],
  );
  static const LinearGradient heroOverlay = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xDD1C1109)],
  );
  static const LinearGradient cardOverlay = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xAA1C1109)],
  );

  // ── Shadows ──────────────────────────────────────────────
  static List<BoxShadow> cardShadow = [
    BoxShadow(color: const Color(0xFF1C1109).withOpacity(0.10), blurRadius: 24, offset: const Offset(0, 8)),
    BoxShadow(color: const Color(0xFF1C1109).withOpacity(0.04), blurRadius: 6,  offset: const Offset(0, 2)),
  ];
  static List<BoxShadow> goldShadow = [
    BoxShadow(color: gold.withOpacity(0.45), blurRadius: 16, offset: const Offset(0, 4)),
  ];
  static List<BoxShadow> primaryShadow = [
    BoxShadow(color: terracotta.withOpacity(0.40), blurRadius: 20, offset: const Offset(0, 6)),
  ];

  // ── Typography ───────────────────────────────────────────
  static const TextStyle serif32 = TextStyle(
    fontFamily: 'Georgia', fontSize: 32, fontWeight: FontWeight.w700,
    color: espresso, letterSpacing: -0.5, height: 1.15,
  );
  static const TextStyle serif24 = TextStyle(
    fontFamily: 'Georgia', fontSize: 24, fontWeight: FontWeight.w700,
    color: espresso, letterSpacing: -0.3,
  );
  static const TextStyle serif20 = TextStyle(
    fontFamily: 'Georgia', fontSize: 20, fontWeight: FontWeight.w700,
    color: espresso,
  );
  static const TextStyle title16 = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w700, color: espresso, letterSpacing: 0.1,
  );
  static const TextStyle body14 = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, color: mocha, height: 1.65,
  );
  static const TextStyle label11 = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w600, color: latte, letterSpacing: 0.9,
  );
  static const TextStyle goldLabel = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w700, color: gold, letterSpacing: 1.1,
  );

  // ── Shapes ───────────────────────────────────────────────
  static const BorderRadius r8  = BorderRadius.all(Radius.circular(8));
  static const BorderRadius r14 = BorderRadius.all(Radius.circular(14));
  static const BorderRadius r20 = BorderRadius.all(Radius.circular(20));
  static const BorderRadius r28 = BorderRadius.all(Radius.circular(28));
  static const BorderRadius rPill = BorderRadius.all(Radius.circular(50));
}

// ── Reusable Widgets ─────────────────────────────────────────

/// Animated press-scale feedback
class PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scale;
  const PressScale({super.key, required this.child, required this.onTap, this.scale = 0.95});
  @override State<PressScale> createState() => _PressScaleState();
}
class _PressScaleState extends State<PressScale> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 100)); _s = Tween(begin: 1.0, end: widget.scale).animate(_c); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => _c.forward(), onTapCancel: () => _c.reverse(),
    onTap: () { _c.reverse(); widget.onTap(); },
    child: ScaleTransition(scale: _s, child: widget.child),
  );
}

/// Gold thin divider
class GoldDivider extends StatelessWidget {
  final String? label;
  const GoldDivider({super.key, this.label});
  @override Widget build(BuildContext context) {
    final line = Container(height: 1, decoration: const BoxDecoration(gradient: LuxTheme.goldGrad));
    if (label == null) return line;
    return Row(children: [
      Expanded(child: line),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: Text(label!, style: LuxTheme.goldLabel)),
      Expanded(child: line),
    ]);
  }
}

/// Gold star rating
class StarRating extends StatelessWidget {
  final double rating; final int reviews;
  const StarRating({super.key, required this.rating, required this.reviews});
  @override Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.star_rounded, size: 14, color: LuxTheme.gold),
    const SizedBox(width: 3),
    Text(rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: LuxTheme.espresso)),
    const SizedBox(width: 4),
    Text('($reviews)', style: const TextStyle(fontSize: 11, color: LuxTheme.latte)),
  ]);
}

/// Gold category badge
class GoldBadge extends StatelessWidget {
  final String label;
  const GoldBadge({super.key, required this.label});
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: const BoxDecoration(gradient: LuxTheme.goldGrad, borderRadius: LuxTheme.rPill),
    child: Text(label, style: const TextStyle(color: LuxTheme.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
  );
}

/// Primary luxury button with shimmer sweep
class LuxButton extends StatefulWidget {
  final String label; final IconData? icon;
  final VoidCallback? onTap; final bool isLoading;
  const LuxButton({super.key, required this.label, this.icon, this.onTap, this.isLoading = false});
  @override State<LuxButton> createState() => _LuxButtonState();
}
class _LuxButtonState extends State<LuxButton> with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer;
  @override void initState() { super.initState(); _shimmer = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(); }
  @override void dispose() { _shimmer.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => PressScale(
    scale: 0.97, onTap: widget.onTap ?? () {},
    child: AnimatedBuilder(animation: _shimmer, builder: (_, __) => Container(
      height: 58, decoration: BoxDecoration(
        borderRadius: LuxTheme.r14,
        gradient: LinearGradient(
          begin: Alignment(-2 + _shimmer.value * 4, 0), end: Alignment(0 + _shimmer.value * 4, 0),
          colors: const [Color(0xFFB94020), Color(0xFFD05535), Color(0xFFC9A84C), Color(0xFFB94020)],
          stops: const [0.0, 0.4, 0.65, 1.0],
        ),
        boxShadow: LuxTheme.primaryShadow,
      ),
      child: Center(child: widget.isLoading
        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: LuxTheme.white, strokeWidth: 2.5))
        : Row(mainAxisSize: MainAxisSize.min, children: [
            if (widget.icon != null) ...[Icon(widget.icon, color: LuxTheme.white, size: 20), const SizedBox(width: 10)],
            Text(widget.label, style: const TextStyle(color: LuxTheme.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
          ]),
      ),
    )),
  );
}

/// Secondary outlined button
class LuxOutlineButton extends StatelessWidget {
  final String label; final IconData? icon; final VoidCallback onTap;
  const LuxOutlineButton({super.key, required this.label, this.icon, required this.onTap});
  @override Widget build(BuildContext context) => PressScale(
    onTap: onTap,
    child: Container(
      height: 52, decoration: BoxDecoration(
        borderRadius: LuxTheme.r14, color: LuxTheme.sandLight,
        border: Border.all(color: LuxTheme.gold.withOpacity(0.5), width: 1.5),
      ),
      child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, color: LuxTheme.gold, size: 18), const SizedBox(width: 8)],
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: LuxTheme.terracotta)),
      ])),
    ),
  );
}