import 'package:flutter/material.dart';
import '../utils/luxury_theme.dart';

// ═══════════════════════════════════════════════════════════════
//  MANUAL TRIP PLANNER  —  Luxury Edition
// ═══════════════════════════════════════════════════════════════
class ManualTripPlannerPage extends StatefulWidget {
  const ManualTripPlannerPage({super.key});
  @override
  State<ManualTripPlannerPage> createState() => _ManualTripPlannerPageState();
}

class _ManualTripPlannerPageState extends State<ManualTripPlannerPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset>  _slide;

  final List<_TripDay> _days = [_TripDay(dayNumber: 1)];
  final _titleCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); _titleCtrl.dispose(); _notesCtrl.dispose(); super.dispose(); }

  void _addDay() => setState(() => _days.add(_TripDay(dayNumber: _days.length + 1)));
  void _removeDay(int index) => setState(() { _days.removeAt(index); for (int i = 0; i < _days.length; i++) _days[i] = _TripDay(dayNumber: i + 1, activities: _days[i].activities); });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            pinned: true,
            backgroundColor: LuxTheme.cream,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(10),
              child: PressScale(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(color: LuxTheme.sand, borderRadius: LuxTheme.radius10),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: LuxTheme.mocha),
                ),
              ),
            ),
            title: RichText(text: const TextSpan(children: [
              TextSpan(text: 'Manual ', style: TextStyle(fontFamily: 'Georgia', fontSize: 20, fontWeight: FontWeight.w700, color: LuxTheme.gold)),
              TextSpan(text: 'Planner', style: TextStyle(fontFamily: 'Georgia', fontSize: 20, fontWeight: FontWeight.w700, color: LuxTheme.espresso)),
            ])),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 14, top: 10),
                child: PressScale(
                  onTap: _save,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]),
                      borderRadius: LuxTheme.radiusPill,
                      boxShadow: LuxTheme.goldShadow,
                    ),
                    child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, decoration: const BoxDecoration(gradient: LuxTheme.goldGrad)),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            sliver: SliverList(delegate: SliverChildListDelegate([

              // Intro
              FadeSlideIn(fade: _fade, slide: _slide, child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GoldBadge(label: 'BUILD YOUR JOURNEY'),
                  const SizedBox(height: 12),
                  const Text('Design Your\nOwn Adventure', style: LuxTheme.displayMd),
                  const SizedBox(height: 8),
                  Text('Add destinations, activities and notes for each day.', style: LuxTheme.body),
                  const SizedBox(height: 28),
                  const GoldDivider(),
                  const SizedBox(height: 24),
                ],
              )),

              // Trip title
              FadeSlideIn(fade: _fade, slide: _slide, child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trip Name', style: LuxTheme.caption),
                  const SizedBox(height: 8),
                  LuxTextField(hint: 'e.g. Summer in Kabylia 2025', prefixIcon: Icons.luggage_rounded, controller: _titleCtrl),
                  const SizedBox(height: 24),
                ],
              )),

              // Day cards
              ..._days.asMap().entries.map((entry) {
                final i   = entry.key;
                final day = entry.value;
                return _DayCard(
                  day: day,
                  onAddActivity: (a) => setState(() => day.activities.add(a)),
                  onRemoveActivity: (a) => setState(() => day.activities.remove(a)),
                  onRemoveDay: _days.length > 1 ? () => _removeDay(i) : null,
                );
              }),

              const SizedBox(height: 8),

              // Add Day button
              PressScale(
                onTap: _addDay,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: LuxTheme.cream,
                    borderRadius: LuxTheme.radius14,
                    border: Border.all(color: LuxTheme.sandDark, width: 1.2, style: BorderStyle.solid),
                    boxShadow: LuxTheme.cardShadow,
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: 26, height: 26,
                      decoration: BoxDecoration(gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]), shape: BoxShape.circle),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Text('Add Day ${_days.length + 1}', style: LuxTheme.titleMd.copyWith(color: LuxTheme.mocha)),
                  ]),
                ),
              ),

              const SizedBox(height: 24),

              // Notes
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const GoldDivider(label: 'TRIP NOTES'),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesCtrl,
                  maxLines: 4,
                  style: LuxTheme.body.copyWith(color: LuxTheme.espresso),
                  decoration: InputDecoration(
                    hintText: 'Additional notes, packing list, reminders…',
                    hintStyle: LuxTheme.body.copyWith(color: LuxTheme.latte),
                    filled: true, fillColor: LuxTheme.cream,
                    contentPadding: const EdgeInsets.all(16),
                    enabledBorder: OutlineInputBorder(borderRadius: LuxTheme.radius14, borderSide: BorderSide(color: LuxTheme.sandDark)),
                    focusedBorder: OutlineInputBorder(borderRadius: LuxTheme.radius14, borderSide: const BorderSide(color: LuxTheme.gold, width: 1.8)),
                  ),
                ),
              ]),

              const SizedBox(height: 28),

              SizedBox(width: double.infinity, child: LuxButton(
                label: 'Save Journey',
                icon: Icons.check_rounded,
                onTap: _save,
              )),
            ])),
          ),
        ],
      ),
    );
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Journey saved!', style: TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: LuxTheme.terracotta,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: LuxTheme.radius10),
    ));
  }
}

