// lib/screens/wilaya_detail_page.dart
import 'package:flutter/material.dart';
import '../utils/luxury_theme.dart';
import '../models/destination.dart';
import 'recommendation_page.dart';

class WilayaDetailPage extends StatefulWidget {
  final String name;
  final IconData icon;
  final Color color;
  final String imagePath;
  final String description;
  final List<String> attractions;
  final String bestTime;
  final String famousFood;
  final List<Destination>? allDestinations;

  const WilayaDetailPage({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.imagePath,
    required this.description,
    required this.attractions,
    required this.bestTime,
    required this.famousFood,
    this.allDestinations,
  });
  @override State<WilayaDetailPage> createState() => _WilayaDetailPageState();
}

class _WilayaDetailPageState extends State<WilayaDetailPage> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _fade;
  late final Animation<Offset>   _slide;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: CustomScrollView(slivers: [
        // ── Hero image app bar
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          backgroundColor: LuxTheme.sandLight,
          foregroundColor: LuxTheme.white,
          elevation: 0,
          leading: Padding(padding: const EdgeInsets.all(10), child: PressScale(onTap: () => Navigator.pop(context), child:
            Container(decoration: BoxDecoration(color: Colors.black38, borderRadius: LuxTheme.r8), padding: const EdgeInsets.all(6),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: LuxTheme.white)))),
          actions: [
            Padding(padding: const EdgeInsets.only(right: 8), child: PressScale(onTap: () => setState(() => _isSaved = !_isSaved), child:
              Container(margin: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.black38, borderRadius: LuxTheme.r8), padding: const EdgeInsets.all(6),
                child: Icon(_isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 20, color: _isSaved ? LuxTheme.gold : LuxTheme.white)))),
            Padding(padding: const EdgeInsets.only(right: 10), child: PressScale(onTap: () {
              if (widget.allDestinations != null) Navigator.push(context, MaterialPageRoute(builder: (_) => RecommendationPage(
                allDestinations: widget.allDestinations!,
                currentDestination: Destination(name: widget.name, region: '', imageUrl: widget.imagePath, description: widget.description),
              )));
            }, child: Container(margin: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.black38, borderRadius: LuxTheme.r8), padding: const EdgeInsets.all(6),
              child: const Icon(Icons.recommend_rounded, size: 20, color: LuxTheme.white)))),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(fit: StackFit.expand, children: [
              Image.asset(widget.imagePath, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: widget.color.withOpacity(0.4), child: Icon(widget.icon, size: 80, color: LuxTheme.white))),
              const DecoratedBox(decoration: BoxDecoration(gradient: LuxTheme.heroOverlay)),
              // City name over hero
              Positioned(bottom: 24, left: 24, right: 24, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.name.toUpperCase(), style: LuxTheme.goldLabel.copyWith(color: LuxTheme.goldLight, fontSize: 12, letterSpacing: 3)),
                const SizedBox(height: 4),
                Text(widget.name, style: const TextStyle(fontFamily: 'Georgia', fontSize: 36, fontWeight: FontWeight.w700, color: LuxTheme.white, height: 1.1)),
              ])),
            ]),
          ),
        ),

        // ── Content
        SliverToBoxAdapter(child: FadeTransition(opacity: _fade, child: SlideTransition(position: _slide, child:
          Padding(padding: const EdgeInsets.fromLTRB(24, 28, 24, 40), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // Quick stats row
            Row(children: [
              _StatPill(icon: Icons.star_rounded, label: '4.8 Rating', color: LuxTheme.gold),
              const SizedBox(width: 10),
              _StatPill(icon: Icons.calendar_today_rounded, label: 'Best: ${widget.bestTime}', color: LuxTheme.terracotta),
            ]),
            const SizedBox(height: 28),

            // Description
            Text('About', style: LuxTheme.goldLabel.copyWith(letterSpacing: 2)),
            const SizedBox(height: 8),
            Text(widget.name, style: LuxTheme.serif24),
            const SizedBox(height: 10),
            Text(widget.description, style: LuxTheme.body14),
            const SizedBox(height: 28),

            // Divider
            const GoldDivider(label: 'ATTRACTIONS'),
            const SizedBox(height: 20),

            // Attractions grid
            ...widget.attractions.asMap().entries.map((e) => _AttractionRow(index: e.key, label: e.value, color: widget.color)),
            const SizedBox(height: 28),

            // Best time card
            Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: LuxTheme.sandLight, borderRadius: LuxTheme.r20, boxShadow: LuxTheme.cardShadow,
              border: Border.all(color: LuxTheme.sandDark, width: 1)), child:
              Row(children: [
                Container(width: 46, height: 46, decoration: BoxDecoration(gradient: LuxTheme.primaryGrad, borderRadius: LuxTheme.r14),
                  child: const Icon(Icons.calendar_month_rounded, color: LuxTheme.white, size: 22)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Best time to visit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: LuxTheme.latte, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(widget.bestTime, style: LuxTheme.title16.copyWith(fontSize: 14)),
                ])),
              ]),
            ),
            const SizedBox(height: 16),

            // Food card
            Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: LuxTheme.sandLight, borderRadius: LuxTheme.r20, boxShadow: LuxTheme.cardShadow,
              border: Border.all(color: LuxTheme.sandDark, width: 1)), child:
              Row(children: [
                Container(width: 46, height: 46, decoration: const BoxDecoration(gradient: LuxTheme.goldGrad, borderRadius: LuxTheme.r14),
                  child: const Icon(Icons.restaurant_rounded, color: LuxTheme.white, size: 22)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Local cuisine', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: LuxTheme.latte, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(widget.famousFood, style: LuxTheme.title16.copyWith(fontSize: 14)),
                ])),
              ]),
            ),
            const SizedBox(height: 32),

            // CTA
            LuxButton(label: 'Plan a Trip Here', icon: Icons.map_rounded, onTap: () => Navigator.pop(context)),
          ])),
        ))),
      ]),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon; final String label; final Color color;
  const _StatPill({required this.icon, required this.label, required this.color});
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(color: color.withOpacity(0.10), borderRadius: LuxTheme.rPill, border: Border.all(color: color.withOpacity(0.25))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 6),
      Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    ]),
  );
}

class _AttractionRow extends StatelessWidget {
  final int index; final String label; final Color color;
  const _AttractionRow({required this.index, required this.label, required this.color});
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: LuxTheme.goldPale, borderRadius: LuxTheme.r8),
        child: Center(child: Text('${index + 1}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: LuxTheme.gold)))),
      const SizedBox(width: 14),
      Expanded(child: Text(label, style: LuxTheme.title16.copyWith(fontWeight: FontWeight.w500))),
      const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: LuxTheme.latte),
    ]),
  );
}