// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/luxury_theme.dart';
import 'ai_trip_planner.dart';
import 'wilaya_detail_page.dart';
import 'manual_trip_planner.dart';
import 'favorites_page.dart';
import 'login_page.dart';
import 'trip_planner_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  late final AnimationController _pageCtrl;
  late final List<Animation<double>>  _fades;
  late final List<Animation<Offset>>  _slides;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All',      'icon': Icons.apps_rounded,         'color': LuxTheme.mocha},
    {'name': 'Beach',    'icon': Icons.beach_access_rounded, 'color': Color(0xFF2E86AB)},
    {'name': 'Mountain', 'icon': Icons.terrain_rounded,      'color': Color(0xFF4A7C59)},
    {'name': 'Sahara',   'icon': Icons.wb_sunny_rounded,     'color': LuxTheme.gold},
    {'name': 'Culture',  'icon': Icons.museum_rounded,       'color': LuxTheme.terracotta},
  ];

  final List<Map<String, dynamic>> _wilayas = [
    {'name': 'Algiers',     'color': 0xFF6C7D76, 'image': 'assets/images/wilayas/alger.jpg',       'description': 'The white capital, blending modernity and history.',                         'attractions': ['Casbah', "Notre-Dame d'Afrique", "Jardin d'Essai"],                  'bestTime': 'March–May / Sep–Nov',  'famousFood': 'Couscous, Merguez, Baklawa',    'coordinates': {'lat': 36.7538, 'lng': 3.0588},  'categories': ['Beach', 'Culture'],  'rating': 4.9, 'reviews': 248},
    {'name': 'Oran',        'color': 0xFF91A8B0, 'image': 'assets/images/wilayas/oran.jpg',         'description': 'The joyful city, famous for Raï music and Fort Santa Cruz.',              'attractions': ['Fort Santa Cruz', 'Le Château Neuf', 'Les Andalouses'],               'bestTime': 'Apr–Jun / Sep–Oct',    'famousFood': 'Bouchée à la reine, El Kebab',  'coordinates': {'lat': 35.6973, 'lng': -0.6336}, 'categories': ['Beach', 'Culture'],  'rating': 4.7, 'reviews': 193},
    {'name': 'Constantine', 'color': 0xFFA39C7C, 'image': 'assets/images/wilayas/constantine.jpg',  'description': 'City of suspended bridges, perched on dramatic cliffs.',                  'attractions': ["Sidi M'Cid Bridge", 'Ahmed Bey Palace', 'Rhumel Gorges'],             'bestTime': 'May–Sep',              'famousFood': 'Chakhchoukha, Merguez',         'coordinates': {'lat': 36.3650, 'lng': 6.6147},  'categories': ['Culture'],           'rating': 4.8, 'reviews': 176},
    {'name': 'Annaba',      'color': 0xFF4A7C59, 'image': 'assets/images/wilayas/annaba.jpg',       'description': 'Coastal gem with pristine beaches and the Roman site of Hippo Regius.',   'attractions': ['Basilica of St Augustine', 'Hippo Regius', "Sable d'Or Beach"],       'bestTime': 'Jun–Sep',              'famousFood': 'Grilled fish, Couscous',        'coordinates': {'lat': 36.9028, 'lng': 7.7558},  'categories': ['Beach', 'Culture'],  'rating': 4.6, 'reviews': 142},
    {'name': 'Tlemcen',     'color': 0xFF8B6552, 'image': 'assets/images/wilayas/tlemcen.jpg',      'description': 'Pearl of Islamic art — magnificent mosques and ancient palaces.',         'attractions': ['Sidi Boumediene Mosque', 'Mansourah', 'El Mechouar Palace'],          'bestTime': 'Mar–May / Sep–Nov',    'famousFood': 'Couscous, Mhadjeb, Zlabia',    'coordinates': {'lat': 34.8828, 'lng': -1.3167}, 'categories': ['Culture'],           'rating': 4.8, 'reviews': 215},
    {'name': 'Ghardaïa',   'color': 0xFFC9A84C, 'image': 'assets/images/wilayas/ghardaia.jpg',     'description': "Heart of the M'zab valley, a UNESCO World Heritage masterpiece.",        'attractions': ["M'zab Valley", 'Ghardaïa Mosque', 'Traditional Market'],             'bestTime': 'Oct–Apr',              'famousFood': 'Couscous, Dates, Mahjouba',    'coordinates': {'lat': 32.4833, 'lng': 3.6667},  'categories': ['Sahara', 'Culture'], 'rating': 4.9, 'reviews': 301},
    {'name': 'Tamanrasset', 'color': 0xFFB94020, 'image': 'assets/images/wilayas/tamanrasset.jpg',  'description': 'Gateway to the Hoggar — dramatic lunar landscapes of the deep Sahara.',  'attractions': ['Hoggar Mountains', 'Assekrem', "Tassili n'Ajjer"],                    'bestTime': 'Oct–Mar',              'famousFood': 'Couscous, Tuareg tea',         'coordinates': {'lat': 22.7850, 'lng': 5.5228},  'categories': ['Sahara', 'Mountain'],'rating': 4.9, 'reviews': 389},
    {'name': 'Béjaïa',     'color': 0xFF2E86AB, 'image': 'assets/images/wilayas/bejaia.jpg',       'description': 'Gulf of Kings — turquoise waters and the lush Gouraya National Park.',   'attractions': ['Gouraya National Park', 'Cap Carbon', 'Pic des Singes'],             'bestTime': 'May–Oct',              'famousFood': 'Merguez, Grilled sardines',    'coordinates': {'lat': 36.7500, 'lng': 5.0833},  'categories': ['Beach', 'Mountain'], 'rating': 4.7, 'reviews': 168},
    {'name': 'Tipaza',      'color': 0xFF7B8B6F, 'image': 'assets/images/wilayas/tipaza.jpg',       'description': 'Ancient Roman ruins meet the Mediterranean — a UNESCO treasure.',         'attractions': ['Roman Ruins', 'Tombeau de la Chrétienne', 'Chenoua Beach'],          'bestTime': 'Mar–May / Sep–Nov',    'famousFood': 'Fresh fish, Couscous',         'coordinates': {'lat': 36.5897, 'lng': 2.4500},  'categories': ['Beach', 'Culture'],  'rating': 4.6, 'reviews': 134},
    {'name': 'Biskra',      'color': 0xFFC9A84C, 'image': 'assets/images/wilayas/biskra.jpg',       'description': 'Queen of the Zibans — the enchanting gateway to the Algerian desert.',   'attractions': ['Palm grove', 'Tassili National Park', 'Hammam Salah'],               'bestTime': 'Oct–Apr',              'famousFood': 'Dates, Vegetable couscous',    'coordinates': {'lat': 34.8500, 'lng': 5.7333},  'categories': ['Sahara'],            'rating': 4.5, 'reviews': 112},
  ];

  List<Map<String, dynamic>> get _filtered {
    var list = _wilayas;
    if (_selectedCategory != 'All') list = list.where((w) => (w['categories'] as List).contains(_selectedCategory)).toList();
    if (_searchQuery.isNotEmpty)    list = list.where((w) => (w['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    return list;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
    _pageCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fades  = List.generate(4, (i) => CurvedAnimation(parent: _pageCtrl, curve: Interval(i * 0.12, (i * 0.12 + 0.5).clamp(0, 1), curve: Curves.easeOut)));
    _slides = List.generate(4, (i) => Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(CurvedAnimation(parent: _pageCtrl, curve: Interval(i * 0.12, (i * 0.12 + 0.5).clamp(0, 1), curve: Curves.easeOut))));
    _pageCtrl.forward();
  }

  @override void dispose() { _pageCtrl.dispose(); super.dispose(); }

  void _switchCategory(String cat) {
    setState(() => _selectedCategory = cat);
    _pageCtrl..reset()..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: SafeArea(child: _selectedIndex == 0 ? _home() : _other()),
      bottomNavigationBar: _bottomNav(),
    );
  }

  // ── HOME ────────────────────────────────────────────────
  Widget _home() => CustomScrollView(slivers: [
    // ── Header
    SliverToBoxAdapter(child: FadeTransition(opacity: _fades[0], child: SlideTransition(position: _slides[0], child: _header()))),
    // ── Search
    SliverToBoxAdapter(child: FadeTransition(opacity: _fades[1], child: SlideTransition(position: _slides[1], child: _searchBar()))),
    // ── Categories
    SliverToBoxAdapter(child: FadeTransition(opacity: _fades[2], child: SlideTransition(position: _slides[2], child: _categoriesSection()))),
    // ── Destinations
    SliverToBoxAdapter(child: FadeTransition(opacity: _fades[3], child: SlideTransition(position: _slides[3], child: _destinationsSection()))),
    // ── Featured (full width)
    SliverToBoxAdapter(child: FadeTransition(opacity: _fades[3], child: _featuredSection())),
    const SliverToBoxAdapter(child: SizedBox(height: 32)),
  ]);

  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('PLANGO DZ', style: LuxTheme.goldLabel.copyWith(fontSize: 12, letterSpacing: 2.5)),
        const SizedBox(height: 6),
        Text('Discover\nAlgeria', style: LuxTheme.serif32),
        const SizedBox(height: 6),
        Text('Where do you want to go?', style: LuxTheme.body14),
      ])),
      const SizedBox(width: 16),
      // Notification bell
      Container(
        width: 48, height: 48,
        decoration: BoxDecoration(color: LuxTheme.sandLight, shape: BoxShape.circle, boxShadow: LuxTheme.cardShadow),
        child: const Icon(Icons.notifications_none_rounded, color: LuxTheme.terracotta, size: 22),
      ),
    ]),
  );

  Widget _searchBar() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
    child: Container(
      decoration: BoxDecoration(color: LuxTheme.sandLight, borderRadius: LuxTheme.r14, boxShadow: LuxTheme.cardShadow),
      child: Row(children: [
        Expanded(child: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(fontSize: 14, color: LuxTheme.espresso),
          decoration: InputDecoration(
            hintText: 'Search destinations…',
            hintStyle: TextStyle(color: LuxTheme.latte, fontSize: 14),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search_rounded, color: LuxTheme.gold, size: 22),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        )),
        Padding(padding: const EdgeInsets.only(right: 10), child: _FilterBtn()),
      ]),
    ),
  );

  Widget _categoriesSection() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 28, 0, 0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(right: 24),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Explore by type', style: LuxTheme.serif20),
          Text('See all', style: TextStyle(fontSize: 13, color: LuxTheme.gold, fontWeight: FontWeight.w600)),
        ]),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 88,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(right: 24),
          itemCount: _categories.length,
          itemBuilder: (_, i) => _CategoryPill(cat: _categories[i], isSelected: _selectedCategory == _categories[i]['name'], onTap: () => _switchCategory(_categories[i]['name'])),
        ),
      ),
    ]),
  );

  Widget _destinationsSection() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 28, 0, 0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(right: 24),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Top destinations', style: LuxTheme.serif20),
          Text('${_filtered.length} places', style: LuxTheme.label11),
        ]),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 255,
        child: _filtered.isEmpty
          ? Center(child: Text('No destinations found', style: TextStyle(color: LuxTheme.latte)))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 24),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _DestinationCard(wilaya: _filtered[i], index: i, ctrl: _pageCtrl),
            ),
      ),
    ]),
  );

  Widget _featuredSection() {
    if (_wilayas.isEmpty) return const SizedBox();
    final w = _wilayas.firstWhere((w) => w['name'] == 'Tamanrasset', orElse: () => _wilayas.first);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const GoldDivider(label: 'EDITOR\'S PICK'),
        const SizedBox(height: 20),
        _FeaturedCard(wilaya: w),
      ]),
    );
  }

  Widget _other() {
    switch (_selectedIndex) {
      case 1: return const TripPlannerScreen();
      case 2: return const MyTripsScreen();
      case 3: return const FavoritesPage();
      case 4: return const ProfileScreen();
      default: return _home();
    }
  }

  Widget _bottomNav() => Container(
    decoration: BoxDecoration(color: LuxTheme.sandLight, border: Border(top: BorderSide(color: LuxTheme.sandDark, width: 1))),
    child: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (i) => setState(() => _selectedIndex = i),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: LuxTheme.terracotta,
      unselectedItemColor: LuxTheme.latte,
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10, letterSpacing: 0.3),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded),           label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined),           label: 'Plan'),
        BottomNavigationBarItem(icon: Icon(Icons.luggage_rounded),        label: 'My Trips'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border_rounded),label: 'Saved'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
      ],
    ),
  );
}