class _TripDay {
  final int dayNumber;
  final List<String> activities;
  _TripDay({required this.dayNumber, List<String>? activities}) : activities = activities ?? [];
}

class _DayCard extends StatefulWidget {
  final _TripDay day;
  final ValueChanged<String> onAddActivity;
  final ValueChanged<String> onRemoveActivity;
  final VoidCallback? onRemoveDay;
  const _DayCard({required this.day, required this.onAddActivity, required this.onRemoveActivity, this.onRemoveDay});
  @override
  State<_DayCard> createState() => _DayCardState();
}
class _DayCardState extends State<_DayCard> {
  final _activityCtrl = TextEditingController();
  bool _expanded = true;

  @override
  void dispose() { _activityCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: LuxTheme.cream,
      borderRadius: LuxTheme.radius20,
      boxShadow: LuxTheme.cardShadow,
      border: Border.all(color: LuxTheme.sandDark, width: 1),
    ),
    child: Column(children: [
      // Header
      PressScale(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [LuxTheme.terracotta, LuxTheme.terracottaL]), borderRadius: LuxTheme.radius10),
              child: Center(child: Text('${widget.day.dayNumber}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('Day ${widget.day.dayNumber}', style: LuxTheme.titleMd)),
            if (widget.onRemoveDay != null)
              PressScale(
                onTap: widget.onRemoveDay!,
                child: Icon(Icons.remove_circle_outline_rounded, color: LuxTheme.latte, size: 20),
              ),
            const SizedBox(width: 8),
            Icon(_expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: LuxTheme.latte),
          ]),
        ),
      ),

      if (_expanded) ...[
        Container(height: 1, margin: const EdgeInsets.symmetric(horizontal: 16), decoration: const BoxDecoration(gradient: LuxTheme.goldGrad)),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Existing activities
            if (widget.day.activities.isNotEmpty) ...[
              ...widget.day.activities.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  const Icon(Icons.radio_button_checked_rounded, size: 14, color: LuxTheme.gold),
                  const SizedBox(width: 10),
                  Expanded(child: Text(a, style: LuxTheme.body.copyWith(color: LuxTheme.espresso, height: 1))),
                  PressScale(
                    onTap: () { widget.onRemoveActivity(a); setState(() {}); },
                    child: const Icon(Icons.close_rounded, size: 16, color: LuxTheme.latte),
                  ),
                ]),
              )),
              const SizedBox(height: 8),
            ],
            // Add activity
            Row(children: [
              Expanded(child: TextField(
                controller: _activityCtrl,
                style: LuxTheme.body.copyWith(color: LuxTheme.espresso, height: 1),
                decoration: InputDecoration(
                  hintText: 'Add activity or place…',
                  hintStyle: LuxTheme.body.copyWith(color: LuxTheme.latte, height: 1),
                  filled: true, fillColor: LuxTheme.sand,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: LuxTheme.radius10, borderSide: BorderSide.none),
                ),
                onSubmitted: (v) { if (v.trim().isNotEmpty) { widget.onAddActivity(v.trim()); _activityCtrl.clear(); setState(() {}); } },
              )),
              const SizedBox(width: 10),
              PressScale(
                onTap: () {
                  final v = _activityCtrl.text.trim();
                  if (v.isNotEmpty) { widget.onAddActivity(v); _activityCtrl.clear(); setState(() {}); }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]), borderRadius: LuxTheme.radius10, boxShadow: LuxTheme.goldShadow),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                ),
              ),
            ]),
          ]),
        ),
      ],
    ]),
  );
}