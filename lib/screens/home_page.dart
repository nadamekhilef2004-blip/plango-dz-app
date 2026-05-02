import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/luxury_theme.dart';
import 'ai_trip_planner.dart';
import 'manual_trip_planner.dart';
import 'wilaya_detail_page.dart';
import 'favorites_page.dart';
import 'login_page.dart';

// ═══════════════════════════════════════════════════════════════
//  HOME PAGE  —  Luxury Edition
// ═══════════════════════════════════════════════════════════════
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  late final AnimationController _entranceCtrl;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>>  _slideAnims;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All',      'icon': Icons.apps_rounded,         'color': LuxTheme.mocha},
    {'name': 'Beach',    'icon': Icons.beach_access_rounded, 'color': Color(0xFF2E86AB)},
    {'name': 'Mountain', 'icon': Icons.terrain_rounded,      'color': Color(0xFF4E7C59)},
    {'name': 'Sahara',   'icon': Icons.wb_sunny_rounded,     'color': LuxTheme.gold},
    {'name': 'Culture',  'icon': Icons.museum_rounded,       'color': LuxTheme.terracotta},
  ];

  final List<Map<String, dynamic>> _wilayas = [
    {'name':'Algiers',    'image':'assets/images/wilayas/alger.jpg',       'color':0xFF6C7D76,'description':'The white capital, blending modernity and history.','attractions':['Casbah',"Notre-Dame d'Afrique","Jardin d'Essai"],'bestTime':'March–May / Sep–Nov','famousFood':'Couscous, Merguez, Baklawa','coordinates':{'lat':36.7538,'lng':3.0588},'categories':['Beach','Culture'],'rating':4.9,'reviews':312},
    {'name':'Oran',       'image':'assets/images/wilayas/oran.jpg',        'color':0xFF91A8B0,'description':'The joyful city, famous for Raï music and Fort Santa Cruz.','attractions':['Fort Santa Cruz','Le Château Neuf','Les Andalouses'],'bestTime':'Apr–Jun / Sep–Oct','famousFood':'Bouchée à la reine, El Kebab','coordinates':{'lat':35.6973,'lng':-0.6336},'categories':['Beach','Culture'],'rating':4.8,'reviews':254},
    {'name':'Constantine','image':'assets/images/wilayas/constantine.jpg', 'color':0xFFA39C7C,'description':'City of suspended bridges, perched on dramatic cliffs.','attractions':["Sidi M'Cid Bridge",'Ahmed Bey Palace','Rhumel Gorges'],'bestTime':'May–Sep','famousFood':'Chakhchoukha, Merguez','coordinates':{'lat':36.3650,'lng':6.6147},'categories':['Culture'],'rating':4.9,'reviews':198},
    {'name':'Annaba',     'image':'assets/images/wilayas/annaba.jpg',      'color':0xFFC1D3C6,'description':'Coastal city with beautiful beaches and Hippo Regius.','attractions':['Basilica of St Augustine','Hippo Regius',"Sable d'Or Beach"],'bestTime':'Jun–Sep','famousFood':'Grilled fish, Couscous','coordinates':{'lat':36.9028,'lng':7.7558},'categories':['Beach','Culture'],'rating':4.7,'reviews':176},
    {'name':'Tlemcen',    'image':'assets/images/wilayas/tlemcen.jpg',     'color':0xFF6C7D76,'description':'Pearl of Islamic art and magnificent architecture.','attractions':['Sidi Boumediene Mosque','Mansourah','El Mechouar Palace'],'bestTime':'Mar–May / Sep–Nov','famousFood':'Couscous, Mhadjeb, Zlabia','coordinates':{'lat':34.8828,'lng':-1.3167},'categories':['Culture'],'rating':4.8,'reviews':221},
    {'name':'Ghardaïa',  'image':'assets/images/wilayas/ghardaia.jpg',    'color':0xFFD4A853,'description':"Heart of the M'zab valley, a UNESCO World Heritage site.",'attractions':["M'zab Valley",'Ghardaïa Mosque','Traditional Market'],'bestTime':'Oct–Apr','famousFood':'Couscous, Dates, Mahjouba','coordinates':{'lat':32.4833,'lng':3.6667},'categories':['Sahara','Culture'],'rating':4.9,'reviews':289},
    {'name':'Béjaïa',   'image':'assets/images/wilayas/bejaia.jpg',      'color':0xFF6C7D76,'description':'Gulf of Kings with Gouraya National Park.','attractions':['Gouraya National Park','Cap Carbon','Pic des Singes'],'bestTime':'May–Oct','famousFood':'Merguez, Grilled sardines','coordinates':{'lat':36.7500,'lng':5.0833},'categories':['Beach','Mountain'],'rating':4.7,'reviews':203},
    {'name':'Tamanrasset','image':'assets/images/wilayas/tamanrasset.jpg', 'color':0xFFD4A853,'description':'Gateway to the Hoggar, lunar landscapes and silence.','attractions':['Hoggar','Assekrem',"Tassili n'Ajjer"],'bestTime':'Oct–Mar','famousFood':'Couscous, Tuareg tea','coordinates':{'lat':22.7850,'lng':5.5228},'categories':['Sahara','Mountain'],'rating':5.0,'reviews':341},
    {'name':'Tipaza',     'image':'assets/images/wilayas/tipaza.jpg',      'color':0xFFC1D3C6,'description':'Famous for UNESCO Roman ruins by the sea.','attractions':['Roman Ruins','Tombeau de la Chrétienne','Chenoua Beach'],'bestTime':'Mar–May / Sep–Nov','famousFood':'Fresh fish, Couscous','coordinates':{'lat':36.5897,'lng':2.4500},'categories':['Beach','Culture'],'rating':4.8,'reviews':187},
    {'name':'Biskra',     'image':'assets/images/wilayas/biskra.jpg',      'color':0xFFD4A853,'description':'Queen of the Zibans, gateway to the Sahara.','attractions':['Palm grove','Tassili National Park','Hammam Salah'],'bestTime':'Oct–Apr','famousFood':'Dates, Vegetable couscous','coordinates':{'lat':34.8500,'lng':5.7333},'categories':['Sahara'],'rating':4.6,'reviews':165},
  ];

  List<Map<String, dynamic>> get _filtered {
    var list = _wilayas;
    if (_selectedCategory != 'All') list = list.where((w) => (w['categories'] as List).contains(_selectedCategory)).toList();
    if (_searchQuery.isNotEmpty) list = list.where((w) => (w['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    return list;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
    _entranceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnims = List.generate(4, (i) {
      final start = i * 0.15;
      final end   = (start + 0.55).clamp(0.0, 1.0);
      return CurvedAnimation(parent: _entranceCtrl, curve: Interval(start, end, curve: Curves.easeOut));
    });
    _slideAnims = List.generate(4, (i) {
      final start = i * 0.15;
      final end   = (start + 0.55).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
          .animate(CurvedAnimation(parent: _entranceCtrl, curve: Interval(start, end, curve: Curves.easeOut)));
    });
    _entranceCtrl.forward();
  }

  @override
  void dispose() { _entranceCtrl.dispose(); super.dispose(); }

  void _switchCategory(String cat) {
    setState(() => _selectedCategory = cat);
    _entranceCtrl.reset();
    _entranceCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: _selectedIndex == 0 ? _home() : _other(),
      bottomNavigationBar: _navBar(),
    );
  }

  // ── MAIN HOME ────────────────────────────────────────────────
  Widget _home() {
    return CustomScrollView(
      slivers: [
        // ── Sticky App Bar ──
        SliverAppBar(
          pinned: true,
          expandedHeight: 0,
          backgroundColor: LuxTheme.sand,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: FadeSlideIn(fade: _fadeAnims[0], slide: _slideAnims[0],
            child: Row(children: [
              RichText(text: const TextSpan(children: [
                TextSpan(text: 'Plan', style: TextStyle(fontFamily: 'Georgia', fontSize: 22, fontWeight: FontWeight.w700, color: LuxTheme.espresso)),
                TextSpan(text: 'Go', style: TextStyle(fontFamily: 'Georgia', fontSize: 22, fontWeight: FontWeight.w700, color: LuxTheme.terracotta)),
                TextSpan(text: ' DZ', style: TextStyle(fontFamily: 'Georgia', fontSize: 22, fontWeight: FontWeight.w700, color: LuxTheme.gold)),
              ])),
            ]),
          ),
          actions: [
            FadeSlideIn(fade: _fadeAnims[0], slide: _slideAnims[0],
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: PressScale(
                  onTap: () {},
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: LuxTheme.cream,
                      borderRadius: LuxTheme.radius10,
                      boxShadow: LuxTheme.cardShadow,
                    ),
                    child: const Icon(Icons.notifications_none_rounded, color: LuxTheme.mocha, size: 22),
                  ),
                ),
              ),
            ),
          ],
        ),

        // ── Hero greeting ──
        SliverToBoxAdapter(
          child: FadeSlideIn(fade: _fadeAnims[0], slide: _slideAnims[0],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Discover', style: LuxTheme.displayLg),
                Row(children: [
                  const Text('Algeria', style: LuxTheme.displayLg),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]), borderRadius: LuxTheme.radiusPill),
                    child: const Text('✦ LUXURY', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.4)),
                  ),
                ]),
                const SizedBox(height: 6),
                Text('Curated journeys across 48 wilayas', style: LuxTheme.body),
              ]),
            ),
          ),
        ),

        // ── Search bar ──
        SliverToBoxAdapter(
          child: FadeSlideIn(fade: _fadeAnims[1], slide: _slideAnims[1],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: LuxTheme.cream,
                  borderRadius: LuxTheme.radius14,
                  boxShadow: LuxTheme.cardShadow,
                  border: Border.all(color: LuxTheme.sandDark, width: 1),
                ),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: LuxTheme.titleMd.copyWith(color: LuxTheme.espresso, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: 'Search destinations…',
                        hintStyle: LuxTheme.body.copyWith(color: LuxTheme.latte, height: 1),
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.search_rounded, color: LuxTheme.latte, size: 21),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  PressScale(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]),
                        borderRadius: LuxTheme.radius10,
                        boxShadow: LuxTheme.goldShadow,
                      ),
                      child: const Icon(Icons.tune_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),

        // ── Category label ──
        SliverToBoxAdapter(
          child: FadeSlideIn(fade: _fadeAnims[1], slide: _slideAnims[1],
            child: const Padding(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 14),
              child: GoldDivider(label: 'EXPLORE BY TYPE'),
            ),
          ),
        ),

        // ── Categories ──
        SliverToBoxAdapter(
          child: FadeSlideIn(fade: _fadeAnims[1], slide: _slideAnims[1],
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (_, i) => _CategoryPill(_categories[i], _selectedCategory == _categories[i]['name'], () => _switchCategory(_categories[i]['name'])),
              ),
            ),
          ),
        ),

        // ── Featured label ──
        SliverToBoxAdapter(
          child: FadeSlideIn(fade: _fadeAnims[2], slide: _slideAnims[2],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Featured Destinations', style: LuxTheme.titleLg),
                Text('See all', style: TextStyle(fontSize: 13, color: LuxTheme.terracotta, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ),

        // ── Destination cards (horizontal scroll) ──
        SliverToBoxAdapter(
          child: SizedBox(
            height: 280,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _DestCard(
                wilaya: _filtered[i],
                index: i,
                parentCtrl: _entranceCtrl,
              ),
            ),
          ),
        ),

        // ── Spacer ──
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }

  // ── OTHER SCREENS ────────────────────────────────────────────
  Widget _other() {
    switch (_selectedIndex) {
      case 1: return const _PlanScreen();
      case 2: return const _MyTripsScreen();
      case 3: return const FavoritesPage();
      case 4: return const _ProfileScreen();
      default: return _home();
    }
  }

  // ── BOTTOM NAV ───────────────────────────────────────────────
  Widget _navBar() {
    return Container(
      decoration: BoxDecoration(
        color: LuxTheme.cream,
        border: Border(top: BorderSide(color: LuxTheme.sandDark, width: 1)),
        boxShadow: [BoxShadow(color: LuxTheme.espresso.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded,            label: 'Home',      index: 0, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
              _NavItem(icon: Icons.calendar_today_rounded,  label: 'Plan',      index: 1, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
              _NavItem(icon: Icons.luggage_rounded,         label: 'My Trips',  index: 2, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
              _NavItem(icon: Icons.favorite_rounded,        label: 'Saved',     index: 3, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
              _NavItem(icon: Icons.person_rounded,          label: 'Profile',   index: 4, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Nav Item ─────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index, selected;
  final ValueChanged<int> onTap;
  const _NavItem({required this.icon, required this.label, required this.index, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final active = index == selected;
    return PressScale(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? LuxTheme.terracotta.withOpacity(0.1) : Colors.transparent,
          borderRadius: LuxTheme.radiusPill,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 22, color: active ? LuxTheme.terracotta : LuxTheme.latte),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: active ? LuxTheme.terracotta : LuxTheme.latte)),
        ]),
      ),
    );
  }
}

// ── Category Pill ─────────────────────────────────────────────────────────────
class _CategoryPill extends StatefulWidget {
  final Map<String, dynamic> cat;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryPill(this.cat, this.selected, this.onTap);
  @override
  State<_CategoryPill> createState() => _CategoryPillState();
}
class _CategoryPillState extends State<_CategoryPill> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _s = Tween<double>(begin: 1.0, end: 0.90).animate(_c);
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final Color col = widget.cat['color'] as Color;
    return GestureDetector(
      onTapDown: (_) => _c.forward(),
      onTapCancel: () => _c.reverse(),
      onTap: () { _c.reverse(); widget.onTap(); },
      child: ScaleTransition(
        scale: _s,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 230),
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: widget.selected ? col : LuxTheme.cream,
            borderRadius: LuxTheme.radiusPill,
            border: Border.all(color: widget.selected ? col : LuxTheme.sandDark, width: 1.2),
            boxShadow: widget.selected ? [BoxShadow(color: col.withOpacity(0.30), blurRadius: 10, offset: const Offset(0, 3))] : LuxTheme.cardShadow,
          ),
          child: Row(children: [
            Icon(widget.cat['icon'] as IconData, size: 16, color: widget.selected ? Colors.white : LuxTheme.latte),
            const SizedBox(width: 7),
            Text(widget.cat['name'] as String, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: widget.selected ? Colors.white : LuxTheme.mocha)),
          ]),
        ),
      ),
    );
  }
}