// ── Filter Button ────────────────────────────────────────────
class _FilterBtn extends StatefulWidget { @override State<_FilterBtn> createState() => _FilterBtnState(); }
class _FilterBtnState extends State<_FilterBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 100)); _s = Tween(begin: 1.0, end: 0.88).animate(_c); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => _c.forward(), onTapCancel: () => _c.reverse(), onTap: () => _c.reverse(),
    child: ScaleTransition(scale: _s, child: Container(
      width: 44, height: 44,
      decoration: BoxDecoration(gradient: LuxTheme.primaryGrad, borderRadius: LuxTheme.r14, boxShadow: LuxTheme.primaryShadow),
      child: const Icon(Icons.tune_rounded, color: LuxTheme.white, size: 20),
    )),
  );
}

// ── Category Pill ────────────────────────────────────────────
class _CategoryPill extends StatefulWidget {
  final Map<String, dynamic> cat; final bool isSelected; final VoidCallback onTap;
  const _CategoryPill({required this.cat, required this.isSelected, required this.onTap});
  @override State<_CategoryPill> createState() => _CategoryPillState();
}
class _CategoryPillState extends State<_CategoryPill> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 100)); _s = Tween(begin: 1.0, end: 0.90).animate(_c); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final color = widget.cat['color'] as Color;
    return GestureDetector(
      onTapDown: (_) => _c.forward(), onTapCancel: () => _c.reverse(),
      onTap: () { _c.reverse(); widget.onTap(); },
      child: ScaleTransition(scale: _s, child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: widget.isSelected ? color : LuxTheme.sandLight,
          borderRadius: LuxTheme.rPill,
          border: Border.all(color: widget.isSelected ? color : LuxTheme.sandDark, width: 1.5),
          boxShadow: widget.isSelected ? [BoxShadow(color: color.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))] : LuxTheme.cardShadow,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(widget.cat['icon'] as IconData, size: 16, color: widget.isSelected ? LuxTheme.white : color),
          const SizedBox(width: 8),
          Text(widget.cat['name'] as String, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: widget.isSelected ? LuxTheme.white : LuxTheme.espresso)),
        ]),
      )),
    );
  }
}

