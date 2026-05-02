import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/luxury_theme.dart';
import '../data/wilaya_data.dart';

// ═══════════════════════════════════════════════════════════════
//  AI TRIP PLANNER  —  Luxury Edition
// ═══════════════════════════════════════════════════════════════
class AITripPlannerPage extends StatefulWidget {
  const AITripPlannerPage({super.key});
  @override
  State<AITripPlannerPage> createState() => _AITripPlannerPageState();
}

class _AITripPlannerPageState extends State<AITripPlannerPage>
    with TickerProviderStateMixin {

  String _category = '';
  WilayaData? _wilaya;
  List<String> _activities = [];
  int _days = 3;
  String _budgetMode  = 'auto';
  String _luxLevel    = 'Mid-range';
  int    _manualBudget= 50000;
  String _result      = '';
  bool   _generating  = false;
  List<WilayaData> _wilayas = [];

  final _budgetCtrl = TextEditingController(text: '50000');
  final List<String> _cats = ['Beach', 'Mountain', 'Sahara', 'Culture'];

  // Step reveal controllers
  late final List<AnimationController> _stepCtrls;
  late final List<Animation<double>>   _stepFades;
  late final List<Animation<Offset>>   _stepSlides;

  @override
  void initState() {
    super.initState();
    _stepCtrls = List.generate(7, (_) =>
        AnimationController(vsync: this, duration: const Duration(milliseconds: 450)));
    _stepFades = _stepCtrls.map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut)).toList();
    _stepSlides = _stepCtrls.map((c) =>
      Tween<Offset>(begin: const Offset(0, 0.16), end: Offset.zero)
          .animate(CurvedAnimation(parent: c, curve: Curves.easeOut))).toList();
    _stepCtrls[0].forward();
  }

  @override
  void dispose() { for (final c in _stepCtrls) c.dispose(); _budgetCtrl.dispose(); super.dispose(); }

  void _reveal(int step) {
    if (step < _stepCtrls.length && !_stepCtrls[step].isCompleted) {
      Future.delayed(const Duration(milliseconds: 100), () { if (mounted) _stepCtrls[step].forward(); });
    }
  }

  void _resetFrom(int step) {
    for (int i = step; i < _stepCtrls.length; i++) _stepCtrls[i].reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: CustomScrollView(
        slivers: [
          // ── App bar ──
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
              TextSpan(text: 'AI ', style: TextStyle(fontFamily: 'Georgia', fontSize: 20, fontWeight: FontWeight.w700, color: LuxTheme.gold)),
              TextSpan(text: 'Planner', style: TextStyle(fontFamily: 'Georgia', fontSize: 20, fontWeight: FontWeight.w700, color: LuxTheme.espresso)),
            ])),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, decoration: const BoxDecoration(gradient: LuxTheme.goldGrad)),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            sliver: SliverList(delegate: SliverChildListDelegate([

              // ── Intro ──
              FadeSlideIn(fade: _stepFades[0], slide: _stepSlides[0], child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GoldBadge(label: 'AI POWERED'),
                  const SizedBox(height: 12),
                  const Text('Craft Your\nPerfect Journey', style: LuxTheme.displayMd),
                  const SizedBox(height: 8),
                  Text('Answer a few questions and receive a curated itinerary.', style: LuxTheme.body),
                  const SizedBox(height: 28),
                  const GoldDivider(),
                ],
              )),

              const SizedBox(height: 24),

              // ── Step 1 ──
              FadeSlideIn(fade: _stepFades[0], slide: _stepSlides[0],
                child: _StepCard(number: 1, title: 'What type of experience?', child: Wrap(
                  spacing: 8, runSpacing: 8,
                  children: _cats.map((cat) {
                    final icons = {'Beach': Icons.beach_access_rounded, 'Mountain': Icons.terrain_rounded, 'Sahara': Icons.wb_sunny_rounded, 'Culture': Icons.museum_rounded};
                    return _LuxChip(
                      label: cat, icon: icons[cat]!, selected: _category == cat,
                      onTap: () {
                        setState(() { _category = cat; _wilaya = null; _activities.clear(); _wilayas = allWilayas.where((w) => w.categories.contains(cat)).toList(); });
                        _resetFrom(1);
                        _reveal(1);
                      },
                    );
                  }).toList(),
                )),
              ),

              const SizedBox(height: 16),

              // ── Step 2 ──
              if (_category.isNotEmpty) ...[
                FadeSlideIn(fade: _stepFades[1], slide: _stepSlides[1],
                  child: _StepCard(number: 2, title: 'Choose your destination', child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _wilayas.length,
                      itemBuilder: (_, i) {
                        final w = _wilayas[i];
                        final sel = _wilaya == w;
                        return GestureDetector(
                          onTap: () { setState(() { _wilaya = w; _activities.clear(); }); _resetFrom(2); _reveal(2); },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: 100,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: sel ? LuxTheme.terracotta.withOpacity(0.08) : LuxTheme.cream,
                              borderRadius: LuxTheme.radius14,
                              border: Border.all(color: sel ? LuxTheme.terracotta : LuxTheme.sandDark, width: sel ? 2 : 1),
                              boxShadow: sel ? LuxTheme.terrShadow : LuxTheme.cardShadow,
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              ClipRRect(
                                borderRadius: LuxTheme.radius10,
                                child: Image.asset(w.imagePath, width: 54, height: 54, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(width: 54, height: 54,
                                    decoration: const BoxDecoration(gradient: LuxTheme.terracottaGrad, borderRadius: LuxTheme.radius10),
                                    child: const Icon(Icons.location_city_rounded, color: Colors.white54, size: 24)),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(w.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: sel ? LuxTheme.terracotta : LuxTheme.espresso), textAlign: TextAlign.center),
                            ]),
                          ),
                        );
                      },
                    ),
                  )),
                ),
                const SizedBox(height: 16),
              ],

              // ── Step 3 ──
              if (_wilaya != null) ...[
                FadeSlideIn(fade: _stepFades[2], slide: _stepSlides[2],
                  child: _StepCard(number: 3, title: 'Which activities?', child: Wrap(
                    spacing: 8, runSpacing: 8,
                    children: _wilaya!.activities.map((a) => _LuxChip(
                      label: a, icon: Icons.check_circle_outline_rounded,
                      selected: _activities.contains(a),
                      onTap: () { setState(() => _activities.contains(a) ? _activities.remove(a) : _activities.add(a)); _reveal(3); },
                    )).toList(),
                  )),
                ),
                const SizedBox(height: 16),

                // ── Step 4 ──
                FadeSlideIn(fade: _stepFades[3], slide: _stepSlides[3],
                  child: _StepCard(number: 4, title: 'Duration of stay', child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CircleBtn(icon: Icons.remove_rounded, onTap: () { if (_days > 1) setState(() => _days--); _reveal(4); }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(children: [
                          Text('$_days', style: const TextStyle(fontFamily: 'Georgia', fontSize: 42, fontWeight: FontWeight.w700, color: LuxTheme.espresso)),
                          Text(_days == 1 ? 'day' : 'days', style: LuxTheme.caption),
                        ]),
                      ),
                      _CircleBtn(icon: Icons.add_rounded, onTap: () { if (_days < 21) setState(() => _days++); _reveal(4); }, filled: true),
                    ],
                  )),
                ),
                const SizedBox(height: 16),

                // ── Step 5 ──
                FadeSlideIn(fade: _stepFades[4], slide: _stepSlides[4],
                  child: _StepCard(number: 5, title: 'Budget preference', child: Column(children: [
                    Row(children: [
                      Expanded(child: _LuxChip(label: 'Auto estimate', icon: Icons.auto_fix_high_rounded, selected: _budgetMode == 'auto', onTap: () => setState(() => _budgetMode = 'auto'))),
                      const SizedBox(width: 8),
                      Expanded(child: _LuxChip(label: 'Custom amount', icon: Icons.edit_rounded, selected: _budgetMode == 'manual', onTap: () => setState(() => _budgetMode = 'manual'))),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(child: _LuxChip(label: 'Budget',  icon: Icons.savings_rounded,          selected: _luxLevel == 'Budget',    onTap: () => setState(() { _budgetMode = 'level'; _luxLevel = 'Budget'; }))),
                      const SizedBox(width: 6),
                      Expanded(child: _LuxChip(label: 'Mid',     icon: Icons.hotel_rounded,             selected: _luxLevel == 'Mid-range', onTap: () => setState(() { _budgetMode = 'level'; _luxLevel = 'Mid-range'; }))),
                      const SizedBox(width: 6),
                      Expanded(child: _LuxChip(label: 'Luxury',  icon: Icons.diamond_outlined,          selected: _luxLevel == 'Luxury',    onTap: () => setState(() { _budgetMode = 'level'; _luxLevel = 'Luxury'; }))),
                    ]),
                    if (_budgetMode == 'manual') ...[
                      const SizedBox(height: 14),
                      LuxTextField(hint: 'Total budget (DZD)', prefixIcon: Icons.account_balance_wallet_outlined, controller: _budgetCtrl, keyboardType: TextInputType.number, onChanged: (v) => _manualBudget = int.tryParse(v) ?? 0),
                    ],
                  ])),
                ),

                const SizedBox(height: 32),

                // ── Generate button ──
                FadeSlideIn(fade: _stepFades[4], slide: _stepSlides[4],
                  child: SizedBox(width: double.infinity, child: LuxButton(
                    label: 'Generate My Itinerary',
                    icon: Icons.auto_awesome_rounded,
                    isLoading: _generating,
                    onTap: _generating ? null : _generate,
                  )),
                ),
              ],

              const SizedBox(height: 24),

              // ── Result ──
              if (_result.isNotEmpty)
                FadeSlideIn(fade: _stepFades[5], slide: _stepSlides[5],
                  child: _ResultCard(result: _result, wilayaName: _wilaya?.name ?? '', onPdf: _pdf, onShare: _share),
                ),

            ])),
          ),
        ],
      ),
    );
  }

  Future<void> _generate() async {
    if (_wilaya == null) return;
    setState(() { _generating = true; _result = ''; });

    int budget = 0;
    if (_budgetMode == 'auto') {
      budget = (_wilaya!.defaultPricePerDay * _days).round();
    } else if (_budgetMode == 'manual') {
      budget = _manualBudget;
    } else {
      final m = _luxLevel == 'Budget' ? 0.7 : (_luxLevel == 'Luxury' ? 2.0 : 1.2);
      budget = (_wilaya!.defaultPricePerDay * _days * m).round();
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    final sb = StringBuffer();
    sb.writeln('✦ ITINERARY — ${_wilaya!.name.toUpperCase()} ($_days Days)\n');
    sb.writeln('Estimated Budget: ${NumberFormat('#,##0').format(budget)} DZD');
    sb.writeln('Level: $_luxLevel  |  Activities: ${_activities.isEmpty ? 'All suggested' : _activities.join(', ')}\n');
    sb.writeln('─────────────────────────────────\n');
    for (int day = 1; day <= _days; day++) {
      final act  = _activities.isNotEmpty && day <= _activities.length ? _activities[day - 1] : _wilaya!.activities[(day - 1) % _wilaya!.activities.length];
      final rest = _wilaya!.restaurants[day % _wilaya!.restaurants.length];
      final attr = _wilaya!.attractions[(day * 2) % _wilaya!.attractions.length];
      sb.writeln('DAY $day');
      sb.writeln('  ☀  Morning: $act');
      sb.writeln('  🍽  Lunch: $rest');
      sb.writeln('  🗺  Afternoon: Explore $attr');
      sb.writeln('  🌙  Evening: ${_wilaya!.restaurants[(day + 1) % _wilaya!.restaurants.length]}');
      sb.writeln('  🏨  Hotel: from ${(budget / _days * 0.4).round()} DZD/night\n');
    }
    sb.writeln('─────────────────────────────────');
    sb.writeln('\n✦ TIPS');
    sb.writeln('• Transport: Taxi or rental car recommended');
    sb.writeln('• Weather: ${_wilaya!.categories.contains('Beach') ? 'Best in summer (Jun–Sep)' : 'Spring & autumn are ideal'}');
    sb.writeln('• Currency: Carry cash for local markets');
    sb.writeln('\nBon voyage in ${_wilaya!.name}!');

    setState(() { _result = sb.toString(); _generating = false; });
    _reveal(5);
  }

  Future<void> _pdf() async {
    if (_result.isEmpty) return;
    final regular = await PdfGoogleFonts.poppinsRegular();
    final bold    = await PdfGoogleFonts.poppinsBold();
    final pdf     = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (_) => [
        pw.Text('PlanGo DZ — Luxury Itinerary', style: pw.TextStyle(font: bold, fontSize: 22, color: PdfColors.brown800)),
        pw.SizedBox(height: 6),
        pw.Text('Generated: ${DateFormat('dd MMMM yyyy').format(DateTime.now())}', style: pw.TextStyle(font: regular, fontSize: 11, color: PdfColors.grey)),
        pw.SizedBox(height: 20),
        pw.Text(_result, style: pw.TextStyle(font: regular, fontSize: 11)),
      ],
    ));
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'plango_${_wilaya?.name}.pdf');
  }

  void _share() => Share.share(_result, subject: 'My PlanGo DZ Itinerary');
}

