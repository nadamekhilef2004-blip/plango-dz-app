import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/luxury_theme.dart';
import '../services/trip_storage.dart';
import '../services/auth_service.dart';
import '../data/wilaya_data.dart';

// ═══════════════════════════════════════════════════════════════
//  MANUAL TRIP PLANNER  —  Full-featured with save to My Trips
// ═══════════════════════════════════════════════════════════════
class ManualTripPlannerPage extends StatefulWidget {
  const ManualTripPlannerPage({super.key});
  @override
  State<ManualTripPlannerPage> createState() => _ManualTripPlannerPageState();
}

class _ManualTripPlannerPageState extends State<ManualTripPlannerPage>
    with TickerProviderStateMixin {

  // ── Step tracking ─────────────────────────────────────────
  int _step = 0; // 0=destination, 1=days setup, 2=fill itinerary, 3=budget
  static const int _totalSteps = 4;

  // ── Trip metadata ─────────────────────────────────────────
  WilayaData? _selectedWilaya;
  String _selectedCategory = '';
  int _days = 3;
  String _budgetMode = 'mid';
  int _customBudget = 50000;
  final _budgetCtrl = TextEditingController(text: '50000');

  // ── Day data ──────────────────────────────────────────────
  List<_ManualDay> _manualDays = [];

  // ── UI state ──────────────────────────────────────────────
  bool _saving = false;
  bool _saved  = false;

  // ── Animations ────────────────────────────────────────────
  late final AnimationController _stepCtrl;
  late final Animation<double>   _stepFade;
  late final Animation<Offset>   _stepSlide;

  late final AnimationController _progressCtrl;

  final PageController _pageCtrl = PageController();
  final ScrollController _scrollCtrl = ScrollController();

  // ── Data ─────────────────────────────────────────────────
  final List<String> _categories = ['Beach', 'Mountain', 'Sahara', 'Culture'];
  final Map<String, IconData> _catIcons = {
    'Beach':    Icons.beach_access_rounded,
    'Mountain': Icons.terrain_rounded,
    'Sahara':   Icons.wb_sunny_rounded,
    'Culture':  Icons.museum_rounded,
  };

  List<WilayaData> get _filteredWilayas => _selectedCategory.isEmpty
      ? allWilayas
      : allWilayas.where((w) => w.categories.contains(_selectedCategory)).toList();

  @override
  void initState() {
    super.initState();

    _stepCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _stepFade  = CurvedAnimation(parent: _stepCtrl, curve: Curves.easeOut);
    _stepSlide = Tween<Offset>(
        begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _stepCtrl, curve: Curves.easeOut));

    _progressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));

    _stepCtrl.forward();
  }

  @override
  void dispose() {
    _stepCtrl.dispose();
    _progressCtrl.dispose();
    _pageCtrl.dispose();
    _budgetCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Navigation ────────────────────────────────────────────
  void _goTo(int step) {
    if (step < 0 || step >= _totalSteps) return;

    // When entering itinerary step, build day list
    if (step == 2 && _manualDays.isEmpty) {
      _manualDays = List.generate(
          _days, (i) => _ManualDay(dayNumber: i + 1));
    }
    // When changing days count, rebuild list preserving existing data
    if (step == 2 && _manualDays.length != _days) {
      final old = List<_ManualDay>.from(_manualDays);
      _manualDays = List.generate(_days, (i) {
        if (i < old.length) return old[i];
        return _ManualDay(dayNumber: i + 1);
      });
    }

    setState(() => _step = step);
    _stepCtrl.reset();
    _stepCtrl.forward();
    _progressCtrl.animateTo(step / (_totalSteps - 1));

    if (_pageCtrl.hasClients) {
      _pageCtrl.animateToPage(step,
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeInOut);
    }
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut);
    }
  }

  bool get _canAdvance {
    switch (_step) {
      case 0: return _selectedWilaya != null;
      case 1: return _days >= 1;
      case 2: return true; // partial fill is fine
      case 3: return true;
      default: return false;
    }
  }

  // ── Save ──────────────────────────────────────────────────
  Future<void> _saveTrip() async {
    if (_selectedWilaya == null) return;
    if (!AuthService.instance.isLoggedIn) {
      _showLoginRequired();
      return;
    }

    setState(() => _saving = true);
    HapticFeedback.lightImpact();

    final perDay = _computeTotalBudget() ~/ _days;

    final itinerary = _manualDays.map((d) => SavedTripDay(
      dayNumber:  d.dayNumber,
      morning:    d.morning.text.isEmpty    ? 'Free exploration' : d.morning.text,
      lunch:      d.lunch.text.isEmpty      ? 'Local restaurant' : d.lunch.text,
      afternoon:  d.afternoon.text.isEmpty  ? 'Sightseeing'      : d.afternoon.text,
      evening:    d.evening.text.isEmpty    ? 'Dinner & rest'    : d.evening.text,
      hotel:      d.hotel.text.isEmpty      ? 'TBD'              : d.hotel.text,
      budgetDay:  perDay,
    )).toList();

    final ok = await TripStorageService.instance.save(
      wilayaName:  _selectedWilaya!.name,
      wilayaImage: _selectedWilaya!.imagePath,
      category:    _selectedCategory.isEmpty
          ? (_selectedWilaya!.categories.isNotEmpty
          ? _selectedWilaya!.categories.first
          : 'Culture')
          : _selectedCategory,
      days:        _days,
      totalBudget: _computeTotalBudget(),
      budgetMode:  _budgetMode,
      itinerary:   itinerary,
    );

    if (mounted) {
      setState(() { _saving = false; _saved = ok; });
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          ok ? '✓  Trip saved to My Journeys!' : 'Could not save — please try again.',
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: ok ? LuxTheme.gold : LuxTheme.terracotta,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: LuxTheme.radius10),
        margin: const EdgeInsets.all(16),
      ));
    }
  }

  int _computeTotalBudget() {
    if (_budgetMode == 'custom') return _customBudget;
    final base = (_selectedWilaya?.defaultPricePerDay ?? 7000) * _days;
    final mult = _budgetMode == 'budget' ? 0.7 : (_budgetMode == 'luxury' ? 2.0 : 1.2);
    return (base * mult).round();
  }

  void _showLoginRequired() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
            color: LuxTheme.cream, borderRadius: LuxTheme.radius20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [LuxTheme.gold, LuxTheme.goldLight]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_outline_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(height: 16),
          const Text('Sign in required', style: LuxTheme.titleLg),
          const SizedBox(height: 8),
          Text('You need to be signed in to save trips.',
              style: LuxTheme.body, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: LuxButton(
              label: 'Go to Profile',
              icon: Icons.person_rounded,
              onTap: () { Navigator.pop(context); Navigator.pop(context); },
            ),
          ),
        ]),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: Column(children: [
        _buildAppBar(),
        _buildProgressBar(),
        Expanded(
          child: PageView(
            controller: _pageCtrl,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStep0(),  // destination
              _buildStep1(),  // duration
              _buildStep2(),  // itinerary
              _buildStep3(),  // budget + save
            ],
          ),
        ),
        _buildBottomBar(),
      ]),
    );
  }

  // ── App Bar ───────────────────────────────────────────────
  Widget _buildAppBar() => Container(
    color: LuxTheme.cream,
    child: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          PressScale(
            onTap: () {
              if (_step > 0) _goTo(_step - 1);
              else Navigator.pop(context);
            },
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                  color: LuxTheme.sand,
                  borderRadius: LuxTheme.radius10),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16, color: LuxTheme.mocha),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Manual Planner',
                  style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: LuxTheme.espresso)),
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: LuxTheme.sand,
              borderRadius: LuxTheme.radiusPill,
              border: Border.all(color: LuxTheme.sandDark),
            ),
            child: const Text('MANUAL',
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: LuxTheme.mocha,
                    letterSpacing: 1.2)),
          ),
        ]),
      ),
    ),
  );

  // ── Progress bar ──────────────────────────────────────────
  Widget _buildProgressBar() => Container(
    color: LuxTheme.cream,
    child: Column(children: [
      Container(
          height: 1,
          decoration:
          const BoxDecoration(gradient: LuxTheme.goldGrad)),
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_totalSteps,
                    (i) => _StepDot(index: i, current: _step)),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: LuxTheme.radiusPill,
            child: LinearProgressIndicator(
              value: _step / (_totalSteps - 1),
              minHeight: 4,
              backgroundColor: LuxTheme.sandDark,
              valueColor:
              const AlwaysStoppedAnimation<Color>(LuxTheme.gold),
            ),
          ),
          const SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_stepLabel(_step),
                    style: LuxTheme.caption
                        .copyWith(color: LuxTheme.mocha)),
                Text('Step ${_step + 1} of $_totalSteps',
                    style: LuxTheme.caption),
              ]),
        ]),
      ),
    ]),
  );

  String _stepLabel(int s) => [
    'Choose destination',
    'Set duration',
    'Plan each day',
    'Budget & save'
  ][s];

  // ── Bottom bar ────────────────────────────────────────────
  Widget _buildBottomBar() {
    final isLast = _step == _totalSteps - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      decoration: BoxDecoration(
        color: LuxTheme.cream,
        border: Border(top: BorderSide(color: LuxTheme.sandDark)),
        boxShadow: [
          BoxShadow(
              color: LuxTheme.espresso.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, -4))
        ],
      ),
      child: Row(children: [
        if (_step > 0) ...[
          PressScale(
            onTap: () => _goTo(_step - 1),
            child: Container(
              height: 54,
              padding:
              const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: LuxTheme.sand,
                borderRadius: LuxTheme.radius14,
                border: Border.all(color: LuxTheme.sandDark),
              ),
              child: const Row(children: [
                Icon(Icons.arrow_back_rounded,
                    size: 18, color: LuxTheme.mocha),
                SizedBox(width: 6),
                Text('Back',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: LuxTheme.mocha)),
              ]),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: isLast
              ? LuxButton(
            label: _saved ? 'Saved ✓' : 'Save to My Trips',
            icon: _saved
                ? Icons.check_circle_rounded
                : Icons.bookmark_add_rounded,
            isLoading: _saving,
            onTap: _saved ? null : _saveTrip,
          )
              : PressScale(
            onTap: _canAdvance ? () => _goTo(_step + 1) : () {},
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 54,
              decoration: BoxDecoration(
                gradient: _canAdvance
                    ? const LinearGradient(colors: [
                  LuxTheme.terracotta,
                  LuxTheme.terracottaL
                ])
                    : null,
                color: _canAdvance ? null : LuxTheme.sandDark,
                borderRadius: LuxTheme.radius14,
                boxShadow: _canAdvance
                    ? LuxTheme.terrShadow
                    : [],
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _canAdvance
                                ? Colors.white
                                : LuxTheme.latte)),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded,
                        size: 18,
                        color: _canAdvance
                            ? Colors.white
                            : LuxTheme.latte),
                  ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _stepWrapper(Widget child) => FadeTransition(
    opacity: _stepFade,
    child: SlideTransition(
      position: _stepSlide,
      child: SingleChildScrollView(
        controller: _scrollCtrl,
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: child,
      ),
    ),
  );

  // ══════════════════════════════════════════════════════════
  //  STEP 0 — Destination
  // ══════════════════════════════════════════════════════════
  Widget _buildStep0() => _stepWrapper(Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GoldBadge(label: 'STEP 1 OF 4'),
      const SizedBox(height: 14),
      const Text('Where are\nyou going?', style: LuxTheme.displayMd),
      const SizedBox(height: 8),
      Text('Choose a category then pick your destination.',
          style: LuxTheme.body),
      const SizedBox(height: 24),

      // Category filter
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: 'All',
              selected: _selectedCategory.isEmpty,
              onTap: () => setState(() => _selectedCategory = ''),
            ),
            ...List.generate(_categories.length, (i) => _FilterChip(
              label: _categories[i],
              icon: _catIcons[_categories[i]],
              selected: _selectedCategory == _categories[i],
              onTap: () => setState(
                      () => _selectedCategory = _categories[i]),
            )),
          ],
        ),
      ),

      const SizedBox(height: 24),
      const GoldDivider(label: 'SELECT DESTINATION'),
      const SizedBox(height: 20),

      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: _filteredWilayas.length,
        itemBuilder: (_, i) {
          final w = _filteredWilayas[i];
          final sel = _selectedWilaya == w;
          return PressScale(
            onTap: () => setState(() => _selectedWilaya = w),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: LuxTheme.radius20,
                border: Border.all(
                  color:
                  sel ? LuxTheme.gold : Colors.transparent,
                  width: 2.2,
                ),
                boxShadow: sel
                    ? LuxTheme.goldShadow
                    : LuxTheme.cardShadow,
              ),
              child: ClipRRect(
                borderRadius: LuxTheme.radius20,
                child: Stack(children: [
                  Image.asset(w.imagePath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: const BoxDecoration(
                            gradient:
                            LuxTheme.terracottaGrad),
                      )),
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LuxTheme.heroOverlay),
                    ),
                  ),
                  Positioned(
                    left: 10, right: 10, bottom: 10,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(w.name,
                            style: const TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        if (sel) ...[
                          const SizedBox(height: 4),
                          const Row(children: [
                            Icon(
                                Icons.check_circle_rounded,
                                color: LuxTheme.gold,
                                size: 13),
                            SizedBox(width: 4),
                            Text('Selected',
                                style: TextStyle(
                                    color: LuxTheme.gold,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w700)),
                          ]),
                        ],
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    ],
  ));

  // ══════════════════════════════════════════════════════════
  //  STEP 1 — Duration
  // ══════════════════════════════════════════════════════════
  Widget _buildStep1() => _stepWrapper(Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GoldBadge(label: 'STEP 2 OF 4'),
      const SizedBox(height: 14),
      const Text('How long is\nyour trip?', style: LuxTheme.displayMd),
      const SizedBox(height: 8),
      Text('Set the number of days to plan.',
          style: LuxTheme.body),
      const SizedBox(height: 48),

      Center(child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _RoundBtn(
            icon: Icons.remove_rounded,
            onTap: () { if (_days > 1) setState(() => _days--); },
          ),
          const SizedBox(width: 36),
          Column(children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Text('$_days',
                  key: ValueKey(_days),
                  style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 72,
                      fontWeight: FontWeight.w700,
                      color: LuxTheme.espresso,
                      height: 1)),
            ),
            Text(_days == 1 ? 'day' : 'days',
                style: LuxTheme.caption.copyWith(fontSize: 14)),
          ]),
          const SizedBox(width: 36),
          _RoundBtn(
            icon: Icons.add_rounded,
            filled: true,
            onTap: () { if (_days < 21) setState(() => _days++); },
          ),
        ]),

        const SizedBox(height: 48),
        const GoldDivider(label: 'QUICK SELECT'),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [2, 3, 5, 7, 10, 14].map((d) {
            final sel = _days == d;
            return PressScale(
              onTap: () => setState(() => _days = d),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 22, vertical: 12),
                decoration: BoxDecoration(
                  gradient: sel
                      ? const LinearGradient(colors: [
                    LuxTheme.terracotta,
                    LuxTheme.terracottaL
                  ])
                      : null,
                  color: sel ? null : LuxTheme.cream,
                  borderRadius: LuxTheme.radiusPill,
                  border: Border.all(
                      color: sel
                          ? Colors.transparent
                          : LuxTheme.sandDark),
                  boxShadow:
                  sel ? LuxTheme.terrShadow : LuxTheme.cardShadow,
                ),
                child: Text(
                  '$d ${d == 1 ? 'day' : 'days'}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: sel ? Colors.white : LuxTheme.mocha,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        if (_selectedWilaya != null) ...[
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: LuxTheme.cream,
              borderRadius: LuxTheme.radius14,
              boxShadow: LuxTheme.cardShadow,
            ),
            child: Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [LuxTheme.gold, LuxTheme.goldLight]),
                  borderRadius: LuxTheme.radius12,
                ),
                child: const Icon(Icons.lightbulb_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Best time to visit',
                        style: LuxTheme.caption),
                    const SizedBox(height: 3),
                    Text(_selectedWilaya!.bestTime,
                        style: LuxTheme.titleMd
                            .copyWith(fontSize: 13)),
                  ])),
            ]),
          ),
        ],
      ])),
    ],
  ));

  // ══════════════════════════════════════════════════════════
  //  STEP 2 — Fill Itinerary
  // ══════════════════════════════════════════════════════════
  Widget _buildStep2() => _stepWrapper(Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GoldBadge(label: 'STEP 3 OF 4'),
      const SizedBox(height: 14),
      const Text('Plan each\nday', style: LuxTheme.displayMd),
      const SizedBox(height: 8),
      Text(
          'Fill in what you want to do. Leave blank to auto-fill.',
          style: LuxTheme.body),
      const SizedBox(height: 24),
      const GoldDivider(label: 'YOUR ITINERARY'),
      const SizedBox(height: 20),

      ...List.generate(_manualDays.length, (i) {
        final day = _manualDays[i];
        return _DayEditor(
          day: day,
          suggestions: _selectedWilaya?.activities ?? [],
          isFirst: i == 0,
          isLast:  i == _manualDays.length - 1,
        );
      }),

      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: LuxTheme.gold.withOpacity(0.08),
          borderRadius: LuxTheme.radius14,
          border: Border.all(
              color: LuxTheme.gold.withOpacity(0.3)),
        ),
        child: Row(children: [
          const Icon(Icons.info_outline_rounded,
              color: LuxTheme.gold, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Any empty fields will be filled with sensible defaults when you save.',
              style: LuxTheme.body
                  .copyWith(fontSize: 12, height: 1.4),
            ),
          ),
        ]),
      ),
    ],
  ));

  // ══════════════════════════════════════════════════════════
  //  STEP 3 — Budget & Save
  // ══════════════════════════════════════════════════════════
  Widget _buildStep3() {
    final budgets = [
      {
        'key': 'budget',
        'label': 'Budget',
        'sub': 'Essential & affordable',
        'icon': Icons.savings_rounded,
        'mult': 0.7
      },
      {
        'key': 'mid',
        'label': 'Mid-range',
        'sub': 'Comfort & good value',
        'icon': Icons.hotel_rounded,
        'mult': 1.2
      },
      {
        'key': 'luxury',
        'label': 'Luxury',
        'sub': 'Premium experiences',
        'icon': Icons.diamond_rounded,
        'mult': 2.0
      },
      {
        'key': 'custom',
        'label': 'Custom',
        'sub': 'Enter your own amount',
        'icon': Icons.edit_rounded,
        'mult': 1.0
      },
    ];

    final base = (_selectedWilaya?.defaultPricePerDay ?? 7000) * _days;

    return _stepWrapper(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GoldBadge(label: 'STEP 4 OF 4'),
        const SizedBox(height: 14),
        const Text('Set your\nbudget', style: LuxTheme.displayMd),
        const SizedBox(height: 8),
        Text('Choose a spending level for your trip.',
            style: LuxTheme.body),
        const SizedBox(height: 24),
        const GoldDivider(label: 'BUDGET LEVEL'),
        const SizedBox(height: 20),

        ...budgets.map((b) {
          final key  = b['key'] as String;
          final mult = b['mult'] as double;
          final sel  = _budgetMode == key;
          final amount = key == 'custom'
              ? _customBudget
              : (base * mult).round();

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
                  border: Border.all(
                      color: sel
                          ? Colors.transparent
                          : LuxTheme.sandDark,
                      width: 1.2),
                  boxShadow: sel
                      ? LuxTheme.terrShadow
                      : LuxTheme.cardShadow,
                ),
                child: Row(children: [
                  Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      color: sel
                          ? Colors.white.withOpacity(0.2)
                          : LuxTheme.sand,
                      borderRadius: LuxTheme.radius12,
                    ),
                    child: Icon(b['icon'] as IconData,
                        size: 22,
                        color: sel
                            ? Colors.white
                            : LuxTheme.terracotta),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b['label'] as String,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: sel
                                  ? Colors.white
                                  : LuxTheme.espresso)),
                      Text(b['sub'] as String,
                          style: TextStyle(
                              fontSize: 12,
                              color: sel
                                  ? Colors.white70
                                  : LuxTheme.latte)),
                    ],
                  )),
                  if (key != 'custom') ...[
                    Text(
                      '~${NumberFormat('#,##0').format(amount)} DZD',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: sel
                              ? Colors.white
                              : LuxTheme.gold),
                    ),
                  ],
                  const SizedBox(width: 8),
                  Icon(
                      sel
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: sel ? Colors.white : LuxTheme.sandDark,
                      size: 20),
                ]),
              ),
            ),
          );
        }),

        if (_budgetMode == 'custom') ...[
          const SizedBox(height: 4),
          LuxTextField(
            hint: 'Enter total budget (DZD)',
            prefixIcon: Icons.account_balance_wallet_rounded,
            controller: _budgetCtrl,
            keyboardType: TextInputType.number,
            onChanged: (v) => setState(
                    () => _customBudget = int.tryParse(v) ?? 50000),
          ),
        ],

        const SizedBox(height: 28),
        const GoldDivider(label: 'TRIP SUMMARY'),
        const SizedBox(height: 20),

        // Summary card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: LuxTheme.cream,
            borderRadius: LuxTheme.radius20,
            boxShadow: LuxTheme.cardShadow,
          ),
          child: Column(children: [
            _SummaryRow(
              icon: Icons.location_on_rounded,
              label: 'Destination',
              value: _selectedWilaya?.name ?? '—',
            ),
            const Divider(height: 20, color: LuxTheme.sandDark),
            _SummaryRow(
              icon: Icons.calendar_today_rounded,
              label: 'Duration',
              value: '$_days ${_days == 1 ? 'day' : 'days'}',
            ),
            const Divider(height: 20, color: LuxTheme.sandDark),
            _SummaryRow(
              icon: Icons.account_balance_wallet_rounded,
              label: 'Estimated budget',
              value:
              '${NumberFormat('#,##0').format(_computeTotalBudget())} DZD',
              highlight: true,
            ),
            const Divider(height: 20, color: LuxTheme.sandDark),
            _SummaryRow(
              icon: Icons.wb_sunny_rounded,
              label: 'Best time',
              value: _selectedWilaya?.bestTime ?? '—',
            ),
          ]),
        ),

        const SizedBox(height: 16),

        // Auth warning if not logged in
        if (!AuthService.instance.isLoggedIn) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: LuxTheme.gold.withOpacity(0.08),
              borderRadius: LuxTheme.radius14,
              border: Border.all(
                  color: LuxTheme.gold.withOpacity(0.4)),
            ),
            child: Row(children: [
              const Icon(Icons.lock_outline_rounded,
                  color: LuxTheme.gold, size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sign in to save this trip to My Journeys.',
                  style: LuxTheme.body
                      .copyWith(fontSize: 12, height: 1.4),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
        ],
      ],
    ));
  }
}

