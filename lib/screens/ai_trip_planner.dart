import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/luxury_theme.dart';
import '../data/wilaya_data.dart';

// ═══════════════════════════════════════════════════════════════
//  AI TRIP PLANNER  —  Professional Luxury Edition
// ═══════════════════════════════════════════════════════════════

class AITripPlannerPage extends StatefulWidget {
  const AITripPlannerPage({super.key});
  @override
  State<AITripPlannerPage> createState() => _AITripPlannerPageState();
}

class _AITripPlannerPageState extends State<AITripPlannerPage>
    with TickerProviderStateMixin {

  // ══════════════════════════════════════════════════════════
  //  ▶▶ PASTE YOUR API KEY HERE — KEEP IT PRIVATE ◀◀
  // ══════════════════════════════════════════════════════════
  static const String _apiKey = 'sk-abcdijkl1234uvwxabcdijkl1234uvwxabcdijkl';
  // ══════════════════════════════════════════════════════════

  // ── State ──────────────────────────────────────────────────
  int     _currentStep   = 0;
  String  _category      = '';
  WilayaData? _wilaya;
  List<String> _activities = [];
  int     _days          = 3;
  String  _budgetMode    = 'mid';
  int     _customBudget  = 50000;

  // ── Result ────────────────────────────────────────────────
  bool _generating = false;
  bool _generated  = false;
  List<_ItineraryDay> _itineraryDays = [];
  int  _totalBudget = 0;

  // ── Typing animation ─────────────────────────────────────
  late final AnimationController _typingCtrl;
  String _typingText = '';
  int    _typingIndex = 0;
  final String _typingMessage = 'Crafting your personalised itinerary…';

  // ── Progress bar animation ────────────────────────────────
  late final AnimationController _progressCtrl;
  late final Animation<double>   _progressAnim;

  // ── Step reveal animations ────────────────────────────────
  late final AnimationController _stepCtrl;
  late final Animation<double>   _stepFade;
  late final Animation<Offset>   _stepSlide;

  // ── Result card animations ────────────────────────────────
  late final AnimationController _resultCtrl;
  late final Animation<double>   _resultFade;
  late final Animation<Offset>   _resultSlide;

  // ── Page controller ───────────────────────────────────────
  final PageController _pageCtrl = PageController();

  // ── Data ─────────────────────────────────────────────────
  final List<String> _cats = ['Beach', 'Mountain', 'Sahara', 'Culture'];
  final Map<String, IconData> _catIcons = {
    'Beach':    Icons.beach_access_rounded,
    'Mountain': Icons.terrain_rounded,
    'Sahara':   Icons.wb_sunny_rounded,
    'Culture':  Icons.museum_rounded,
  };
  final Map<String, String> _catDesc = {
    'Beach':    'Coast, sun & sea',
    'Mountain': 'Peaks & nature',
    'Sahara':   'Dunes & starlit skies',
    'Culture':  'History & heritage',
  };
  List<WilayaData> _wilayas = [];
  final _budgetCtrl  = TextEditingController(text: '50000');
  final ScrollController _scrollCtrl = ScrollController();

  static const int _totalSteps = 5;

  @override
  void initState() {
    super.initState();

    _typingCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 50))
      ..addListener(_onTypingTick);

    _progressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _progressAnim = CurvedAnimation(parent: _progressCtrl, curve: Curves.easeOut);

    _stepCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _stepFade  = CurvedAnimation(parent: _stepCtrl, curve: Curves.easeOut);
    _stepSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _stepCtrl, curve: Curves.easeOut));

    _resultCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _resultFade  = CurvedAnimation(parent: _resultCtrl, curve: Curves.easeOut);
    _resultSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _resultCtrl, curve: Curves.easeOut));

    _stepCtrl.forward();
    _progressCtrl.animateTo(0);
  }

  @override
  void dispose() {
    _typingCtrl.dispose();
    _progressCtrl.dispose();
    _stepCtrl.dispose();
    _resultCtrl.dispose();
    _pageCtrl.dispose();
    _budgetCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Typing animation tick ─────────────────────────────────
  void _onTypingTick() {
    if (_typingIndex < _typingMessage.length) {
      setState(() {
        _typingText = _typingMessage.substring(0, _typingIndex + 1);
        _typingIndex++;
      });
      if (_typingIndex < _typingMessage.length) {
        Future.delayed(const Duration(milliseconds: 38), () {
          if (mounted && _generating) _typingCtrl.forward(from: 0);
        });
      }
    }
  }

  // ── Step navigation ───────────────────────────────────────
  void _goToStep(int step) {
    if (step < 0 || step >= _totalSteps) return;
    setState(() => _currentStep = step);
    _stepCtrl.reset();
    _stepCtrl.forward();
    _progressCtrl.animateTo(step / (_totalSteps - 1));
    _pageCtrl.animateToPage(step, duration: const Duration(milliseconds: 380), curve: Curves.easeInOut);
  }

  bool get _canAdvance {
    switch (_currentStep) {
      case 0: return _category.isNotEmpty;
      case 1: return _wilaya != null;
      case 2: return true;
      case 3: return true;
      case 4: return true;
      default: return false;
    }
  }

  // ══════════════════════════════════════════════════════════
  //  REAL AI GENERATE — calls Claude API
  // ══════════════════════════════════════════════════════════
  Future<void> _generate() async {
    if (_wilaya == null) return;

    _scrollCtrl.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);

    setState(() {
      _generating    = true;
      _generated     = false;
      _typingText    = '';
      _typingIndex   = 0;
      _itineraryDays = [];
    });

    _typingCtrl.forward(from: 0);

    // Calculate total budget
    double multiplier = _budgetMode == 'budget' ? 0.7 : (_budgetMode == 'luxury' ? 2.0 : 1.2);
    _totalBudget = _budgetMode == 'custom'
        ? _customBudget
        : (_wilaya!.defaultPricePerDay * _days * multiplier).round();

    try {
      final prompt = '''
You are a professional Algerian travel planner. Create a detailed $_days-day itinerary for ${_wilaya!.name}, Algeria.

Trip details:
- Category: $_category
- Duration: $_days days
- Budget level: $_budgetMode
- Total budget: ${NumberFormat('#,##0').format(_totalBudget)} DZD
- Preferred activities: ${_activities.isEmpty ? 'any suitable activities for this destination' : _activities.join(', ')}

Important rules:
- Day 1 morning must always be: arrival and hotel check-in
- Last day evening must always be: farewell dinner and departure preparation
- Use REAL local restaurant names from ${_wilaya!.name}
- Use REAL attraction and landmark names from ${_wilaya!.name}
- Hotel suggestion must match the $_budgetMode budget level
- Each day tip must be a genuinely useful local insight
- Be specific and descriptive, never generic

Return ONLY a valid JSON array with no explanation, no markdown formatting, no code blocks — just raw JSON:
[
  {
    "day": 1,
    "morning": "detailed morning activity",
    "lunch": "Restaurant name — short description of cuisine/dish",
    "afternoon": "detailed afternoon activity",
    "evening": "Restaurant name or evening activity description",
    "hotel": "Hotel name — price range per night in DZD",
    "tip": "One practical local tip for this day"
  }
]
''';

      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-6',
          'max_tokens': 4000,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String rawText = jsonResponse['content'][0]['text'];

        // Strip markdown code blocks if Claude adds them
        rawText = rawText
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        final List<dynamic> daysJson = jsonDecode(rawText);
        final days = <_ItineraryDay>[];

        for (final d in daysJson) {
          days.add(_ItineraryDay(
            dayNumber:  d['day'] as int,
            morning:    d['morning'] as String,
            lunch:      d['lunch'] as String,
            afternoon:  d['afternoon'] as String,
            evening:    d['evening'] as String,
            hotel:      d['hotel'] as String,
            budgetDay:  (_totalBudget / _days).round(),
            tip:        d['tip'] as String? ?? '',
          ));
        }

        if (mounted) {
          setState(() {
            _generating    = false;
            _generated     = true;
            _itineraryDays = days;
          });
          _resultCtrl.reset();
          _resultCtrl.forward();
        }

      } else {
        throw Exception('API error ${response.statusCode}: ${response.body}');
      }

    } catch (e) {
      if (mounted) {
        setState(() => _generating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),   // ← shows the REAL error now
            backgroundColor: LuxTheme.terracotta,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 8), // long enough to read it
          ),
        );
      }
    }
  }

  // ── Export PDF ─────────────────────────────────────────────
  Future<void> _exportPdf() async {
    final bold    = await PdfGoogleFonts.poppinsBold();
    final regular = await PdfGoogleFonts.poppinsRegular();
    final pdf     = pw.Document();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      build: (_) => [
        pw.Text('PlanGo DZ — Luxury Itinerary', style: pw.TextStyle(font: bold, fontSize: 24, color: PdfColors.brown800)),
        pw.SizedBox(height: 4),
        pw.Text('${_wilaya!.name}  •  $_days days  •  ${NumberFormat('#,##0').format(_totalBudget)} DZD',
            style: pw.TextStyle(font: regular, fontSize: 12, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Text('Generated: ${DateFormat('dd MMMM yyyy').format(DateTime.now())}',
            style: pw.TextStyle(font: regular, fontSize: 10, color: PdfColors.grey)),
        pw.Divider(color: PdfColors.brown200),
        pw.SizedBox(height: 12),
        ..._itineraryDays.map((day) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('DAY ${day.dayNumber}', style: pw.TextStyle(font: bold, fontSize: 14, color: PdfColors.brown800)),
            pw.SizedBox(height: 6),
            pw.Text('☀  Morning:   ${day.morning}',    style: pw.TextStyle(font: regular, fontSize: 11)),
            pw.Text('🍽  Lunch:     ${day.lunch}',     style: pw.TextStyle(font: regular, fontSize: 11)),
            pw.Text('🗺  Afternoon: ${day.afternoon}', style: pw.TextStyle(font: regular, fontSize: 11)),
            pw.Text('🌙  Evening:   ${day.evening}',   style: pw.TextStyle(font: regular, fontSize: 11)),
            pw.Text('🏨  Hotel:     ${day.hotel}',     style: pw.TextStyle(font: regular, fontSize: 11)),
            if (day.tip.isNotEmpty)
              pw.Text('💡  Tip:       ${day.tip}',     style: pw.TextStyle(font: regular, fontSize: 11)),
            pw.SizedBox(height: 14),
          ],
        )),
        pw.Divider(color: PdfColors.brown200),
        pw.SizedBox(height: 8),
        pw.Text('Tips & Reminders', style: pw.TextStyle(font: bold, fontSize: 13, color: PdfColors.brown800)),
        pw.SizedBox(height: 6),
        pw.Text('• Transport: Taxi or rental car recommended.',                                                                   style: pw.TextStyle(font: regular, fontSize: 11)),
        pw.Text('• Currency: Carry cash for local markets.',                                                                      style: pw.TextStyle(font: regular, fontSize: 11)),
        pw.Text('• Best time: ${_wilaya!.categories.contains('Beach') ? 'Jun–Sep' : 'Mar–May / Sep–Nov'}',                       style: pw.TextStyle(font: regular, fontSize: 11)),
        pw.SizedBox(height: 20),
        pw.Center(child: pw.Text('PlanGo DZ — Your Luxury Travel Companion', style: pw.TextStyle(font: regular, fontSize: 10, color: PdfColors.grey))),
      ],
    ));

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'plango_${_wilaya!.name}_itinerary.pdf');
  }

  void _share() {
    final sb = StringBuffer();
    sb.writeln('✦ My Trip to ${_wilaya!.name} ($_days days)');
    sb.writeln('Budget: ${NumberFormat('#,##0').format(_totalBudget)} DZD\n');
    for (final d in _itineraryDays) {
      sb.writeln('Day ${d.dayNumber}:');
      sb.writeln('  ☀ ${d.morning}');
      sb.writeln('  🍽 ${d.lunch}');
      sb.writeln('  🗺 ${d.afternoon}');
      sb.writeln('  🌙 ${d.evening}');
      if (d.tip.isNotEmpty) sb.writeln('  💡 Tip: ${d.tip}');
      sb.writeln();
    }
    sb.writeln('Generated with PlanGo DZ');
    Share.share(sb.toString(), subject: 'My Trip to ${_wilaya!.name}');
  }

  // ══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: Column(children: [
        _buildAppBar(),
        _buildProgressBar(),
        Expanded(
          child: _generated
              ? _buildResult()
              : PageView(
                  controller: _pageCtrl,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep0(),
                    _buildStep1(),
                    _buildStep2(),
                    _buildStep3(),
                    _buildStep4(),
                  ],
                ),
        ),
        if (!_generated && !_generating) _buildBottomBar(),
      ]),
    );
  }

  // ── App Bar ───────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: LuxTheme.cream,
      child: SafeArea(
        bottom: false,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              PressScale(
                onTap: () {
                  if (_generated) {
                    setState(() { _generated = false; _currentStep = 4; _goToStep(4); });
                  } else if (_currentStep > 0) {
                    _goToStep(_currentStep - 1);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: LuxTheme.sand, borderRadius: LuxTheme.radius10),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: LuxTheme.mocha),
                ),
              ),
              const Expanded(child: Center(
                child: Text('AI Planner', style: TextStyle(fontFamily: 'Georgia', fontSize: 20, fontWeight: FontWeight.w700, color: LuxTheme.espresso)),
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]), borderRadius: LuxTheme.radiusPill),
                child: const Text('AI', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1)),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  // ── Progress bar ──────────────────────────────────────────
  Widget _buildProgressBar() {
    return Container(
      color: LuxTheme.cream,
      child: Column(children: [
        Container(height: 1, decoration: const BoxDecoration(gradient: LuxTheme.goldGrad)),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_totalSteps, (i) => _StepDot(index: i, current: _currentStep, done: _generated)),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: LuxTheme.radiusPill,
              child: AnimatedBuilder(
                animation: _progressAnim,
                builder: (_, __) => LinearProgressIndicator(
                  value: _generated ? 1.0 : (_totalSteps <= 1 ? 0 : _currentStep / (_totalSteps - 1)),
                  minHeight: 4,
                  backgroundColor: LuxTheme.sandDark,
                  valueColor: const AlwaysStoppedAnimation<Color>(LuxTheme.gold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(_generated ? 'Your itinerary is ready ✦' : _stepLabel(_currentStep),
                  style: LuxTheme.caption.copyWith(color: LuxTheme.mocha)),
              Text(_generated ? '$_days days · ${NumberFormat('#,##0').format(_totalBudget)} DZD' : 'Step ${_currentStep + 1} of $_totalSteps',
                  style: LuxTheme.caption),
            ]),
          ]),
        ),
      ]),
    );
  }

  String _stepLabel(int step) {
    const labels = ['Experience type', 'Destination', 'Activities', 'Duration', 'Budget'];
    return step < labels.length ? labels[step] : '';
  }

  // ── Bottom bar ────────────────────────────────────────────
  Widget _buildBottomBar() {
    final isLast = _currentStep == _totalSteps - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      decoration: BoxDecoration(
        color: LuxTheme.cream,
        border: Border(top: BorderSide(color: LuxTheme.sandDark)),
        boxShadow: [BoxShadow(color: LuxTheme.espresso.withOpacity(0.07), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: Row(children: [
        if (_currentStep > 0) ...[
          PressScale(
            onTap: () => _goToStep(_currentStep - 1),
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: LuxTheme.sand,
                borderRadius: LuxTheme.radius14,
                border: Border.all(color: LuxTheme.sandDark),
              ),
              child: const Row(children: [
                Icon(Icons.arrow_back_rounded, size: 18, color: LuxTheme.mocha),
                SizedBox(width: 6),
                Text('Back', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: LuxTheme.mocha)),
              ]),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: isLast
              ? LuxButton(label: 'Generate Itinerary', icon: Icons.auto_awesome_rounded, onTap: _canAdvance ? _generate : null)
              : PressScale(
                  onTap: _canAdvance ? () => _goToStep(_currentStep + 1) : () {},
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: _canAdvance ? const LinearGradient(colors: [LuxTheme.terracotta, LuxTheme.terracottaL]) : null,
                      color: _canAdvance ? null : LuxTheme.sandDark,
                      borderRadius: LuxTheme.radius14,
                      boxShadow: _canAdvance ? LuxTheme.terrShadow : [],
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Continue', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _canAdvance ? Colors.white : LuxTheme.latte)),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18, color: _canAdvance ? Colors.white : LuxTheme.latte),
                    ]),
                  ),
                ),
        ),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  STEP PAGES
  // ══════════════════════════════════════════════════════════

  Widget _stepWrapper(Widget child) => FadeTransition(
    opacity: _stepFade,
    child: SlideTransition(
      position: _stepSlide,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: child,
      ),
    ),
  );

  // ── Step 0 : Category ─────────────────────────────────────
  Widget _buildStep0() => _stepWrapper(Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GoldBadge(label: 'STEP 1 OF 5'),
      const SizedBox(height: 14),
      const Text('What kind of\nexperience?', style: LuxTheme.displayMd),
      const SizedBox(height: 8),
      Text('Choose the type of trip that calls to you.', style: LuxTheme.body),
      const SizedBox(height: 32),
      ...List.generate(_cats.length, (i) {
        final cat = _cats[i];
        final selected = _category == cat;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: PressScale(
            onTap: () => setState(() => _category = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: selected ? LuxTheme.terracotta : LuxTheme.cream,
                borderRadius: LuxTheme.radius20,
                border: Border.all(color: selected ? LuxTheme.terracottaL : LuxTheme.sandDark, width: selected ? 0 : 1.2),
                boxShadow: selected ? LuxTheme.terrShadow : LuxTheme.cardShadow,
              ),
              child: Row(children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: selected ? Colors.white.withOpacity(0.2) : LuxTheme.sand,
                    borderRadius: LuxTheme.radius14,
                  ),
                  child: Icon(_catIcons[cat]!, size: 26, color: selected ? Colors.white : LuxTheme.terracotta),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(cat, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: selected ? Colors.white : LuxTheme.espresso)),
                  const SizedBox(height: 3),
                  Text(_catDesc[cat]!, style: TextStyle(fontSize: 13, color: selected ? Colors.white70 : LuxTheme.latte)),
                ])),
                Icon(selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                    color: selected ? Colors.white : LuxTheme.sandDark, size: 22),
              ]),
            ),
          ),
        );
      }),
    ],
  ));

  // ── Step 1 : Wilaya ───────────────────────────────────────
  Widget _buildStep1() {
    _wilayas = allWilayas.where((w) => w.categories.contains(_category)).toList();
    return _stepWrapper(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GoldBadge(label: 'STEP 2 OF 5'),
        const SizedBox(height: 14),
        const Text('Choose your\ndestination', style: LuxTheme.displayMd),
        const SizedBox(height: 8),
        Text('Select the wilaya you want to explore.', style: LuxTheme.body),
        const SizedBox(height: 28),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.88),
          itemCount: _wilayas.length,
          itemBuilder: (_, i) {
            final w   = _wilayas[i];
            final sel = _wilaya == w;
            return PressScale(
              onTap: () => setState(() => _wilaya = w),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: LuxTheme.cream,
                  borderRadius: LuxTheme.radius20,
                  border: Border.all(color: sel ? LuxTheme.gold : Colors.transparent, width: 2.2),
                  boxShadow: sel ? LuxTheme.goldShadow : LuxTheme.cardShadow,
                ),
                child: Stack(children: [
                  ClipRRect(
                    borderRadius: LuxTheme.radius20,
                    child: Image.asset(w.imagePath, width: double.infinity, height: double.infinity, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: const BoxDecoration(gradient: LuxTheme.terracottaGrad, borderRadius: LuxTheme.radius20),
                        child: const Icon(Icons.landscape_rounded, color: Colors.white38, size: 48),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: LuxTheme.radius20,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(gradient: LuxTheme.heroOverlay),
                      position: DecorationPosition.foreground,
                    ),
                  ),
                  Positioned(left: 12, right: 12, bottom: 12, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(w.name, style: const TextStyle(fontFamily: 'Georgia', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      if (sel) ...[
                        const SizedBox(height: 4),
                        const Row(children: [
                          Icon(Icons.check_circle_rounded, color: LuxTheme.gold, size: 14),
                          SizedBox(width: 4),
                          Text('Selected', style: TextStyle(color: LuxTheme.gold, fontSize: 11, fontWeight: FontWeight.w700)),
                        ]),
                      ],
                    ],
                  )),
                ]),
              ),
            );
          },
        ),
      ],
    ));
  }

  // ── Step 2 : Activities ───────────────────────────────────
  Widget _buildStep2() {
    final acts = _wilaya?.activities ?? [];
    return _stepWrapper(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GoldBadge(label: 'STEP 3 OF 5'),
        const SizedBox(height: 14),
        const Text('Preferred\nactivities', style: LuxTheme.displayMd),
        const SizedBox(height: 8),
        Text('Pick what excites you. Skip to include everything.', style: LuxTheme.body),
        const SizedBox(height: 28),
        const GoldDivider(label: 'AVAILABLE ACTIVITIES'),
        const SizedBox(height: 20),
        ...acts.map((act) {
          final sel = _activities.contains(act);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PressScale(
              onTap: () => setState(() => sel ? _activities.remove(act) : _activities.add(act)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: sel ? LuxTheme.gold.withOpacity(0.08) : LuxTheme.cream,
                  borderRadius: LuxTheme.radius14,
                  border: Border.all(color: sel ? LuxTheme.gold : LuxTheme.sandDark, width: sel ? 1.5 : 1),
                  boxShadow: LuxTheme.cardShadow,
                ),
                child: Row(children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: sel ? LuxTheme.gold : LuxTheme.sand,
                      borderRadius: LuxTheme.radius10,
                    ),
                    child: Icon(sel ? Icons.check_rounded : Icons.add_rounded, color: sel ? Colors.white : LuxTheme.latte, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Text(act, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: sel ? LuxTheme.espresso : LuxTheme.mocha))),
                ]),
              ),
            ),
          );
        }),
        if (acts.isEmpty)
          Center(child: Padding(
            padding: const EdgeInsets.all(40),
            child: Text('Select a destination first', style: LuxTheme.body),
          )),
        if (_activities.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]), borderRadius: LuxTheme.radius14),
            child: Row(children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Text('${_activities.length} activit${_activities.length == 1 ? 'y' : 'ies'} selected',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
            ]),
          ),
        ],
      ],
    ));
  }

  // ── Step 3 : Duration ─────────────────────────────────────
  Widget _buildStep3() => _stepWrapper(Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GoldBadge(label: 'STEP 4 OF 5'),
      const SizedBox(height: 14),
      const Text('How long is\nyour stay?', style: LuxTheme.displayMd),
      const SizedBox(height: 8),
      Text('Choose the number of nights for your trip.', style: LuxTheme.body),
      const SizedBox(height: 48),
      Center(child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _BigRoundBtn(icon: Icons.remove_rounded, onTap: () { if (_days > 1) setState(() => _days--); }),
          const SizedBox(width: 36),
          Column(children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Text('$_days', key: ValueKey(_days),
                  style: const TextStyle(fontFamily: 'Georgia', fontSize: 72, fontWeight: FontWeight.w700, color: LuxTheme.espresso, height: 1)),
            ),
            Text(_days == 1 ? 'day' : 'days', style: LuxTheme.caption.copyWith(fontSize: 14)),
          ]),
          const SizedBox(width: 36),
          _BigRoundBtn(icon: Icons.add_rounded, onTap: () { if (_days < 21) setState(() => _days++); }, filled: true),
        ]),
        const SizedBox(height: 48),
        const GoldDivider(label: 'QUICK SELECT'),
        const SizedBox(height: 20),
        Wrap(spacing: 10, runSpacing: 10, children: [3, 5, 7, 10, 14].map((d) {
          final sel = _days == d;
          return PressScale(
            onTap: () => setState(() => _days = d),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              decoration: BoxDecoration(
                gradient: sel ? const LinearGradient(colors: [LuxTheme.terracotta, LuxTheme.terracottaL]) : null,
                color: sel ? null : LuxTheme.cream,
                borderRadius: LuxTheme.radiusPill,
                border: Border.all(color: sel ? Colors.transparent : LuxTheme.sandDark),
                boxShadow: sel ? LuxTheme.terrShadow : LuxTheme.cardShadow,
              ),
              child: Text('$d ${d == 1 ? 'day' : 'days'}',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: sel ? Colors.white : LuxTheme.mocha)),
            ),
          );
        }).toList()),
      ])),
    ],
  ));

  // ── Step 4 : Budget ───────────────────────────────────────
  Widget _buildStep4() {
    final est = _wilaya != null ? (_wilaya!.defaultPricePerDay * _days).round() : 0;
    final budgets = [
      {'key': 'budget',  'label': 'Budget',    'sub': 'Essential & affordable',  'icon': Icons.savings_rounded,  'mult': 0.7},
      {'key': 'mid',     'label': 'Mid-range', 'sub': 'Comfort & good value',    'icon': Icons.hotel_rounded,    'mult': 1.2},
      {'key': 'luxury',  'label': 'Luxury',    'sub': 'Premium experiences',     'icon': Icons.diamond_rounded,  'mult': 2.0},
      {'key': 'custom',  'label': 'Custom',    'sub': 'Enter your own amount',   'icon': Icons.edit_rounded,     'mult': 1.0},
    ];
    return _stepWrapper(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GoldBadge(label: 'STEP 5 OF 5'),
        const SizedBox(height: 14),
        const Text('Budget\npreference', style: LuxTheme.displayMd),
        const SizedBox(height: 8),
        Text('We\'ll tailor recommendations to your budget.', style: LuxTheme.body),
        const SizedBox(height: 28),
        ...budgets.map((b) {
          final key    = b['key'] as String;
          final mult   = b['mult'] as double;
          final sel    = _budgetMode == key;
          final amount = key == 'custom' ? _customBudget : (est * mult).round();
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PressScale(
              onTap: () => setState(() => _budgetMode = key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: sel ? LuxTheme.terracotta : LuxTheme.cream,
                  borderRadius: LuxTheme.radius20,
                  border: Border.all(color: sel ? Colors.transparent : LuxTheme.sandDark, width: 1.2),
                  boxShadow: sel ? LuxTheme.terrShadow : LuxTheme.cardShadow,
                ),
                child: Row(children: [
                  Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      color: sel ? Colors.white.withOpacity(0.2) : LuxTheme.sand,
                      borderRadius: LuxTheme.radius12,
                    ),
                    child: Icon(b['icon'] as IconData, size: 22, color: sel ? Colors.white : LuxTheme.terracotta),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(b['label'] as String, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: sel ? Colors.white : LuxTheme.espresso)),
                    Text(b['sub'] as String, style: TextStyle(fontSize: 12, color: sel ? Colors.white70 : LuxTheme.latte)),
                  ])),
                  if (key != 'custom') ...[
                    Text('~${NumberFormat('#,##0').format(amount)} DZD',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: sel ? Colors.white : LuxTheme.gold)),
                  ],
                  const SizedBox(width: 8),
                  Icon(sel ? Icons.check_circle_rounded : Icons.circle_outlined,
                      color: sel ? Colors.white : LuxTheme.sandDark, size: 20),
                ]),
              ),
            ),
          );
        }),
        if (_budgetMode == 'custom') ...[
          const SizedBox(height: 8),
          LuxTextField(
            hint: 'Enter total budget (DZD)',
            prefixIcon: Icons.account_balance_wallet_rounded,
            controller: _budgetCtrl,
            keyboardType: TextInputType.number,
            onChanged: (v) => setState(() => _customBudget = int.tryParse(v) ?? 50000),
          ),
        ],
      ],
    ));
  }

  // ══════════════════════════════════════════════════════════
  //  RESULT VIEW
  // ══════════════════════════════════════════════════════════
  Widget _buildResult() {
    return SingleChildScrollView(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
      child: _generating
          ? _buildGeneratingState()
          : FadeTransition(opacity: _resultFade, child: SlideTransition(position: _resultSlide, child: _buildItineraryView())),
    );
  }

  Widget _buildGeneratingState() {
    return SizedBox(
      height: 400,
      child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.92, end: 1.08),
          duration: const Duration(milliseconds: 800),
          builder: (_, v, child) => Transform.scale(scale: v, child: child),
          child: Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]),
              shape: BoxShape.circle,
              boxShadow: LuxTheme.goldShadow,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 36),
          ),
        ),
        const SizedBox(height: 28),
        Text(_typingText.isEmpty ? ' ' : _typingText,
            style: LuxTheme.titleMd.copyWith(color: LuxTheme.mocha), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('Analysing $_category preferences…', style: LuxTheme.caption),
        const SizedBox(height: 32),
        SizedBox(width: 180, child: ClipRRect(
          borderRadius: LuxTheme.radiusPill,
          child: const LinearProgressIndicator(
            minHeight: 4,
            backgroundColor: LuxTheme.sandDark,
            valueColor: AlwaysStoppedAnimation<Color>(LuxTheme.gold),
          ),
        )),
      ])),
    );
  }

  Widget _buildItineraryView() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Stack(children: [
        SizedBox(height: 220, width: double.infinity,
          child: Image.asset(_wilaya!.imagePath, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(height: 220, decoration: const BoxDecoration(gradient: LuxTheme.terracottaGrad)),
          ),
        ),
        Container(height: 220, decoration: const BoxDecoration(gradient: LuxTheme.heroOverlay)),
        Positioned(left: 24, right: 24, bottom: 24, child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GoldBadge(label: 'YOUR ITINERARY'),
            const SizedBox(height: 10),
            Text(_wilaya!.name, style: const TextStyle(fontFamily: 'Georgia', fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 10),
            Row(children: [
              _SummaryChip(icon: Icons.calendar_today_rounded, label: '$_days ${_days == 1 ? 'day' : 'days'}'),
              const SizedBox(width: 10),
              _SummaryChip(icon: Icons.account_balance_wallet_rounded, label: '${NumberFormat('#,##0').format(_totalBudget)} DZD'),
              const SizedBox(width: 10),
              _SummaryChip(icon: Icons.star_rounded, label: _budgetMode == 'luxury' ? 'Luxury' : (_budgetMode == 'budget' ? 'Budget' : 'Mid')),
            ]),
          ],
        )),
        Positioned(top: 16, right: 16, child: Row(children: [
          _HeroActionBtn(icon: Icons.picture_as_pdf_rounded, onTap: _exportPdf),
          const SizedBox(width: 8),
          _HeroActionBtn(icon: Icons.share_rounded, onTap: _share),
        ])),
      ]),
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const GoldDivider(label: 'DAY BY DAY'),
          const SizedBox(height: 24),
          ..._itineraryDays.map((day) => _DayCard(day: day, totalDays: _days)),
          const SizedBox(height: 28),
          const GoldDivider(label: 'TRAVEL TIPS'),
          const SizedBox(height: 20),
          _TipCard(icon: Icons.directions_car_rounded, title: 'Transport',  body: 'Taxi or rental car is recommended for maximum flexibility.'),
          const SizedBox(height: 10),
          _TipCard(icon: Icons.thermostat_rounded,     title: 'Weather',    body: _wilaya!.categories.contains('Beach') ? 'Best visited Jun–Sep for warm beaches.' : 'Spring (Mar–May) and autumn (Sep–Nov) offer ideal conditions.'),
          const SizedBox(height: 10),
          _TipCard(icon: Icons.payments_rounded,       title: 'Currency',   body: 'Carry cash — many local shops and markets are cash-only.'),
          const SizedBox(height: 10),
          _TipCard(icon: Icons.restaurant_rounded,     title: 'Local Food', body: 'Must-try: ${_wilaya!.activities.take(2).join(' · ')}'),
          const SizedBox(height: 32),
          SizedBox(width: double.infinity, child: LuxButton(
            label: 'Plan Another Trip',
            icon: Icons.refresh_rounded,
            outlined: true,
            onTap: () => setState(() { _generated = false; _currentStep = 0; _goToStep(0); }),
          )),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: LuxButton(
            label: 'Export as PDF',
            icon: Icons.picture_as_pdf_rounded,
            onTap: _exportPdf,
          )),
        ]),
      ),
    ]);
  }
}

