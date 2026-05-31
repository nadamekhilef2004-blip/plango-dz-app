// ═══════════════════════════════════════════════════════════════
//  WILAYA DATA  —  PlangoDZ  (English)
//  Rich tourism data: activities, hotels, attractions, hours
//  Wilayas: Algiers, Tipaza, Blida, Tizi Ouzou, Guelma, Jijel,
//           Annaba, Sétif, Skikda, Oran, Tlemcen, Mostaganem,
//           Sidi Bel Abbès, Ghardaïa, Tamanrasset,
//           Constantine, Béjaïa
// ═══════════════════════════════════════════════════════════════

class WilayaData {
  final String name;
  final String region;
  final String imagePath;
  final List<String> categories;
  final List<String> activities;
  final List<String> attractions;
  final List<String> hotels;
  final List<String> restaurants;
  final List<TouristZone> touristZones;
  final double defaultPricePerDay;
  final String bestTime;
  final String famousFood;
  final String description;
  final Map<String, double> coordinates;

  WilayaData({
    required this.name,
    required this.region,
    required this.imagePath,
    required this.categories,
    required this.activities,
    required this.attractions,
    required this.hotels,
    required this.restaurants,
    required this.touristZones,
    required this.defaultPricePerDay,
    required this.bestTime,
    required this.famousFood,
    required this.description,
    required this.coordinates,
  });
}

class TouristZone {
  final String name;
  final String description;
  final String openingHours;
  final String closingDay;
  final String type;
  final double? entryFee;

  const TouristZone({
    required this.name,
    required this.description,
    required this.openingHours,
    required this.closingDay,
    required this.type,
    this.entryFee,
  });
}

