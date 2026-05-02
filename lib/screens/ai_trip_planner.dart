// lib/screens/ai_trip_planner.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/luxury_theme.dart';
import '../data/wilaya_data.dart';

class AITripPlannerPage extends StatefulWidget {
  const AITripPlannerPage({super.key});
  @override State<AITripPlannerPage> createState() => _AITripPlannerPageState();
}

class _AITripPlannerPageState extends State<AITripPlannerPage> with TickerProviderStateMixin {
  String _selectedCategory = '';
  WilayaData? _selectedWilaya;
  List<String> _selectedActivities = [];
  int _duration = 3;
  String _budgetMode  = 'auto';
  String _luxuryLevel = 'Mid-range';
  int _manualBudget   = 50000;
  String _generatedItinerary = '';
  bool _isGenerating = false;

  final List<String> _categories = ['Plage', 'Montagne', 'Sahara', 'Culture'];
  List<WilayaData> _filteredWilayas = [];
  final TextEditingController _budgetCtrl = TextEditingController(text: '50000');

  // One controller per step card (0–4) + result (5)
  late final List<AnimationController> _stepCtrls;
  late final List<Animation<double>>   _stepFades;
  late final List<Animation<Offset>>   _stepSlides;

  @override
  void initState() {
    super.initState();
    _stepCtrls = List.generate(6, (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 400)));
    _stepFades  = _stepCtrls.map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut)).toList();
    _stepSlides = _stepCtrls.map((c) => Tween<Offset>(begin: const Offset(0, 0.14), end: Offset.zero)
        .animate(CurvedAnimation(parent: c, curve: Curves.easeOut))).toList();
    _stepCtrls[0].forward();
  }

  @override void dispose() { for (final c in _stepCtrls) c.dispose(); _budgetCtrl.dispose(); super.dispose(); }

  void _reveal(int step) { if (step < _stepCtrls.length && !_stepCtrls[step].isCompleted) Future.delayed(const Duration(milliseconds: 60), () { if (mounted) _stepCtrls[step].forward(); }); }
  void _reset(int fromStep) { for (int i = fromStep; i < _stepCtrls.length; i++) _stepCtrls[i].reset(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      appBar: _appBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Hero heading
          _Reveal(fade: _stepFades[0], slide: _stepSlides[0], child: _heading()),
          const SizedBox(height: 28),

          // Step 1 – Category
          _Reveal(fade: _stepFades[0], slide: _stepSlides[0], child: _StepCard(step: 1, title: 'Type of trip', child:
            Wrap(spacing: 10, runSpacing: 10, children: _categories.map((cat) {
              final icons = {'Plage': Icons.beach_access_rounded,'Montagne': Icons.terrain_rounded,'Sahara': Icons.wb_sunny_rounded,'Culture': Icons.museum_rounded};
              return _LuxChip(label: cat, icon: icons[cat]!, isSelected: _selectedCategory == cat, onTap: () {
                setState(() { _selectedCategory = cat; _selectedWilaya = null; _selectedActivities.clear(); _filteredWilayas = allWilayas.where((w) => w.categories.contains(cat)).toList(); });
                _reveal(1); _reset(2);
              });
            }).toList()),
          )),
          const SizedBox(height: 16),

          // Step 2 – Wilaya
          if (_selectedCategory.isNotEmpty) ...[
            _Reveal(fade: _stepFades[1], slide: _stepSlides[1], child: _StepCard(step: 2, title: 'Choose destination', child:
              SizedBox(height: 122, child: ListView.builder(
                scrollDirection: Axis.horizontal, itemCount: _filteredWilayas.length,
                itemBuilder: (_, i) { final w = _filteredWilayas[i]; final sel = _selectedWilaya == w;
                  return GestureDetector(onTap: () { setState(() { _selectedWilaya = w; _selectedActivities.clear(); }); _reveal(2); _reset(3); },
                    child: AnimatedContainer(duration: const Duration(milliseconds: 220),
                      width: 105, margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: sel ? LuxTheme.terracotta.withOpacity(0.08) : LuxTheme.sandLight,
                        borderRadius: LuxTheme.r14,
                        border: Border.all(color: sel ? LuxTheme.terracotta : LuxTheme.sandDark, width: sel ? 2 : 1),
                        boxShadow: sel ? LuxTheme.primaryShadow : LuxTheme.cardShadow,
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        ClipRRect(borderRadius: LuxTheme.rPill, child: Image.asset(w.imagePath, width: 54, height: 54, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 54, height: 54, color: LuxTheme.sandDark, child: const Icon(Icons.location_city_rounded, color: LuxTheme.latte)))),
                        const SizedBox(height: 8),
                        Text(w.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: sel ? LuxTheme.terracotta : LuxTheme.espresso), textAlign: TextAlign.center),
                      ]),
                    ),
                  );
                },
              )),
            )),
            const SizedBox(height: 16),
          ],

          // Step 3 – Activities
          if (_selectedWilaya != null) ...[
            _Reveal(fade: _stepFades[2], slide: _stepSlides[2], child: _StepCard(step: 3, title: 'Preferred activities', child:
              Wrap(spacing: 10, runSpacing: 10, children: _selectedWilaya!.activities.map((act) {
                final sel = _selectedActivities.contains(act);
                return _LuxChip(label: act, icon: Icons.check_circle_outline_rounded, isSelected: sel, onTap: () {
                  setState(() => sel ? _selectedActivities.remove(act) : _selectedActivities.add(act));
                  _reveal(3);
                });
              }).toList()),
            )),
            const SizedBox(height: 16),
          ],

          // Step 4 – Duration
          if (_selectedWilaya != null) ...[
            _Reveal(fade: _stepFades[3], slide: _stepSlides[3], child: _StepCard(step: 4, title: 'Duration', child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _DurationBtn(icon: Icons.remove_rounded, onTap: () { if (_duration > 1) setState(() => _duration--); _reveal(4); }),
                const SizedBox(width: 28),
                Column(children: [
                  Text('$_duration', style: LuxTheme.serif32),
                  Text(_duration == 1 ? 'day' : 'days', style: LuxTheme.body14),
                ]),
                const SizedBox(width: 28),
                _DurationBtn(icon: Icons.add_rounded, onTap: () { if (_duration < 21) setState(() => _duration++); _reveal(4); }, filled: true),
              ]),
            )),
            const SizedBox(height: 16),
          ],

          // Step 5 – Budget
          if (_selectedWilaya != null) ...[
            _Reveal(fade: _stepFades[4], slide: _stepSlides[4], child: _StepCard(step: 5, title: 'Budget', child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Wrap(spacing: 10, runSpacing: 10, children: [
                  _LuxChip(label: 'Auto estimate',  icon: Icons.auto_fix_high_rounded, isSelected: _budgetMode == 'auto',   onTap: () => setState(() => _budgetMode = 'auto')),
                  _LuxChip(label: 'Enter amount',   icon: Icons.edit_rounded,          isSelected: _budgetMode == 'manual', onTap: () => setState(() => _budgetMode = 'manual')),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _BudgetTile(label: 'Budget',   icon: Icons.savings_rounded, selected: _luxuryLevel == 'Budget',    onTap: () => setState(() { _budgetMode = 'level'; _luxuryLevel = 'Budget'; }))),
                  const SizedBox(width: 8),
                  Expanded(child: _BudgetTile(label: 'Mid-range', icon: Icons.hotel_rounded,  selected: _luxuryLevel == 'Mid-range', onTap: () => setState(() { _budgetMode = 'level'; _luxuryLevel = 'Mid-range'; }))),
                  const SizedBox(width: 8),
                  Expanded(child: _BudgetTile(label: 'Luxury',   icon: Icons.star_rounded,    selected: _luxuryLevel == 'Luxury',    onTap: () => setState(() { _budgetMode = 'level'; _luxuryLevel = 'Luxury'; }))),
                ]),
                if (_budgetMode == 'manual') ...[
                  const SizedBox(height: 14),
                  TextField(
                    controller: _budgetCtrl, keyboardType: TextInputType.number,
                    onChanged: (v) => _manualBudget = int.tryParse(v) ?? 0,
                    style: LuxTheme.body14.copyWith(color: LuxTheme.espresso),
                    decoration: InputDecoration(
                      labelText: 'Total budget (DZD)', labelStyle: TextStyle(color: LuxTheme.latte),
                      prefixIcon: const Icon(Icons.account_balance_wallet_outlined, color: LuxTheme.gold),
                      filled: true, fillColor: LuxTheme.sandLight,
                      enabledBorder: OutlineInputBorder(borderRadius: LuxTheme.r14, borderSide: BorderSide(color: LuxTheme.sandDark)),
                      focusedBorder: OutlineInputBorder(borderRadius: LuxTheme.r14, borderSide: const BorderSide(color: LuxTheme.gold, width: 1.5)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ],
              ]),
            )),
            const SizedBox(height: 32),
          ],

          // Generate button
          if (_selectedWilaya != null)
            LuxButton(label: 'Generate My Itinerary', icon: Icons.auto_awesome_rounded, isLoading: _isGenerating, onTap: _isGenerating ? null : _generate),

          // Result
          if (_generatedItinerary.isNotEmpty) ...[
            const SizedBox(height: 28),
            _Reveal(fade: _stepFades[5], slide: _stepSlides[5], child: _ResultCard(
              itinerary: _generatedItinerary,
              wilayaName: _selectedWilaya?.name ?? '',
              onPdf: _pdf, onShare: _share,
            )),
          ],
        ]),
      ),
    );
  }

  PreferredSizeWidget _appBar() => AppBar(
    backgroundColor: LuxTheme.sandLight, foregroundColor: LuxTheme.espresso, elevation: 0, surfaceTintColor: Colors.transparent,
    title: const Text('AI Trip Planner', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: LuxTheme.espresso)),
    bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: LuxTheme.sandDark)),
    leading: Padding(padding: const EdgeInsets.all(10), child: PressScale(onTap: () => Navigator.pop(context), child:
      Container(decoration: BoxDecoration(color: LuxTheme.sand, borderRadius: LuxTheme.r8), padding: const EdgeInsets.all(6),
        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: LuxTheme.espresso)))),
    actions: [Padding(padding: const EdgeInsets.only(right: 16), child: GoldBadge(label: 'AI'))],
  );

  Widget _heading() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('CRAFT YOUR JOURNEY', style: LuxTheme.goldLabel.copyWith(letterSpacing: 2.5)),
    const SizedBox(height: 8),
    Text('Tell us your\ndream trip', style: LuxTheme.serif32),
    const SizedBox(height: 8),
    Text('Answer a few questions for a tailor-made Algerian adventure.', style: LuxTheme.body14),
  ]);

  Future<void> _generate() async {
    if (_selectedWilaya == null) return;
    setState(() { _isGenerating = true; _generatedItinerary = ''; });
    int budget = 0;
    if (_budgetMode == 'auto')        budget = (_selectedWilaya!.defaultPricePerDay * _duration).round();
    else if (_budgetMode == 'manual') budget = _manualBudget;
    else {
      final m = _luxuryLevel == 'Budget' ? 0.65 : (_luxuryLevel == 'Luxury' ? 2.0 : 1.2);
      budget = (_selectedWilaya!.defaultPricePerDay * _duration * m).round();
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() { _generatedItinerary = _buildText(_selectedWilaya!, _duration, _selectedActivities, budget); _isGenerating = false; });
    _reveal(5);
  }

  String _buildText(WilayaData w, int days, List<String> acts, int budget) {
    final sb = StringBuffer();
    sb.writeln('✦  ${w.name.toUpperCase()} — $days-DAY ITINERARY\n');
    sb.writeln('Estimated budget: ${NumberFormat('#,##0').format(budget)} DZD');
    sb.writeln('Style: $_luxuryLevel\n');
    sb.writeln('─────────────────────────────────────\n');
    for (int d = 1; d <= days; d++) {
      final act  = acts.isNotEmpty && d <= acts.length ? acts[d - 1] : w.activities[(d - 1) % w.activities.length];
      final rest = w.restaurants[d % w.restaurants.length];
      final attr = w.attractions[(d * 2) % w.attractions.length];
      sb.writeln('DAY $d');
      sb.writeln('Morning   › $act');
      sb.writeln('Lunch     › $rest');
      sb.writeln('Afternoon › $attr');
      sb.writeln('Evening   › Dinner at ${w.restaurants[(d + 1) % w.restaurants.length]}');
      sb.writeln('Lodging   › From ${(budget / days * 0.35).round()} DZD/night\n');
    }
    sb.writeln('─────────────────────────────────────');
    sb.writeln('\n✦  TRAVEL TIPS');
    sb.writeln('Transport  › Taxi or car rental recommended');
    sb.writeln('Season     › ${w.categories.contains('Plage') ? 'Best in summer (Jun–Sep)' : 'Spring & autumn are ideal'}');
    sb.writeln('Currency   › Carry cash for local markets');
    sb.writeln('Language   › Arabic & French widely spoken\n');
    sb.writeln('Enjoy your journey in ${w.name}!');
    return sb.toString();
  }

  Future<void> _pdf() async {
    if (_generatedItinerary.isEmpty) return;
    final reg  = await PdfGoogleFonts.poppinsRegular();
    final bold = await PdfGoogleFonts.poppinsBold();
    final doc  = pw.Document();
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4, margin: pw.EdgeInsets.all(36),
      build: (_) => [
        pw.Text('PlanGo Dz — Luxury Itinerary', style: pw.TextStyle(font: bold, fontSize: 22, color: PdfColors.brown800)),
        pw.SizedBox(height: 6),
        pw.Text('Generated ${DateFormat('dd MMM yyyy').format(DateTime.now())}', style: pw.TextStyle(font: reg, fontSize: 11, color: PdfColors.grey)),
        pw.SizedBox(height: 24),
        pw.Text(_generatedItinerary, style: pw.TextStyle(font: reg, fontSize: 11, lineSpacing: 2)),
      ],
    ));
    await Printing.sharePdf(bytes: await doc.save(), filename: 'plango_${_selectedWilaya?.name}.pdf');
  }

  void _share() => Share.share(_generatedItinerary, subject: 'My PlanGo Dz itinerary');
}

