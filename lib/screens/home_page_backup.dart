import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme.dart';
import 'trip_planner_page.dart';
import 'favorites_page.dart';
import 'login_page.dart';
import 'ai_trip_planner.dart';
import 'wilaya_detail_page.dart';
import 'manual_trip_planner.dart';

// ─────────────────────────────────────────────────────────────
//  HOME PAGE  –  Clean & Professional with subtle animations
// ─────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // ── Animation controllers ──
  late final AnimationController _headerCtrl;
  late final AnimationController _searchCtrl;
  late final AnimationController _categoryCtrl;
  late final AnimationController _cardsCtrl;

  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _searchFade;
  late final Animation<Offset> _searchSlide;
  late final Animation<double> _categoryFade;
  late final Animation<double> _cardsFade;

  // ── Data ──
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All',     'icon': Icons.apps,         'image': null,                           'color': 0xFF6C7D76},
    {'name': 'Beach',   'icon': Icons.beach_access,  'image': 'assets/images/plage.jpg',      'color': 0xFF4FC3F7},
    {'name': 'Mountain','icon': Icons.terrain,       'image': 'assets/images/montagne.jpg',   'color': 0xFF81C784},
    {'name': 'Sahara',  'icon': Icons.wb_sunny,      'image': 'assets/images/sahara.jpg',     'color': 0xFFFFB74D},
    {'name': 'Culture', 'icon': Icons.museum,        'image': 'assets/images/culture.jpg',    'color': 0xFFCE93D8},
  ];

  final List<Map<String, dynamic>> _allWilayas = [
    {'name': 'Algiers',    'region': 'Center', 'icon': Icons.account_balance, 'color': 0xFF6C7D76, 'image': 'assets/images/wilayas/alger.jpg',        'description': 'The white capital, blending modernity and history.',                              'attractions': ['Casbah', "Notre-Dame d'Afrique", "Jardin d'Essai"],            'bestTime': 'March–May / Sep–Nov',   'famousFood': 'Couscous, Merguez, Baklawa',       'coordinates': {'lat': 36.7538, 'lng': 3.0588},   'categories': ['Beach', 'Culture']},
    {'name': 'Oran',       'region': 'West',   'icon': Icons.music_note,      'color': 0xFF91A8B0, 'image': 'assets/images/wilayas/oran.jpg',          'description': 'The joyful city, famous for Raï music and Fort Santa Cruz.',                     'attractions': ['Fort Santa Cruz', 'Le Château Neuf', 'Les Andalouses'],         'bestTime': 'Apr–Jun / Sep–Oct',     'famousFood': 'Bouchée à la reine, El Kebab',     'coordinates': {'lat': 35.6973, 'lng': -0.6336},  'categories': ['Beach', 'Culture']},
    {'name': 'Constantine','region': 'East',   'icon': Icons.landscape,       'color': 0xFFA39C7C, 'image': 'assets/images/wilayas/constantine.jpg',   'description': 'City of suspended bridges, perched on dramatic cliffs.',                        'attractions': ["Sidi M'Cid Bridge", 'Ahmed Bey Palace', 'Rhumel Gorges'],       'bestTime': 'May–Sep',               'famousFood': 'Chakhchoukha, Merguez',            'coordinates': {'lat': 36.3650, 'lng': 6.6147},   'categories': ['Culture']},
    {'name': 'Annaba',     'region': 'East',   'icon': Icons.beach_access,    'color': 0xFFC1D3C6, 'image': 'assets/images/wilayas/annaba.jpg',        'description': 'Coastal city with beautiful beaches and the Roman site of Hippo Regius.',       'attractions': ['Basilica of St Augustine', 'Hippo Regius', "Sable d'Or Beach"], 'bestTime': 'Jun–Sep',               'famousFood': 'Grilled fish, Couscous',           'coordinates': {'lat': 36.9028, 'lng': 7.7558},   'categories': ['Beach', 'Culture']},
    {'name': 'Tlemcen',    'region': 'West',   'icon': Icons.mosque,          'color': 0xFF6C7D76, 'image': 'assets/images/wilayas/tlemcen.jpg',       'description': 'Pearl of Islamic art, magnificent architecture.',                               'attractions': ['Sidi Boumediene Mosque', 'Mansourah', 'El Mechouar Palace'],    'bestTime': 'Mar–May / Sep–Nov',     'famousFood': 'Couscous, Mhadjeb, Zlabia',        'coordinates': {'lat': 34.8828, 'lng': -1.3167},  'categories': ['Culture']},
    {'name': 'Ghardaïa',  'region': 'Sahara', 'icon': Icons.wb_sunny,        'color': 0xFF91A8B0, 'image': 'assets/images/wilayas/ghardaia.jpg',      'description': "Heart of the M'zab valley, a UNESCO site.",                                    'attractions': ["M'zab Valley", 'Ghardaïa Mosque', 'Traditional Market'],        'bestTime': 'Oct–Apr',               'famousFood': 'Couscous, Dates, Mahjouba',        'coordinates': {'lat': 32.4833, 'lng': 3.6667},   'categories': ['Sahara', 'Culture']},
    {'name': 'Béjaïa',    'region': 'Center', 'icon': Icons.terrain,         'color': 0xFF6C7D76, 'image': 'assets/images/wilayas/bejaia.jpg',        'description': 'Gulf of Kings, beautiful landscapes and Gouraya National Park.',               'attractions': ['Gouraya National Park', 'Cap Carbon', 'Pic des Singes'],        'bestTime': 'May–Oct',               'famousFood': 'Merguez, Grilled sardines, Tahlia', 'coordinates': {'lat': 36.7500, 'lng': 5.0833},   'categories': ['Beach', 'Mountain']},
    {'name': 'Tipaza',     'region': 'Center', 'icon': Icons.history,         'color': 0xFFC1D3C6, 'image': 'assets/images/wilayas/tipaza.jpg',        'description': 'Famous for Roman ruins classified as UNESCO.',                                  'attractions': ['Roman Ruins', 'Tombeau de la Chrétienne', 'Chenoua Beach'],     'bestTime': 'Mar–May / Sep–Nov',     'famousFood': 'Fresh fish, Couscous',             'coordinates': {'lat': 36.5897, 'lng': 2.4500},   'categories': ['Beach', 'Culture']},
    {'name': 'Tamanrasset','region': 'Sahara', 'icon': Icons.wb_sunny,        'color': 0xFFFFB74D, 'image': 'assets/images/wilayas/tamanrasset.jpg',   'description': 'Gateway to the Hoggar desert, lunar landscapes.',                              'attractions': ['Hoggar', 'Assekrem', "Tassili n'Ajjer"],                        'bestTime': 'Oct–Mar',               'famousFood': 'Couscous, Tuareg tea',             'coordinates': {'lat': 22.7850, 'lng': 5.5228},   'categories': ['Sahara', 'Mountain']},
    {'name': 'Jijel',      'region': 'East',   'icon': Icons.beach_access,    'color': 0xFF4FC3F7, 'image': 'assets/images/wilayas/jijel.jpg',         'description': 'City with stunning beaches and the Taza National Park.',                       'attractions': ['Taza National Park', 'Plage Tichi', 'Cap Djinet'],              'bestTime': 'Jun–Sep',               'famousFood': 'Grilled fish, Boulettes',           'coordinates': {'lat': 36.8200, 'lng': 5.7667},   'categories': ['Beach', 'Mountain']},
    {'name': 'Biskra',     'region': 'Sahara', 'icon': Icons.wb_sunny,        'color': 0xFFFFB74D, 'image': 'assets/images/wilayas/biskra.jpg',        'description': 'Queen of the Zibans, gateway to the desert.',                                  'attractions': ['Palm grove', 'Tassili National Park', 'Hammam Salah'],          'bestTime': 'Oct–Apr',               'famousFood': 'Dates, Vegetable couscous',         'coordinates': {'lat': 34.8500, 'lng': 5.7333},   'categories': ['Sahara']},
    {'name': 'Blida',      'region': 'Center', 'icon': Icons.terrain,         'color': 0xFF81C784, 'image': 'assets/images/wilayas/blida.jpg',         'description': 'City of roses, at the foot of the Atlas mountains.',                           'attractions': ['Chréa National Park', 'Télécabine de Chréa', 'Mouzaia Gorges'], 'bestTime': 'Apr–Jun / Sep–Oct',     'famousFood': 'Couscous, Mhadjeb',                'coordinates': {'lat': 36.4667, 'lng': 2.8167},   'categories': ['Mountain']},
    {'name': 'Tizi Ouzou', 'region': 'Center', 'icon': Icons.landscape,       'color': 0xFF81C784, 'image': 'assets/images/wilayas/tizi.jpg',          'description': 'Capital of Kabylia, heart of the Djurdjura mountains.',                        'attractions': ['Djurdjura National Park', 'Tizi Ouzou market', 'Beni Yenni'],   'bestTime': 'May–Sep',               'famousFood': 'Tagine, Olive oil',                'coordinates': {'lat': 36.7167, 'lng': 4.0500},   'categories': ['Mountain']},
    {'name': 'Sétif',      'region': 'East',   'icon': Icons.landscape,       'color': 0xFF91A8B0, 'image': 'assets/images/wilayas/setif.webp',        'description': 'High plateau city, known for its museum and mountains.',                        'attractions': ['Mont Babor', 'Guergour Forest', 'Ain El Fouara'],               'bestTime': 'Jun–Sep',               'famousFood': 'Merguez, Mhadjeb',                 'coordinates': {'lat': 36.1911, 'lng': 5.4097},   'categories': ['Mountain']},
    {'name': 'Adrar',      'region': 'Sahara', 'icon': Icons.wb_sunny,        'color': 0xFFFFB74D, 'image': 'assets/images/wilayas/adrar.jpg',         'description': 'Known for its ksour and oasis.',                                               'attractions': ['Ksar of Timimoun', 'Oasis of Adrar', 'Taghit'],                 'bestTime': 'Oct–Apr',               'famousFood': 'Dates, Méchoui',                   'coordinates': {'lat': 27.8667, 'lng': -0.2833},  'categories': ['Sahara']},
    {'name': 'Batna',      'region': 'East',   'icon': Icons.history,         'color': 0xFFCE93D8, 'image': 'assets/images/wilayas/batna.jpg',         'description': 'Gateway to the Aurès and the Roman city of Timgad.',                           'attractions': ['Timgad ruins', 'Lambese', 'Belezma National Park'],             'bestTime': 'Apr–Jun / Sep–Oct',     'famousFood': 'Chakhchoukha, Merguez',            'coordinates': {'lat': 35.5500, 'lng': 6.1667},   'categories': ['Culture', 'Mountain']},
  ];

  List<Map<String, dynamic>> get _filteredWilayas {
    List<Map<String, dynamic>> list = _allWilayas;
    if (_selectedCategory != 'All') {
      list = list.where((w) => (w['categories'] as List).contains(_selectedCategory)).toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list.where((w) => (w['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _playEntrance();
  }

  void _setupAnimations() {
    _headerCtrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _searchCtrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _categoryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _cardsCtrl    = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _headerFade  = CurvedAnimation(parent: _headerCtrl,   curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut));

    _searchFade  = CurvedAnimation(parent: _searchCtrl,  curve: Curves.easeOut);
    _searchSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _searchCtrl, curve: Curves.easeOut));

    _categoryFade = CurvedAnimation(parent: _categoryCtrl, curve: Curves.easeOut);
    _cardsFade    = CurvedAnimation(parent: _cardsCtrl,    curve: Curves.easeOut);
  }

  Future<void> _playEntrance() async {
    await Future.delayed(const Duration(milliseconds: 80));
    _headerCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 160));
    _searchCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 160));
    _categoryCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 160));
    _cardsCtrl.forward();
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _searchCtrl.dispose();
    _categoryCtrl.dispose();
    _cardsCtrl.dispose();
    super.dispose();
  }

  // ── re-animate cards when category changes ──
  void _selectCategory(String cat) {
    setState(() => _selectedCategory = cat);
    _cardsCtrl
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: _selectedIndex == 0 ? _buildHomeScreen() : _buildOtherScreen(),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  HOME SCREEN
  // ══════════════════════════════════════════════════════════
  Widget _buildHomeScreen() {
    return CustomScrollView(
      slivers: [
        // ── Header ──
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _headerFade,
            child: SlideTransition(
              position: _headerSlide,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Discover Algeria',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1A2020),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Where do you want to go?',
                              style: TextStyle(fontSize: 15, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                        // Avatar / notification button
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
                          ),
                          child: Icon(Icons.notifications_none_rounded, color: AppTheme.primaryColor, size: 22),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Search bar ──
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _searchFade,
            child: SlideTransition(
              position: _searchSlide,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (v) => setState(() => _searchQuery = v),
                          decoration: InputDecoration(
                            hintText: 'Search a destination…',
                            hintStyle: TextStyle(color: AppTheme.textHint, fontSize: 14),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search_rounded, color: AppTheme.primaryColor, size: 22),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      // Filter pill
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _AnimatedFilterButton(
                          onTap: () {},
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Category label ──
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _categoryFade,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF1A2020)),
              ),
            ),
          ),
        ),

        // ── Categories row ──
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _categoryFade,
            child: SizedBox(
              height: 96,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat['name'];
                  return _CategoryChip(
                    cat: cat,
                    isSelected: isSelected,
                    onTap: () => _selectCategory(cat['name']),
                  );
                },
              ),
            ),
          ),
        ),

        // ── Popular destinations label ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Popular destinations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF1A2020))),
                Text('See all', style: TextStyle(fontSize: 13, color: AppTheme.primaryColor, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),

        // ── Destination cards ──
        SliverToBoxAdapter(
          child: SizedBox(
            height: 240,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: _filteredWilayas.length,
              itemBuilder: (context, index) {
                return FadeTransition(
                  opacity: _cardsFade,
                  child: _AnimatedDestinationCard(
                    wilaya: _filteredWilayas[index],
                    index: index,
                    cardsCtrl: _cardsCtrl,
                  ),
                );
              },
            ),
          ),
        ),

        // ── Bottom padding ──
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  //  OTHER SCREENS
  // ══════════════════════════════════════════════════════════
  Widget _buildOtherScreen() {
    switch (_selectedIndex) {
      case 1: return const TripPlannerScreen();
      case 2: return const MyTripsScreen();
      case 3: return const FavoritesPage();
      case 4: return const ProfilePage();
      default: return _buildHomeScreen();
    }
  }

  // ══════════════════════════════════════════════════════════
  //  BOTTOM NAV
  // ══════════════════════════════════════════════════════════
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textHint,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded),           label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.work_rounded),           label: 'My Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border_rounded),label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  CATEGORY CHIP  – scale on tap
// ─────────────────────────────────────────────────────────────
class _CategoryChip extends StatefulWidget {
  final Map<String, dynamic> cat;
  final bool isSelected;
  final VoidCallback onTap;
  const _CategoryChip({required this.cat, required this.isSelected, required this.onTap});

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cat        = widget.cat;
    final isSelected = widget.isSelected;