// ── Step Card ─────────────────────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final int number;
  final String title;
  final Widget child;
  const _StepCard({required this.number, required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: LuxTheme.cream, borderRadius: LuxTheme.radius20, boxShadow: LuxTheme.cardShadow),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]), borderRadius: LuxTheme.radius10),
          child: Center(child: Text('$number', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800))),
        ),
        const SizedBox(width: 12),
        Text(title, style: LuxTheme.titleMd),
      ]),
      const SizedBox(height: 16),
      child,
    ]),
  );
}

// ── Lux Chip ──────────────────────────────────────────────────────────────────
class _LuxChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _LuxChip({required this.label, required this.icon, required this.selected, required this.onTap});
  @override
  State<_LuxChip> createState() => _LuxChipState();
}
class _LuxChipState extends State<_LuxChip> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _s = Tween<double>(begin: 1.0, end: 0.91).animate(_c);
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => _c.forward(),
    onTapCancel: () => _c.reverse(),
    onTap: () { _c.reverse(); widget.onTap(); },
    child: ScaleTransition(scale: _s,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          gradient: widget.selected ? const LinearGradient(colors: [LuxTheme.terracotta, LuxTheme.terracottaL]) : null,
          color: widget.selected ? null : LuxTheme.sand,
          borderRadius: LuxTheme.radiusPill,
          border: Border.all(color: widget.selected ? LuxTheme.terracottaL : LuxTheme.sandDark),
          boxShadow: widget.selected ? LuxTheme.terrShadow : [],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(widget.icon, size: 14, color: widget.selected ? Colors.white : LuxTheme.latte),
          const SizedBox(width: 6),
          Text(widget.label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: widget.selected ? Colors.white : LuxTheme.mocha)),
        ]),
      ),
    ),
  );
}

