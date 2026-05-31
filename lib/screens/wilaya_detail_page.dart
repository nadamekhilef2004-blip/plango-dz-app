import 'package:flutter/material.dart';
import '../utils/luxury_theme.dart';
import '../services/favorites_service.dart';
import 'ai_trip_planner.dart';
import 'package:url_launcher/url_launcher.dart';

// ═══════════════════════════════════════════════════════════════
//  WILAYA DETAIL PAGE  —  Luxury Edition
// ═══════════════════════════════════════════════════════════════
class WilayaDetailPage extends StatefulWidget {
  final String name;
  final IconData icon;
  final Color color;
  final String imagePath;
  final String description;
  final List<String> attractions;
  final String bestTime;
  final String famousFood;
  final List<String> hotels;
  final List<String> openingHours;
  final Map<String, double> coordinates;

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
    this.hotels = const [],
    this.openingHours = const [],
    this.coordinates = const {},
  });

  @override
  State<WilayaDetailPage> createState() => _WilayaDetailPageState();
}

class _WilayaDetailPageState extends State<WilayaDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _fades;
  late final List<Animation<Offset>> _slides;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fades = List.generate(4, (i) {
      final s = (i * 0.18).clamp(0.0, 0.7);
      final e = (s + 0.5).clamp(0.0, 1.0);
      return CurvedAnimation(
          parent: _ctrl, curve: Interval(s, e, curve: Curves.easeOut));
    });
    _slides = List.generate(4, (i) {
      final s = (i * 0.18).clamp(0.0, 0.7);
      final e = (s + 0.5).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
          .animate(CurvedAnimation(
          parent: _ctrl,
          curve: Interval(s, e, curve: Curves.easeOut)));
    });
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: CustomScrollView(
        slivers: [
          // ── Hero image sliver ──────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: LuxTheme.espresso,
            leading: Padding(
              padding: const EdgeInsets.all(10),
              child: PressScale(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 10),
                child: PressScale(
                  onTap: () async {
                    await FavoritesService.instance.toggle(
                      wilayaName: widget.name,
                      wilayaImage: widget.imagePath,
                      category: 'Culture',
                    );
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle),
                    child: Icon(
                      FavoritesService.instance.isFavorite(widget.name)
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: FavoritesService.instance.isFavorite(widget.name)
                          ? LuxTheme.gold
                          : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(fit: StackFit.expand, children: [
                Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: const BoxDecoration(
                        gradient: LuxTheme.terracottaGrad),
                    child: const Icon(Icons.landscape_rounded,
                        size: 80, color: Colors.white30),
                  ),
                ),
                const DecoratedBox(
                    decoration:
                    BoxDecoration(gradient: LuxTheme.heroOverlay)),
                // ── Name only — rating/reviews removed ────────
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const GoldBadge(label: 'FEATURED DESTINATION'),
                      const SizedBox(height: 10),
                      Text(
                        widget.name,
                        style: const TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.1),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),

          // ── Body content ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── About ──
                    FadeSlideIn(
                      fade: _fades[0],
                      slide: _slides[0],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('About', style: LuxTheme.titleLg),
                          const SizedBox(height: 10),
                          Text(widget.description, style: LuxTheme.body),
                          const SizedBox(height: 24),
                          const GoldDivider(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Info cards ──
                    FadeSlideIn(
                      fade: _fades[1],
                      slide: _slides[1],
                      child: Row(children: [
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.calendar_month_rounded,
                            label: 'Best Time',
                            value: widget.bestTime,
                            color: LuxTheme.terracotta,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.restaurant_rounded,
                            label: 'Local Food',
                            value: widget.famousFood,
                            color: LuxTheme.gold,
                          ),
                        ),
                      ]),
                    ),

                    const SizedBox(height: 28),

                    // ── Attractions ──
                    FadeSlideIn(
                      fade: _fades[2],
                      slide: _slides[2],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const GoldDivider(label: 'TOP ATTRACTIONS'),
                          const SizedBox(height: 20),
                          ...List.generate(
                            widget.attractions.length,
                                (i) => _AttractionRow(
                              name: widget.attractions[i],
                              index: i + 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Hotels ──
                    if (widget.hotels.isNotEmpty) ...[
                      FadeSlideIn(
                        fade: _fades[2],
                        slide: _slides[2],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const GoldDivider(label: 'WHERE TO STAY'),
                            const SizedBox(height: 20),
                            ...widget.hotels.map((h) => _HotelRow(hotel: h)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],

                    // ── Opening Hours ──
                    if (widget.openingHours.isNotEmpty) ...[
                      FadeSlideIn(
                        fade: _fades[2],
                        slide: _slides[2],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const GoldDivider(label: 'OPENING HOURS & PRICES'),
                            const SizedBox(height: 20),
                            ...widget.openingHours.map((o) => _HoursRow(info: o)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],

                    // ── CTA buttons ──
                    FadeSlideIn(
                      fade: _fades[3],
                      slide: _slides[3],
                      child: Column(children: [
                        const GoldDivider(),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: LuxButton(
                            label: 'Plan a Trip Here',
                            icon: Icons.auto_awesome_rounded,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AITripPlannerPage()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: LuxButton(
                            label: 'View on Maps',
                            icon: Icons.map_rounded,
                            outlined: true,
                            onTap: () async {
                              final lat = widget.coordinates['lat'] ?? 36.7538;
                              final lng = widget.coordinates['lng'] ?? 3.0588;
                              final url =
                                  'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                          ),
                        ),
                      ]),
                    ),

                    const SizedBox(height: 20),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SUB-WIDGETS
// ═══════════════════════════════════════════════════════════════

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _InfoCard(
      {required this.icon,
        required this.label,
        required this.value,
        required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: LuxTheme.cream,
      borderRadius: LuxTheme.radius14,
      boxShadow: LuxTheme.cardShadow,
      border: Border.all(color: color.withOpacity(0.15), width: 1.2),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: LuxTheme.radius10),
        child: Icon(icon, color: color, size: 18),
      ),
      const SizedBox(height: 10),
      Text(label, style: LuxTheme.caption),
      const SizedBox(height: 4),
      Text(value,
          style: LuxTheme.body.copyWith(
              fontSize: 13,
              color: LuxTheme.espresso,
              fontWeight: FontWeight.w600,
              height: 1.4)),
    ]),
  );
}

class _AttractionRow extends StatelessWidget {
  final String name;
  final int index;
  const _AttractionRow({required this.name, required this.index});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [LuxTheme.gold, LuxTheme.goldLight]),
          borderRadius: LuxTheme.radius10,
        ),
        child: Center(
            child: Text('$index',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800))),
      ),
      const SizedBox(width: 14),
      Expanded(child: Text(name, style: LuxTheme.titleMd)),
      const Icon(Icons.chevron_right_rounded,
          color: LuxTheme.latte, size: 20),
    ]),
  );
}

class _HotelRow extends StatelessWidget {
  final String hotel;
  const _HotelRow({required this.hotel});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: LuxTheme.cream,
        borderRadius: LuxTheme.radius14,
        boxShadow: LuxTheme.cardShadow,
        border: Border.all(color: LuxTheme.gold.withOpacity(0.2)),
      ),
      child:
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [LuxTheme.gold, LuxTheme.goldLight]),
            borderRadius: LuxTheme.radius10,
          ),
          child: const Icon(Icons.hotel_rounded,
              size: 18, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Text(hotel,
                style: LuxTheme.body.copyWith(
                    fontSize: 13,
                    color: LuxTheme.espresso,
                    height: 1.4))),
      ]),
    ),
  );
}

class _HoursRow extends StatelessWidget {
  final String info;
  const _HoursRow({required this.info});

  @override
  Widget build(BuildContext context) {
    final parts = info.split('|');
    final name = parts[0].trim();
    final detail =
    parts.length > 1 ? parts.sublist(1).join(' · ').trim() : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: LuxTheme.cream,
          borderRadius: LuxTheme.radius14,
          boxShadow: LuxTheme.cardShadow,
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.schedule_rounded, size: 16, color: LuxTheme.gold),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: LuxTheme.body.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: LuxTheme.espresso)),
                if (detail.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(detail,
                      style: LuxTheme.caption
                          .copyWith(fontSize: 11, color: LuxTheme.mocha)),
                ],
              ],
            ),
          ),
        ]),
      ),
    );
  }
}