// ── Destination Card ─────────────────────────────────────────
class _DestinationCard extends StatefulWidget {
  final Map<String, dynamic> wilaya; final int index; final AnimationController ctrl;
  const _DestinationCard({required this.wilaya, required this.index, required this.ctrl});
  @override State<_DestinationCard> createState() => _DestinationCardState();
}
class _DestinationCardState extends State<_DestinationCard> with SingleTickerProviderStateMixin {
  late final Animation<double>  _fade;
  late final Animation<Offset>  _slide;
  late final AnimationController _tap;
  late final Animation<double>   _tapScale;

  @override void initState() {
    super.initState();
    final start = (widget.index * 0.06).clamp(0.0, 0.6);
    final end   = (start + 0.45).clamp(0.0, 1.0);
    final curve = Interval(start, end, curve: Curves.easeOut);
    _fade  = CurvedAnimation(parent: widget.ctrl, curve: curve);
    _slide = Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero).animate(CurvedAnimation(parent: widget.ctrl, curve: curve));
    _tap      = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _tapScale = Tween(begin: 1.0, end: 0.95).animate(_tap);
  }
  @override void dispose() { _tap.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    final w = widget.wilaya;
    return FadeTransition(opacity: _fade, child: SlideTransition(position: _slide, child:
      GestureDetector(
        onTapDown: (_) => _tap.forward(), onTapCancel: () => _tap.reverse(),
        onTap: () {
          _tap.reverse();
          Navigator.push(context, PageRouteBuilder(
            pageBuilder: (_, __, ___) => WilayaDetailPage(
              name: w['name'], icon: Icons.place_rounded,
              color: Color(w['color'] as int),
              imagePath: w['image'], description: w['description'],
              attractions: List<String>.from(w['attractions']),
              bestTime: w['bestTime'], famousFood: w['famousFood'],
            ),
            transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ));
        },
        child: ScaleTransition(scale: _tapScale, child: Container(
          width: 190, margin: const EdgeInsets.only(right: 16, bottom: 4),
          decoration: BoxDecoration(color: LuxTheme.sandLight, borderRadius: LuxTheme.r20, boxShadow: LuxTheme.cardShadow),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(w['image'], height: 160, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 160, color: Color(w['color'] as int).withOpacity(0.3),
                    child: const Center(child: Icon(Icons.landscape_rounded, size: 48, color: LuxTheme.white))),
                )),
              // Gradient overlay
              Positioned.fill(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: DecoratedBox(decoration: const BoxDecoration(gradient: LuxTheme.cardOverlay)))),
              // Rating badge top-left
              Positioned(top: 10, left: 10, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: LuxTheme.sandLight.withOpacity(0.92), borderRadius: LuxTheme.rPill),
                child: StarRating(rating: (w['rating'] as num).toDouble(), reviews: w['reviews'] as int),
              )),
              // Map button top-right
              Positioned(top: 10, right: 10, child: PressScale(onTap: () async {
                final lat = w['coordinates']['lat']; final lng = w['coordinates']['lng'];
                final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              }, child: Container(
                width: 34, height: 34,
                decoration: BoxDecoration(color: LuxTheme.sandLight.withOpacity(0.92), shape: BoxShape.circle),
                child: const Icon(Icons.navigation_rounded, size: 17, color: LuxTheme.terracotta),
              ))),
              // Category badge bottom-left
              Positioned(bottom: 10, left: 10, child: GoldBadge(label: (w['categories'] as List).first.toUpperCase())),
            ]),
            Padding(padding: const EdgeInsets.fromLTRB(14, 12, 14, 14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(w['name'], style: LuxTheme.title16),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on_rounded, size: 12, color: LuxTheme.latte),
                const SizedBox(width: 3),
                Text('Algeria', style: LuxTheme.label11.copyWith(fontSize: 11)),
              ]),
            ])),
          ]),
        )),
      ),
    ));
  }
}

