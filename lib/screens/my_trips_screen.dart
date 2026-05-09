import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/luxury_theme.dart';
import '../services/trip_storage.dart';
import 'ai_trip_planner.dart';

// ═══════════════════════════════════════════════════════════════
//  MY TRIPS SCREEN  —  Saved Trips with full persistence
// ═══════════════════════════════════════════════════════════════
class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});
  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _fade;
  late final Animation<Offset>   _slide;

  final _storage = TripStorageService.instance;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _storage.addListener(_onStorageChanged);
    _storage.load().then((_) => _ctrl.forward());
  }

  void _onStorageChanged() => setState(() {});

  @override
  void dispose() {
    _storage.removeListener(_onStorageChanged);
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(SavedTrip trip) async {
    HapticFeedback.mediumImpact();
    final confirm = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _DeleteSheet(tripName: trip.wilayaName),
    );
    if (confirm == true) {
      await _storage.delete(trip.id);
      HapticFeedback.lightImpact();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(_luxSnackBar('Trip removed'));
      }
    }
  }

  Future<void> _confirmClearAll() async {
    HapticFeedback.mediumImpact();
    final confirm = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ClearAllSheet(),
    );
    if (confirm == true) {
      await _storage.clearAll();
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final trips = _storage.trips;

    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('My Journeys', style: LuxTheme.displayMd),
                              const SizedBox(height: 4),
                              Text(
                                trips.isEmpty
                                    ? 'No trips saved yet'
                                    : '${trips.length} trip${trips.length == 1 ? '' : 's'} saved',
                                style: LuxTheme.body,
                              ),
                            ],
                          ),
                        ),
                        if (trips.isNotEmpty)
                          PressScale(
                            onTap: _confirmClearAll,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: LuxTheme.cream,
                                borderRadius: LuxTheme.radiusPill,
                                border: Border.all(color: LuxTheme.sandDark),
                                boxShadow: LuxTheme.cardShadow,
                              ),
                              child: const Row(children: [
                                Icon(Icons.delete_outline_rounded, size: 14, color: LuxTheme.latte),
                                SizedBox(width: 5),
                                Text('Clear all', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: LuxTheme.latte)),
                              ]),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Gold divider ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: trips.isEmpty
                    ? const GoldDivider()
                    : const GoldDivider(label: 'SAVED ITINERARIES'),
              ),
            ),

            // ── Content ──
            trips.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) {
                          final trip  = trips[i];
                          final delay = (i * 0.08).clamp(0.0, 0.5);
                          final end   = (delay + 0.5).clamp(0.0, 1.0);
                          final itemFade = CurvedAnimation(
                            parent: _ctrl,
                            curve: Interval(delay, end, curve: Curves.easeOut),
                          );
                          final itemSlide = Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _ctrl,
                            curve: Interval(delay, end, curve: Curves.easeOut),
                          ));
                          return FadeTransition(
                            opacity: itemFade,
                            child: SlideTransition(
                              position: itemSlide,
                              child: _TripCard(
                                trip: trip,
                                onDelete: () => _confirmDelete(trip),
                                onTap: () => _openDetail(trip),
                              ),
                            ),
                          );
                        },
                        childCount: trips.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      // ── FAB ──
      floatingActionButton: PressScale(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AITripPlannerPage()),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [LuxTheme.terracotta, LuxTheme.terracottaL]),
            borderRadius: LuxTheme.radiusPill,
            boxShadow: LuxTheme.terrShadow,
          ),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('New Trip', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
    );
  }

  void _openDetail(SavedTrip trip) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => TripDetailPage(trip: trip),
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  SnackBar _luxSnackBar(String msg) => SnackBar(
    content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
    backgroundColor: LuxTheme.espresso,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: LuxTheme.radius10),
    margin: const EdgeInsets.all(16),
  );
}