// ── Step card ──────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final int step; final String title; final Widget child;
  const _StepCard({required this.step, required this.title, required this.child});
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: LuxTheme.sandLight, borderRadius: LuxTheme.r20, boxShadow: LuxTheme.cardShadow,
      border: Border.all(color: LuxTheme.sandDark, width: 1)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 30, height: 30, decoration: const BoxDecoration(gradient: LuxTheme.primaryGrad, shape: BoxShape.circle),
          child: Center(child: Text('$step', style: const TextStyle(color: LuxTheme.white, fontSize: 13, fontWeight: FontWeight.w800)))),
        const SizedBox(width: 10),
        Text(title, style: LuxTheme.title16),
      ]),
      const SizedBox(height: 16),
      child,
    ]),
  );
}

// ── Reveal wrapper ─────────────────────────────────────────────
class _Reveal extends StatelessWidget {
  final Animation<double> fade; final Animation<Offset> slide; final Widget child;
  const _Reveal({required this.fade, required this.slide, required this.child});
  @override Widget build(BuildContext context) => FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child));
}

// ── Luxury chip ────────────────────────────────────────────────
class _LuxChip extends StatefulWidget {
  final String label; final IconData icon; final bool isSelected; final VoidCallback onTap;
  const _LuxChip({required this.label, required this.icon, required this.isSelected, required this.onTap});
  @override State<_LuxChip> createState() => _LuxChipState();
}
class _LuxChipState extends State<_LuxChip> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 100)); _s = Tween(begin: 1.0, end: 0.91).animate(_c); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => _c.forward(), onTapCancel: () => _c.reverse(),
    onTap: () { _c.reverse(); widget.onTap(); },
    child: ScaleTransition(scale: _s, child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: widget.isSelected ? LuxTheme.terracotta : LuxTheme.sandLight,
        borderRadius: LuxTheme.rPill,
        border: Border.all(color: widget.isSelected ? LuxTheme.terracotta : LuxTheme.sandDark, width: 1.2),
        boxShadow: widget.isSelected ? LuxTheme.primaryShadow : LuxTheme.cardShadow,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(widget.icon, size: 15, color: widget.isSelected ? LuxTheme.white : LuxTheme.latte),
        const SizedBox(width: 7),
        Text(widget.label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: widget.isSelected ? LuxTheme.white : LuxTheme.espresso)),
      ]),
    )),
  );
}

