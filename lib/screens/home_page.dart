import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/luxury_theme.dart';
import 'ai_trip_planner.dart';
import 'my_trips_screen.dart';
import 'manual_trip_planner.dart';
import 'wilaya_detail_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';

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
  late final List<Animation<Offset>> _slideAnims;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All',      'icon': Icons.apps_rounded,         'color': LuxTheme.mocha},
    {'name': 'Beach',    'icon': Icons.beach_access_rounded, 'color': Color(0xFF2E86AB)},
    {'name': 'Mountain', 'icon': Icons.terrain_rounded,      'color': Color(0xFF4E7C59)},
    {'name': 'Sahara',   'icon': Icons.wb_sunny_rounded,     'color': LuxTheme.gold},
    {'name': 'Culture',  'icon': Icons.museum_rounded,       'color': LuxTheme.terracotta},
  ];

  final List<Map<String, dynamic>> _wilayas = [

    // ── ALGIERS ────────────────────────────────────────────────
    {
      'name': 'Algiers',
      'image': 'assets/images/wilayas/alger.jpg',
      'color': 0xFF6C7D76,
      'description': 'The White City — Algeria\'s vibrant capital blending Ottoman heritage, French boulevards and a stunning Mediterranean waterfront. Home to the UNESCO-listed Casbah and the world\'s third-largest mosque.',
      'categories': ['Beach', 'Culture'],
      'bestTime': 'March–May / Sep–Nov',
      'famousFood': 'Couscous, Merguez, Baklawa, Chorba',
      'coordinates': {'lat': 36.7538, 'lng': 3.0588},
      'attractions': [
        'Casbah of Algiers (UNESCO World Heritage)',
        'Great Mosque of Algiers — Djamaa el Djazaïr',
        'Notre-Dame d\'Afrique Basilica',
        'Jardin d\'Essai du Hamma',
        'Monument of the Martyrs — Maqam Echahid',
        'Bardo National Museum',
        'Tipaza Roman Ruins (day trip)',
      ],
      'activities': [
        'Guided tour of the UNESCO Casbah quarter — Free entry',
        'Visit the Great Mosque of Algiers — Free (non-prayer times)',
        'Stroll the waterfront Corniche promenade — Free',
        'Jardin d\'Essai botanical garden — 100 DZD entry',
        'Bardo National Museum — 200 DZD entry',
        'Boat trip in the Bay of Algiers — 500–1500 DZD',
        'Day trip to Tipaza Roman Ruins — 300 DZD entry',
      ],
      'hotels': [
        'Hôtel El Aurassi ★★★★★ — from 25,000 DZD/night',
        'Sheraton Club des Pins ★★★★★ — from 30,000 DZD/night',
        'Hôtel Sofitel Algiers ★★★★★ — from 22,000 DZD/night',
        'Hôtel Mercure Alger ★★★★ — from 12,000 DZD/night',
        'Hôtel Albert 1er ★★★ — from 6,000 DZD/night',
      ],
      'openingHours': [
        'Casbah: Open daily 08:00–18:00 | Free',
        'Great Mosque: 09:00–17:00 (closed Friday mornings to tourists)',
        'Notre-Dame d\'Afrique: 08:00–19:00 daily | Free',
        'Jardin d\'Essai: 08:00–17:30 daily | 100 DZD',
        'Bardo Museum: 09:00–16:30 | Closed Monday | 200 DZD',
      ],
    },

    // ── TIPAZA ─────────────────────────────────────────────────
    {
      'name': 'Tipaza',
      'image': 'assets/images/wilayas/tipaza.jpg',
      'color': 0xFF7A9E8E,
      'description': 'A UNESCO World Heritage jewel — Tipaza is home to the most spectacular Roman and Phoenician ruins in North Africa, set dramatically against the blue Mediterranean. Albert Camus immortalised its light and beauty.',
      'categories': ['Beach', 'Culture'],
      'bestTime': 'March–June / Sep–Nov',
      'famousFood': 'Grilled fish, Couscous, Chorba, Fresh seafood',
      'coordinates': {'lat': 36.5911, 'lng': 2.4477},
      'attractions': [
        'Tipaza Roman Ruins (UNESCO World Heritage)',
        'Royal Mausoleum of Mauretania (Tomb of the Christian)',
        'Tipaza Archaeological Museum',
        'Tipaza Beach beside ancient ruins',
        'Chenoua Mountain',
        'Ruins of the Great Basilica',
        'Phoenician Necropolis',
      ],
      'activities': [
        'Explore Tipaza Roman Ruins (UNESCO) — 300 DZD | 08:00–17:30',
        'Visit Royal Mausoleum of Mauretania — 200 DZD | 08:00–17:00',
        'Tipaza Archaeological Museum — 100 DZD | 08:00–16:30',
        'Swim at Tipaza beach beside the ruins — Free',
        'Hike Chenoua Mountain — Free',
        'Boat trip along the Tipaza coastline — 500–1500 DZD',
      ],
      'hotels': [
        'Hôtel Club des Pins ★★★★★ — from 28,000 DZD/night',
        'Hôtel Matarès ★★★★ — from 11,000 DZD/night',
        'Hôtel Tipaza ★★★ — from 5,500 DZD/night',
        'Résidence Les Oliviers ★★★ — from 4,500 DZD/night',
      ],
      'openingHours': [
        'Tipaza Roman Ruins: 08:00–17:30 daily | 300 DZD',
        'Royal Mausoleum: 08:00–17:00 | Closed Monday | 200 DZD',
        'Archaeological Museum: 08:00–16:30 | Closed Monday | 100 DZD',
        'Tipaza Beach: Open all day | Free',
      ],
    },

    // ── BLIDA ──────────────────────────────────────────────────
    {
      'name': 'Blida',
      'image': 'assets/images/wilayas/blida.jpg',
      'color': 0xFF5D8A5E,
      'description': 'The City of Roses — Blida sits at the foot of the spectacular Tell Atlas mountains, famous for its rose gardens, orange blossom fragrance, cedar forests, and the dramatic Chiffa Gorge where wild Barbary macaques roam.',
      'categories': ['Mountain', 'Culture'],
      'bestTime': 'March–June / Sep–Nov',
      'famousFood': 'Rose jam, Orange blossom pastries, Couscous, Rechta',
      'coordinates': {'lat': 36.4692, 'lng': 2.8277},
      'attractions': [
        'Chrea National Park (cedar forests)',
        'Chiffa Gorge (Barbary macaques)',
        'Chrea Ski Station',
        'Mosque of Sidi Ahmed Kebir',
        'Blida Rose Gardens',
        'Oued Chiffa Valley',
        'Blida Old Medina',
      ],
      'activities': [
        'Hike in Chrea National Park — 100 DZD | 07:00–18:00',
        'Spot Barbary macaques in Chiffa Gorge — Free',
        'Ski at Chrea Ski Station — 500 DZD (Dec–Feb)',
        'Visit Blida Rose Gardens — Free | 08:00–18:00',
        'Walk the Oued Chiffa valley trail — Free',
        'Day trip to Medea historic city — Free',
      ],
      'hotels': [
        'Hôtel Atlas Blida ★★★★ — from 10,000 DZD/night',
        'Hôtel Chrea ★★★ — from 6,000 DZD/night',
        'Hôtel du Parc ★★★ — from 5,000 DZD/night',
        'Chalet Chiffa ★★★ — from 5,500 DZD/night',
      ],
      'openingHours': [
        'Chrea National Park: 07:00–18:00 daily | 100 DZD',
        'Chiffa Gorge: Open all day | Free',
        'Chrea Ski Station: 08:00–16:30 (Dec–Feb) | 500 DZD',
        'Blida Rose Gardens: 08:00–18:00 daily | Free',
      ],
    },

    // ── TIZI OUZOU ─────────────────────────────────────────────
    {
      'name': 'Tizi Ouzou',
      'image': 'assets/images/wilayas/Tizi_Ouzou.jpg',
      'color': 0xFF4E7C59,
      'description': 'The capital of Kabylie — a land of proud Berber culture, dramatic Djurdjura mountain peaks, traditional stone villages perched on cliff edges, and the turquoise waters of the Aghribs coast.',
      'categories': ['Mountain', 'Culture'],
      'bestTime': 'May–October',
      'famousFood': 'Aghrum (Kabyle bread), Tafraout, Couscous berber, Tamtunt',
      'coordinates': {'lat': 36.7167, 'lng': 4.0500},
      'attractions': [
        'Djurdjura National Park (UNESCO Biosphere)',
        'Lalla Khedidja Summit (2,308m)',
        'Beni Yenni (silver jewellery village)',
        'Tigzirt Roman Ruins and Beach',
        'Ath Yenni Village',
        'Aghribs Beach',
        'Fort National',
      ],
      'activities': [
        'Hike in Djurdjura National Park — 100 DZD | 07:00–18:00',
        'Explore Beni Yenni silver workshops — Free',
        'Visit Tigzirt Roman Ruins — 100 DZD | 08:00–17:00',
        'Trek to Lalla Khedidja summit — Free (guide recommended)',
        'Swim at Aghribs Beach — Free | May–October',
        'Explore traditional Kabyle villages — Free',
      ],
      'hotels': [
        'Hôtel Belloua ★★★★ — from 10,000 DZD/night',
        'Hôtel Djurdjura ★★★ — from 6,000 DZD/night',
        'Hôtel Lalla Khedidja ★★★ — from 5,500 DZD/night',
        'Gite Rural Ath Yenni — from 4,000 DZD/night',
      ],
      'openingHours': [
        'Djurdjura National Park: 07:00–18:00 daily | 100 DZD',
        'Beni Yenni: 09:00–17:00 daily | Free',
        'Tigzirt Ruins: 08:00–17:00 daily | 100 DZD',
        'Aghribs Beach: Open all day | May–October | Free',
      ],
    },

    // ── GUELMA ─────────────────────────────────────────────────
    {
      'name': 'Guelma',
      'image': 'assets/images/wilayas/guelma.jpg',
      'color': 0xFF8A7560,
      'description': 'The Antique City — Guelma is home to some of North Africa\'s best-preserved Roman theatres, the extraordinary thermal baths of Hammam Meskhoutine, and the lush Medjez-Amar forests.',
      'categories': ['Culture', 'Mountain'],
      'bestTime': 'April–October',
      'famousFood': 'Chakhchoukha, Rechta, Grilled lamb, Berkoukes',
      'coordinates': {'lat': 36.4619, 'lng': 7.4278},
      'attractions': [
        'Roman Theatre of Calama (2nd century AD)',
        'Hammam Meskhoutine Hot Springs',
        'Petrified Waterfall (calcified formations)',
        'Guelma Regional Museum',
        'Roman Triumphal Arch',
        'Medjez-Amar Forest',
        'Ain Makhlouf Waterfalls',
      ],
      'activities': [
        'Visit Roman Theatre of Calama — 200 DZD | 08:00–17:00',
        'Bathe at Hammam Meskhoutine hot springs — 200 DZD | 08:00–18:00',
        'Explore petrified waterfall formations — Free',
        'Guelma Regional Museum — 100 DZD | 09:00–16:30',
        'Hike in Medjez-Amar forests — Free',
        'Day trip to Ain Makhlouf waterfalls — Free',
      ],
      'hotels': [
        'Hôtel Medjez-Amar ★★★★ — from 9,000 DZD/night',
        'Hôtel Hammam Meskhoutine ★★★ — from 6,000 DZD/night',
        'Hôtel Guelma ★★★ — from 5,000 DZD/night',
        'Hôtel El Houria ★★★ — from 4,500 DZD/night',
      ],
      'openingHours': [
        'Roman Theatre of Calama: 08:00–17:00 | Closed Monday | 200 DZD',
        'Hammam Meskhoutine: 08:00–18:00 daily | 200 DZD',
        'Guelma Regional Museum: 09:00–16:30 | Closed Monday | 100 DZD',
        'Medjez-Amar Forest: Open all day | Free',
      ],
    },

    // ── JIJEL ──────────────────────────────────────────────────
    {
      'name': 'Jijel',
      'image': 'assets/images/wilayas/jijel.jpg',
      'color': 0xFF2E7A6E,
      'description': 'The Pearl of the Mediterranean — Jijel is Algeria\'s best-kept coastal secret, with 120km of spectacular coastline: emerald coves, towering red rock arches, ancient cedar forests, and pristine wild beaches.',
      'categories': ['Beach', 'Mountain'],
      'bestTime': 'June–September',
      'famousFood': 'Grilled fish, Seafood couscous, Merguez, Brik',
      'coordinates': {'lat': 36.8208, 'lng': 5.7664},
      'attractions': [
        'Les Falaises (rock arch beaches)',
        'Taza National Park (giant cedars)',
        'Cap Bouak lighthouse and cove',
        'Aouana Beach',
        'El Aouana Coastal Forest',
        'Ziama Mansouria Beach',
        'Kotama Beach',
      ],
      'activities': [
        'Swim at Les Falaises rock arch beaches — Free | June–September',
        'Hike in Taza National Park — 100 DZD | 07:00–18:00',
        'Snorkelling and diving at Cap Bouak — Free',
        'Boat trip along the red rock coastline — 500–1500 DZD',
        'Beach hop from Kotama to Ziama Mansouria — Free',
        'Visit the Jijel Old Port — Free',
      ],
      'hotels': [
        'Hôtel Kotama ★★★★ — from 10,000 DZD/night',
        'Hôtel Les Falaises ★★★★ — from 9,500 DZD/night',
        'Hôtel Aouana ★★★ — from 6,000 DZD/night',
        'Hôtel Jijel ★★★ — from 5,000 DZD/night',
      ],
      'openingHours': [
        'Les Falaises Beach: Open all day | June–September | Free',
        'Taza National Park: 07:00–18:00 daily | 100 DZD',
        'Cap Bouak: Open all day | Free',
        'Aouana Beach: Open all day | June–September | Free',
      ],
    },

    // ── ANNABA ─────────────────────────────────────────────────
    {
      'name': 'Annaba',
      'image': 'assets/images/wilayas/annaba.jpg',
      'color': 0xFFC1D3C6,
      'description': 'The City of Jujube Trees — a coastal gem combining golden beaches, ancient Roman ruins and the magnificent Basilica of St. Augustine, birthplace of the great philosopher.',
      'categories': ['Beach', 'Culture'],
      'bestTime': 'June–September',
      'famousFood': 'Grilled fish, Couscous with seafood, Brik',
      'coordinates': {'lat': 36.9028, 'lng': 7.7558},
      'attractions': [
        'Basilica of St. Augustine (1900 neo-Byzantine)',
        'Hippo Regius Roman Ruins',
        'Sable d\'Or Beach',
        'Cap de Garde Lighthouse',
        'El Kala National Park (UNESCO Biosphere)',
        'Annaba Museum',
        'Seybouse River Valley',
      ],
      'activities': [
        'Visit Basilica of St. Augustine — Free | 08:00–12:00 / 14:00–18:00',
        'Explore Hippo Regius Roman Ruins — 200 DZD',
        'Relax at Sable d\'Or Beach — Free | June–September',
        'El Kala National Park hiking — 100 DZD entry',
        'Snorkelling at Cap de Garde — Free',
        'Visit Annaba Museum — 100 DZD | 09:00–16:30',
      ],
      'hotels': [
        'Hôtel Sheraton Annaba ★★★★★ — from 20,000 DZD/night',
        'Hôtel Sabri ★★★★ — from 9,000 DZD/night',
        'Hôtel Seybouse International ★★★★ — from 8,000 DZD/night',
        'Hôtel La Gazelle ★★★ — from 4,500 DZD/night',
      ],
      'openingHours': [
        'Basilica of St. Augustine: 08:00–12:00 / 14:00–18:00 | Free',
        'Hippo Regius Ruins: 08:00–17:00 | Closed Monday | 200 DZD',
        'Sable d\'Or Beach: Open all day | June–September | Free',
        'El Kala National Park: 07:00–19:00 daily | 100 DZD',
      ],
    },

    // ── SÉTIF ──────────────────────────────────────────────────
    {
      'name': 'Sétif',
      'image': 'assets/images/wilayas/setif.jpg',
      'color': 0xFF8B7355,
      'description': 'The Capital of the High Plateaus — Sétif is surrounded by spectacular archaeological treasures including the UNESCO ruins of Djémila, sweeping plateau landscapes, and the wild Babors mountains.',
      'categories': ['Culture', 'Mountain'],
      'bestTime': 'April–October',
      'famousFood': 'Chakhchoukha, Dolma, Couscous, Zgougou sweets',
      'coordinates': {'lat': 36.1898, 'lng': 5.4107},
      'attractions': [
        'Djemila Roman Ruins (UNESCO World Heritage)',
        'Sétif Archaeological Museum',
        'Ain El Fouara Fountain (historic symbol)',
        'Babors Mountains',
        'Beni Ourtilane Waterfalls',
        'Djemila Village',
        'Guergour Forest',
      ],
      'activities': [
        'Explore Djemila Roman Ruins (UNESCO) — 300 DZD | 08:00–17:30',
        'Visit Sétif Archaeological Museum — 100 DZD | 09:00–16:30',
        'Walk through Ain El Fouara park — Free',
        'Hike in the Babors Mountains — Free',
        'Visit Beni Ourtilane Waterfalls — Free',
        'Day trip to Jijel coast — varies',
      ],
      'hotels': [
        'Hôtel El Hidhab ★★★★ — from 11,000 DZD/night',
        'Hôtel Vieux Moulin ★★★★ — from 10,000 DZD/night',
        'Hôtel Sétif ★★★ — from 6,000 DZD/night',
        'Hôtel Djemila ★★★ — from 5,000 DZD/night',
      ],
      'openingHours': [
        'Djemila UNESCO Ruins: 08:00–17:30 daily | 300 DZD',
        'Sétif Museum: 09:00–16:30 | Closed Monday | 100 DZD',
        'Ain El Fouara Park: Open all day | Free',
        'Babors Mountains: Open all day | Free',
      ],
    },

    // ── SKIKDA ─────────────────────────────────────────────────
    {
      'name': 'Skikda',
      'image': 'assets/images/wilayas/skikda.jpg',
      'color': 0xFF3A7A6A,
      'description': 'The Emerald Bay — Skikda boasts some of Algeria\'s most stunning beaches and a spectacular bay, plus the remarkable Roman ruins of Rusicade, cedar forests, and the wild Collo peninsula.',
      'categories': ['Beach', 'Culture'],
      'bestTime': 'June–September',
      'famousFood': 'Grilled fish, Octopus salad, Couscous with seafood, Brik',
      'coordinates': {'lat': 36.8761, 'lng': 6.9003},
      'attractions': [
        'Stora Beach (crystal clear bay)',
        'Roman Ruins of Rusicade',
        'Skikda Archaeological Museum',
        'Collo Peninsula',
        'Filfila Nature Reserve',
        'La Marsa Beach',
        'Skikda Corniche',
      ],
      'activities': [
        'Swim at Stora and Chetaibi beaches — Free | June–September',
        'Explore Roman Ruins of Rusicade — 200 DZD | 08:00–17:00',
        'Visit Skikda Archaeological Museum — 100 DZD',
        'Boat trip around Skikda bay — 500–1500 DZD',
        'Hike the Collo Peninsula trails — Free',
        'Explore Filfila Nature Reserve — 100 DZD',
      ],
      'hotels': [
        'Hôtel Rusicade ★★★★ — from 10,000 DZD/night',
        'Hôtel Stora ★★★★ — from 9,500 DZD/night',
        'Hôtel Skikda ★★★ — from 5,500 DZD/night',
        'Résidence Les Pins ★★★ — from 4,500 DZD/night',
      ],
      'openingHours': [
        'Stora Beach: Open all day | June–September | Free',
        'Roman Ruins of Rusicade: 08:00–17:00 | Closed Monday | 200 DZD',
        'Filfila Nature Reserve: 07:00–18:00 daily | 100 DZD',
        'Collo Peninsula: Open all day | Free',
      ],
    },

    // ── ORAN ───────────────────────────────────────────────────
    {
      'name': 'Oran',
      'image': 'assets/images/wilayas/oran.jpg',
      'color': 0xFF91A8B0,
      'description': 'The Joyful City — Algeria\'s second city famous for Raï music, Fort Santa Cruz, beautiful beaches and French colonial architecture.',
      'categories': ['Beach', 'Culture'],
      'bestTime': 'April–June / September–October',
      'famousFood': 'Bouchée à la reine, El Kebab, Rechta',
      'coordinates': {'lat': 35.6973, 'lng': -0.6336},
      'attractions': [
        'Fort Santa Cruz (16th-century Spanish fortress)',
        'Bey\'s Palace — Palais du Bey',
        'Les Andalouses Beach',
        'Cathedral of Saint-Louis',
        'Santa Cruz Lighthouse',
        'Le Château Neuf',
        'Oran Museum of Modern Art',
      ],
      'activities': [
        'Visit Fort Santa Cruz — 100 DZD | 08:00–18:00',
        'Tour Bey\'s Palace — 200 DZD | 09:00–17:00',
        'Les Andalouses Beach — Free | June–September',
        'Raï music evening — 500–2000 DZD',
        'Stroll along the seafront Corniche — Free',
        'Visit Cathedral of Saint-Louis — Free | 09:00–17:00',
      ],
      'hotels': [
        'Hôtel Le Méridien Oran ★★★★★ — from 28,000 DZD/night',
        'Hôtel Sheraton Oran ★★★★★ — from 25,000 DZD/night',
        'Royal Hotel Oran ★★★★ — from 11,000 DZD/night',
        'Hôtel Timgad ★★★ — from 4,500 DZD/night',
      ],
      'openingHours': [
        'Fort Santa Cruz: 08:00–18:00 daily | 100 DZD',
        'Bey\'s Palace: 09:00–17:00 | Closed Monday | 200 DZD',
        'Les Andalouses Beach: Open all day | June–September | Free',
        'Cathedral of Saint-Louis: 09:00–17:00 | Closed Sunday | Free',
      ],
    },

    // ── TLEMCEN ────────────────────────────────────────────────
    {
      'name': 'Tlemcen',
      'image': 'assets/images/wilayas/tlemcen.jpg',
      'color': 0xFF7A6550,
      'description': 'The Pearl of the Maghreb — Algeria\'s most refined cultural city, a former medieval Islamic capital of staggering architectural beauty: magnificent mosques, palaces, Andalusian gardens, and the ruins of Mansourah.',
      'categories': ['Culture', 'Mountain'],
      'bestTime': 'April–June / September–October',
      'famousFood': 'Couscous tlemcenien, Mchermel, Bradj, Makrout, Rechta',
      'coordinates': {'lat': 34.8828, 'lng': -1.3147},
      'attractions': [
        'Great Mosque of Tlemcen (12th century)',
        'Ruins of Mansourah (14th-century city)',
        'Sidi Boumediene Mosque and Mausoleum',
        'Mechover Palace and Gardens',
        'Tlemcen National Park',
        'Beni Add Stalactite Caves',
        'Grand Synagogue of Tlemcen',
      ],
      'activities': [
        'Visit Great Mosque of Tlemcen — Free | 08:00–17:30',
        'Explore Mansourah Ruins — 100 DZD | 08:00–17:00',
        'Tour Sidi Boumediene Mosque — Free | 08:00–18:00',
        'Visit Beni Add Stalactite Caves — 200 DZD | 09:00–16:30',
        'Hike in Tlemcen National Park — 100 DZD | 07:00–18:00',
        'Attend Andalusian music festival (seasonal)',
      ],
      'hotels': [
        'Hôtel Les Zianides ★★★★ — from 11,000 DZD/night',
        'Hôtel Renaissance Tlemcen ★★★★ — from 12,000 DZD/night',
        'Hôtel Agadir ★★★ — from 6,000 DZD/night',
        'Hôtel Mansourah ★★★ — from 5,000 DZD/night',
      ],
      'openingHours': [
        'Great Mosque: 08:00–17:30 | Closed during prayer times | Free',
        'Sidi Boumediene: 08:00–18:00 daily | Free',
        'Mansourah Ruins: 08:00–17:00 daily | 100 DZD',
        'Beni Add Caves: 09:00–16:30 | Closed Monday | 200 DZD',
        'Tlemcen National Park: 07:00–18:00 daily | 100 DZD',
      ],
    },

    // ── MOSTAGANEM ─────────────────────────────────────────────
    {
      'name': 'Mostaganem',
      'image': 'assets/images/wilayas/mostaganem.jpg',
      'color': 0xFF5A8A9F,
      'description': 'The Perfumed City — famous for some of Algeria\'s most beautiful turquoise beaches, a charming Spanish-era old town, and the surrounding vineyards and orange groves of the Dahra mountains.',
      'categories': ['Beach', 'Culture'],
      'bestTime': 'June–September',
      'famousFood': 'Grilled fish, Moussem couscous, Chakhchouka, Sfenj',
      'coordinates': {'lat': 35.9311, 'lng': 0.0890},
      'attractions': [
        'Sayada Beach (crystal clear water)',
        'Stidia Beach (family resort)',
        'Tobana Spanish Quarter',
        'Mostaganem Old Medina',
        'Kharouba Cliffs and Beach',
        'Mostaganem Lighthouse',
        'Salamandre Beach',
      ],
      'activities': [
        'Swim at Sayada Beach — Free | June–September',
        'Explore Tobana Spanish Quarter — Free',
        'Visit Kharouba Cliffs and Beach — Free',
        'Swim at Stidia Beach Resort — Free | June–September',
        'Visit the local fish market at dawn — Free',
        'Tour the historic Ottoman Lighthouse — Free',
      ],
      'hotels': [
        'Hôtel Mazagran ★★★★ — from 10,000 DZD/night',
        'Hôtel Salamandre ★★★★ — from 9,500 DZD/night',
        'Hôtel Les Pins ★★★ — from 5,500 DZD/night',
        'Hôtel El Mordjane ★★★ — from 5,000 DZD/night',
      ],
      'openingHours': [
        'Sayada Beach: Open all day | June–September | Free',
        'Tobana Quarter: Open all day | Free',
        'Kharouba Cliffs: Open all day | Free',
        'Stidia Beach: Open all day | June–September | Free',
      ],
    },

    // ── SIDI BEL ABBÈS ─────────────────────────────────────────
    {
      'name': 'Sidi Bel Abbès',
      'image': 'assets/images/wilayas/sidibelabas.jpg',
      'color': 0xFF6B7A5E,
      'description': 'The City of the Foreign Legion — legendary headquarters of the French Foreign Legion for 132 years, now a prosperous city surrounded by vineyards, the Tessala mountains, and the Mekerra river valley.',
      'categories': ['Culture', 'Mountain'],
      'bestTime': 'April–October',
      'famousFood': 'Couscous, Mechaoui, Chakhchouka, Grilled lamb',
      'coordinates': {'lat': 35.1897, 'lng': -0.6306},
      'attractions': [
        'Foreign Legion Museum',
        'Tessala Mountains and Forest',
        'Museum of Anthropology',
        'Historic Foreign Legion Barracks',
        'Mekerra River Promenade',
        'Lartigue Park',
        'Djebel Tessala Summit',
      ],
      'activities': [
        'Visit the Foreign Legion Museum — 100 DZD | 09:00–16:30',
        'Hike in Tessala Mountains — Free',
        'Visit Museum of Anthropology — 100 DZD | 09:00–16:30',
        'Walk the Mekerra River Promenade — Free',
        'Explore Lartigue Park — Free',
        'Day trip to Tlemcen ruins — 100–200 DZD',
      ],
      'hotels': [
        'Hôtel Le Zenith ★★★★ — from 10,000 DZD/night',
        'Hôtel Méridional ★★★ — from 5,500 DZD/night',
        'Hôtel Tessala ★★★ — from 5,000 DZD/night',
        'Hôtel La Paix ★★★ — from 4,000 DZD/night',
      ],
      'openingHours': [
        'Foreign Legion Museum: 09:00–16:30 | Closed Monday | 100 DZD',
        'Tessala Mountains: Open all day | Free',
        'Museum of Anthropology: 09:00–16:30 | Closed Monday | 100 DZD',
        'Mekerra Promenade: Open all day | Free',
      ],
    },

    // ── BÉJAÏA ─────────────────────────────────────────────────
    {
      'name': 'Béjaïa',
      'image': 'assets/images/wilayas/bejaia.jpg',
      'color': 0xFF4E7C59,
      'description': 'The Gulf of Kings — where the mountains meet the sea. Dramatic Gouraya National Park cliffs, wild Barbary macaques and the highest cape in Algeria.',
      'categories': ['Beach', 'Mountain'],
      'bestTime': 'May–October',
      'famousFood': 'Grilled sardines, Merguez, Tajine, Olive oil dishes',
      'coordinates': {'lat': 36.7500, 'lng': 5.0833},
      'attractions': [
        'Gouraya National Park',
        'Cap Carbon — highest cape in Algeria',
        'Pic des Singes — wild Barbary macaques',
        'Yemma Gouraya Shrine',
        'Béjaïa Old Port and Citadel',
        'Tichi Beach',
        'Melbou Beach',
      ],
      'activities': [
        'Gouraya National Park hiking — 100 DZD | 07:00–18:00',
        'Cap Carbon hike — Free | Open all day',
        'Pic des Singes snorkelling — 100 DZD',
        'Tichi Beach — Free | May–October',
        'Visit Yemma Gouraya Shrine — Free',
        'Explore Béjaïa Old Port — Free',
      ],
      'hotels': [
        'Hôtel Saldae ★★★★ — from 9,000 DZD/night',
        'Hôtel Les Hammadites ★★★★ — from 10,000 DZD/night',
        'Hôtel Yemma ★★★ — from 5,000 DZD/night',
        'Club des Pins Béjaïa ★★★ — from 6,000 DZD/night',
      ],
      'openingHours': [
        'Gouraya National Park: 07:00–18:00 daily | 100 DZD',
        'Cap Carbon: Open all day | Free',
        'Tichi Beach: Open all day | May–October | Free',
        'Béjaïa Port: Open all day | Free',
      ],
    },

    // ── GHARDAÏA ───────────────────────────────────────────────
    {
      'name': 'Ghardaïa',
      'image': 'assets/images/wilayas/ghardaia.jpg',
      'color': 0xFFD4A853,
      'description': 'Heart of the M\'zab Valley — a UNESCO World Heritage site. Medieval cities built by the Mozabite Berbers in the 11th century.',
      'categories': ['Sahara', 'Culture'],
      'bestTime': 'October–April',
      'famousFood': 'Couscous with dates, Mahjouba, Tchicha, Méchoui',
      'coordinates': {'lat': 32.4833, 'lng': 3.6667},
      'attractions': [
        'M\'zab Valley (UNESCO World Heritage)',
        'Ghardaïa Old Mosque',
        'Beni Isguen Holy City',
        'Traditional Covered Market',
        'El Atteuf (oldest city in the valley)',
        'Ghardaïa Museum',
        'Desert dunes near Metlili',
      ],
      'activities': [
        'M\'zab Valley UNESCO tour — 300 DZD | 08:00–17:00',
        'Beni Isguen guided visit — 200 DZD | 09:00–16:00',
        'Camel riding in desert — 1000–3000 DZD/hour',
        '4x4 desert excursion — 3000–8000 DZD',
        'Watch traditional Mozabite carpet weaving — Free',
        'Visit Ghardaïa Museum — 100 DZD | 09:00–16:30',
      ],
      'hotels': [
        'Hôtel Atlantis ★★★★ — from 10,000 DZD/night',
        'Hôtel Timmi ★★★★ — from 9,000 DZD/night',
        'Hôtel La Rose du M\'zab ★★★ — from 5,500 DZD/night',
        'Hôtel La Palmeraie ★★★ — from 5,000 DZD/night',
      ],
      'openingHours': [
        'M\'zab Valley: 08:00–17:00 | Fridays restricted | 300 DZD',
        'Beni Isguen: 09:00–16:00 | Closed Fridays | 200 DZD',
        'Ghardaïa Souk: 08:00–12:00 / 15:00–18:00',
        'Ghardaïa Museum: 09:00–16:30 | Closed Monday | 100 DZD',
      ],
    },

    // ── TAMANRASSET ────────────────────────────────────────────
    {
      'name': 'Tamanrasset',
      'image': 'assets/images/wilayas/tamanrasset.jpg',
      'color': 0xFFD4A853,
      'description': 'Gateway to the Hoggar — lunar volcanic landscapes, Tuareg culture, prehistoric rock art and the sacred Assekrem sunrise.',
      'categories': ['Sahara', 'Mountain'],
      'bestTime': 'October–March',
      'famousFood': 'Tuareg couscous, Méchoui, Aghajira, Mint tea',
      'coordinates': {'lat': 22.7850, 'lng': 5.5228},
      'attractions': [
        'Assekrem Plateau sunrise (2,728m)',
        'Hoggar Mountains (Atakor Massif)',
        'Tassili n\'Ajjer UNESCO rock art',
        'Tuareg Cultural Village',
        'Charles de Foucauld Hermitage',
        'Abalessa (Tin Hinan tomb)',
        'Erg Admer Sand Dunes',
      ],
      'activities': [
        'Assekrem sunrise — Free | 05:30–07:30 | 4x4 required',
        'Tassili n\'Ajjer rock art — 500 DZD | Guided',
        'Camel trekking — 2000–5000 DZD/day',
        'Stargazing — Free',
        '4x4 excursion to Hoggar formations — 3000–8000 DZD',
        'Visit Tuareg Market — Free | Thursday mornings',
      ],
      'hotels': [
        'Hôtel Tahat ★★★★ — from 12,000 DZD/night',
        'Hôtel Tin Hinan ★★★ — from 7,000 DZD/night',
        'Hôtel Tidikelt ★★★ — from 6,000 DZD/night',
        'Desert Camp Assekrem — from 15,000 DZD/person',
      ],
      'openingHours': [
        'Assekrem Sunrise: Best 05:30–07:30 | 4x4 required | Free',
        'Tassili n\'Ajjer: 08:00–17:00 | Guide required | 500 DZD',
        'Tuareg Market: 07:00–13:00 | Thursday | Free',
      ],
    },

    // ── CONSTANTINE ────────────────────────────────────────────
    {
      'name': 'Constantine',
      'image': 'assets/images/wilayas/constantine.jpg',
      'color': 0xFFA39C7C,
      'description': 'The City of Bridges — perched dramatically on a rocky plateau above the Rhumel Gorges. One of the oldest continuously inhabited cities in the world.',
      'categories': ['Culture', 'Mountain'],
      'bestTime': 'May–September',
      'famousFood': 'Chakhchoukha, Merguez, Rechta, Baklawa',
      'coordinates': {'lat': 36.3650, 'lng': 6.6147},
      'attractions': [
        'Sidi M\'Cid Suspension Bridge (175m above the gorge)',
        'Ahmed Bey Palace (300-room Ottoman palace)',
        'Rhumel Gorges',
        'Cable Car over the gorges',
        'Cirta Museum',
        'Emir Abdelkader Mosque',
        'Timgad Roman Ruins — UNESCO (2h drive)',
      ],
      'activities': [
        'Walk Sidi M\'Cid suspension bridge — Free | Open 24h',
        'Visit Ahmed Bey Palace — 200 DZD | 09:00–17:00',
        'Cable car ride — 150 DZD | 08:30–17:30',
        'Cirta Museum — 100 DZD | 09:00–16:30',
        'Day trip to Timgad Roman Ruins — 300 DZD',
        'Explore the old medina — Free',
      ],
      'hotels': [
        'Constantine Marriott Hotel ★★★★★ — from 22,000 DZD/night',
        'Protea Hotel by Marriott ★★★★ — from 12,000 DZD/night',
        'Hôtel Cirta ★★★★ — from 9,000 DZD/night',
        'Hôtel Panorama ★★★ — from 5,000 DZD/night',
      ],
      'openingHours': [
        'Sidi M\'Cid Bridge: Open 24 hours | Free',
        'Ahmed Bey Palace: 09:00–17:00 | Closed Monday | 200 DZD',
        'Cable Car: 08:30–17:30 | Closed Tuesday | 150 DZD',
        'Timgad UNESCO Ruins: 08:00–17:00 daily | 300 DZD',
      ],
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    var list = _wilayas;
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
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
    _entranceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnims = List.generate(4, (i) {
      final start = i * 0.15;
      final end = (start + 0.55).clamp(0.0, 1.0);
      return CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(start, end, curve: Curves.easeOut));
    });
    _slideAnims = List.generate(4, (i) {
      final start = i * 0.15;
      final end = (start + 0.55).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
          .animate(CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(start, end, curve: Curves.easeOut)));
    });
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  void _switchCategory(String cat) {
    setState(() => _selectedCategory = cat);
    _entranceCtrl.reset();
    _entranceCtrl.forward();
  }

  void _showFilterSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: LuxTheme.cream, borderRadius: LuxTheme.radius20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: LuxTheme.sandDark,
                    borderRadius: LuxTheme.radiusPill),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Filter Destinations', style: LuxTheme.titleLg),
            const SizedBox(height: 20),
            const GoldDivider(label: 'EXPERIENCE TYPE'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ['All', 'Beach', 'Mountain', 'Sahara', 'Culture'].map((cat) {
                final selected = _selectedCategory == cat;
                return PressScale(
                  onTap: () { Navigator.pop(context); _switchCategory(cat); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: selected ? const LinearGradient(
                          colors: [LuxTheme.terracotta, LuxTheme.terracottaL]) : null,
                      color: selected ? null : LuxTheme.sand,
                      borderRadius: LuxTheme.radiusPill,
                      border: Border.all(
                          color: selected ? Colors.transparent : LuxTheme.sandDark),
                      boxShadow: selected ? LuxTheme.terrShadow : LuxTheme.cardShadow,
                    ),
                    child: Text(cat, style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : LuxTheme.mocha,
                    )),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const GoldDivider(label: 'SORT BY'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ['A–Z', 'Z–A'].map((sort) {
                return PressScale(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      if (sort == 'A–Z') {
                        _wilayas.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
                      } else {
                        _wilayas.sort((a, b) => (b['name'] as String).compareTo(a['name'] as String));
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: LuxTheme.sand,
                      borderRadius: LuxTheme.radiusPill,
                      border: Border.all(color: LuxTheme.sandDark),
                      boxShadow: LuxTheme.cardShadow,
                    ),
                    child: Text(sort, style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: LuxTheme.mocha)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: LuxButton(
                label: 'Clear Filters',
                icon: Icons.refresh_rounded,
                outlined: true,
                onTap: () { Navigator.pop(context); _switchCategory('All'); },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  NOTIFICATIONS SHEET  —  Redesigned
  // ══════════════════════════════════════════════════════════
  void _showNotificationsSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: LuxTheme.cream,
          borderRadius: LuxTheme.radius20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ──
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: LuxTheme.sandDark,
                    borderRadius: LuxTheme.radiusPill),
              ),
            ),
            const SizedBox(height: 20),

            // ── Header row ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [LuxTheme.gold, LuxTheme.goldLight]),
                    borderRadius: LuxTheme.radius12,
                  ),
                  child: const Icon(Icons.notifications_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Travel Updates',
                        style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: LuxTheme.espresso)),
                    Text('Tips & seasonal reminders',
                        style: LuxTheme.caption),
                  ],
                )),
                PressScale(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                        color: LuxTheme.sand,
                        shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded,
                        size: 16, color: LuxTheme.mocha),
                  ),
                ),
              ]),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 1,
                decoration: const BoxDecoration(gradient: LuxTheme.goldGrad),
              ),
            ),
            const SizedBox(height: 16),

            // ── Notification tiles ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                _NotifTile(
                  icon: Icons.wb_sunny_rounded,
                  color: LuxTheme.gold,
                  label: 'SEASON',
                  title: 'Perfect travel weather',
                  body: 'Spring is ideal across northern Algeria. March–May brings mild temperatures and blooming landscapes.',
                ),
                const SizedBox(height: 10),
                _NotifTile(
                  icon: Icons.terrain_rounded,
                  color: const Color(0xFF4E7C59),
                  label: 'MOUNTAIN',
                  title: 'Djurdjura is calling',
                  body: 'May–October is prime season for Kabylie hiking. Snow caps recede revealing lush cedar trails.',
                ),
                const SizedBox(height: 10),
                _NotifTile(
                  icon: Icons.wb_twighlight,
                  color: LuxTheme.terracotta,
                  label: 'SAHARA',
                  title: 'Hoggar at its best',
                  body: 'Plan Tamanrasset for October–March. Cool nights, clear skies — stargazing season is open.',
                ),
                const SizedBox(height: 10),
                _NotifTile(
                  icon: Icons.beach_access_rounded,
                  color: const Color(0xFF2E86AB),
                  label: 'COAST',
                  title: 'Beach season starting',
                  body: 'Jijel, Béjaïa, and Skikda open up June–September. Book accommodations early for peak weeks.',
                ),
                const SizedBox(height: 10),
                _NotifTile(
                  icon: Icons.favorite_rounded,
                  color: LuxTheme.terracotta,
                  label: 'TIP',
                  title: 'Save your favourites',
                  body: 'Tap ♥ on any destination card to build your personal travel wishlist.',
                ),
              ]),
            ),

            const SizedBox(height: 20),

            // ── Bottom CTA ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: LuxButton(
                label: 'Plan a Trip Now',
                icon: Icons.auto_awesome_rounded,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
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
          title: FadeSlideIn(
            fade: _fadeAnims[0],
            slide: _slideAnims[0],
            child: RichText(
                text: const TextSpan(children: [
                  TextSpan(
                      text: 'Plan',
                      style: TextStyle(
                          fontFamily: 'Georgia', fontSize: 22,
                          fontWeight: FontWeight.w700, color: LuxTheme.espresso)),
                  TextSpan(
                      text: 'Go',
                      style: TextStyle(
                          fontFamily: 'Georgia', fontSize: 22,
                          fontWeight: FontWeight.w700, color: LuxTheme.terracotta)),
                  TextSpan(
                      text: ' DZ',
                      style: TextStyle(
                          fontFamily: 'Georgia', fontSize: 22,
                          fontWeight: FontWeight.w700, color: LuxTheme.gold)),
                ])),
          ),
          actions: [
            FadeSlideIn(
              fade: _fadeAnims[0],
              slide: _slideAnims[0],
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: PressScale(
                  onTap: _showNotificationsSheet,
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: LuxTheme.cream,
                      borderRadius: LuxTheme.radius10,
                      boxShadow: LuxTheme.cardShadow,
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      const Icon(Icons.notifications_rounded,
                          color: LuxTheme.mocha, size: 22),
                      // ── Notification dot ──
                      Positioned(
                        top: 8, right: 8,
                        child: Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            color: LuxTheme.terracotta,
                            shape: BoxShape.circle,
                            border: Border.all(color: LuxTheme.cream, width: 1.5),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),

        // ── Hero greeting ──
        SliverToBoxAdapter(
          child: FadeSlideIn(
            fade: _fadeAnims[0],
            slide: _slideAnims[0],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Discover', style: LuxTheme.displayLg),
                Row(children: [
                  const Text('Algeria', style: LuxTheme.displayLg),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [LuxTheme.gold, LuxTheme.goldLight]),
                        borderRadius: LuxTheme.radiusPill),
                    child: const Text('✦',
                        style: TextStyle(
                            color: Colors.white, fontSize: 9,
                            fontWeight: FontWeight.w800, letterSpacing: 1.4)),
                  ),
                ]),
                const SizedBox(height: 6),
                Text('Curated journeys across 69 wilayas', style: LuxTheme.body),
              ]),
            ),
          ),
        ),

        // ── Search bar ──
        SliverToBoxAdapter(
          child: FadeSlideIn(
            fade: _fadeAnims[1],
            slide: _slideAnims[1],
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
                      style: LuxTheme.titleMd.copyWith(
                          color: LuxTheme.espresso, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: 'Search destinations…',
                        hintStyle: LuxTheme.body.copyWith(color: LuxTheme.latte, height: 1),
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: LuxTheme.latte, size: 21),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  PressScale(
                    onTap: _showFilterSheet,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [LuxTheme.gold, LuxTheme.goldLight]),
                        borderRadius: LuxTheme.radius10,
                        boxShadow: LuxTheme.goldShadow,
                      ),
                      child: const Icon(Icons.tune_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),

        // ── Category label ──
        SliverToBoxAdapter(
          child: FadeSlideIn(
            fade: _fadeAnims[1],
            slide: _slideAnims[1],
            child: const Padding(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 14),
              child: GoldDivider(label: 'EXPLORE BY TYPE'),
            ),
          ),
        ),

        // ── Categories ──
        SliverToBoxAdapter(
          child: FadeSlideIn(
            fade: _fadeAnims[1],
            slide: _slideAnims[1],
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (_, i) => _CategoryPill(
                  _categories[i],
                  _selectedCategory == _categories[i]['name'],
                      () => _switchCategory(_categories[i]['name']),
                ),
              ),
            ),
          ),
        ),

        // ── Featured label ──
        SliverToBoxAdapter(
          child: FadeSlideIn(
            fade: _fadeAnims[2],
            slide: _slideAnims[2],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Featured Destinations', style: LuxTheme.titleLg),
                    Text('${_filtered.length} destinations',
                        style: const TextStyle(
                            fontSize: 13,
                            color: LuxTheme.terracotta,
                            fontWeight: FontWeight.w600)),
                  ]),
            ),
          ),
        ),

        // ── Destination cards ──
        SliverToBoxAdapter(
          child: SizedBox(
            height: 260,
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

        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }

  Widget _other() {
    switch (_selectedIndex) {
      case 1:  return const _PlanScreen();
      case 2:  return const MyTripsScreen();
      case 3:  return const FavoritesPage();
      case 4:  return const ProfilePage();
      default: return _home();
    }
  }

  Widget _navBar() {
    return Container(
      decoration: BoxDecoration(
        color: LuxTheme.cream,
        border: Border(top: BorderSide(color: LuxTheme.sandDark, width: 1)),
        boxShadow: [BoxShadow(
            color: LuxTheme.espresso.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded,           label: 'Home',     index: 0, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
              _NavItem(icon: Icons.calendar_today_rounded, label: 'Plan',     index: 1, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
              _NavItem(icon: Icons.luggage_rounded,        label: 'My Trips', index: 2, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
              _NavItem(icon: Icons.favorite_rounded,       label: 'Saved',    index: 3, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
              _NavItem(icon: Icons.person_rounded,         label: 'Profile',  index: 4, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  WIDGETS
// ═══════════════════════════════════════════════════════════════

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index, selected;
  final ValueChanged<int> onTap;
  const _NavItem({required this.icon, required this.label,
    required this.index, required this.selected, required this.onTap});

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
          Text(label, style: TextStyle(
              fontSize: 10,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? LuxTheme.terracotta : LuxTheme.latte)),
        ]),
      ),
    );
  }
}

class _CategoryPill extends StatefulWidget {
  final Map<String, dynamic> cat;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryPill(this.cat, this.selected, this.onTap);
  @override
  State<_CategoryPill> createState() => _CategoryPillState();
}

class _CategoryPillState extends State<_CategoryPill>
    with SingleTickerProviderStateMixin {
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
            border: Border.all(
                color: widget.selected ? col : LuxTheme.sandDark, width: 1.2),
            boxShadow: widget.selected
                ? [BoxShadow(color: col.withOpacity(0.30), blurRadius: 10, offset: const Offset(0, 3))]
                : LuxTheme.cardShadow,
          ),
          child: Row(children: [
            Icon(widget.cat['icon'] as IconData, size: 16,
                color: widget.selected ? Colors.white : LuxTheme.latte),
            const SizedBox(width: 7),
            Text(widget.cat['name'] as String,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: widget.selected ? Colors.white : LuxTheme.mocha)),
          ]),
        ),
      ),
    );
  }
}

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
    final end = (start + 0.4).clamp(0.0, 1.0);
    final curve = Interval(start, end, curve: Curves.easeOut);
    _fade = CurvedAnimation(parent: widget.parentCtrl, curve: curve);
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: widget.parentCtrl, curve: curve));
    _tap = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
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
                name: w['name'],
                icon: Icons.location_on_rounded,
                color: Color(w['color'] as int),
                imagePath: w['image'],
                description: w['description'],
                attractions: List<String>.from(w['attractions']),
                bestTime: w['bestTime'],
                famousFood: w['famousFood'],
                hotels: List<String>.from(w['hotels'] ?? []),
                openingHours: List<String>.from(w['openingHours'] ?? []),
                coordinates: Map<String, double>.from(
                  (w['coordinates'] as Map).map(
                        (k, v) => MapEntry(k as String, (v as num).toDouble()),
                  ),
                ),
              ),
              transitionsBuilder: (_, a, __, child) =>
                  FadeTransition(opacity: a, child: child),
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
                Stack(children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(w['image'],
                        height: 170, width: double.infinity, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 170,
                          decoration: BoxDecoration(
                              gradient: LuxTheme.terracottaGrad,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          child: const Center(child: Icon(Icons.landscape_rounded,
                              size: 52, color: Colors.white54)),
                        )),
                  ),
                  Positioned.fill(child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: const DecoratedBox(
                        decoration: BoxDecoration(gradient: LuxTheme.heroOverlay)),
                  )),
                  Positioned(
                      top: 12, left: 12,
                      child: GoldBadge(label: (w['categories'] as List).first)),
                  Positioned(
                    top: 10, right: 10,
                    child: PressScale(
                      scale: 0.88,
                      onTap: () async {
                        final lat = w['coordinates']['lat'];
                        final lng = w['coordinates']['lng'];
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
                            boxShadow: LuxTheme.cardShadow),
                        child: const Icon(Icons.navigation_rounded,
                            size: 15, color: LuxTheme.terracotta),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10, left: 12, right: 12,
                    child: Text(w['name'],
                        style: const TextStyle(
                            fontFamily: 'Georgia', fontSize: 18,
                            fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Row(children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 13, color: LuxTheme.latte),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                          w['bestTime'].toString().split('/').first.trim(),
                          style: LuxTheme.caption.copyWith(fontSize: 11),
                          overflow: TextOverflow.ellipsis),
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

// ── Plan Screen ───────────────────────────────────────────────
class _PlanScreen extends StatelessWidget {
  const _PlanScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LuxTheme.sand,
    body: SafeArea(
      child: SingleChildScrollView(
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
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AITripPlannerPage())),
          ),
          const SizedBox(height: 16),
          _PlanOption(
            icon: Icons.edit_calendar_rounded,
            title: 'Manual Planner',
            subtitle: 'Build your own itinerary day by day',
            color: LuxTheme.gold,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ManualTripPlannerPage())),
          ),
        ]),
      ),
    ),
  );
}