// ── Circle Button ─────────────────────────────────────────────────────────────
class _CircleBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _CircleBtn({required this.icon, required this.onTap, this.filled = false});
  @override
  State<_CircleBtn> createState() => _CircleBtnState();
}
class _CircleBtnState extends State<_CircleBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _s = Tween<double>(begin: 1.0, end: 0.88).animate(_c);
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => _c.forward(),
    onTapCancel: () => _c.reverse(),
    onTap: () { _c.reverse(); widget.onTap(); },
    child: ScaleTransition(scale: _s,
      child: Container(
        width: 50, height: 50,
        decoration: BoxDecoration(
          gradient: widget.filled ? const LinearGradient(colors: [LuxTheme.terracotta, LuxTheme.terracottaL]) : null,
          color: widget.filled ? null : LuxTheme.cream,
          shape: BoxShape.circle,
          border: Border.all(color: widget.filled ? Colors.transparent : LuxTheme.sandDark),
          boxShadow: widget.filled ? LuxTheme.terrShadow : LuxTheme.cardShadow,
        ),
        child: Icon(widget.icon, size: 22, color: widget.filled ? Colors.white : LuxTheme.terracotta),
      ),
    ),
  );
}

// ── Result Card ───────────────────────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final String result, wilayaName;
  final VoidCallback onPdf, onShare;
  const _ResultCard({required this.result, required this.wilayaName, required this.onPdf, required this.onShare});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: LuxTheme.cream, borderRadius: LuxTheme.radius20, boxShadow: LuxTheme.cardShadow,
      border: Border.all(color: LuxTheme.gold.withOpacity(0.3), width: 1.2),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]), borderRadius: LuxTheme.radius10),
          child: const Icon(Icons.map_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        const Expanded(child: Text('Your Curated Itinerary', style: LuxTheme.titleMd)),
        _ActionBtn(icon: Icons.picture_as_pdf_rounded, color: LuxTheme.terracotta, onTap: onPdf),
        const SizedBox(width: 8),
        _ActionBtn(icon: Icons.share_rounded, color: LuxTheme.gold, onTap: onShare),
      ]),
      const SizedBox(height: 16),
      Container(height: 1, decoration: const BoxDecoration(gradient: LuxTheme.goldGrad)),
      const SizedBox(height: 16),
      SelectableText(result, style: LuxTheme.body.copyWith(fontSize: 13, color: LuxTheme.espresso)),
    ]),
  );
}

class _ActionBtn extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.color, required this.onTap});
  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}
class _ActionBtnState extends State<_ActionBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _s = Tween<double>(begin: 1.0, end: 0.85).animate(_c);
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => _c.forward(),
    onTapCancel: () => _c.reverse(),
    onTap: () { _c.reverse(); widget.onTap(); },
    child: ScaleTransition(scale: _s,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: widget.color.withOpacity(0.1), borderRadius: LuxTheme.radius10),
        child: Icon(widget.icon, color: widget.color, size: 20),
      ),
    ),
  );
}