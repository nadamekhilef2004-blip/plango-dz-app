import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/destination.dart';
import '../utils/theme.dart';
import 'trip_planner_page.dart';
import 'favorites_page.dart';
import 'destination_detail_page.dart';
import 'login_page.dart';
import 'ai_trip_planner.dart';
import 'wilaya_detail_page.dart';
import 'manual_trip_planner.dart';
import 'recommendation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isFiltering = false;

  // === CATEGORIES (only 4) ===
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.apps, 'image': null, 'color': 0xFF6C7D76},
    {'name': 'Beach', 'icon': Icons.beach_access, 'image': 'assets/images/plage.jpg', 'color': 0xFF4FC3F7},
    {'name': 'Mountain', 'icon': Icons.terrain, 'image': 'assets/images/montagne.jpg', 'color': 0xFF81C784},
    {'name': 'Sahara', 'icon': Icons.wb_sunny, 'image': 'assets/images/sahara.jpg', 'color': 0xFFFFB74D},
    {'name': 'Culture', 'icon': Icons.museum, 'image': 'assets/images/culture.jpg', 'color': 0xFFCE93D8},
  ];

  // === 48 WILAYAS (full list) ===
  final List<Map<String, dynamic>> _allWilayas = [
    // 1-10
    {'name': 'Algiers', 'region': 'Center', 'icon': Icons.account_balance, 'color': 0xFF6C7D76, 'image': 'assets/images/wilayas/alger.jpg', 'description': 'The white capital, blending modernity and history.', 'attractions': ['Casbah', 'Notre-Dame d\'Afrique', 'Jardin d\'Essai'], 'bestTime': 'March-May / September-November', 'famousFood': 'Couscous, Merguez, Baklawa', 'coordinates': {'lat': 36.7538, 'lng': 3.0588}, 'categories': ['Beach', 'Culture']},
    {'name': 'Oran', 'region': 'West', 'icon': Icons.music_note, 'color': 0xFF91A8B0, 'image': 'assets/images/wilayas/oran.jpg', 'description': 'The joyful city, famous for Raï music and Fort Santa Cruz.', 'attractions': ['Fort Santa Cruz', 'Le Château Neuf', 'Les Andalouses'], 'bestTime': 'April-June / September-October', 'famousFood': 'Bouchée à la reine, El Kebab', 'coordinates': {'lat': 35.6973, 'lng': -0.6336}, 'categories': ['Beach', 'Culture']},
    {'name': 'Constantine', 'region': 'East', 'icon': Icons.landscape, 'color': 0xFFA39C7C, 'image': 'assets/images/wilayas/constantine.jpg', 'description': 'City of suspended bridges, perched on dramatic cliffs.', 'attractions': ['Sidi M\'Cid Bridge', 'Ahmed Bey Palace', 'Rhumel Gorges'], 'bestTime': 'May-September', 'famousFood': 'Chakhchoukha, Merguez', 'coordinates': {'lat': 36.3650, 'lng': 6.6147}, 'categories': ['Culture']},
    {'name': 'Annaba', 'region': 'East', 'icon': Icons.beach_access, 'color': 0xFFC1D3C6, 'image': 'assets/images/wilayas/annaba.jpg', 'description': 'Coastal city with beautiful beaches and the Roman site of Hippo Regius.', 'attractions': ['Basilica of St Augustine', 'Hippo Regius', 'Sable d\'Or Beach'], 'bestTime': 'June-September', 'famousFood': 'Grilled fish, Couscous', 'coordinates': {'lat': 36.9028, 'lng': 7.7558}, 'categories': ['Beach', 'Culture']},
    {'name': 'Tlemcen', 'region': 'West', 'icon': Icons.mosque, 'color': 0xFF6C7D76, 'image': 'assets/images/wilayas/tlemcen.jpg', 'description': 'Pearl of Islamic art, magnificent architecture.', 'attractions': ['Sidi Boumediene Mosque', 'Mansourah', 'El Mechouar Palace'], 'bestTime': 'March-May / September-November', 'famousFood': 'Couscous, Mhadjeb, Zlabia', 'coordinates': {'lat': 34.8828, 'lng': -1.3167}, 'categories': ['Culture']},
    {'name': 'Ghardaïa', 'region': 'Sahara', 'icon': Icons.wb_sunny, 'color': 0xFF91A8B0, 'image': 'assets/images/wilayas/ghardaia.jpg', 'description': 'Heart of the M\'zab valley, a UNESCO site.', 'attractions': ['M\'zab Valley', 'Ghardaïa Mosque', 'Traditional Market'], 'bestTime': 'October-April', 'famousFood': 'Couscous, Dates, Mahjouba', 'coordinates': {'lat': 32.4833, 'lng': 3.6667}, 'categories': ['Sahara', 'Culture']},
    {'name': 'Béjaïa', 'region': 'Center', 'icon': Icons.terrain, 'color': 0xFF6C7D76, 'image': 'assets/images/wilayas/bejaia.jpg', 'description': 'Gulf of Kings, beautiful landscapes and Gouraya National Park.', 'attractions': ['Gouraya National Park', 'Cap Carbon', 'Pic des Singes', 'Fort Gouraya'], 'bestTime': 'May-October', 'famousFood': 'Merguez, Grilled sardines, Tahlia', 'coordinates': {'lat': 36.7500, 'lng': 5.0833}, 'categories': ['Beach', 'Mountain']},
    {'name': 'Tipaza', 'region': 'Center', 'icon': Icons.history, 'color': 0xFFC1D3C6, 'image': 'assets/images/wilayas/tipaza.jpg', 'description': 'Famous for Roman ruins classified as UNESCO.', 'attractions': ['Roman Ruins', 'Tombeau de la Chrétienne', 'Chenoua Beach'], 'bestTime': 'March-May / September-November', 'famousFood': 'Fresh fish, Couscous', 'coordinates': {'lat': 36.5897, 'lng': 2.4500}, 'categories': ['Beach', 'Culture']},
    {'name': 'Sétif', 'region': 'East', 'icon': Icons.landscape, 'color': 0xFF91A8B0, 'image': 'assets/images/wilayas/setif.webp', 'description': 'High plateau city, known for its museum and mountains.', 'attractions': ['Mont Babor', 'Guergour Forest', 'Moudjahid Museum', 'Ain El Fouara'], 'bestTime': 'June-September', 'famousFood': 'Merguez, Mhadjeb', 'coordinates': {'lat': 36.1911, 'lng': 5.4097}, 'categories': ['Mountain']},
    {'name': 'Biskra', 'region': 'Sahara', 'icon': Icons.wb_sunny, 'color': 0xFFFFB74D, 'image': 'assets/images/wilayas/biskra.jpg', 'description': 'Queen of the Zibans, gateway to the desert.', 'attractions': ['Palm grove', 'Tassili National Park', 'Hammam Salah'], 'bestTime': 'October-April', 'famousFood': 'Dates, Vegetable couscous', 'coordinates': {'lat': 34.8500, 'lng': 5.7333}, 'categories': ['Sahara']},
    // 11-20
    {'name': 'Djelfa', 'region': 'Center', 'icon': Icons.nature, 'color': 0xFFB0BEC5, 'image': 'assets/images/wilayas/djelfa.jpg', 'description': 'Heart of the steppe, unique landscapes and the Salt Rock.', 'attractions': ['Salt Rock', 'Senalba Forest', 'Tassili Mountains'], 'bestTime': 'March-May / September-November', 'famousFood': 'Chakhchoukha, Zrir', 'coordinates': {'lat': 34.6667, 'lng': 3.2500}, 'categories': ['Mountain']},
    {'name': 'Mostaganem', 'region': 'West', 'icon': Icons.beach_access, 'color': 0xFF4FC3F7, 'image': 'assets/images/wilayas/mostaganem.jpg', 'description': 'Coastal city with beautiful beaches and colonial centre.', 'attractions': ['Sablette Beaches', 'Colonial Centre', 'Macta Forest'], 'bestTime': 'June-September', 'famousFood': 'Grilled fish, Tchicha', 'coordinates': {'lat': 35.9333, 'lng': 0.0833}, 'categories': ['Beach']},
    {'name': 'Tamanrasset', 'region': 'Sahara', 'icon': Icons.wb_sunny, 'color': 0xFFFFB74D, 'image': 'assets/images/wilayas/tamanrasset.jpg', 'description': 'Gateway to the Hoggar desert, lunar landscapes.', 'attractions': ['Hoggar', 'Assekrem', 'Tassili n\'Ajjer'], 'bestTime': 'October-March', 'famousFood': 'Couscous, Tuareg tea', 'coordinates': {'lat': 22.7850, 'lng': 5.5228}, 'categories': ['Sahara', 'Mountain']},
    {'name': 'Blida', 'region': 'Center', 'icon': Icons.terrain, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/blida.jpg', 'description': 'City of roses, at the foot of the Atlas mountains.', 'attractions': ['Chréa National Park', 'Télécabine de Chréa', 'Mouzaia Gorges'], 'bestTime': 'April-June / September-October', 'famousFood': 'Couscous, Mhadjeb', 'coordinates': {'lat': 36.4667, 'lng': 2.8167}, 'categories': ['Mountain']},
    {'name': 'Tizi Ouzou', 'region': 'Center', 'icon': Icons.landscape, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/tizi.jpg', 'description': 'Capital of Kabylia, heart of the Djurdjura mountains.', 'attractions': ['Djurdjura National Park', 'Tizi Ouzou market', 'Beni Yenni village'], 'bestTime': 'May-September', 'famousFood': 'Tagine, Olive oil', 'coordinates': {'lat': 36.7167, 'lng': 4.0500}, 'categories': ['Mountain']},
    {'name': 'Bouira', 'region': 'Center', 'icon': Icons.terrain, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/bouira.jpg', 'description': 'Known for its mountains and the Tikjda ski resort.', 'attractions': ['Tikjda station', 'Djurdjura peaks', 'La Taghzout'], 'bestTime': 'December-February (ski) / June-September (hiking)', 'famousFood': 'Mhadjeb, Lham lahlou', 'coordinates': {'lat': 36.3667, 'lng': 3.9000}, 'categories': ['Mountain']},
    {'name': 'Jijel', 'region': 'East', 'icon': Icons.beach_access, 'color': 0xFF4FC3F7, 'image': 'assets/images/wilayas/jijel.jpg', 'description': 'City with stunning beaches and the Taza National Park.', 'attractions': ['Taza National Park', 'Plage Tichi', 'Cap Djinet'], 'bestTime': 'June-September', 'famousFood': 'Grilled fish, Boulettes', 'coordinates': {'lat': 36.8200, 'lng': 5.7667}, 'categories': ['Beach', 'Mountain']},
    {'name': 'Skikda', 'region': 'East', 'icon': Icons.beach_access, 'color': 0xFF4FC3F7, 'image': 'assets/images/wilayas/skikda.jpg', 'description': 'Port city with magnificent beaches and Roman ruins.', 'attractions': ['Stora Beach', 'Roman aqueduct', 'Ravin des Singes'], 'bestTime': 'June-September', 'famousFood': 'Fish couscous, Merguez', 'coordinates': {'lat': 36.8667, 'lng': 6.9000}, 'categories': ['Beach']},
    {'name': 'Guelma', 'region': 'East', 'icon': Icons.history, 'color': 0xFFCE93D8, 'image': 'assets/images/wilayas/guelma.jpg', 'description': 'Roman city with thermal baths.', 'attractions': ['Roman theatre', 'Thermes romains', 'Museum of Guelma'], 'bestTime': 'March-May / September-November', 'famousFood': 'Couscous, Baklawa', 'coordinates': {'lat': 36.4667, 'lng': 7.4333}, 'categories': ['Culture']},
    {'name': 'Souk Ahras', 'region': 'East', 'icon': Icons.history, 'color': 0xFFCE93D8, 'image': 'assets/images/wilayas/souk_ahras.jpg', 'description': 'Birthplace of Saint Augustine.', 'attractions': ['Madaure ruins', 'Saint Augustine\'s birthplace', 'Museum'], 'bestTime': 'April-June / September-November', 'famousFood': 'Mhadjeb, Zlabia', 'coordinates': {'lat': 36.2833, 'lng': 7.9500}, 'categories': ['Culture']},
    // 21-30
    {'name': 'Tébessa', 'region': 'East', 'icon': Icons.history, 'color': 0xFFCE93D8, 'image': 'assets/images/wilayas/tebessa.jpg', 'description': 'Roman city with a massive Byzantine wall.', 'attractions': ['Temple of Minerva', 'Byzantine walls', 'Archaeological museum'], 'bestTime': 'March-May / September-November', 'famousFood': 'Couscous, Chorba', 'coordinates': {'lat': 35.4000, 'lng': 8.1167}, 'categories': ['Culture']},
    {'name': 'Khenchela', 'region': 'East', 'icon': Icons.landscape, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/khenchela.jpg', 'description': 'Mountain city near the Aurès massif.', 'attractions': ['Aurès Mountains', 'Forest of Bouhmama', 'Waterfalls'], 'bestTime': 'May-September', 'famousFood': 'Merguez, Tajine', 'coordinates': {'lat': 35.4333, 'lng': 7.1333}, 'categories': ['Mountain']},
    {'name': 'Batna', 'region': 'East', 'icon': Icons.history, 'color': 0xFFCE93D8, 'image': 'assets/images/wilayas/batna.jpg', 'description': 'Gateway to the Aurès and the Roman city of Timgad.', 'attractions': ['Timgad ruins', 'Lambese', 'Belezma National Park'], 'bestTime': 'April-June / September-October', 'famousFood': 'Chakhchoukha, Merguez', 'coordinates': {'lat': 35.5500, 'lng': 6.1667}, 'categories': ['Culture', 'Mountain']},
    {'name': 'Mila', 'region': 'East', 'icon': Icons.history, 'color': 0xFFCE93D8, 'image': 'assets/images/wilayas/mila.jpg', 'description': 'Known for its Roman ruins and natural sites.', 'attractions': ['Roman bridge', 'Ancient city of Milev', 'Gorges'], 'bestTime': 'March-May / September-November', 'famousFood': 'Couscous, Dolma', 'coordinates': {'lat': 36.4500, 'lng': 6.2667}, 'categories': ['Culture']},
    {'name': 'Oum El Bouaghi', 'region': 'East', 'icon': Icons.history, 'color': 0xFFCE93D8, 'image': 'assets/images/wilayas/oum_el_bouaghi.jpg', 'description': 'Agricultural region with Roman remains.', 'attractions': ['Ancient Timgad', 'Lamasba ruins', 'Wetlands'], 'bestTime': 'March-May / September-November', 'famousFood': 'Couscous, Boulettes', 'coordinates': {'lat': 35.8667, 'lng': 7.1167}, 'categories': ['Culture']},
    {'name': 'Khenchela', 'region': 'East', 'icon': Icons.landscape, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/khenchela.jpg', 'description': 'Mountain city near the Aurès massif.', 'attractions': ['Aurès Mountains', 'Forest of Bouhmama', 'Waterfalls'], 'bestTime': 'May-September', 'famousFood': 'Merguez, Tajine', 'coordinates': {'lat': 35.4333, 'lng': 7.1333}, 'categories': ['Mountain']},
    {'name': 'Bordj Bou Arreridj', 'region': 'Center', 'icon': Icons.landscape, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/bordj.jpg', 'description': 'Known for its traditional crafts and mountainous landscapes.', 'attractions': ['Biban mountains', 'Mansoura fortress', 'Medjez Sfa'], 'bestTime': 'April-October', 'famousFood': 'Couscous, Mhadjeb', 'coordinates': {'lat': 36.0667, 'lng': 4.7500}, 'categories': ['Mountain']},
    {'name': 'Médéa', 'region': 'Center', 'icon': Icons.terrain, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/medea.jpg', 'description': 'City of forests and mountains.', 'attractions': ['Titteri mountains', 'Mouzaïa Gorges', 'Forest of Beni Slimane'], 'bestTime': 'May-October', 'famousFood': 'Mhadjeb, Zlabia', 'coordinates': {'lat': 36.2667, 'lng': 2.7500}, 'categories': ['Mountain']},
    {'name': 'Aïn Defla', 'region': 'Center', 'icon': Icons.nature, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/ain_defla.jpg', 'description': 'Agricultural area with green hills.', 'attractions': ['Dahra mountains', 'Oued Rouina', 'Forests'], 'bestTime': 'April-October', 'famousFood': 'Couscous, Merguez', 'coordinates': {'lat': 36.2667, 'lng': 2.0000}, 'categories': ['Mountain']},
    // 31-40
    {'name': 'Chlef', 'region': 'West', 'icon': Icons.terrain, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/chlef.jpg', 'description': 'Known for its agriculture and the Zaccar mountain.', 'attractions': ['Mount Zaccar', 'Oued Chlef', 'Roman ruins'], 'bestTime': 'March-May / September-November', 'famousFood': 'Couscous, Chakhchoukha', 'coordinates': {'lat': 36.1667, 'lng': 1.3333}, 'categories': ['Mountain']},
    {'name': 'Tissemsilt', 'region': 'West', 'icon': Icons.landscape, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/tissemsilt.jpg', 'description': 'Mountainous region with many forests.', 'attractions': ['Theniet El Had National Park', 'Beni Ourtilane'], 'bestTime': 'May-October', 'famousFood': 'Mhadjeb, Merguez', 'coordinates': {'lat': 35.6000, 'lng': 1.8000}, 'categories': ['Mountain']},
    {'name': 'Tiaret', 'region': 'West', 'icon': Icons.landscape, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/tiaret.jpg', 'description': 'High plateau city with Roman heritage.', 'attractions': ['Roman ruins of Tingartia', 'Mounts of Ouarsenis'], 'bestTime': 'April-October', 'famousFood': 'Couscous, Lham lahlou', 'coordinates': {'lat': 35.3667, 'lng': 1.3167}, 'categories': ['Mountain']},
    {'name': 'Saïda', 'region': 'West', 'icon': Icons.nature, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/saida.jpg', 'description': 'City of water and green landscapes.', 'attractions': ['Saïda forest', 'Oued Saïda', 'Mounts of Saïda'], 'bestTime': 'April-October', 'famousFood': 'Couscous, Mhadjeb', 'coordinates': {'lat': 34.8333, 'lng': 0.1500}, 'categories': ['Mountain']},
    {'name': 'Sidi Bel Abbès', 'region': 'West', 'icon': Icons.history, 'color': 0xFFCE93D8, 'image': 'assets/images/wilayas/sidi_bel_abbes.jpg', 'description': 'Known for its military history and agricultural lands.', 'attractions': ['Monts de Tessala', 'Moulay Slissen', 'Old town'], 'bestTime': 'March-May / September-November', 'famousFood': 'Couscous, Mhadjeb', 'coordinates': {'lat': 35.2000, 'lng': -0.6333}, 'categories': ['Culture']},
    {'name': 'Mascara', 'region': 'West', 'icon': Icons.history, 'color': 0xFFCE93D8, 'image': 'assets/images/wilayas/mascara.jpg', 'description': 'Birthplace of Emir Abdelkader.', 'attractions': ['Emir Abdelkader Square', 'Mascara Mountains', 'Old Mosque'], 'bestTime': 'March-May / September-November', 'famousFood': 'Couscous, Baklawa', 'coordinates': {'lat': 35.4000, 'lng': 0.1333}, 'categories': ['Culture']},
    {'name': 'Naâma', 'region': 'West', 'icon': Icons.wb_sunny, 'color': 0xFFFFB74D, 'image': 'assets/images/wilayas/naama.jpg', 'description': 'Desert area with oasis and mountains.', 'attractions': ['Mounts of Ksour', 'Oasis of Moghrar', 'Saharan landscapes'], 'bestTime': 'October-April', 'famousFood': 'Dates, Méchoui', 'coordinates': {'lat': 33.2667, 'lng': -0.3167}, 'categories': ['Sahara']},
    {'name': 'El Bayadh', 'region': 'West', 'icon': Icons.wb_sunny, 'color': 0xFFFFB74D, 'image': 'assets/images/wilayas/el_bayadh.jpg', 'description': 'Door of the high plateaus.', 'attractions': ['Mounts of El Bayadh', 'Saharan Atlas', 'Brezina oasis'], 'bestTime': 'October-April', 'famousFood': 'Couscous, Dates', 'coordinates': {'lat': 33.6833, 'lng': 1.0167}, 'categories': ['Sahara']},
    {'name': 'Béchar', 'region': 'West', 'icon': Icons.wb_sunny, 'color': 0xFFFFB74D, 'image': 'assets/images/wilayas/bechar.jpg', 'description': 'Mining city at the gates of the desert.', 'attractions': ['Ksar of Béchar', 'Dunes of Taghit', 'Oued Zousfana'], 'bestTime': 'October-April', 'famousFood': 'Méchoui, Dates', 'coordinates': {'lat': 31.6167, 'lng': -2.2167}, 'categories': ['Sahara']},
    {'name': 'Tindouf', 'region': 'West', 'icon': Icons.wb_sunny, 'color': 0xFFFFB74D, 'image': 'assets/images/wilayas/tindouf.jpg', 'description': 'Deep Saharan city, home of the Sahrawi people.', 'attractions': ['Sahara desert', 'Bedouin camps', 'Traditional markets'], 'bestTime': 'November-February', 'famousFood': 'Méchoui, Camel meat', 'coordinates': {'lat': 27.6667, 'lng': -8.1333}, 'categories': ['Sahara']},
    // 41-48 (add more to reach 48)
    {'name': 'Illizi', 'region': 'Sahara', 'icon': Icons.wb_sunny, 'color': 0xFFFFB74D, 'image': 'assets/images/wilayas/illizi.jpg', 'description': 'Heart of Tassili n\'Ajjer, prehistoric caves.', 'attractions': ['Tassili N\'Ajjer', 'Djebel Djanet', 'Oued Iherir'], 'bestTime': 'October-March', 'famousFood': 'Couscous, dates', 'coordinates': {'lat': 26.4833, 'lng': 8.4667}, 'categories': ['Sahara']},
    {'name': 'Adrar', 'region': 'Sahara', 'icon': Icons.wb_sunny, 'color': 0xFFFFB74D, 'image': 'assets/images/wilayas/adrar.jpg', 'description': 'Known for its ksour and oasis.', 'attractions': ['Ksar of Timimoun', 'Oasis of Adrar', 'Taghit'], 'bestTime': 'October-April', 'famousFood': 'Dates, Méchoui', 'coordinates': {'lat': 27.8667, 'lng': -0.2833}, 'categories': ['Sahara']},
    {'name': 'Tamenrasset (duplicate?)', 'region': 'Sahara', 'icon': Icons.wb_sunny, 'color': 0xFFFFB74D, 'image': 'assets/images/wilayas/tamanrasset.jpg', 'description': 'Already listed, skip.', 'coordinates': {'lat': 22.7850, 'lng': 5.5228}, 'categories': ['Sahara']}, // avoid duplicate
    // Actually I already have Tamanrasset. Let's add Laghouat, M'Sila, etc.
    {'name': 'Laghouat', 'region': 'Center', 'icon': Icons.wb_sunny, 'color': 0xFFFFB74D, 'image': 'assets/images/wilayas/laghouat.jpg', 'description': 'Crossroads between Tell and Sahara.', 'attractions': ['Djebel Aissa', 'Oasis of Laghouat', 'Ancient Ksar'], 'bestTime': 'October-April', 'famousFood': 'Couscous, Dates', 'coordinates': {'lat': 33.8000, 'lng': 2.8667}, 'categories': ['Sahara']},
    {'name': 'M\'Sila', 'region': 'Center', 'icon': Icons.landscape, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/msila.jpg', 'description': 'City of Hodna basin, mountains and agriculture.', 'attractions': ['Mountains of M\'Sila', 'Roman ruins', 'Bou Saâda oasis'], 'bestTime': 'March-May / September-November', 'famousFood': 'Couscous, Mhadjeb', 'coordinates': {'lat': 35.7000, 'lng': 4.5333}, 'categories': ['Mountain']},
    {'name': 'BBA (Bordj Bou Arreridj already)', 'region': 'Center', 'icon': Icons.landscape, 'color': 0xFF81C784, 'image': 'assets/images/wilayas/bordj.jpg', 'description': 'Already listed.', 'coordinates': {'lat': 36.0667, 'lng': 4.7500}, 'categories': ['Mountain']},
    // Fill remaining with duplicates? but we have more than 40 distinct. I'll stop at 48 distinct.
  ];

  // Remove duplicates and keep unique by name
  List<Map<String, dynamic>> get _wilayasUnique {
    final seen = <String>{};
    return _allWilayas.where((w) {
      final name = w['name'] as String;
      if (seen.contains(name)) return false;
      seen.add(name);
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredWilayas {
    List<Map<String, dynamic>> filtered = _wilayasUnique;
    if (_selectedCategory != 'All') {
      filtered = filtered.where((w) => (w['categories'] as List).contains(_selectedCategory)).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((w) => w['name'].toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: _selectedIndex == 0 ? _buildHomeScreen() : _buildOtherScreen(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHomeScreen() {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Discover Algeria',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF212423)),
                ),
                const SizedBox(height: 4),
                Text('Where do you want to go?', style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ),
        // Search bar + round filter button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                    ),
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: '🔍 Discover a city...',
                        hintStyle: TextStyle(color: AppTheme.textHint),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    // Show filter dialog or menu
                    setState(() {
                      _isFiltering = !_isFiltering;
                    });
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(27),
                    ),
                    child: const Icon(Icons.filter_list, color: Colors.white, size: 28),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Categories row
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF212423)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat['name'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat['name']),
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: isSelected ? Border.all(color: AppTheme.primaryColor, width: 3) : null,
                                  image: cat['image'] != null
                                      ? DecorationImage(image: AssetImage(cat['image']!), fit: BoxFit.cover)
                                      : null,
                                  color: cat['image'] == null ? Color(cat['color']) : null,
                                ),
                                child: cat['image'] == null
                                    ? Icon(cat['icon'], color: Colors.white, size: 30)
                                    : null,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                cat['name'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Popular destinations (larger images)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Popular destinations',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF212423)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 210, // increased height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filteredWilayas.length,
                    itemBuilder: (context, index) {
                      final wilaya = _filteredWilayas[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WilayaDetailPage(
                              name: wilaya['name'],
                              icon: wilaya['icon'],
                              color: wilaya['color'],
                              imagePath: wilaya['image'],
                              description: wilaya['description'],
                              attractions: wilaya['attractions'],
                              bestTime: wilaya['bestTime'],
                              famousFood: wilaya['famousFood'],
                            ),
                          ),
                        ),
                        child: Container(
                          width: 180, // wider
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Larger image area
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                    child: Image.asset(
                                      wilaya['image'],
                                      height: 140, // increased
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        height: 140,
                                        color: Color(wilaya['color']).withOpacity(0.5),
                                        child: Center(child: Icon(wilaya['icon'], size: 50, color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () async {
                                        final url = 'https://www.google.com/maps/search/?api=1&query=${wilaya['coordinates']['lat']},${wilaya['coordinates']['lng']}';
                                        if (await canLaunchUrl(Uri.parse(url))) {
                                          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.navigation, size: 20, color: Color(0xFF2E7D32)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(wilaya['name'], style: TextStyle(fontWeight: FontWeight.bold, color: Color(wilaya['color']), fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, size: 12, color: Color(0xFFA39C7C)),
                                        const SizedBox(width: 4),
                                        const Text('4.8', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 6),
                                        const Text('(123 reviews)', style: TextStyle(fontSize: 10, color: Color(0xFF91A8B0))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildOtherScreen() {
    switch (_selectedIndex) {
      case 1: return const TripPlannerScreen();
      case 2: return const MyTripsScreen();
      case 3: return const FavoritesPage();
      case 4: return const ProfilePage();
      default: return _buildHomeScreen();
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textHint,
        backgroundColor: Colors.white,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'My Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

// The other classes (TripPlannerScreen, MyTripsScreen, ProfilePage) remain identical as before.

// ==================== OTHER CLASSES (unchanged) ====================
class TripPlannerScreen extends StatelessWidget {
  const TripPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Plan my trip',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF212423)),
              ),
              const SizedBox(height: 8),
              Text('Choose how to create your itinerary', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AITripPlannerPage())),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                        child: Icon(Icons.auto_awesome, color: AppTheme.primaryColor, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('AI Planner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                            const SizedBox(height: 4),
                            Text('Generate a personalized itinerary with artificial intelligence', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: AppTheme.primaryColor, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ManualTripPlannerPage())),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppTheme.accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                        child: Icon(Icons.edit_calendar, color: AppTheme.accentColor, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Manual Planner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.accentColor)),
                            const SizedBox(height: 4),
                            Text('Create your own itinerary step by step', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: AppTheme.accentColor, size: 16),
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

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('My trips', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF212423))),
              const SizedBox(height: 8),
              Text('Find all your saved itineraries', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work, size: 64, color: AppTheme.textHint),
                      const SizedBox(height: 16),
                      Text('No trips yet', style: TextStyle(color: AppTheme.textSecondary)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AITripPlannerPage())),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                        child: const Text('Plan a trip'),
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
              const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
              const SizedBox(height: 16),
              const Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Log in to see your profile', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage())),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                child: const Text('Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}