    return GestureDetector(
      onTapDown:   (_) => _ctrl.forward(),
      onTapCancel: ()  => _ctrl.reverse(),
      onTap: () {
        _ctrl.reverse();
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 76,
          margin: const EdgeInsets.only(right: 14),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                width: 60, height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: AppTheme.primaryColor, width: 3)
                      : Border.all(color: Colors.transparent, width: 3),
                  image: cat['image'] != null
                      ? DecorationImage(image: AssetImage(cat['image']!), fit: BoxFit.cover)
                      : null,
                  color: cat['image'] == null ? Color(cat['color']) : null,
                  boxShadow: isSelected
                      ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.30), blurRadius: 10, offset: const Offset(0, 4))]
                      : [],
                ),
                child: cat['image'] == null
                    ? Icon(cat['icon'] as IconData, color: Colors.white, size: 26)
                    : null,
              ),
              const SizedBox(height: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                ),
                child: Text(cat['name'] as String, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  DESTINATION CARD  – staggered slide-up + scale on tap
// ─────────────────────────────────────────────────────────────
class _AnimatedDestinationCard extends StatefulWidget {
  final Map<String, dynamic> wilaya;
  final int index;
  final AnimationController cardsCtrl;
  const _AnimatedDestinationCard({required this.wilaya, required this.index, required this.cardsCtrl});

  @override
  State<_AnimatedDestinationCard> createState() => _AnimatedDestinationCardState();
}

class _AnimatedDestinationCardState extends State<_AnimatedDestinationCard>
    with SingleTickerProviderStateMixin {
  late final Animation<Offset> _slide;
  late final Animation<double>  _fade;
  late final AnimationController _tapCtrl;
  late final Animation<double>   _tapScale;

  @override
  void initState() {
    super.initState();

    // Stagger: each card slides up with delay proportional to index
    final double start = (widget.index * 0.07).clamp(0.0, 0.7);
    final double end   = (start + 0.5).clamp(0.0, 1.0);
    final interval     = Interval(start, end, curve: Curves.easeOut);

    _slide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(CurvedAnimation(parent: widget.cardsCtrl, curve: interval));
    _fade  = CurvedAnimation(parent: widget.cardsCtrl, curve: interval);

    _tapCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _tapScale = Tween<double>(begin: 1.0, end: 0.95).animate(_tapCtrl);
  }

  @override
  void dispose() { _tapCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final wilaya = widget.wilaya;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTapDown:   (_) => _tapCtrl.forward(),
          onTapCancel: ()  => _tapCtrl.reverse(),
          onTap: () {
            _tapCtrl.reverse();
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, a, __) => WilayaDetailPage(
                  name:        wilaya['name'],
                  icon:        wilaya['icon'],
                  color:       Color(wilaya['color'] as int),
                  imagePath:   wilaya['image'],
                  description: wilaya['description'],
                  attractions: List<String>.from(wilaya['attractions']),
                  bestTime:    wilaya['bestTime'],
                  famousFood:  wilaya['famousFood'],
                ),
                transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
                transitionDuration: const Duration(milliseconds: 280),
              ),
            );
          },
          child: ScaleTransition(
            scale: _tapScale,
            child: Container(
              width: 185,
              margin: const EdgeInsets.only(right: 14, bottom: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                        child: Image.asset(
                          wilaya['image'],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 150,
                            color: Color(wilaya['color'] as int).withOpacity(0.45),
                            child: Center(child: Icon(wilaya['icon'] as IconData, size: 48, color: Colors.white)),
                          ),
                        ),
                      ),
                      // Gradient overlay for text legibility
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withOpacity(0.18)],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Maps button
                      Positioned(
                        top: 10, right: 10,
                        child: GestureDetector(
                          onTap: () async {
                            final lat = wilaya['coordinates']['lat'];
                            final lng = wilaya['coordinates']['lng'];
                            final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.92),
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6)],
                            ),
                            child: const Icon(Icons.navigation_rounded, size: 17, color: Color(0xFF2E7D32)),
                          ),
                        ),
                      ),
                      // Category badge
                      Positioned(
                        bottom: 10, left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Color(wilaya['color'] as int).withOpacity(0.88),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            (wilaya['categories'] as List).first,
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Info
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wilaya['name'],
                          style: TextStyle(fontWeight: FontWeight.w700, color: const Color(0xFF1A2020), fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 3),
                            const Text('4.8', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1A2020))),
                            const SizedBox(width: 4),
                            Text('(123)', style: TextStyle(fontSize: 11, color: AppTheme.textHint)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FILTER BUTTON  – animated press
// ─────────────────────────────────────────────────────────────
class _AnimatedFilterButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color color;
  const _AnimatedFilterButton({required this.onTap, required this.color});

  @override
  State<_AnimatedFilterButton> createState() => _AnimatedFilterButtonState();
}