// ── Featured Card ─────────────────────────────────────────────
class _FeaturedCard extends StatelessWidget {
  final Map<String, dynamic> wilaya;
  const _FeaturedCard({required this.wilaya});
  @override Widget build(BuildContext context) {
    final w = wilaya;
    return PressScale(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WilayaDetailPage(
      name: w['name'], icon: Icons.place_rounded, color: Color(w['color'] as int),
      imagePath: w['image'], description: w['description'],
      attractions: List<String>.from(w['attractions']),
      bestTime: w['bestTime'], famousFood: w['famousFood'],
    ))),
    child: Container(
      height: 200,
      decoration: BoxDecoration(borderRadius: LuxTheme.r20, boxShadow: LuxTheme.cardShadow),
      child: ClipRRect(
        borderRadius: LuxTheme.r20,
        child: Stack(children: [
          Image.asset(w['image'], height: 200, width: double.infinity, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(height: 200, color: Color(w['color'] as int).withOpacity(0.4))),
          const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: LuxTheme.heroOverlay))),
          Positioned(bottom: 20, left: 20, right: 20, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('EDITOR\'S PICK', style: LuxTheme.goldLabel),
              const SizedBox(height: 4),
              Text(w['name'], style: const TextStyle(fontFamily: 'Georgia', fontSize: 22, fontWeight: FontWeight.w700, color: LuxTheme.white)),
              const SizedBox(height: 4),
              Text((w['description'] as String).substring(0, 40) + '…', style: const TextStyle(fontSize: 12, color: Colors.white70)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(gradient: LuxTheme.primaryGrad, borderRadius: LuxTheme.rPill),
              child: const Text('Explore', style: TextStyle(color: LuxTheme.white, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ])),
        ]),
      ),
    ));
  }
}