// ══════════════════════════════════════════════════════════════
//  SUB-WIDGETS
// ══════════════════════════════════════════════════════════════

class _StepDot extends StatelessWidget {
  final int index, current;
  final bool done;
  const _StepDot({required this.index, required this.current, required this.done});
  @override
  Widget build(BuildContext context) {
    final active   = index == current && !done;
    final complete = index < current || done;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: active ? 28 : 10,
      height: 10,
      decoration: BoxDecoration(
        gradient: complete || active ? const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]) : null,
        color: complete || active ? null : LuxTheme.sandDark,
        borderRadius: LuxTheme.radiusPill,
      ),
    );
  }
}

class _BigRoundBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _BigRoundBtn({required this.icon, required this.onTap, this.filled = false});
  @override
  State<_BigRoundBtn> createState() => _BigRoundBtnState();
}
class _BigRoundBtnState extends State<_BigRoundBtn> with SingleTickerProviderStateMixin {
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
        width: 56, height: 56,
        decoration: BoxDecoration(
          gradient: widget.filled ? const LinearGradient(colors: [LuxTheme.terracotta, LuxTheme.terracottaL]) : null,
          color: widget.filled ? null : LuxTheme.cream,
          shape: BoxShape.circle,
          border: Border.all(color: widget.filled ? Colors.transparent : LuxTheme.sandDark),
          boxShadow: widget.filled ? LuxTheme.terrShadow : LuxTheme.cardShadow,
        ),
        child: Icon(widget.icon, size: 24, color: widget.filled ? Colors.white : LuxTheme.terracotta),
      ),
    ),
  );
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SummaryChip({required this.icon, required this.label});
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