// ───────────────────────────────────────────────────────────────
final List<WilayaData> allWilayas = [

  // ══════════════════════════════════════════════════════════════
  // 1. ALGIERS
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Algiers',
    region: 'Centre',
    imagePath: 'assets/images/wilayas/alger.jpg',
    categories: ['Beach', 'Culture'],
    description:
    'The White City — Algeria\'s vibrant capital blends Ottoman heritage, French boulevards, and a stunning Mediterranean waterfront. Home to the UNESCO-listed Casbah and the world\'s third-largest mosque.',
    bestTime: 'March–May / September–November',
    famousFood: 'Couscous, Merguez, Baklawa, Chorba',
    coordinates: {'lat': 36.7538, 'lng': 3.0588},
    defaultPricePerDay: 9000,
    activities: [
      'Tour the UNESCO Casbah quarter',
      'Visit the Great Mosque of Algiers',
      'Stroll along the waterfront Corniche',
      'Explore Jardin d\'Essai botanical garden',
      'Day trip to Roman ruins at Tipaza',
      'Shopping at Rue Didouche Mourad',
      'Visit Notre-Dame d\'Afrique basilica',
      'Boat trip in the Bay of Algiers',
    ],
    attractions: [
      'Casbah of Algiers (UNESCO)',
      'Great Mosque of Algiers (Djamaa el Djazair)',
      'Notre-Dame d\'Afrique',
      'Jardin d\'Essai du Hamma',
      'Bardo National Museum',
      'Monument of the Martyrs (Maqam Echahid)',
      'Tipaza Roman Ruins (day trip)',
    ],
    hotels: [
      'Hotel El Aurassi ★★★★★ — panoramic city views, pool, spa',
      'Sheraton Club des Pins ★★★★★ — private beach, resort',
      'Hotel Sofitel Algiers Hamma Garden ★★★★★',
      'Hotel Mercure Alger ★★★★ — central location',
      'Hotel Albert 1er ★★★ — budget-friendly city centre',
    ],
    restaurants: [
      'El Djenina — traditional Algerian cuisine',
      'Le Tantra — rooftop Mediterranean dining',
      'Cafe Tonton — iconic local cafe',
      'La Brasserie — French-Algerian fusion',
      'Restaurant Timgad — upscale Algerian',
    ],
    touristZones: [
      TouristZone(
        name: 'Casbah of Algiers',
        description:
        'UNESCO World Heritage Site. A labyrinth of narrow Ottoman-era streets, palaces, mosques and traditional houses dating to the 16th century.',
        openingHours: '08:00 – 18:00',
        closingDay: 'Open daily',
        type: 'Historic Quarter',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Great Mosque of Algiers',
        description:
        'The world\'s third-largest mosque, completed in 2019. Features a 265m minaret (tallest in the world), library, and museum.',
        openingHours: '09:00 – 17:00',
        closingDay: 'Friday mornings closed to tourists',
        type: 'Mosque',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Notre-Dame d\'Afrique',
        description:
        'A 19th-century Catholic basilica perched on a cliff overlooking the Bay of Algiers. Open to all faiths.',
        openingHours: '08:00 – 19:00',
        closingDay: 'Open daily',
        type: 'Religious Site',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Jardin d\'Essai du Hamma',
        description:
        'One of the oldest botanical gardens in Africa, founded in 1832. Over 3,000 plant species.',
        openingHours: '08:00 – 17:30',
        closingDay: 'Open daily',
        type: 'Park and Garden',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Bardo National Museum',
        description:
        'Housed in an Ottoman palace, showcasing prehistoric and Islamic artefacts from across Algeria.',
        openingHours: '09:00 – 16:30',
        closingDay: 'Closed Monday',
        type: 'Museum',
        entryFee: 200,
      ),
      TouristZone(
        name: 'Monument of the Martyrs',
        description:
        'Iconic 92m concrete monument commemorating Algerian independence. Free to visit, panoramic views.',
        openingHours: '08:00 – 20:00',
        closingDay: 'Open daily',
        type: 'Monument',
        entryFee: 0,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 2. TIPAZA
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Tipaza',
    region: 'Centre',
    imagePath: 'assets/images/wilayas/tipaza.jpg',
    categories: ['Beach', 'Culture'],
    description:
    'A UNESCO World Heritage jewel — Tipaza is home to the most spectacular Roman and Phoenician ruins in North Africa, set dramatically against the blue Mediterranean. Albert Camus immortalised its light and beauty in his essays.',
    bestTime: 'March–June / September–November',
    famousFood: 'Grilled fish, Couscous, Chorba, Fresh seafood',
    coordinates: {'lat': 36.5911, 'lng': 2.4477},
    defaultPricePerDay: 7000,
    activities: [
      'Explore Tipaza Roman Ruins (UNESCO)',
      'Visit the Tomb of the Christian — Royal Mausoleum of Mauretania',
      'Swim at Tipaza beach beside the ruins',
      'Visit the Tipaza Archaeological Museum',
      'Explore the Phoenician ruins of Kbour er Roumia',
      'Day trip to Chenoua mountain hike',
      'Visit the Church of Alexander Severus ruins',
      'Boat trip along the Tipaza coastline',
    ],
    attractions: [
      'Tipaza Roman Ruins (UNESCO World Heritage)',
      'Royal Mausoleum of Mauretania (Tomb of the Christian)',
      'Tipaza Archaeological Museum',
      'Tipaza Beach beside ancient ruins',
      'Chenoua Mountain',
      'Ruins of the Great Basilica',
      'Phoenician Necropolis',
      'Theatre and Nymphaeum ruins',
    ],
    hotels: [
      'Hotel Club des Pins ★★★★★ — luxury beachfront resort',
      'Hotel Matarès ★★★★ — sea views, pool',
      'Hotel Tipaza ★★★ — near ruins, affordable',
      'Résidence Les Oliviers ★★★ — family apartments',
      'Hotel Chenoua Plage ★★★ — beachside',
    ],
    restaurants: [
      'La Madrague — fresh fish on the seafront',
      'Restaurant Tipaza — traditional Algerian cuisine',
      'Chez Mimoun — grills and local dishes',
      'Le Rocher — cliff-top terrace',
      'Café Camus — named after the famous writer',
    ],
    touristZones: [
      TouristZone(
        name: 'Tipaza Roman Ruins (UNESCO)',
        description:
        'One of North Africa\'s finest Roman and Phoenician archaeological sites, dating from the 3rd century BC. Temples, a theatre, nymphaeum, and basilicas overlooking the sea.',
        openingHours: '08:00 – 17:30',
        closingDay: 'Open daily',
        type: 'Archaeological Site',
        entryFee: 300,
      ),
      TouristZone(
        name: 'Royal Mausoleum of Mauretania',
        description:
        'A massive 60m-diameter circular mausoleum built in the 3rd century BC for Berber King Juba II and Queen Cleopatra Selene. Also called Tomb of the Christian.',
        openingHours: '08:00 – 17:00',
        closingDay: 'Closed Monday',
        type: 'Archaeological Monument',
        entryFee: 200,
      ),
      TouristZone(
        name: 'Tipaza Archaeological Museum',
        description:
        'Houses remarkable mosaic floors, statues, coins, and artefacts recovered from the Tipaza excavations. Essential companion to the outdoor ruins.',
        openingHours: '08:00 – 16:30',
        closingDay: 'Closed Monday',
        type: 'Museum',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Tipaza Beach',
        description:
        'A stunning beach where Roman columns rise from the sand and sea. One of the most unique swimming spots in the world — ruins and Mediterranean combined.',
        openingHours: 'Open all day',
        closingDay: 'Open daily',
        type: 'Beach and Heritage',
        entryFee: 0,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 3. BLIDA
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Blida',
    region: 'Centre',
    imagePath: 'assets/images/wilayas/blida.jpg',
    categories: ['Mountain', 'Culture'],
    description:
    'The City of Roses — Blida sits at the foot of the spectacular Tell Atlas mountains, famous for its rose gardens, orange blossom fragrance, cedar forests, and the dramatic Chiffa Gorge where wild Barbary macaques roam.',
    bestTime: 'March–June / September–November',
    famousFood: 'Rose jam, Orange blossom water pastries, Couscous, Rechta',
    coordinates: {'lat': 36.4692, 'lng': 2.8277},
    defaultPricePerDay: 6000,
    activities: [
      'Hike in Chrea National Park through cedar forests',
      'Spot Barbary macaques in Chiffa Gorge',
      'Visit the rose gardens and orange groves',
      'Ski at Chrea ski station (December–February)',
      'Explore the historic mosque of Sidi Ahmed Kébir',
      'Walk the scenic Oued Chiffa valley trail',
      'Visit the Blida Museum of Natural History',
      'Day trip to Medea historic city',
    ],
    attractions: [
      'Chrea National Park (cedar forests)',
      'Chiffa Gorge (Barbary macaques)',
      'Chrea Ski Station',
      'Mosque of Sidi Ahmed Kebir',
      'Blida Rose Gardens',
      'Oued Chiffa Valley',
      'Blida Old Medina',
      'Medea Historic City (day trip)',
    ],
    hotels: [
      'Hotel Atlas Blida ★★★★ — mountain views, restaurant',
      'Hotel Chrea ★★★ — ski resort setting',
      'Hotel du Parc ★★★ — near rose gardens',
      'Hotel El Mountazah ★★★ — city centre, reliable',
      'Chalet Chiffa ★★★ — gorge-side, unique setting',
    ],
    restaurants: [
      'Restaurant Chiffa — gorge-view dining, grills',
      'Chez Lamine — traditional blidi cuisine',
      'La Rose — garden setting, Algerian cuisine',
      'Restaurant Atlas — mountain views',
      'Cafe Oued Chiffa — riverside terrace',
    ],
    touristZones: [
      TouristZone(
        name: 'Chrea National Park',
        description:
        'A spectacular national park in the Tell Atlas at 1,500m altitude. Ancient cedar forests, hiking trails, mountain wildlife, and Algeria\'s only ski resort.',
        openingHours: '07:00 – 18:00',
        closingDay: 'Open daily',
        type: 'National Park',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Chiffa Gorge (Ravin de la Femme Sauvage)',
        description:
        'A magnificent limestone gorge carved by the Oued Chiffa river. Famous for colonies of wild Barbary macaques who approach visitors. Dramatic cliffs and waterfalls.',
        openingHours: 'Open all day',
        closingDay: 'Open daily',
        type: 'Natural Wonder',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Chrea Ski Station',
        description:
        'Algeria\'s most popular ski resort at 1,500m in the Tell Atlas. Open December to February with ski runs, chairlifts, and mountain chalets.',
        openingHours: '08:00 – 16:30',
        closingDay: 'Open daily (winter season)',
        type: 'Ski Resort',
        entryFee: 500,
      ),
      TouristZone(
        name: 'Blida Rose Gardens',
        description:
        'Blida is renowned across Algeria for its roses and orange blossoms. The city gardens are at their best in April–May when the fragrance fills the air.',
        openingHours: '08:00 – 18:00',
        closingDay: 'Open daily',
        type: 'Garden',
        entryFee: 0,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 4. TIZI OUZOU
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Tizi Ouzou',
    region: 'Centre',
    imagePath: 'assets/images/wilayas/Tizi_Ouzou.jpg',
    categories: ['Mountain', 'Culture'],
    description:
    'The capital of Kabylie — a land of proud Berber culture, dramatic Djurdjura mountain peaks, traditional red-roofed stone villages perched on cliff edges, and the turquoise waters of the Aghribs coast.',
    bestTime: 'May–October',
    famousFood: 'Aghrum (Kabyle bread), Tafraout, Couscous berber, Tamtunt',
    coordinates: {'lat': 36.7167, 'lng': 4.0500},
    defaultPricePerDay: 6500,
    activities: [
      'Hike in Djurdjura National Park',
      'Explore traditional Kabyle villages (Ath Yenni, Beni Yenni)',
      'Visit the silver jewellery workshops of Beni Yenni',
      'Trek to the summit of Lalla Khedidja (2,308m)',
      'Swim at Aghribs and Tigzirt beaches',
      'Attend a Kabyle cultural festival',
      'Visit the Tizi Ouzou Mouloud Mammeri Museum',
      'Explore the Gorges of Palestro',
    ],
    attractions: [
      'Djurdjura National Park (UNESCO Biosphere)',
      'Lalla Khedidja Summit (2,308m)',
      'Beni Yenni (silver jewellery village)',
      'Tigzirt Roman Ruins and Beach',
      'Ath Yenni Village',
      'Aghribs Beach',
      'Fort National (historic fort)',
      'Mouloud Mammeri University Museum',
    ],
    hotels: [
      'Hotel Belloua ★★★★ — mountain panoramic views',
      'Hotel Djurdjura ★★★ — near national park',
      'Hotel Lalla Khedidja ★★★ — town centre',
      'Hotel Tagmount ★★★ — traditional style',
      'Gite Rural Ath Yenni — authentic village stay',
    ],
    restaurants: [
      'Restaurant Djurdjura — traditional Kabyle cuisine',
      'Chez Hamid — mountain grills and couscous',
      'La Chaumière — European-Algerian menu',
      'Restaurant Tigzirt — seafood near the coast',
      'Cafe Mouloud — beloved local spot',
    ],
    touristZones: [
      TouristZone(
        name: 'Djurdjura National Park',
        description:
        'A UNESCO Biosphere Reserve with soaring limestone peaks, ancient cedar forests, endemic wildlife, and some of Algeria\'s most dramatic mountain scenery.',
        openingHours: '07:00 – 18:00',
        closingDay: 'Open daily',
        type: 'National Park',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Beni Yenni Silver Village',
        description:
        'A historic Kabyle village famous for centuries-old silver filigree jewellery craft. Artisans still work in traditional workshops. Unique souvenirs.',
        openingHours: '09:00 – 17:00',
        closingDay: 'Open daily',
        type: 'Cultural Village',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Tigzirt Roman Ruins and Beach',
        description:
        'A charming coastal town with Roman ruins, an ancient lighthouse, and a beautiful beach. The ruins of a 4th-century basilica sit above the turquoise sea.',
        openingHours: '08:00 – 17:00',
        closingDay: 'Open daily',
        type: 'Heritage and Beach',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Lalla Khedidja Peak',
        description:
        'The highest peak in the Djurdjura range at 2,308m. A challenging but rewarding hike with extraordinary views across Kabylie and the Mediterranean.',
        openingHours: 'Open all day',
        closingDay: 'Open daily (guide recommended)',
        type: 'Mountain Summit',
        entryFee: 0,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 5. GUELMA
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Guelma',
    region: 'East',
    imagePath: 'assets/images/wilayas/guelma.jpg',
    categories: ['Culture', 'Mountain'],
    description:
    'The Antique City — Guelma sits in a lush green valley of the northeast, home to some of North Africa\'s best-preserved Roman theatres, the thermal baths of Hammam Meskhoutine, and the spectacular Medjez-Amar forests.',
    bestTime: 'April–October',
    famousFood: 'Chakhchoukha, Rechta, Grilled lamb, Berkoukes',
    coordinates: {'lat': 36.4619, 'lng': 7.4278},
    defaultPricePerDay: 5500,
    activities: [
      'Visit the remarkably preserved Roman theatre of Calama',
      'Bathe in the natural hot springs of Hammam Meskhoutine',
      'Explore the petrified waterfall formations',
      'Hike in Medjez-Amar forests',
      'Visit the Guelma Regional Museum',
      'Tour the Roman triumphal arch and ruins',
      'Day trip to Ain Makhlouf waterfalls',
      'Explore the historic Guelma citadel',
    ],
    attractions: [
      'Roman Theatre of Calama (2nd century AD)',
      'Hammam Meskhoutine Hot Springs',
      'Petrified Waterfall (calcified formations)',
      'Guelma Regional Museum',
      'Roman Triumphal Arch',
      'Medjez-Amar Forest',
      'Ain Makhlouf Waterfalls',
      'Guelma Ottoman Citadel',
    ],
    hotels: [
      'Hotel Medjez-Amar ★★★★ — forested setting, restaurant',
      'Hotel Hammam Meskhoutine ★★★ — thermal spa access',
      'Hotel Guelma ★★★ — city centre, reliable',
      'Hotel El Houria ★★★ — near Roman ruins',
      'Residence du Parc ★★★ — comfortable apartments',
    ],
    restaurants: [
      'Restaurant Calama — traditional northeastern cuisine',
      'Chez Ahmed — local home-cooking favourite',
      'La Cascade — near the waterfall',
      'Restaurant du Therme — near hot springs',
      'Cafe de la Paix — historic town centre spot',
    ],
    touristZones: [
      TouristZone(
        name: 'Roman Theatre of Calama',
        description:
        'One of the best-preserved Roman theatres in North Africa, dating from the 2nd century AD. Still used for performances today. Seats over 3,000 spectators.',
        openingHours: '08:00 – 17:00',
        closingDay: 'Closed Monday',
        type: 'Archaeological Site',
        entryFee: 200,
      ),
      TouristZone(
        name: 'Hammam Meskhoutine',
        description:
        'Natural hot springs gushing at 98°C — among the hottest in the world. The calcium carbonate deposits have created extraordinary petrified waterfall formations.',
        openingHours: '08:00 – 18:00',
        closingDay: 'Open daily',
        type: 'Natural Thermal Springs',
        entryFee: 200,
      ),
      TouristZone(
        name: 'Guelma Regional Museum',
        description:
        'A well-curated museum displaying Roman mosaics, sculptures, coins, and pottery from the ancient city of Calama, plus regional history and ethnography.',
        openingHours: '09:00 – 16:30',
        closingDay: 'Closed Monday',
        type: 'Museum',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Medjez-Amar Forest',
        description:
        'A dense forest of cork oak and pine in the hills above Guelma. Pleasant hiking trails, natural springs, and abundant birdlife.',
        openingHours: 'Open all day',
        closingDay: 'Open daily',
        type: 'Forest and Nature',
        entryFee: 0,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 6. JIJEL
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Jijel',
    region: 'East',
    imagePath: 'assets/images/wilayas/jijel.jpg',
    categories: ['Beach', 'Mountain'],
    description:
    'The Pearl of the Mediterranean — Jijel is Algeria\'s best-kept coastal secret, with 120km of some of the country\'s most spectacular coastline: emerald coves, towering red rock arches, ancient cedar forests, and pristine wild beaches.',
    bestTime: 'June–September',
    famousFood: 'Grilled fish, Seafood couscous, Merguez, Brik',
    coordinates: {'lat': 36.8208, 'lng': 5.7664},
    defaultPricePerDay: 6500,
    activities: [
      'Swim at the legendary Les Falaises rock arch beaches',
      'Hike in El Aouana coastal forest',
      'Snorkelling and diving at Cap Bouak',
      'Explore the Giant Cedar trees of Taza National Park',
      'Boat trip along the red rock coastline',
      'Visit the Jijel Museum',
      'Beach hop from Kotama to Ziama Mansouria',
      'Explore Aouana beach resort area',
    ],
    attractions: [
      'Les Falaises (rock arch beaches)',
      'Taza National Park (giant cedars)',
      'Cap Bouak lighthouse and cove',
      'Aouana Beach',
      'El Aouana Coastal Forest',
      'Ziama Mansouria Beach',
      'Kotama Beach',
      'Jijel Old Port',
    ],
    hotels: [
      'Hotel Kotama ★★★★ — beachfront, sea views',
      'Hotel Les Falaises ★★★★ — cliff-top location',
      'Hotel Aouana ★★★ — resort beach setting',
      'Hotel Jijel ★★★ — city centre',
      'Club Nautique Jijel ★★★ — water sports, marina',
    ],
    restaurants: [
      'La Marine — fresh catch by the harbour',
      'Restaurant Les Falaises — rock arch view dining',
      'Chez Samir — grills and couscous',
      'Restaurant Kotama — seafront terrace',
      'Cafe du Port — local fishermen\'s cafe',
    ],
    touristZones: [
      TouristZone(
        name: 'Les Falaises Beach',
        description:
        'Algeria\'s most photographed coastal formation — dramatic red sandstone cliffs and natural rock arches framing emerald sea coves. Truly spectacular scenery.',
        openingHours: 'Open all day',
        closingDay: 'Open daily (June–September)',
        type: 'Natural Beach',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Taza National Park',
        description:
        'A spectacular park combining mountain cedar forest and Mediterranean coastline. Home to giant Atlantic cedar trees, Barbary deer, and rare birds.',
        openingHours: '07:00 – 18:00',
        closingDay: 'Open daily',
        type: 'National Park',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Cap Bouak',
        description:
        'A scenic cape with a lighthouse, crystal clear water, and excellent snorkelling and diving. One of the best dive sites on Algeria\'s coast.',
        openingHours: 'Open all day',
        closingDay: 'Open daily',
        type: 'Cape and Dive Site',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Aouana and Ziama Beaches',
        description:
        'Two of Jijel\'s finest beaches — wide golden sand, turquoise water, and mountain backdrop. Aouana has resort facilities; Ziama is wilder and more scenic.',
        openingHours: 'Open all day',
        closingDay: 'Open daily (June–September)',
        type: 'Beach',
        entryFee: 0,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 7. ANNABA
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Annaba',
    region: 'East',
    imagePath: 'assets/images/wilayas/annaba.jpg',
    categories: ['Beach', 'Culture'],
    description:
    'The City of Jujube Trees — a coastal gem on Algeria\'s northeast coast, Annaba combines golden beaches with ancient Roman ruins and the magnificent Basilica of St. Augustine, birthplace of the great philosopher.',
    bestTime: 'June–September',
    famousFood: 'Grilled fish, Couscous with seafood, Brik',
    coordinates: {'lat': 36.9028, 'lng': 7.7558},
    defaultPricePerDay: 8000,
    activities: [
      'Visit the Basilica of St. Augustine',
      'Explore Roman ruins at Hippo Regius',
      'Relax at Sable d\'Or beach',
      'Snorkelling and diving at Cap de Garde',
      'Stroll Boulevard du 1er Novembre',
      'Visit Annaba Museum',
      'Day trip to El Kala National Park',
      'Explore the old city medina',
    ],
    attractions: [
      'Basilica of St. Augustine (1900 neo-Byzantine)',
      'Hippo Regius Roman Ruins',
      'Sable d\'Or Beach',
      'Cap de Garde Lighthouse',
      'El Kala National Park (UNESCO Biosphere)',
      'Annaba Museum',
      'Seybouse River Valley',
      'Theatre of Annaba',
    ],
    hotels: [
      'Hotel Sheraton Annaba ★★★★★ — 5-star beachfront',
      'Hotel Sabri ★★★★ — sea views, well-rated',
      'Hotel Seybouse International ★★★★ — city centre',
      'Hotel La Gazelle ★★★ — near beach',
      'Hotel Le Refuge ★★★ — comfortable, central',
    ],
    restaurants: [
      'La Brise — fresh seafood on the seafront',
      'Mediterranee — Italian-Algerian fusion',
      'Chez Momo — beloved local restaurant',
      'Restaurant El Bahri — sea view terrace',
      'Cafe de la Plage — beachside snacks',
    ],
    touristZones: [
      TouristZone(
        name: 'Basilica of St. Augustine',
        description:
        'A stunning 1900 neo-Byzantine basilica dedicated to St. Augustine, born near Annaba. Overlooks the city from a hilltop and is one of Algeria\'s most visited monuments.',
        openingHours: '08:00 – 12:00 / 14:00 – 18:00',
        closingDay: 'Open daily',
        type: 'Religious and Historic Site',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Hippo Regius Roman Ruins',
        description:
        'Ancient Roman city where St. Augustine served as bishop for 35 years. Features a Roman theatre, forum, Byzantine basilica, and remarkable mosaics.',
        openingHours: '08:00 – 17:00',
        closingDay: 'Closed Monday',
        type: 'Archaeological Site',
        entryFee: 200,
      ),
      TouristZone(
        name: 'Sable d\'Or Beach',
        description:
        'One of Algeria\'s most beautiful beaches — golden sand, clear Mediterranean water, with parasols and water sports facilities in summer.',
        openingHours: 'Open all day',
        closingDay: 'Open daily (June–September)',
        type: 'Beach',
        entryFee: 0,
      ),
      TouristZone(
        name: 'El Kala National Park',
        description:
        'UNESCO Biosphere Reserve with lakes, Mediterranean forest, and coastline. Rich in rare birds, cork oak, and pristine beaches. 50km from Annaba.',
        openingHours: '07:00 – 19:00',
        closingDay: 'Open daily',
        type: 'National Park',
        entryFee: 100,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 8. SÉTIF
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Sétif',
    region: 'East',
    imagePath: 'assets/images/wilayas/setif.jpg',
    categories: ['Culture', 'Mountain'],
    description:
    'The Capital of the High Plateaus — Sétif is a dynamic modern city surrounded by some of Algeria\'s most spectacular archaeological treasures: the UNESCO ruins of Djémila (ancient Cuicul), sweeping plateau landscapes, and the forests of the Babors mountains.',
    bestTime: 'April–October',
    famousFood: 'Chakhchoukha, Dolma, Couscous, Zgougou sweets',
    coordinates: {'lat': 36.1898, 'lng': 5.4107},
    defaultPricePerDay: 6000,
    activities: [
      'Explore Djemila Roman ruins (UNESCO World Heritage)',
      'Visit the Sétif Archaeological Museum',
      'Walk through Ain El Fouara park and fountain',
      'Hike in the Babors mountains',
      'Visit the National Museum of Sétif',
      'Explore Beni Ourtilane waterfalls',
      'Day trip to Jijel coast',
      'Explore the Guergour mountain forests',
    ],
    attractions: [
      'Djemila Roman Ruins (UNESCO World Heritage)',
      'Sétif Archaeological Museum',
      'Ain El Fouara Fountain (historic symbol)',
      'Babors Mountains',
      'Beni Ourtilane Waterfalls',
      'Djemila Village',
      'Sétif Old Town',
      'Guergour Forest',
    ],
    hotels: [
      'Hotel El Hidhab ★★★★ — modern, city views',
      'Hotel Vieux Moulin ★★★★ — well-regarded, pool',
      'Hotel Sétif ★★★ — central, reliable',
      'Hotel Djemila ★★★ — near ruins',
      'Hotel El Mountazah ★★★ — comfortable, affordable',
    ],
    restaurants: [
      'Restaurant Djemila — traditional high-plateau cuisine',
      'Le Plateau — Algerian and European menu',
      'Chez Baya — home cooking, local favourite',
      'Restaurant Ain El Fouara — central terrace',
      'La Coupole — refined Algerian cuisine',
    ],
    touristZones: [
      TouristZone(
        name: 'Djemila (UNESCO World Heritage)',
        description:
        'One of the finest examples of Roman-era town planning in the world, built at 900m altitude. Remarkably preserved temples, arches, basilicas, and an extraordinary 3,000-seat theatre.',
        openingHours: '08:00 – 17:30',
        closingDay: 'Open daily',
        type: 'UNESCO Archaeological Site',
        entryFee: 300,
      ),
      TouristZone(
        name: 'Sétif Archaeological Museum',
        description:
        'Houses an outstanding collection of Roman mosaics, sculptures, and artefacts from Djemila and the wider region. The mosaic gallery alone is worth the visit.',
        openingHours: '09:00 – 16:30',
        closingDay: 'Closed Monday',
        type: 'Museum',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Ain El Fouara',
        description:
        'Sétif\'s iconic Art Nouveau fountain dating from 1899, depicting a nude Algerian woman — a subject of fierce debate and symbol of the city. Set in a pleasant central park.',
        openingHours: 'Open all day',
        closingDay: 'Open daily',
        type: 'Historic Landmark',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Babors Mountains',
        description:
        'A wild mountain range north of Sétif reaching 2,004m. Home to Algeria\'s last population of Barbary macaques and rare endemic plants. Excellent hiking.',
        openingHours: 'Open all day',
        closingDay: 'Open daily',
        type: 'Mountain Nature',
        entryFee: 0,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 9. SKIKDA
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Skikda',
    region: 'East',
    imagePath: 'assets/images/wilayas/skikda.jpg',
    categories: ['Beach', 'Culture'],
    description:
    'The Emerald Bay — Skikda is blessed with some of Algeria\'s most stunning beaches and a spectacular bay, plus the remarkable Roman ruins of Rusicade, cedar forests, and the wild beauty of the Collo peninsula.',
    bestTime: 'June–September',
    famousFood: 'Grilled fish, Octopus salad, Couscous with seafood, Brik',
    coordinates: {'lat': 36.8761, 'lng': 6.9003},
    defaultPricePerDay: 6500,
    activities: [
      'Swim at Stora and Chetaibi beaches',
      'Explore Roman ruins of Rusicade',
      'Visit the Skikda Archaeological Museum',
      'Boat trip around the Skikda bay',
      'Hike the Collo peninsula trails',
      'Visit the Filfila nature reserve',
      'Explore the Skikda corniche promenade',
      'Day trip to La Marsa beach',
    ],
    attractions: [
      'Stora Beach (crystal clear bay)',
      'Roman Ruins of Rusicade',
      'Skikda Archaeological Museum',
      'Collo Peninsula',
      'Filfila Nature Reserve',
      'La Marsa Beach',
      'Skikda Corniche',
      'Chetaibi Beach',
    ],
    hotels: [
      'Hotel Rusicade ★★★★ — sea views, central',
      'Hotel Stora ★★★★ — beachfront, pool',
      'Hotel Skikda ★★★ — city centre, reliable',
      'Hotel El Mordjane ★★★ — near ruins',
      'Residence Les Pins ★★★ — beach apartments',
    ],
    restaurants: [
      'Restaurant Stora — daily fresh catch, bay views',
      'La Caravelle — seafront terrace dining',
      'Chez Rachid — local seafood specialist',
      'Restaurant Rusicade — traditional Algerian',
      'Cafe de la Corniche — sunset terrace',
    ],
    touristZones: [
      TouristZone(
        name: 'Stora Beach and Bay',
        description:
        'A stunning semicircular bay with crystal-clear green water, backed by pine-covered hills. One of Algeria\'s most beautiful natural harbours.',
        openingHours: 'Open all day',
        closingDay: 'Open daily (June–September)',
        type: 'Beach and Bay',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Roman Ruins of Rusicade',
        description:
        'The ancient Roman port city of Rusicade, with a well-preserved theatre, temples, and mosaics integrated into the modern city of Skikda.',
        openingHours: '08:00 – 17:00',
        closingDay: 'Closed Monday',
        type: 'Archaeological Site',
        entryFee: 200,
      ),
      TouristZone(
        name: 'Filfila Nature Reserve',
        description:
        'A protected coastal forest of umbrella pines and wild beaches west of Skikda. Excellent birdwatching and secluded coves accessible by boat.',
        openingHours: '07:00 – 18:00',
        closingDay: 'Open daily',
        type: 'Nature Reserve',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Collo Peninsula',
        description:
        'A wild and beautiful peninsula with soaring cliffs, forest trails, and remote beaches. The town of Collo itself is a picturesque fishing port.',
        openingHours: 'Open all day',
        closingDay: 'Open daily',
        type: 'Coastal Nature',
        entryFee: 0,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 10. ORAN
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Oran',
    region: 'West',
    imagePath: 'assets/images/wilayas/oran.jpg',
    categories: ['Beach', 'Culture'],
    description:
    'The Joyful City — Algeria\'s vibrant second city is famous for its lively Rai music scene, Spanish-era Fort Santa Cruz, beautiful beaches, and grand French colonial architecture lining its broad boulevards.',
    bestTime: 'April–June / September–October',
    famousFood: 'Bouchee a la reine, El Kebab, Rechta',
    coordinates: {'lat': 35.6973, 'lng': -0.6336},
    defaultPricePerDay: 8000,
    activities: [
      'Visit Fort Santa Cruz and Mount Murdjadjo',
      'Explore the historic Bey Palace',
      'Relax at Les Andalouses beach',
      'Stroll along the seafront Corniche',
      'Experience the Rai music nightlife',
      'Visit the Cathedral of Saint-Louis',
      'Shop at Place du 1er Novembre',
      'Day trip to Mostaganem beaches',
    ],
    attractions: [
      'Fort Santa Cruz (16th-century Spanish fortress)',
      'Bey Palace (Palais du Bey)',
      'Cathedral of Saint-Louis',
      'Les Andalouses Beach',
      'Le Chateau Neuf',
      'Theatre Regional d\'Oran',
      'Santa Cruz Lighthouse',
      'Oran Museum of Modern Art',
    ],
    hotels: [
      'Hotel Le Meridien Oran ★★★★★ — sea views, pool',
      'Hotel Sheraton Oran ★★★★★ — business and leisure',
      'Royal Hotel Oran ★★★★ — central location',
      'Hotel Le Transat ★★★★ — Corniche views',
      'Hotel Timgad ★★★ — budget-friendly city centre',
    ],
    restaurants: [
      'L\'Oriental — traditional Algerian',
      'La Fontaine — French cuisine',
      'Chez Bachir — seafood specialist',
      'Le Corsaire — sea view dining',
      'Restaurant Murdjadjo — fort view terrace',
    ],
    touristZones: [
      TouristZone(
        name: 'Fort Santa Cruz',
        description:
        'A 16th-century Spanish fortress perched on Mount Murdjadjo at 423m. Spectacular panoramic views over Oran and the Mediterranean. One of Algeria\'s most iconic monuments.',
        openingHours: '08:00 – 18:00',
        closingDay: 'Open daily',
        type: 'Historic Fort',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Bey Palace (Palais du Bey)',
        description:
        'An 18th-century Ottoman palace with stunning Moorish architecture, tiled courtyards, and opulent historic rooms. The finest Ottoman interior in western Algeria.',
        openingHours: '09:00 – 17:00',
        closingDay: 'Closed Monday',
        type: 'Palace and Museum',
        entryFee: 200,
      ),
      TouristZone(
        name: 'Les Andalouses Beach',
        description:
        'One of Algeria\'s most beautiful beaches, 25km west of Oran. Crystal clear water, fine sand, water sports, and beach clubs.',
        openingHours: 'Open all day',
        closingDay: 'Open daily (seasonal)',
        type: 'Beach',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Cathedral of Saint-Louis',
        description:
        'A stunning 19th-century French colonial cathedral, now converted into a cultural centre hosting art exhibitions and classical concerts.',
        openingHours: '09:00 – 17:00',
        closingDay: 'Closed Sunday',
        type: 'Cultural Centre',
        entryFee: 0,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 11. TLEMCEN
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Tlemcen',
    region: 'West',
    imagePath: 'assets/images/wilayas/tlemcen.jpg',
    categories: ['Culture', 'Mountain'],
    description:
    'The Pearl of the Maghreb — Tlemcen is Algeria\'s most refined cultural city, a former medieval Islamic capital of staggering architectural beauty: magnificent mosques, palaces, Andalusian gardens, and the impressive ruins of Mansourah.',
    bestTime: 'April–June / September–October',
    famousFood: 'Couscous tlemcenien, Mchermel, Bradj, Makrout, Rechta',
    coordinates: {'lat': 34.8828, 'lng': -1.3147},
    defaultPricePerDay: 6500,
    activities: [
      'Visit the Great Mosque of Tlemcen (12th century)',
      'Explore the ruins of Mansourah',
      'Walk through Mechover palace and gardens',
      'Visit the Grand Synagogue',
      'Tour Sidi Boumediene shrine and mosque',
      'Explore the Beni Add caves',
      'Hike in Tlemcen National Park',
      'Attend Tlemcen\'s classical Andalusian music festival',
    ],
    attractions: [
      'Great Mosque of Tlemcen (12th century)',
      'Ruins of Mansourah (14th-century city)',
      'Sidi Boumediene Mosque and Mausoleum',
      'Mechover Palace and Gardens',
      'Tlemcen National Park',
      'Beni Add Stalactite Caves',
      'Grand Synagogue of Tlemcen',
      'Agadir Ruins (12th century)',
    ],
    hotels: [
      'Hotel Les Zianides ★★★★ — historic city, views',
      'Hotel Renaissance Tlemcen ★★★★ — modern luxury',
      'Hotel Agadir ★★★ — near ruins, good value',
      'Hotel Mansourah ★★★ — city centre, reliable',
      'Hotel du Parc ★★★ — near gardens',
    ],
    restaurants: [
      'Restaurant Sidi Boumediene — traditional cuisine, views',
      'La Maison Andalouse — Andalusian-Algerian fusion',
      'Chez Fatima — home cooking, local favourite',
      'Restaurant Mansourah — near ruins, couscous specialist',
      'Cafe Beni Add — post-cave terrace coffee',
    ],
    touristZones: [
      TouristZone(
        name: 'Great Mosque of Tlemcen',
        description:
        'Founded in 1082 by the Almoravids, this is one of the finest examples of Maghrebi Islamic architecture. The minaret and prayer hall are extraordinarily beautiful.',
        openingHours: '08:00 – 12:00 / 14:00 – 17:30',
        closingDay: 'Closed to tourists during prayer times',
        type: 'Historic Mosque',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Sidi Boumediene Mosque and Mausoleum',
        description:
        'A sublime 14th-century mosque and mausoleum complex dedicated to the Sufi saint Abu Madyan. One of the most sacred sites in the Maghreb.',
        openingHours: '08:00 – 18:00',
        closingDay: 'Open daily',
        type: 'Sacred Site',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Mansourah Ruins',
        description:
        'The dramatic ruins of a 14th-century Merinid rival capital, built to besiege Tlemcen. The enormous minaret and city walls still stand in the forest.',
        openingHours: '08:00 – 17:00',
        closingDay: 'Open daily',
        type: 'Historic Ruins',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Beni Add Stalactite Caves',
        description:
        'Spectacular natural caverns with extraordinary stalactite and stalagmite formations. One of the most impressive cave systems in North Africa.',
        openingHours: '09:00 – 16:30',
        closingDay: 'Closed Monday',
        type: 'Natural Cave',
        entryFee: 200,
      ),
      TouristZone(
        name: 'Tlemcen National Park',
        description:
        'A forested park covering the Tlemcen plateau, with hiking trails through cedar and oak forest, natural springs, and panoramic views.',
        openingHours: '07:00 – 18:00',
        closingDay: 'Open daily',
        type: 'National Park',
        entryFee: 100,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 12. MOSTAGANEM
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Mostaganem',
    region: 'West',
    imagePath: 'assets/images/wilayas/mostaganem.jpg',
    categories: ['Beach', 'Culture'],
    description:
    'The Perfumed City — Mostaganem is famous for some of Algeria\'s most beautiful turquoise beaches, a charming Spanish-era old town, and the surrounding vineyards and orange groves of the Dahra mountains.',
    bestTime: 'June–September',
    famousFood: 'Grilled fish, Moussem couscous, Chakhchouka, Sfenj',
    coordinates: {'lat': 35.9311, 'lng': 0.0890},
    defaultPricePerDay: 6500,
    activities: [
      'Swim at Sayada and Stidia beaches',
      'Explore the old Spanish quarter (Tobana)',
      'Visit the Kharouba beach and cliffs',
      'Explore the Dahra mountain orchards',
      'Visit the local fish market at dawn',
      'Tour the historic Ottoman lighthouse',
      'Day trip to Salamandre Beach',
      'Explore the old medina and souks',
    ],
    attractions: [
      'Sayada Beach (crystal clear water)',
      'Stidia Beach (family resort)',
      'Tobana Spanish Quarter',
      'Mostaganem Old Medina',
      'Kharouba Cliffs and Beach',
      'Mostaganem Lighthouse',
      'Dahra Mountain Views',
      'Salamandre Beach',
    ],
    hotels: [
      'Hotel Mazagran ★★★★ — sea views, pool',
      'Hotel Salamandre ★★★★ — beachfront resort',
      'Hotel Les Pins ★★★ — pine forest setting',
      'Hotel El Mordjane ★★★ — city centre',
      'Residence Stidia Beach ★★★ — beach apartments',
    ],
    restaurants: [
      'Restaurant La Plage — fresh daily catch',
      'Chez Fatima — traditional home cooking',
      'Le Phare — lighthouse view dining',
      'Restaurant Dahra — grills and couscous',
      'Cafe de la Corniche — sunset terrace',
    ],
    touristZones: [
      TouristZone(
        name: 'Sayada Beach',
        description:
        'One of Algeria\'s most beautiful beaches with exceptionally clear turquoise water and white sand. Popular for swimming and snorkelling.',
        openingHours: 'Open all day',
        closingDay: 'Open daily (June–September)',
        type: 'Beach',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Tobana Spanish Quarter',
        description:
        'A picturesque neighbourhood of narrow streets and whitewashed houses dating to the Spanish occupation (1508–1708). Authentic and photogenic.',
        openingHours: 'Open all day',
        closingDay: 'Open daily',
        type: 'Historic Quarter',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Kharouba Cliffs and Beach',
        description:
        'Dramatic white limestone cliffs plunging into turquoise sea. One of the most photographed coastal scenes in western Algeria.',
        openingHours: 'Open all day',
        closingDay: 'Open daily',
        type: 'Natural Landmark and Beach',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Stidia Beach Resort',
        description:
        'A wide sandy beach 12km from Mostaganem with hotels, restaurants, and family facilities. Very popular in summer months.',
        openingHours: 'Open all day',
        closingDay: 'Open daily (June–September)',
        type: 'Beach Resort',
        entryFee: 0,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 13. SIDI BEL ABBES
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Sidi Bel Abbes',
    region: 'West',
    imagePath: 'assets/images/wilayas/sidibelabas.jpg',
    categories: ['Culture', 'Mountain'],
    description:
    'The City of the Foreign Legion — Sidi Bel Abbes was the legendary headquarters of the French Foreign Legion for 132 years, and is now a prosperous agricultural city surrounded by vineyards, the Tessala mountains, and the Mekerra river valley.',
    bestTime: 'April–October',
    famousFood: 'Couscous, Mechaoui, Chakhchouka, Grilled lamb',
    coordinates: {'lat': 35.1897, 'lng': -0.6306},
    defaultPricePerDay: 5500,
    activities: [
      'Visit the Foreign Legion Museum',
      'Explore the Tessala mountain forest and trails',
      'Visit the Sidi Bel Abbes Museum of Anthropology',
      'Tour the historic French Foreign Legion barracks',
      'Walk along the Mekerra river promenade',
      'Visit the Lartigue Park',
      'Day trip to Tlemcen ruins and mosques',
      'Explore the Sidi Ali Benyoub dam lake',
    ],
    attractions: [
      'Foreign Legion Museum (Musee du Legion)',
      'Tessala Mountains and Forest',
      'Sidi Bel Abbes Museum of Anthropology',
      'Historic Foreign Legion Barracks',
      'Mekerra River Promenade',
      'Lartigue Park',
      'Sidi Ali Benyoub Dam',
      'Djebel Tessala Summit',
    ],
    hotels: [
      'Hotel Le Zenith ★★★★ — modern, business hotel',
      'Hotel Méridional ★★★ — city centre, reliable',
      'Hotel Tessala ★★★ — mountain views',
      'Hotel La Paix ★★★ — budget, central',
      'Hotel El Mekerra ★★★ — near river promenade',
    ],
    restaurants: [
      'Restaurant Legion — historic ambience, grills',
      'Chez Ben Ali — traditional local cooking',
      'La Terrasse — European-Algerian menu',
      'Restaurant Tessala — mountain-view terrace',
      'Cafe du Parc — central garden setting',
    ],
    touristZones: [
      TouristZone(
        name: 'Foreign Legion Museum',
        description:
        'The historic headquarters of the French Foreign Legion (1843–1962). The museum preserves Legion artefacts, flags, weapons, and the fascinating history of this legendary force.',
        openingHours: '09:00 – 16:30',
        closingDay: 'Closed Monday',
        type: 'Historical Museum',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Tessala Mountains',
        description:
        'A gentle mountain range rising to 1,061m above the city, covered in pine and cedar forest. Pleasant hiking trails and panoramic views over the western plains.',
        openingHours: 'Open all day',
        closingDay: 'Open daily',
        type: 'Mountain Nature',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Museum of Anthropology',
        description:
        'One of Algeria\'s finest regional museums, with extensive collections on Berber culture, traditional costumes, jewellery, and the archaeology of the western region.',
        openingHours: '09:00 – 16:30',
        closingDay: 'Closed Monday',
        type: 'Museum',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Mekerra River Promenade',
        description:
        'A pleasant riverside walkway with gardens, cafes, and fountains. A popular local meeting place and ideal for an evening stroll.',
        openingHours: 'Open all day',
        closingDay: 'Open daily',
        type: 'Urban Park',
        entryFee: 0,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 14. CONSTANTINE
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Constantine',
    region: 'East',
    imagePath: 'assets/images/wilayas/constantine.jpg',
    categories: ['Culture', 'Mountain'],
    description:
    'The City of Bridges — perched dramatically on a rocky plateau above the Rhumel Gorges, Constantine is one of the oldest continuously inhabited cities in the world, with seven iconic bridges spanning its vertiginous gorges.',
    bestTime: 'May–September',
    famousFood: 'Chakhchoukha, Merguez, Rechta, Baklawa',
    coordinates: {'lat': 36.3650, 'lng': 6.6147},
    defaultPricePerDay: 7000,
    activities: [
      'Walk across the Sidi M\'Cid suspension bridge',
      'Explore Ahmed Bey Palace',
      'Hike the Rhumel Gorges trails',
      'Visit Cirta Museum',
      'Cable car ride over the gorges',
      'Explore the old medina',
      'Day trip to Timgad Roman ruins',
      'Visit the Emir Abdelkader Mosque',
    ],
    attractions: [
      'Sidi M\'Cid Suspension Bridge',
      'Ahmed Bey Palace',
      'Rhumel Gorges',
      'Cirta Museum',
      'Emir Abdelkader Mosque',
      'Cable Car (Telepherique)',
      'Constantine Old Medina',
      'Timgad Roman Ruins (UNESCO, 2h drive)',
    ],
    hotels: [
      'Constantine Marriott Hotel ★★★★★ — riverfront luxury',
      'Protea Hotel by Marriott ★★★★ — modern, central',
      'Hotel Cirta ★★★★ — historic city views',
      'Hotel Panorama ★★★ — gorge views',
      'Hotel El Bey ★★★ — city centre',
    ],
    restaurants: [
      'El Bey — upscale traditional Algerian',
      'Le Gourmet — French-Algerian',
      'Cafe du Centre — iconic local spot',
      'Restaurant El Djazair — Constantine cuisine',
      'Chez Mouloud — local favourite',
    ],
    touristZones: [
      TouristZone(
        name: 'Sidi M\'Cid Suspension Bridge',
        description:
        'A breathtaking 168m suspension bridge spanning the Rhumel Gorge at 175m height. One of Algeria\'s most iconic and vertiginous landmarks.',
        openingHours: 'Open 24 hours',
        closingDay: 'Open daily',
        type: 'Landmark',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Ahmed Bey Palace',
        description:
        'A magnificent 19th-century Ottoman palace with 300 rooms, stunning Moorish tilework and intricate plasterwork. The finest palace interior in eastern Algeria.',
        openingHours: '09:00 – 17:00',
        closingDay: 'Closed Monday',
        type: 'Palace and Museum',
        entryFee: 200,
      ),
      TouristZone(
        name: 'Rhumel Gorges and Cable Car',
        description:
        'Dramatic natural gorges up to 175m deep carved by the Rhumel River. The cable car offers spectacular aerial views of the bridges and gorge.',
        openingHours: '08:30 – 17:30',
        closingDay: 'Closed Tuesday',
        type: 'Nature and Adventure',
        entryFee: 150,
      ),
      TouristZone(
        name: 'Timgad Roman Ruins (UNESCO)',
        description:
        'One of the best-preserved Roman towns in the world, founded by Emperor Trajan in 100 AD. Extraordinary colonnaded streets, temples, and a 3,500-seat theatre.',
        openingHours: '08:00 – 17:00',
        closingDay: 'Open daily',
        type: 'UNESCO Archaeological Site',
        entryFee: 300,
      ),
      TouristZone(
        name: 'Cirta Museum',
        description:
        'The main regional museum with collections of prehistoric artefacts, Roman mosaics, Islamic art, and local history of Constantine.',
        openingHours: '09:00 – 16:30',
        closingDay: 'Closed Monday',
        type: 'Museum',
        entryFee: 100,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 15. BÉJAÏA
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Béjaïa',
    region: 'Centre',
    imagePath: 'assets/images/wilayas/bejaia.jpg',
    categories: ['Beach', 'Mountain'],
    description:
    'The Gulf of Kings — where the mountains plunge into the sea. Béjaïa offers dramatic Gouraya National Park cliffs, crystal-clear beaches, wild Barbary macaques, and is famously the city where Fibonacci learned mathematics.',
    bestTime: 'May–October',
    famousFood: 'Grilled sardines, Merguez, Tajine, Olive oil dishes',
    coordinates: {'lat': 36.7500, 'lng': 5.0833},
    defaultPricePerDay: 7000,
    activities: [
      'Hike in Gouraya National Park',
      'Visit Cap Carbon lighthouse',
      'Snorkelling at Pic des Singes',
      'Explore Bejaia historic port and citadel',
      'Visit the Yemma Gouraya shrine',
      'Beach hopping along the Gulf',
      'Rock climbing at Aiguades',
      'Day trip to Soummam Valley',
    ],
    attractions: [
      'Gouraya National Park',
      'Cap Carbon (highest cape in Algeria)',
      'Pic des Singes (Monkey Peak)',
      'Yemma Gouraya Shrine',
      'Bejaia Old Port and Citadel',
      'Tichi Beach',
      'Melbou Beach',
      'Soummam Valley',
    ],
    hotels: [
      'Hotel Saldae ★★★★ — well-rated, city views',
      'Hotel Les Hammadites ★★★★ — sea views',
      'Hotel Yemma ★★★ — near national park',
      'Hotel La Residence ★★★ — city centre',
      'Club des Pins Bejaia ★★★ — beachside resort',
    ],
    restaurants: [
      'La Marine — fresh seafood, harbour views',
      'Chez Ali — traditional Kabyle cooking',
      'Le Rocher — cliff-top dining',
      'Restaurant Tichi — beachside grills',
      'Cafe du Port — seafront terrace',
    ],
    touristZones: [
      TouristZone(
        name: 'Gouraya National Park',
        description:
        'A stunning national park with dramatic cliffs, Mediterranean forest, and rare Barbary macaques. Panoramic sea views from 671m altitude.',
        openingHours: '07:00 – 18:00',
        closingDay: 'Open daily',
        type: 'National Park',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Cap Carbon',
        description:
        'The highest cape in Algeria at 308m, with a historic lighthouse and breathtaking views of the Gulf of Bejaia. Popular hiking destination.',
        openingHours: 'Open all day',
        closingDay: 'Open daily',
        type: 'Natural Landmark',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Pic des Singes (Monkey Peak)',
        description:
        'A rocky promontory in Gouraya National Park, home to wild Barbary macaques. Excellent snorkelling in the cove below.',
        openingHours: '08:00 – 17:30',
        closingDay: 'Open daily',
        type: 'Nature and Wildlife',
        entryFee: 100,
      ),
      TouristZone(
        name: 'Tichi and Melbou Beaches',
        description:
        'Two of the most beautiful beaches on Algeria\'s coast — turquoise water, fine sand, and mountain backdrop.',
        openingHours: 'Open all day',
        closingDay: 'Open daily (May–October)',
        type: 'Beach',
        entryFee: 0,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 16. GHARDAÏA
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Ghardaïa',
    region: 'Sahara',
    imagePath: 'assets/images/wilayas/ghardaia.jpg',
    categories: ['Sahara', 'Culture'],
    description:
    'Heart of the M\'zab Valley — a UNESCO World Heritage site, Ghardaïa is a medieval city built by the Mozabite Berbers in the 11th century. Its unique pentapolis architecture influenced Le Corbusier himself.',
    bestTime: 'October–April',
    famousFood: 'Couscous with dates, Mahjouba, Tchicha, Mechoui',
    coordinates: {'lat': 32.4833, 'lng': 3.6667},
    defaultPricePerDay: 6000,
    activities: [
      'Explore the M\'zab Valley UNESCO pentapolis',
      'Visit the traditional covered market (souk)',
      'Tour El Atteuf, the oldest M\'zab city',
      'Camel riding in the surrounding desert',
      'Watch traditional Mozabite carpet weaving',
      'Visit the Ghardaia Museum',
      'Desert 4x4 excursion to dunes',
      'Experience a traditional Mozabite dinner',
    ],
    attractions: [
      'M\'zab Valley (UNESCO World Heritage)',
      'Ghardaia Old City and Mosque',
      'Traditional Covered Market (Souk)',
      'El Atteuf (oldest city in the valley)',
      'Beni Isguen (holy city)',
      'Ghardaia Museum',
      'Oued M\'zab (river valley)',
      'Desert Dunes near Metlili',
    ],
    hotels: [
      'Hotel Atlantis ★★★★ — pool, desert views',
      'Hotel Timmi ★★★★ — traditional architecture',
      'Hotel La Rose du M\'zab ★★★ — authentic setting',
      'Hotel El Djanoub ★★★ — city centre',
      'Hotel La Palmeraie ★★★ — palm grove setting',
    ],
    restaurants: [
      'Chez Brahim — traditional Mozabite cuisine',
      'La Palmeraie — desert-view dining',
      'Oasis — local dishes and mint tea',
      'Restaurant El M\'zab — couscous specialist',
      'Cafe des Dunes — terrace with desert views',
    ],
    touristZones: [
      TouristZone(
        name: 'M\'zab Valley (UNESCO)',
        description:
        'A UNESCO World Heritage Site since 1982. Five medieval cities (ksour) built by Mozabite Berbers in the 11th century, perfectly preserved in the Sahara.',
        openingHours: '08:00 – 17:00',
        closingDay: 'Fridays restricted',
        type: 'UNESCO Heritage Site',
        entryFee: 300,
      ),
      TouristZone(
        name: 'Ghardaia Old Mosque and Market',
        description:
        'The historic mosque with its distinctive pyramidal minaret, and the adjacent traditional covered souk selling carpets, spices, and silver jewellery.',
        openingHours: '08:00 – 12:00 / 15:00 – 18:00',
        closingDay: 'Friday mornings',
        type: 'Historic and Market',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Beni Isguen (Holy City)',
        description:
        'The most sacred of the five M\'zab towns. Visitors must enter with a guide. Perfectly preserved medieval architecture and ancient traditions.',
        openingHours: '09:00 – 16:00',
        closingDay: 'Fridays closed to tourists',
        type: 'Historic City',
        entryFee: 200,
      ),
      TouristZone(
        name: 'Desert Dunes (Metlili)',
        description:
        'Golden sand dunes 45km from Ghardaia. Camel rides, 4x4 excursions, and spectacular sunset views. Overnight desert camps available.',
        openingHours: 'Best at sunrise and sunset',
        closingDay: 'Open daily',
        type: 'Desert and Adventure',
        entryFee: 0,
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════════
  // 17. TAMANRASSET
  // ══════════════════════════════════════════════════════════════
  WilayaData(
    name: 'Tamanrasset',
    region: 'Sahara',
    imagePath: 'assets/images/wilayas/tamanrasset.jpg',
    categories: ['Sahara', 'Mountain'],
    description:
    'Gateway to the Hoggar — the most remote and spectacular region of Algeria. Lunar volcanic landscapes, Tuareg culture, prehistoric rock art, and the sacred Assekrem plateau make this a bucket-list destination for adventurers.',
    bestTime: 'October–March',
    famousFood: 'Tuareg couscous, Mechoui (roast lamb), Aghajira, Mint tea',
    coordinates: {'lat': 22.7850, 'lng': 5.5228},
    defaultPricePerDay: 7000,
    activities: [
      'Watch sunrise at Assekrem plateau (2,728m)',
      'Hike and explore the Hoggar Mountains',
      'Visit Tassili n\'Ajjer prehistoric rock art (UNESCO)',
      'Experience Tuareg culture and music',
      'Camel trekking in the Sahara',
      'Stargazing in zero-light-pollution desert',
      '4x4 excursion to rock formations',
      'Visit the hermitage of Charles de Foucauld',
    ],
    attractions: [
      'Hoggar Mountains (Atakor Massif)',
      'Assekrem Plateau and Hermitage',
      'Tassili n\'Ajjer (UNESCO World Heritage)',
      'Tuareg Cultural Village',
      'Charles de Foucauld Hermitage',
      'Tamanrasset Touareg Market',
      'Abalessa (Tin Hinan tomb)',
      'Erg Admer Sand Dunes',
    ],
    hotels: [
      'Hotel Tahat ★★★★ — best in region, Hoggar views',
      'Hotel Tin Hinan ★★★ — Tuareg-style design',
      'Hotel Tidikelt ★★★ — city centre, reliable',
      'Hotel Le Desert ★★★ — traditional rooms',
      'Desert Camp Assekrem — luxury tents (seasonal)',
    ],
    restaurants: [
      'Touareg — authentic Tuareg cuisine',
      'Le Desert — traditional Saharan dishes',
      'Chez Moussa — local favourite',
      'Restaurant Assekrem — great for groups',
      'Cafe Hoggar — mint tea and pastries',
    ],
    touristZones: [
      TouristZone(
        name: 'Assekrem Plateau and Sunrise',
        description:
        'At 2,728m altitude in the Hoggar, Assekrem offers one of the world\'s most spectacular sunrises over volcanic peaks. Father de Foucauld\'s hermitage still stands.',
        openingHours: 'Best 05:30 – 07:30 (sunrise)',
        closingDay: 'Open daily (4x4 required)',
        type: 'Natural Wonder',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Tassili n\'Ajjer (UNESCO)',
        description:
        'A vast plateau containing over 15,000 prehistoric rock paintings and engravings dating back 12,000 years. One of the world\'s most important rock art sites.',
        openingHours: '08:00 – 17:00',
        closingDay: 'Guided tours required',
        type: 'UNESCO Heritage and Rock Art',
        entryFee: 500,
      ),
      TouristZone(
        name: 'Hoggar Mountains',
        description:
        'Dramatic volcanic peaks rising from the Sahara, reaching 2,918m at Mount Tahat. Unique geological formations, endemic plants, and Tuareg heritage.',
        openingHours: 'Open all day',
        closingDay: 'Open daily (guide required)',
        type: 'Mountain and Nature',
        entryFee: 0,
      ),
      TouristZone(
        name: 'Tuareg Market and Crafts',
        description:
        'Tamanrasset\'s weekly market where Tuareg artisans sell handmade silver jewellery, leather goods, swords, and traditional textiles.',
        openingHours: '07:00 – 13:00',
        closingDay: 'Main market day: Thursday',
        type: 'Cultural Market',
        entryFee: 0,
      ),
    ],
  ),

];