// ── Destination Card ──────────────────────────────────────────────────────────
class _DestCard extends StatefulWidget {
  final Map<String, dynamic> wilaya;
  final int index;
  final AnimationController parentCtrl;
  const _DestCard({required this.wilaya, required this.index, required this.parentCtrl});
  @override
  State<_DestCard> createState() => _DestCardState();
}
class _DestCardState extends State<_DestCard> with SingleTickerProviderStateMixin {
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final AnimationController _tap;
  late final Animation<double> _tapScale;

  @override
  void initState() {
    super.initState();
    final start = (0.3 + widget.index * 0.07).clamp(0.0, 0.85);
    final end   = (start + 0.4).clamp(0.0, 1.0);
    final curve = Interval(start, end, curve: Curves.easeOut);
    _fade  = CurvedAnimation(parent: widget.parentCtrl, curve: curve);
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: widget.parentCtrl, curve: curve));
    _tap      = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _tapScale = Tween<double>(begin: 1.0, end: 0.94).animate(_tap);
  }

  @override void dispose() { _tap.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final w = widget.wilaya;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTapDown: (_) => _tap.forward(),
          onTapCancel: () => _tap.reverse(),
          onTap: () {
            _tap.reverse();
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (_, __, ___) => WilayaDetailPage(
                name: w['name'], icon: Icons.location_on_rounded,
                color: Color(w['color'] as int), imagePath: w['image'],
                description: w['description'], attractions: List<String>.from(w['attractions']),
                bestTime: w['bestTime'], famousFood: w['famousFood'],
              ),
              transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
              transitionDuration: const Duration(milliseconds: 300),
            ));
          },
          child: ScaleTransition(
            scale: _tapScale,
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(right: 16, bottom: 6),
              decoration: BoxDecoration(
                color: LuxTheme.cream,
                borderRadius: LuxTheme.radius20,
                boxShadow: LuxTheme.cardShadow,
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Image
                Stack(children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(w['image'], height: 170, width: double.infinity, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(height: 170,
                        decoration: BoxDecoration(gradient: LuxTheme.terracottaGrad, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                        child: const Center(child: Icon(Icons.landscape_rounded, size: 52, color: Colors.white54)),
                      ),
                    ),
                  ),
                  // Hero overlay gradient
                  Positioned.fill(child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: const DecoratedBox(decoration: BoxDecoration(gradient: LuxTheme.heroOverlay)),
                  )),
                  // Category badge top-left
                  Positioned(top: 12, left: 12, child: GoldBadge(label: (w['categories'] as List).first)),
                  // Maps icon top-right
                  Positioned(top: 10, right: 10,
                    child: PressScale(
                      scale: 0.88,
                      onTap: () async {
                        final lat = w['coordinates']['lat'];
                        final lng = w['coordinates']['lng'];
                        final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                        if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.92), shape: BoxShape.circle, boxShadow: LuxTheme.cardShadow),
                        child: const Icon(Icons.navigation_rounded, size: 15, color: LuxTheme.terracotta),
                      ),
                    ),
                  ),
                  // Title at bottom of image
                  Positioned(bottom: 10, left: 12, right: 12,
                    child: Text(w['name'], style: const TextStyle(fontFamily: 'Georgia', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ]),
                // Info row
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    StarRating(rating: (w['rating'] as num).toDouble(), reviews: w['reviews'] as int),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: LuxTheme.sand, borderRadius: LuxTheme.radius10),
                      child: Text(w['bestTime'].toString().split('/').first.trim(), style: LuxTheme.caption.copyWith(fontSize: 10)),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Plan Screen ───────────────────────────────────────────────────────────────