// ── Budget tile ────────────────────────────────────────────────
class _BudgetTile extends StatelessWidget {
  final String label; final IconData icon; final bool selected; final VoidCallback onTap;
  const _BudgetTile({required this.label, required this.icon, required this.selected, required this.onTap});
  @override Widget build(BuildContext context) => PressScale(onTap: onTap, child: AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: selected ? LuxTheme.goldPale : LuxTheme.sandLight,
      borderRadius: LuxTheme.r14,
      border: Border.all(color: selected ? LuxTheme.gold : LuxTheme.sandDark, width: selected ? 1.8 : 1),
    ),
    child: Column(children: [
      Icon(icon, size: 20, color: selected ? LuxTheme.gold : LuxTheme.latte),
      const SizedBox(height: 6),
      Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: selected ? LuxTheme.gold : LuxTheme.latte)),
    ]),
  ));
}

// ── Duration button ────────────────────────────────────────────
class _DurationBtn extends StatefulWidget {
  final IconData icon; final VoidCallback onTap; final bool filled;
  const _DurationBtn({required this.icon, required this.onTap, this.filled = false});
  @override State<_DurationBtn> createState() => _DurationBtnState();
}
class _DurationBtnState extends State<_DurationBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 90)); _s = Tween(begin: 1.0, end: 0.87).animate(_c); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => _c.forward(), onTapCancel: () => _c.reverse(), onTap: () { _c.reverse(); widget.onTap(); },
    child: ScaleTransition(scale: _s, child: Container(
      width: 52, height: 52,
      decoration: BoxDecoration(
        gradient: widget.filled ? LuxTheme.primaryGrad : null,
        color: widget.filled ? null : LuxTheme.sandLight,
        shape: BoxShape.circle,
        border: widget.filled ? null : Border.all(color: LuxTheme.sandDark),
        boxShadow: widget.filled ? LuxTheme.primaryShadow : LuxTheme.cardShadow,
      ),
      child: Icon(widget.icon, size: 24, color: widget.filled ? LuxTheme.white : LuxTheme.terracotta),
    )),
  );
}

// ── Result card ────────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final String itinerary, wilayaName; final VoidCallback onPdf, onShare;
  const _ResultCard({required this.itinerary, required this.wilayaName, required this.onPdf, required this.onShare});
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(color: LuxTheme.sandLight, borderRadius: LuxTheme.r20, boxShadow: LuxTheme.cardShadow,
      border: Border.all(color: LuxTheme.gold.withOpacity(0.35), width: 1.2)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const GoldBadge(label: 'YOUR ITINERARY'),
        const Spacer(),
        PressScale(onTap: onPdf, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFE53935).withOpacity(0.1), borderRadius: LuxTheme.r8),
          child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFE53935), size: 20))),
        const SizedBox(width: 8),
        PressScale(onTap: onShare, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: LuxTheme.terracotta.withOpacity(0.1), borderRadius: LuxTheme.r8),
          child: const Icon(Icons.share_rounded, color: LuxTheme.terracotta, size: 20))),
      ]),
      const SizedBox(height: 14),
      const GoldDivider(),
      const SizedBox(height: 14),
      SelectableText(itinerary, style: LuxTheme.body14.copyWith(fontSize: 13, fontFamily: 'Courier New', height: 1.8)),
    ]),
  );
}