// ── Trip Card ─────────────────────────────────────────────────
class _TripCard extends StatefulWidget {
  final SavedTrip trip;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  const _TripCard({required this.trip, required this.onDelete, required this.onTap});
  @override
  State<_TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<_TripCard> with SingleTickerProviderStateMixin {
  late final AnimationController _tap;
  late final Animation<double>   _scale;

  @override
  void initState() {
    super.initState();
    _tap   = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(_tap);
  }
  @override void dispose() { _tap.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final fmt  = NumberFormat('#,##0');

    return GestureDetector(
      onTapDown:   (_) { HapticFeedback.selectionClick(); _tap.forward(); },
      onTapCancel: ()  => _tap.reverse(),
      onTap: () { _tap.reverse(); widget.onTap(); },
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: LuxTheme.cream,
            borderRadius: LuxTheme.radius20,
            boxShadow: LuxTheme.cardShadow,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── Image header ──
            Stack(children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  trip.wilayaImage,
                  height: 140, width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    decoration: const BoxDecoration(
                      gradient: LuxTheme.terracottaGrad,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: const Icon(Icons.landscape_rounded, color: Colors.white38, size: 52),
                  ),
                ),
              ),
              // Overlay
              Positioned.fill(child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: const DecoratedBox(decoration: BoxDecoration(gradient: LuxTheme.heroOverlay)),
              )),
              // Category badge
              Positioned(top: 12, left: 12, child: GoldBadge(label: trip.category)),
              // Delete button
              Positioned(
                top: 10, right: 10,
                child: PressScale(
                  onTap: widget.onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 17),
                  ),
                ),
              ),
              // Destination name
              Positioned(bottom: 12, left: 12, right: 50,
                child: Text(
                  trip.wilayaName,
                  style: const TextStyle(fontFamily: 'Georgia', fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ]),

            // ── Info row ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(children: [
                Row(children: [
                  _InfoPill(icon: Icons.calendar_today_rounded,           label: '${trip.days} ${trip.days == 1 ? 'day' : 'days'}'),
                  const SizedBox(width: 8),
                  _InfoPill(icon: Icons.account_balance_wallet_rounded,   label: '${fmt.format(trip.totalBudget)} DZD'),
                  const SizedBox(width: 8),
                  _InfoPill(icon: Icons.diamond_rounded,                  label: _modeLabel(trip.budgetMode)),
                  const Spacer(),
                  Text(
                    _formatDate(trip.createdAt),
                    style: LuxTheme.caption.copyWith(fontSize: 10),
                  ),
                ]),
                const SizedBox(height: 12),
                // Progress preview — day count mini-dots
                Row(children: [
                  ...List.generate(trip.days.clamp(0, 7), (i) => Container(
                    width: 6, height: 6,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]),
                      shape: BoxShape.circle,
                    ),
                  )),
                  if (trip.days > 7) ...[
                    const SizedBox(width: 2),
                    Text('+${trip.days - 7}', style: LuxTheme.caption.copyWith(fontSize: 10)),
                  ],
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: LuxTheme.sand,
                      borderRadius: LuxTheme.radiusPill,
                      border: Border.all(color: LuxTheme.sandDark),
                    ),
                    child: const Row(children: [
                      Text('View itinerary', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: LuxTheme.mocha)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios_rounded, size: 10, color: LuxTheme.mocha),
                    ]),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  String _modeLabel(String mode) {
    switch (mode) {
      case 'budget':  return 'Budget';
      case 'luxury':  return 'Luxury';
      case 'custom':  return 'Custom';
      default:        return 'Mid-range';
    }
  }

  String _formatDate(DateTime d) {
    final now  = DateTime.now();
    final diff = now.difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7)  return '$diff days ago';
    return DateFormat('dd MMM yyyy').format(d);
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(color: LuxTheme.sand, borderRadius: LuxTheme.radiusPill),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 11, color: LuxTheme.gold),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: LuxTheme.mocha)),
    ]),
  );
}