class _HeroActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeroActionBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => PressScale(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
  );
}

class _DayCard extends StatefulWidget {
  final _ItineraryDay day;
  final int totalDays;
  const _DayCard({required this.day, required this.totalDays});
  @override
  State<_DayCard> createState() => _DayCardState();
}
class _DayCardState extends State<_DayCard> {
  bool _expanded = true;
  @override
  Widget build(BuildContext context) {
    final d = widget.day;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(color: LuxTheme.cream, borderRadius: LuxTheme.radius20, boxShadow: LuxTheme.cardShadow),
        child: Column(children: [
          PressScale(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [LuxTheme.terracotta, LuxTheme.terracottaL]),
                    borderRadius: LuxTheme.radius12,
                  ),
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
          if (_expanded) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(height: 1, decoration: const BoxDecoration(gradient: LuxTheme.goldGrad)),
          ),
          if (_expanded) Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(children: [
              _TimeSlot(icon: Icons.wb_sunny_rounded,    color: LuxTheme.gold,           label: 'Morning',   value: d.morning),
              _TimeSlot(icon: Icons.restaurant_rounded,  color: LuxTheme.terracotta,     label: 'Lunch',     value: d.lunch),
              _TimeSlot(icon: Icons.explore_rounded,     color: const Color(0xFF2E86AB), label: 'Afternoon', value: d.afternoon),
              _TimeSlot(icon: Icons.nightlight_round,    color: LuxTheme.mocha,          label: 'Evening',   value: d.evening),
              _TimeSlot(icon: Icons.bed_rounded,         color: LuxTheme.latte,          label: 'Hotel',     value: d.hotel),
              if (d.tip.isNotEmpty)
                _TimeSlot(icon: Icons.lightbulb_rounded, color: LuxTheme.gold,           label: 'Tip',       value: d.tip, isLast: true),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _TimeSlot extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, value;
  final bool isLast;
  const _TimeSlot({required this.icon, required this.color, required this.label, required this.value, this.isLast = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: LuxTheme.radius10),
        child: Icon(icon, size: 16, color: color),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: LuxTheme.caption),
        const SizedBox(height: 2),
        Text(value, style: LuxTheme.body.copyWith(color: LuxTheme.espresso, fontSize: 13, height: 1.4)),
      ])),
    ]),
  );
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title, body;
  const _TipCard({required this.icon, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: LuxTheme.cream, borderRadius: LuxTheme.radius14, boxShadow: LuxTheme.cardShadow),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 38, height: 38,
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]), borderRadius: LuxTheme.radius10),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: LuxTheme.titleMd),
        const SizedBox(height: 3),
        Text(body, style: LuxTheme.body.copyWith(fontSize: 13)),
      ])),
    ]),
  );
}

// ── Data model ────────────────────────────────────────────────
class _ItineraryDay {
  final int dayNumber, budgetDay;
  final String morning, lunch, afternoon, evening, hotel, tip;
  const _ItineraryDay({
    required this.dayNumber,
    required this.morning,
    required this.lunch,
    required this.afternoon,
    required this.evening,
    required this.hotel,
    required this.budgetDay,
    this.tip = '',
  });
}