// ═══════════════════════════════════════════════════════════════
//  DAY EDITOR WIDGET
// ═══════════════════════════════════════════════════════════════
class _ManualDay {
  final int dayNumber;
  final TextEditingController morning   = TextEditingController();
  final TextEditingController lunch     = TextEditingController();
  final TextEditingController afternoon = TextEditingController();
  final TextEditingController evening   = TextEditingController();
  final TextEditingController hotel     = TextEditingController();

  _ManualDay({required this.dayNumber});

  void dispose() {
    morning.dispose();
    lunch.dispose();
    afternoon.dispose();
    evening.dispose();
    hotel.dispose();
  }
}

class _DayEditor extends StatefulWidget {
  final _ManualDay day;
  final List<String> suggestions;
  final bool isFirst, isLast;
  const _DayEditor({
    required this.day,
    required this.suggestions,
    this.isFirst = false,
    this.isLast  = false,
  });
  @override
  State<_DayEditor> createState() => _DayEditorState();
}

class _DayEditorState extends State<_DayEditor> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final d = widget.day;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: LuxTheme.cream,
        borderRadius: LuxTheme.radius20,
        boxShadow: LuxTheme.cardShadow,
      ),
      child: Column(children: [
        // ── Header ──
        PressScale(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _expanded = !_expanded);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [LuxTheme.terracotta, LuxTheme.terracottaL]),
                  borderRadius: LuxTheme.radius12,
                ),
                child: Center(
                  child: Text('${d.dayNumber}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          fontFamily: 'Georgia')),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Day ${d.dayNumber}', style: LuxTheme.titleMd),
                    Text(
                      widget.isFirst
                          ? 'Arrival day'
                          : widget.isLast
                          ? 'Departure day'
                          : 'Exploration day',
                      style: LuxTheme.caption,
                    ),
                  ])),
              Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: LuxTheme.latte),
            ]),
          ),
        ),

        if (_expanded) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
                height: 1,
                decoration:
                const BoxDecoration(gradient: LuxTheme.goldGrad)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(children: [
              _SlotField(
                icon: Icons.wb_sunny_rounded,
                color: LuxTheme.gold,
                label: 'Morning',
                hint: widget.isFirst
                    ? 'e.g. Arrival & hotel check-in'
                    : 'e.g. Visit the Casbah',
                controller: d.morning,
                suggestions: widget.suggestions
                    .where((s) => s.isNotEmpty)
                    .take(3)
                    .toList(),
              ),
              const SizedBox(height: 12),
              _SlotField(
                icon: Icons.restaurant_rounded,
                color: LuxTheme.terracotta,
                label: 'Lunch',
                hint: 'e.g. Restaurant El Bey — traditional cuisine',
                controller: d.lunch,
              ),
              const SizedBox(height: 12),
              _SlotField(
                icon: Icons.explore_rounded,
                color: const Color(0xFF2E86AB),
                label: 'Afternoon',
                hint: 'e.g. Guided tour of the medina',
                controller: d.afternoon,
                suggestions: widget.suggestions
                    .where((s) => s.isNotEmpty)
                    .skip(3)
                    .take(3)
                    .toList(),
              ),
              const SizedBox(height: 12),
              _SlotField(
                icon: Icons.nightlight_round,
                color: LuxTheme.mocha,
                label: 'Evening',
                hint: widget.isLast
                    ? 'e.g. Farewell dinner & departure'
                    : 'e.g. Sunset at the Corniche',
                controller: d.evening,
              ),
              const SizedBox(height: 12),
              _SlotField(
                icon: Icons.bed_rounded,
                color: LuxTheme.latte,
                label: 'Hotel',
                hint: 'e.g. Hôtel El Aurassi ★★★★★',
                controller: d.hotel,
              ),
            ]),
          ),
        ],
      ]),
    );
  }
}