// ── Empty State ───────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(40),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 96, height: 96,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [LuxTheme.sandDark, LuxTheme.sand],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.luggage_rounded, size: 44, color: LuxTheme.latte),
        ),
        const SizedBox(height: 24),
        const Text('No journeys yet', style: LuxTheme.titleLg),
        const SizedBox(height: 8),
        Text(
          'Plan your first trip and it will\nappear here automatically.',
          style: LuxTheme.body,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: 200,
          child: LuxButton(
            label: 'Plan a Trip',
            icon: Icons.auto_awesome_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AITripPlannerPage()),
            ),
          ),
        ),
      ]),
    ),
  );
}

// ── Delete Confirmation Sheet ─────────────────────────────────
class _DeleteSheet extends StatelessWidget {
  final String tripName;
  const _DeleteSheet({required this.tripName});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(color: LuxTheme.cream, borderRadius: LuxTheme.radius20),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 40, height: 4, decoration: BoxDecoration(color: LuxTheme.sandDark, borderRadius: LuxTheme.radiusPill)),
      const SizedBox(height: 24),
      Container(
        width: 56, height: 56,
        decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
        child: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400, size: 28),
      ),
      const SizedBox(height: 16),
      Text('Remove "$tripName"?', style: LuxTheme.titleLg, textAlign: TextAlign.center),
      const SizedBox(height: 8),
      Text('This action cannot be undone.', style: LuxTheme.body, textAlign: TextAlign.center),
      const SizedBox(height: 28),
      Row(children: [
        Expanded(child: PressScale(
          onTap: () => Navigator.pop(context, false),
          child: Container(
            height: 50,
            decoration: BoxDecoration(color: LuxTheme.sand, borderRadius: LuxTheme.radius14, border: Border.all(color: LuxTheme.sandDark)),
            child: const Center(child: Text('Cancel', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: LuxTheme.mocha))),
          ),
        )),
        const SizedBox(width: 12),
        Expanded(child: PressScale(
          onTap: () => Navigator.pop(context, true),
          child: Container(
            height: 50,
            decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: LuxTheme.radius14),
            child: const Center(child: Text('Remove', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))),
          ),
        )),
      ]),
    ]),
  );
}

class _ClearAllSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(color: LuxTheme.cream, borderRadius: LuxTheme.radius20),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 40, height: 4, decoration: BoxDecoration(color: LuxTheme.sandDark, borderRadius: LuxTheme.radiusPill)),
      const SizedBox(height: 24),
      const Text('Clear all trips?', style: LuxTheme.titleLg),
      const SizedBox(height: 8),
      Text('All saved journeys will be permanently removed.', style: LuxTheme.body, textAlign: TextAlign.center),
      const SizedBox(height: 28),
      Row(children: [
        Expanded(child: PressScale(
          onTap: () => Navigator.pop(context, false),
          child: Container(
            height: 50,
            decoration: BoxDecoration(color: LuxTheme.sand, borderRadius: LuxTheme.radius14, border: Border.all(color: LuxTheme.sandDark)),
            child: const Center(child: Text('Cancel', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: LuxTheme.mocha))),
          ),
        )),
        const SizedBox(width: 12),
        Expanded(child: PressScale(
          onTap: () => Navigator.pop(context, true),
          child: Container(
            height: 50,
            decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: LuxTheme.radius14),
            child: const Center(child: Text('Clear all', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))),
          ),
        )),
      ]),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