class _PlanScreen extends StatelessWidget {
  const _PlanScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LuxTheme.sand,
    body: SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Plan Your Trip', style: LuxTheme.displayMd),
        const SizedBox(height: 6),
        Text('Choose your planning style', style: LuxTheme.body),
        const SizedBox(height: 28),
        const GoldDivider(label: 'SELECT METHOD'),
        const SizedBox(height: 24),
        _PlanOption(
          icon: Icons.auto_awesome_rounded,
          title: 'AI Planner',
          subtitle: 'Let our AI craft a tailored itinerary for you',
          badge: 'RECOMMENDED',
          color: LuxTheme.terracotta,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AITripPlannerPage())),
        ),
        const SizedBox(height: 16),
        _PlanOption(
          icon: Icons.edit_calendar_rounded,
          title: 'Manual Planner',
          subtitle: 'Build your own itinerary day by day',
          color: LuxTheme.gold,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManualTripPlannerPage())),
        ),
      ]),
    )),
  );
}

class _PlanOption extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final String? badge;
  final Color color;
  final VoidCallback onTap;
  const _PlanOption({required this.icon, required this.title, required this.subtitle, this.badge, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => PressScale(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: LuxTheme.cream, borderRadius: LuxTheme.radius20, boxShadow: LuxTheme.cardShadow,
        border: Border.all(color: color.withOpacity(0.2), width: 1.2)),
      child: Row(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: LuxTheme.radius14),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(title, style: LuxTheme.titleMd.copyWith(color: color)),
            if (badge != null) ...[const SizedBox(width: 8), GoldBadge(label: badge!)],
          ]),
          const SizedBox(height: 4),
          Text(subtitle, style: LuxTheme.body.copyWith(fontSize: 12, height: 1.4)),
        ])),
        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color.withOpacity(0.5)),
      ]),
    ),
  );
}