class _PlanOption extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final String? badge;
  final Color color;
  final VoidCallback onTap;
  const _PlanOption({required this.icon, required this.title,
    required this.subtitle, this.badge, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => PressScale(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: LuxTheme.cream,
          borderRadius: LuxTheme.radius20,
          boxShadow: LuxTheme.cardShadow,
          border: Border.all(color: color.withOpacity(0.2), width: 1.2)),
      child: Row(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
              color: color.withOpacity(0.1), borderRadius: LuxTheme.radius14),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(title, style: LuxTheme.titleMd.copyWith(color: color)),
            if (badge != null) ...[
              const SizedBox(width: 8),
              GoldBadge(label: badge!)
            ],
          ]),
          const SizedBox(height: 4),
          Text(subtitle, style: LuxTheme.body.copyWith(fontSize: 12, height: 1.4)),
        ])),
        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color.withOpacity(0.5)),
      ]),
    ),
  );
}

// ── Notification Tile ─────────────────────────────────────────
class _NotifTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, title, body;
  const _NotifTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: LuxTheme.sand,
      borderRadius: LuxTheme.radius14,
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: LuxTheme.radius10,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: LuxTheme.radiusPill,
            ),
            child: Text(label,
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 0.8)),
          ),
        ]),
        const SizedBox(height: 5),
        Text(title,
            style: LuxTheme.titleMd.copyWith(fontSize: 13, color: LuxTheme.espresso)),
        const SizedBox(height: 3),
        Text(body,
            style: LuxTheme.body.copyWith(fontSize: 12, height: 1.4, color: LuxTheme.mocha)),
      ])),
    ]),
  );
}