class _AnimatedFilterButtonState extends State<_AnimatedFilterButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(_ctrl);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   (_) => _ctrl.forward(),
      onTapCancel: ()  => _ctrl.reverse(),
      onTap: () { _ctrl.reverse(); widget.onTap(); },
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: widget.color.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  OTHER SCREENS (unchanged logic, minor style polish)
// ══════════════════════════════════════════════════════════════
class TripPlannerScreen extends StatelessWidget {
  const TripPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Plan my trip',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1A2020))),
              const SizedBox(height: 6),
              Text('Choose how to create your itinerary', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 32),
              _PlannerOption(
                icon: Icons.auto_awesome_rounded,
                title: 'AI Planner',
                subtitle: 'Generate a personalized itinerary with AI',
                color: AppTheme.primaryColor,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AITripPlannerPage())),
              ),
              const SizedBox(height: 16),
              _PlannerOption(
                icon: Icons.edit_calendar_rounded,
                title: 'Manual Planner',
                subtitle: 'Build your own itinerary step by step',
                color: AppTheme.accentColor,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManualTripPlannerPage())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlannerOption extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _PlannerOption({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});

  @override
  State<_PlannerOption> createState() => _PlannerOptionState();
}

class _PlannerOptionState extends State<_PlannerOption> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(_ctrl);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   (_) => _ctrl.forward(),
      onTapCancel: ()  => _ctrl.reverse(),
      onTap: () { _ctrl.reverse(); widget.onTap(); },
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: widget.color.withOpacity(0.25)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(widget.icon, color: widget.color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: widget.color)),
                  const SizedBox(height: 3),
                  Text(widget.subtitle, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                ]),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: widget.color.withOpacity(0.6), size: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('My trips', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1A2020))),
              const SizedBox(height: 6),
              Text('Find all your saved itineraries', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work_outline_rounded, size: 64, color: AppTheme.textHint),
                      const SizedBox(height: 16),
                      Text('No trips yet', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AITripPlannerPage())),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                        ),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Plan a trip'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor.withOpacity(0.12),
                ),
                child: Icon(Icons.person_outline_rounded, size: 48, color: AppTheme.primaryColor),
              ),
              const SizedBox(height: 16),
              const Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1A2020))),
              const SizedBox(height: 6),
              Text('Log in to see your profile', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
                ),
                child: const Text('Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}