// ── Slot field with optional quick-fill chips ─────────────────
class _SlotField extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, hint;
  final TextEditingController controller;
  final List<String> suggestions;

  const _SlotField({
    required this.icon,
    required this.color,
    required this.label,
    required this.hint,
    required this.controller,
    this.suggestions = const [],
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: LuxTheme.radius10),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 8),
        Text(label, style: LuxTheme.caption),
      ]),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: LuxTheme.espresso),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
          const TextStyle(color: LuxTheme.latte, fontSize: 12),
          filled: true,
          fillColor: LuxTheme.sand,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: LuxTheme.radius10,
            borderSide:
            const BorderSide(color: LuxTheme.sandDark, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: LuxTheme.radius10,
            borderSide:
            const BorderSide(color: LuxTheme.gold, width: 1.6),
          ),
        ),
      ),
      if (suggestions.isNotEmpty) ...[
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: suggestions.map((s) {
              // Shorten long suggestions for the chip
              final short = s.length > 30 ? '${s.substring(0, 28)}…' : s;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => controller.text = s,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: LuxTheme.radiusPill,
                      border: Border.all(
                          color: color.withOpacity(0.25)),
                    ),
                    child: Text(short,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: color)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ],
  );
}

// ═══════════════════════════════════════════════════════════════
//  SHARED UTILITY WIDGETS
// ═══════════════════════════════════════════════════════════════