//  TRIP DETAIL PAGE
// ═══════════════════════════════════════════════════════════════
class TripDetailPage extends StatefulWidget {
  final SavedTrip trip;
  const TripDetailPage({super.key, required this.trip});
  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final fmt  = NumberFormat('#,##0');

    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: CustomScrollView(
        slivers: [
          // ── Hero ──
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            stretch: true,
            backgroundColor: LuxTheme.espresso,
            leading: Padding(
              padding: const EdgeInsets.all(10),
              child: PressScale(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(fit: StackFit.expand, children: [
                Image.asset(trip.wilayaImage, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(decoration: const BoxDecoration(gradient: LuxTheme.terracottaGrad)),
                ),
                const DecoratedBox(decoration: BoxDecoration(gradient: LuxTheme.heroOverlay)),
                Positioned(left: 24, right: 24, bottom: 24, child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoldBadge(label: trip.category.toUpperCase()),
                    const SizedBox(height: 10),
                    Text(trip.wilayaName, style: const TextStyle(fontFamily: 'Georgia', fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 10),
                    Row(children: [
                      _HeroChip(icon: Icons.calendar_today_rounded, label: '${trip.days} days'),
                      const SizedBox(width: 8),
                      _HeroChip(icon: Icons.account_balance_wallet_rounded, label: '${fmt.format(trip.totalBudget)} DZD'),
                    ]),
                  ],
                )),
              ]),
            ),
          ),

          // ── Day cards ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const GoldDivider(label: 'YOUR ITINERARY'),
                const SizedBox(height: 20),
                ...trip.itinerary.map((day) => FadeTransition(
                  opacity: _fade,
                  child: _DetailDayCard(day: day),
                )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeroChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: LuxTheme.radiusPill),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: LuxTheme.goldLight),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
    ]),
  );
}

class _DetailDayCard extends StatefulWidget {
  final SavedTripDay day;
  const _DetailDayCard({required this.day});
  @override
  State<_DetailDayCard> createState() => _DetailDayCardState();
}
class _DetailDayCardState extends State<_DetailDayCard> {
  bool _expanded = true;
  @override
  Widget build(BuildContext context) {
    final d = widget.day;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(color: LuxTheme.cream, borderRadius: LuxTheme.radius20, boxShadow: LuxTheme.cardShadow),
      child: Column(children: [
        PressScale(
          onTap: () { HapticFeedback.selectionClick(); setState(() => _expanded = !_expanded); },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [LuxTheme.terracotta, LuxTheme.terracottaL]), borderRadius: LuxTheme.radius12),
                child: Center(child: Text('${d.dayNumber}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, fontFamily: 'Georgia'))),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Day ${d.dayNumber}', style: LuxTheme.titleMd),
                Text('~${NumberFormat('#,##0').format(d.budgetDay)} DZD', style: LuxTheme.caption),
              ])),
              Icon(_expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: LuxTheme.latte),
            ]),
          ),
        ),
        if (_expanded) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(height: 1, decoration: const BoxDecoration(gradient: LuxTheme.goldGrad)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(children: [
              _Slot(icon: Icons.wb_sunny_rounded,   color: LuxTheme.gold,       label: 'Morning',   value: d.morning),
              _Slot(icon: Icons.restaurant_rounded, color: LuxTheme.terracotta, label: 'Lunch',     value: d.lunch),
              _Slot(icon: Icons.explore_rounded,    color: Color(0xFF2E86AB),   label: 'Afternoon', value: d.afternoon),
              _Slot(icon: Icons.nightlight_round,   color: LuxTheme.mocha,      label: 'Evening',   value: d.evening),
              _Slot(icon: Icons.bed_rounded,        color: LuxTheme.latte,      label: 'Hotel',     value: d.hotel, isLast: true),
            ]),
          ),
        ],
      ]),
    );
  }
}

class _Slot extends StatelessWidget {
  final IconData icon; final Color color;
  final String label, value; final bool isLast;
  const _Slot({required this.icon, required this.color, required this.label, required this.value, this.isLast = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 34, height: 34, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: LuxTheme.radius10), child: Icon(icon, size: 16, color: color)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: LuxTheme.caption),
        const SizedBox(height: 2),
        Text(value, style: LuxTheme.body.copyWith(color: LuxTheme.espresso, fontSize: 13, height: 1.4)),
      ])),
    ]),
  );
}