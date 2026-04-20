import 'package:flutter/material.dart';

class WilayaData {
  final String name;
  final String region;
  final String imagePath;
  final List<String> categories; // Plage, Montagne, Sahara, Culture
  final List<String> activities;
  final List<String> attractions;
  final List<String> restaurants;
  final double defaultPricePerDay; // budget moyen par jour (DZD)

  WilayaData({
    required this.name,
    required this.region,
    required this.imagePath,
    required this.categories,
    required this.activities,
    required this.attractions,
    required this.restaurants,
    required this.defaultPricePerDay,
  });
}

final List<WilayaData> allWilayas = [
  WilayaData(
    name: 'Alger',
    region: 'Centre',
    imagePath: 'assets/images/wilayas/alger.jpg',
    categories: ['Culture', 'Plage'],
    activities: ['Visite de la Casbah', 'Balade en bateau', 'Shopping', 'Dégustation de couscous'],
    attractions: ['Casbah', 'Notre-Dame d\'Afrique', 'Jardin d\'Essai'],
    restaurants: ['El Djenina', 'Le Tantra', 'Café Tonton'],
    defaultPricePerDay: 8000,
  ),
  WilayaData(
    name: 'Oran',
    region: 'Ouest',
    imagePath: 'assets/images/wilayas/oran.jpg',
    categories: ['Plage', 'Culture'],
    activities: ['Fort Santa Cruz', 'Promenade sur le front de mer', 'Musique Raï'],
    attractions: ['Fort Santa Cruz', 'Le Château Neuf', 'Les Andalouses'],
    restaurants: ['Maharaja', 'L\'Oriental', 'La Fontaine'],
    defaultPricePerDay: 7000,
  ),
  WilayaData(
    name: 'Constantine',
    region: 'Est',
    imagePath: 'assets/images/wilayas/constantine.jpg',
    categories: ['Culture', 'Montagne'],
    activities: ['Ponts suspendus', 'Musée Cirta', 'Randonnée dans les gorges'],
    attractions: ['Pont Sidi M\'Cid', 'Palais d\'Ahmed Bey', 'Gorges du Rhumel'],
    restaurants: ['El Bey', 'Le Gourmet', 'Café du Centre'],
    defaultPricePerDay: 6000,
  ),
  WilayaData(
    name: 'Annaba',
    region: 'Est',
    imagePath: 'assets/images/wilayas/annaba.jpg',
    categories: ['Plage', 'Culture'],
    activities: ['Plage de Sable d\'Or', 'Visite d\'Hippo Regius', 'Plongée'],
    attractions: ['Basilique Saint-Augustin', 'Hippo Regius', 'Plage de Sable d\'Or'],
    restaurants: ['La Brise', 'Méditerranée', 'Chez Momo'],
    defaultPricePerDay: 7500,
  ),
  WilayaData(
    name: 'Tlemcen',
    region: 'Ouest',
    imagePath: 'assets/images/wilayas/tlemcen.jpg',
    categories: ['Culture', 'Montagne'],
    activities: ['Mosquée Sidi Boumediene', 'Grottes de Beni Add', 'Artisanat'],
    attractions: ['Mosquée Sidi Boumediene', 'Mansourah', 'Palais El Mechouar'],
    restaurants: ['Mansourah', 'La Perle', 'El Menzeh'],
    defaultPricePerDay: 6500,
  ),
  WilayaData(
    name: 'Ghardaïa',
    region: 'Sahara',
    imagePath: 'assets/images/wilayas/ghardaia.jpg',
    categories: ['Sahara', 'Culture'],
    activities: ['Vallée du M\'zab', 'Marché traditionnel', 'Randonnée dans le désert'],
    attractions: ['Vallée du M\'zab', 'Mosquée de Ghardaïa', 'Marché traditionnel'],
    restaurants: ['Chez Brahim', 'La Palmeraie', 'Oasis'],
    defaultPricePerDay: 5500,
  ),
  WilayaData(
    name: 'Béjaïa',
    region: 'Centre',
    imagePath: 'assets/images/wilayas/bejaia.jpg',
    categories: ['Plage', 'Montagne'],
    activities: ['Parc National de Gouraya', 'Cap Carbon', 'Randonnée', 'Plage'],
    attractions: ['Gouraya', 'Cap Carbon', 'Pic des Singes'],
    restaurants: ['La Marine', 'Chez Ali', 'Le Rocher'],
    defaultPricePerDay: 6500,
  ),
  WilayaData(
    name: 'Tipaza',
    region: 'Centre',
    imagePath: 'assets/images/wilayas/tipaza.jpg',
    categories: ['Plage', 'Culture'],
    activities: ['Ruines romaines', 'Tombeau de la Chrétienne', 'Plage Chenoua'],
    attractions: ['Ruines romaines', 'Tombeau de la Chrétienne', 'Plage Chenoua'],
    restaurants: ['La Plage', 'Chez Mimou', 'Le Pirate'],
    defaultPricePerDay: 7000,
  ),
  WilayaData(
    name: 'Tamanrasset',
    region: 'Sahara',
    imagePath: 'assets/images/wilayas/tamanrasset.jpg',
    categories: ['Sahara', 'Montagne'],
    activities: ['Hoggar', 'Assekrem', 'Randonnée dans le désert', 'Nuit à la belle étoile'],
    attractions: ['Hoggar', 'Assekrem', 'Tassili n\'Ajjer'],
    restaurants: ['Touareg', 'Le Désert', 'Chez Moussa'],
    defaultPricePerDay: 6000,
  ),
  // Ajoute les autres wilayas que tu as (Biskra, Djelfa, Mostaganem, etc.)
];