class _StepDot extends StatelessWidget {
  final int index, current;
  const _StepDot({required this.index, required this.current});
  @override
  Widget build(BuildContext context) {
    final active   = index == current;
    final complete = index < current;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: active ? 28 : 10,
      height: 10,
      decoration: BoxDecoration(
        gradient: complete || active
            ? const LinearGradient(
            colors: [LuxTheme.gold, LuxTheme.goldLight])
            : null,
        color: complete || active ? null : LuxTheme.sandDark,
        borderRadius: LuxTheme.radiusPill,
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _RoundBtn(
      {required this.icon,
        required this.onTap,
        this.filled = false});
  @override
  Widget build(BuildContext context) => PressScale(
    onTap: onTap,
    child: Container(
      width: 56, height: 56,
      decoration: BoxDecoration(
        gradient: filled
            ? const LinearGradient(
            colors: [LuxTheme.terracotta, LuxTheme.terracottaL])
            : null,
        color: filled ? null : LuxTheme.cream,
        shape: BoxShape.circle,
        border: Border.all(
            color:
            filled ? Colors.transparent : LuxTheme.sandDark),
        boxShadow:
        filled ? LuxTheme.terrShadow : LuxTheme.cardShadow,
      ),
      child: Icon(icon,
          size: 24,
          color: filled ? Colors.white : LuxTheme.terracotta),
    ),
  );
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label,
        this.icon,
        required this.selected,
        required this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: PressScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
              colors: [LuxTheme.terracotta, LuxTheme.terracottaL])
              : null,
          color: selected ? null : LuxTheme.cream,
          borderRadius: LuxTheme.radiusPill,
          border: Border.all(
              color:
              selected ? Colors.transparent : LuxTheme.sandDark),
          boxShadow:
          selected ? LuxTheme.terrShadow : LuxTheme.cardShadow,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon,
                size: 14,
                color: selected ? Colors.white : LuxTheme.latte),
            const SizedBox(width: 6),
          ],
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color:
                  selected ? Colors.white : LuxTheme.mocha)),
        ]),
      ),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final bool highlight;
  const _SummaryRow(
      {required this.icon,
        required this.label,
        required this.value,
        this.highlight = false});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      width: 34, height: 34,
      decoration: BoxDecoration(
          color: LuxTheme.sand,
          borderRadius: LuxTheme.radius10),
      child: Icon(icon, size: 16, color: LuxTheme.terracotta),
    ),
    const SizedBox(width: 12),
    Expanded(
        child: Text(label,
            style: LuxTheme.caption.copyWith(fontSize: 12))),
    Text(value,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: highlight ? LuxTheme.terracotta : LuxTheme.espresso)),
  ]);
}