// ── My Trips Screen ───────────────────────────────────────────────────────────
class _MyTripsScreen extends StatelessWidget {
  const _MyTripsScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LuxTheme.sand,
    body: SafeArea(child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('My Journeys', style: LuxTheme.displayMd),
        const SizedBox(height: 6),
        Text('Your saved itineraries', style: LuxTheme.body),
        const SizedBox(height: 24),
        const GoldDivider(),
        Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [LuxTheme.sandDark, LuxTheme.sand]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.luggage_rounded, size: 42, color: LuxTheme.latte),
          ),
          const SizedBox(height: 20),
          const Text('No journeys yet', style: LuxTheme.titleMd),
          const SizedBox(height: 8),
          Text('Start planning your first trip', style: LuxTheme.body),
          const SizedBox(height: 28),
          SizedBox(width: 220, child: LuxButton(
            label: 'Plan a Trip',
            icon: Icons.add_rounded,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AITripPlannerPage())),
          )),
        ]))),
      ]),
    )),
  );
}

// ── Profile Screen ────────────────────────────────────────────────────────────
class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LuxTheme.sand,
    body: SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const SizedBox(height: 20),
        // Avatar
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [LuxTheme.gold, LuxTheme.terracotta]),
            boxShadow: LuxTheme.terrShadow,
          ),
          child: const Icon(Icons.person_rounded, size: 52, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text('Welcome, Traveller', style: LuxTheme.displayMd),
        const SizedBox(height: 6),
        Text('Sign in to unlock your full experience', style: LuxTheme.body),
        const SizedBox(height: 32),
        const GoldDivider(label: 'YOUR ACCOUNT'),
        const SizedBox(height: 28),
        SizedBox(width: double.infinity, child: LuxButton(
          label: 'Sign In',
          icon: Icons.login_rounded,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
        )),
        const SizedBox(height: 14),
        SizedBox(width: double.infinity, child: LuxButton(
          label: 'Create Account',
          outlined: true,
          onTap: () {},
        )),
        const SizedBox(height: 40),
        // Stats row
        Row(children: [
          _StatBox(value: '0', label: 'Trips'),
          const SizedBox(width: 12),
          _StatBox(value: '0', label: 'Saved'),
          const SizedBox(width: 12),
          _StatBox(value: '0', label: 'Reviews'),
        ]),
      ]),
    )),
  );
}

class _StatBox extends StatelessWidget {
  final String value, label;
  const _StatBox({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(color: LuxTheme.cream, borderRadius: LuxTheme.radius14, boxShadow: LuxTheme.cardShadow),
    child: Column(children: [
      Text(value, style: LuxTheme.displayMd.copyWith(fontSize: 28, color: LuxTheme.terracotta)),
      const SizedBox(height: 4),
      Text(label, style: LuxTheme.caption),
    ]),
  ));
}