// ═══════════════════════════════════════════════════════════════
//  OTHER SCREENS
// ═══════════════════════════════════════════════════════════════
class TripPlannerScreen extends StatelessWidget {
  const TripPlannerScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    backgroundColor: LuxTheme.sand,
    body: SafeArea(child: SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('PLAN YOUR TRIP', style: LuxTheme.goldLabel.copyWith(letterSpacing: 2.5)),
      const SizedBox(height: 8),
      Text('How would you\nlike to plan?', style: LuxTheme.serif32),
      const SizedBox(height: 8),
      Text('Choose your planning style below.', style: LuxTheme.body14),
      const SizedBox(height: 32),
      _PlanCard(icon: Icons.auto_awesome_rounded, title: 'AI Planner', subtitle: 'Let AI craft a personalised luxury itinerary for you', color: LuxTheme.terracotta, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AITripPlannerPage()))),
      const SizedBox(height: 16),
      _PlanCard(icon: Icons.edit_calendar_rounded, title: 'Manual Planner', subtitle: 'Build your own itinerary step by step', color: LuxTheme.gold, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManualTripPlannerPage()))),
      const SizedBox(height: 32),
      const GoldDivider(label: 'INSPIRED BY'),
      const SizedBox(height: 20),
      _InspirationRow(),
    ])))),
  );
}

class _PlanCard extends StatelessWidget {
  final IconData icon; final String title, subtitle; final Color color; final VoidCallback onTap;
  const _PlanCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});
  @override Widget build(BuildContext context) => PressScale(onTap: onTap, child: Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: LuxTheme.sandLight, borderRadius: LuxTheme.r20, boxShadow: LuxTheme.cardShadow,
      border: Border.all(color: color.withOpacity(0.2), width: 1.2)),
    child: Row(children: [
      Container(width: 52, height: 52, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: LuxTheme.r14),
        child: Icon(icon, color: color, size: 26)),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: LuxTheme.title16.copyWith(color: color)),
        const SizedBox(height: 3),
        Text(subtitle, style: LuxTheme.body14.copyWith(fontSize: 12)),
      ])),
      Icon(Icons.arrow_forward_ios_rounded, size: 15, color: color.withOpacity(0.6)),
    ]),
  ));
}

class _InspirationRow extends StatelessWidget {
  final List<Map<String, dynamic>> items = const [
    {'label': 'Coastal', 'icon': Icons.waves_rounded, 'color': Color(0xFF2E86AB)},
    {'label': 'Desert',  'icon': Icons.wb_sunny_rounded, 'color': LuxTheme.gold},
    {'label': 'History', 'icon': Icons.museum_rounded,   'color': LuxTheme.terracotta},
    {'label': 'Nature',  'icon': Icons.forest_rounded,   'color': Color(0xFF4A7C59)},
  ];
  @override Widget build(BuildContext context) => Row(children: items.map((item) => Expanded(child: Container(
    margin: const EdgeInsets.only(right: 10),
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(color: (item['color'] as Color).withOpacity(0.10), borderRadius: LuxTheme.r14,
      border: Border.all(color: (item['color'] as Color).withOpacity(0.2))),
    child: Column(children: [
      Icon(item['icon'] as IconData, color: item['color'] as Color, size: 22),
      const SizedBox(height: 6),
      Text(item['label'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: LuxTheme.espresso)),
    ]),
  ))).toList());
}

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    backgroundColor: LuxTheme.sand,
    body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('MY JOURNEYS', style: LuxTheme.goldLabel.copyWith(letterSpacing: 2.5)),
      const SizedBox(height: 8),
      Text('Your Trips', style: LuxTheme.serif32),
      const SizedBox(height: 8),
      Text('All your saved itineraries in one place.', style: LuxTheme.body14),
      const SizedBox(height: 40),
      Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 90, height: 90, decoration: BoxDecoration(color: LuxTheme.sandDark, shape: BoxShape.circle),
          child: const Icon(Icons.luggage_rounded, size: 42, color: LuxTheme.latte)),
        const SizedBox(height: 20),
        Text('No journeys yet', style: LuxTheme.serif20.copyWith(color: LuxTheme.mocha)),
        const SizedBox(height: 8),
        Text('Start planning your first\nAlgerian adventure.', style: LuxTheme.body14, textAlign: TextAlign.center),
        const SizedBox(height: 28),
        SizedBox(width: 200, child: LuxButton(label: 'Plan a Trip', icon: Icons.add_rounded, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AITripPlannerPage())))),
      ]))),
    ]))),
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    backgroundColor: LuxTheme.sand,
    body: SafeArea(child: SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('PROFILE', style: LuxTheme.goldLabel.copyWith(letterSpacing: 2.5)),
      const SizedBox(height: 8),
      Text('Your Account', style: LuxTheme.serif32),
      const SizedBox(height: 32),
      // Avatar section
      Center(child: Column(children: [
        Container(width: 100, height: 100,
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: LuxTheme.primaryGrad, boxShadow: LuxTheme.primaryShadow),
          child: const Icon(Icons.person_rounded, size: 52, color: LuxTheme.white)),
        const SizedBox(height: 16),
        Text('Welcome, Traveller', style: LuxTheme.serif20),
        const SizedBox(height: 4),
        Text('Sign in to unlock your full journey.', style: LuxTheme.body14),
        const SizedBox(height: 28),
        SizedBox(width: 220, child: LuxButton(label: 'Sign In', icon: Icons.login_rounded, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())))),
        const SizedBox(height: 12),
        SizedBox(width: 220, child: LuxOutlineButton(label: 'Create Account', icon: Icons.person_add_rounded, onTap: () {})),
      ])),
      const SizedBox(height: 40),
      const GoldDivider(label: 'FEATURES'),
      const SizedBox(height: 20),
      ...[
        {'icon': Icons.favorite_rounded,        'label': 'Saved Places',   'sub': 'Your favourited destinations'},
        {'icon': Icons.history_rounded,          'label': 'Trip History',   'sub': 'All past journeys'},
        {'icon': Icons.settings_rounded,         'label': 'Preferences',   'sub': 'Language, currency, theme'},
        {'icon': Icons.help_outline_rounded,     'label': 'Help & Support', 'sub': 'FAQ and contact'},
      ].map((item) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: LuxTheme.sandLight, borderRadius: LuxTheme.r14, boxShadow: LuxTheme.cardShadow),
        child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: LuxTheme.goldPale, borderRadius: LuxTheme.r8),
            child: Icon(item['icon'] as IconData, color: LuxTheme.gold, size: 20)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item['label'] as String, style: LuxTheme.title16.copyWith(fontSize: 14)),
            Text(item['sub'] as String, style: LuxTheme.body14.copyWith(fontSize: 12)),
          ])),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: LuxTheme.latte),
        ]),
      ))),
    ])))),
  );
}