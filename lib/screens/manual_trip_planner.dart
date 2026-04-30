import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ManualTripPlannerPage extends StatefulWidget {
  const ManualTripPlannerPage({super.key});

  @override
  State<ManualTripPlannerPage> createState() => _ManualTripPlannerPageState();
}

class _ManualTripPlannerPageState extends State<ManualTripPlannerPage> {
  int _currentStep = 0;
  String _selectedCategory = '';
  String _selectedActivityType = '';
  String _selectedDestination = '';
  List<String> _selectedActivities = [];
  String _selectedTravelCompanion = '';
  String _selectedTransport = '';
  double _budgetAmount = 50000;
  int _duration = 3;

  // === LISTE DES CATÉGORIES (comme sur l'image) ===
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Montagnes', 'icon': '🏔', 'image': 'assets/images/montagne.jpg', 'color': 0xFF81C784},
    {'name': 'Plages', 'icon': '', 'image': 'assets/images/plage.jpg', 'color': 0xFF4FC3F7},
    {'name': 'Sahara', 'icon': '', 'image': 'assets/images/sahara.jpg', 'color': 0xFFFFB74D},
    {'name': 'Culture', 'icon': '', 'image': 'assets/images/culture.jpg', 'color': 0xFFCE93D8},
    {'name': 'Camping', 'icon': '🏕', 'image': 'assets/images/camping.jpg', 'color': 0xFF81C784},
    {'name': 'Randonnée', 'icon': '🥾', 'image': 'assets/images/randonnee.jpg', 'color': 0xFF81C784},
  ];

  final Map<String, List<Map<String, dynamic>>> _activitiesByCategory = {
    'Montagnes': [
      {'name': 'Tizi Ouzou', 'activities': ['Randonnée Djurdjura', 'Forêt d\'Akfadou'], 'image': 'assets/images/tizi.jpg', 'color': 0xFF81C784},
      {'name': 'Béjaïa', 'activities': ['Parc National Gouraya', 'Montagne de Yemma'], 'image': 'assets/images/bejaia.jpg', 'color': 0xFF81C784},
      {'name': 'Blida', 'activities': ['Forêt de Chréa', 'Télécabine Chréa'], 'image': 'assets/images/blida.jpg', 'color': 0xFF81C784},
      {'name': 'Sétif', 'activities': ['Mont Babor', 'Forêt de Guergour'], 'image': 'assets/images/setif.jpg', 'color': 0xFF81C784},
    ],
    'Plages': [
      {'name': 'Annaba', 'activities': ['Plage Sable d\'Or', 'Baignade', 'Jet Ski'], 'image': 'assets/images/annaba.jpg', 'color': 0xFF4FC3F7},
      {'name': 'Alger', 'activities': ['Plage Sablettes', 'Plage Palm Beach'], 'image': 'assets/images/alger_plage.jpg', 'color': 0xFF4FC3F7},
      {'name': 'Oran', 'activities': ['Les Andalouses', 'Madagh Plage'], 'image': 'assets/images/oran_plage.jpg', 'color': 0xFF4FC3F7},
      {'name': 'Tipaza', 'activities': ['Plage Chenoua', 'Plage El Kiffane'], 'image': 'assets/images/tipaza.jpg', 'color': 0xFF4FC3F7},
    ],
    'Sahara': [
      {'name': 'Ghardaïa', 'activities': ['Vallée du M\'zab', 'Palmeraie'], 'image': 'assets/images/ghardaia.jpg', 'color': 0xFFFFB74D},
      {'name': 'Tamanrasset', 'activities': ['Hoggar', 'Assekrem'], 'image': 'assets/images/tamanrasset.jpg', 'color': 0xFFFFB74D},
      {'name': 'Biskra', 'activities': ['Palmeraie', 'Hammam Salah'], 'image': 'assets/images/biskra.jpg', 'color': 0xFFFFB74D},
    ],
    'Culture': [
      {'name': 'Alger', 'activities': ['Casbah', 'Musée du Bardo'], 'image': 'assets/images/alger_casbah.jpg', 'color': 0xFFCE93D8},
      {'name': 'Constantine', 'activities': ['Pont Sidi M\'Cid', 'Palais Ahmed Bey'], 'image': 'assets/images/constantine.jpg', 'color': 0xFFCE93D8},
      {'name': 'Tlemcen', 'activities': ['Mosquée Sidi Boumediene', 'Mansourah'], 'image': 'assets/images/tlemcen.jpg', 'color': 0xFFCE93D8},
      {'name': 'Djemila', 'activities': ['Ruines Romaines', 'Musée'], 'image': 'assets/images/djemila.jpg', 'color': 0xFFCE93D8},
    ],
    'Camping': [
      {'name': 'Tikjda (Bouira)', 'activities': ['Camping en forêt', 'Randonnée'], 'image': 'assets/images/tikjda.jpg', 'color': 0xFF81C784},
      {'name': 'Chréa (Blida)', 'activities': ['Camping', 'Ski en hiver'], 'image': 'assets/images/crea.jpg', 'color': 0xFF81C784},
    ],
    'Randonnée': [
      {'name': 'Djurdjura (Tizi)', 'activities': ['Randonnée', 'Pic des Singes'], 'image': 'assets/images/djurdjura.jpg', 'color': 0xFF81C784},
      {'name': 'Gouraya (Béjaïa)', 'activities': ['Randonnée côtière', 'Observation'], 'image': 'assets/images/gouraya.jpg', 'color': 0xFF81C784},
    ],
  };

  final List<Map<String, dynamic>> _activitiesList = [
    {'name': 'Randonnée', 'icon': '🥾', 'image': 'assets/images/randonnee.jpg', 'color': 0xFF81C784},
    {'name': 'Baignade', 'icon': '🏊', 'image': 'assets/images/baignade.jpg', 'color': 0xFF4FC3F7},
    {'name': 'Visite historique', 'icon': '', 'image': 'assets/images/visite_historique.jpg', 'color': 0xFFCE93D8},
    {'name': 'Photographie', 'icon': '📸', 'image': null, 'color': 0xFFFFB74D},
    {'name': 'Cuisine locale', 'icon': '🍲', 'image': 'assets/images/cuisine.jpg', 'color': 0xFFF06292},
    {'name': 'Shopping', 'icon': '🛍', 'image': 'assets/images/shopping.jpg', 'color': 0xFFE57373},
    {'name': 'Camping', 'icon': '🏕', 'image': 'assets/images/camping.jpg', 'color': 0xFF81C784},
    {'name': 'Ski', 'icon': '⛷', 'image': 'assets/images/ski.jpg', 'color': 0xFF90CAF9},
    {'name': 'Plongée', 'icon': '🤿', 'image': 'assets/images/plongee.jpg', 'color': 0xFF4FC3F7},
  ];

  final List<Map<String, dynamic>> _companionsList = [
    {'icon': '👤', 'label': 'Seul', 'desc': 'Voyage en solo', 'color': 0xFFB0BEC5},
    {'icon': '👥', 'label': 'En couple', 'desc': 'Voyage romantique', 'color': 0xFFF48FB1},
    {'icon': '👨‍👩‍👧', 'label': 'En famille', 'desc': 'Avec enfants', 'color': 0xFF81C784},
    {'icon': '👫', 'label': 'Entre amis', 'desc': 'Voyage entre potes', 'color': 0xFFFFB74D},
    {'icon': '🏢', 'label': 'Groupe organisé', 'desc': 'Voyage en groupe', 'color': 0xFF90CAF9},
  ];

  final List<Map<String, dynamic>> _transportsList = [
    {'icon': '🚗', 'label': 'Voiture personnelle', 'desc': 'Liberté et flexibilité', 'color': 0xFF4FC3F7},
    {'icon': '🚌', 'label': 'Bus/Train', 'desc': 'Économique et confortable', 'color': 0xFF81C784},
    {'icon': '✈', 'label': 'Avion', 'desc': 'Rapide pour longues distances', 'color': 0xFFFFB74D},
    {'icon': '🚐', 'label': 'Location de voiture', 'desc': 'À la location sur place', 'color': 0xFFE57373},
    {'icon': '👣', 'label': 'Randonnée', 'desc': 'Pour les aventuriers', 'color': 0xFF81C784},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Planificateur manuel'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 6) {
            setState(() => _currentStep++);
          } else {
            _showTripSummary();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
        },
        controlsBuilder: (context, details) => Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: details.onStepContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(_currentStep == 6 ? 'Voir mon voyage' : 'Suivant', style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              if (_currentStep > 0)
                OutlinedButton(
                  onPressed: details.onStepCancel,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Précédent'),
                ),
            ],
          ),
        ),
        steps: [
          _buildStep(0, '🎯 Choisis une catégorie', _buildCategoryStep()),
          _buildStep(1, '🌍 Type de voyage', _buildTravelTypeStep()),
          _buildStep(2, ' Activités', _buildActivityStep()),
          _buildStep(3, '👥 Compagnie', _buildCompanionStep()),
          _buildStep(4, '🚗 Transport', _buildTransportStep()),
          _buildStep(5, '💰 Budget', _buildBudgetStep()),
          _buildStep(6, '📅 Durée', _buildDurationStep()),
          _buildStep(7, '✅ Récapitulatif', _buildSummaryStep()),
        ],
      ),
    );
  }

  Step _buildStep(int index, String title, Widget content) => Step(
    title: Text(title),
    content: content,
    isActive: _currentStep >= index,
    state: _currentStep > index ? StepState.complete : StepState.indexed,
  );

  // === ÉTAPE 0 : CATÉGORIES (comme sur l'image) ===
  Widget _buildCategoryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choisis une catégorie de voyage :', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _selectedCategory == cat['name'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = cat['name'];
                    _selectedActivityType = cat['name'];
                    _selectedDestination = '';
                    _selectedActivities.clear();
                  });
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: AppTheme.primaryColor, width: 3) : null,
                          image: DecorationImage(
                            image: AssetImage(cat['image']),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {},
                          ),
                        ),
                        child: cat['image'] == null ? Container(
                          decoration: BoxDecoration(
                            color: Color(cat['color']),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text(cat['icon'], style: const TextStyle(fontSize: 28))),
                        ) : null,
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
    );
  }

  Widget _buildTravelTypeStep() {
    if (_selectedCategory.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.info, color: Colors.orange),
            SizedBox(width: 8),
            Expanded(child: Text('Veuillez d\'abord choisir une catégorie à l\'étape précédente.')),
          ],
        ),
      );
    }

    final destinations = _activitiesByCategory[_selectedCategory] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Destinations disponibles pour "$_selectedCategory" :', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...destinations.map((dest) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: _buildAvatar(dest['image'], dest['name'][0], dest['color']),
            title: Text(dest['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Activités: ${(dest['activities'] as List).join(', ')}'),
            trailing: Radio<String>(
              value: dest['name'],
              groupValue: _selectedDestination,
              onChanged: (value) {
                setState(() {
                  _selectedDestination = value!;
                  _selectedActivities = List.from(dest['activities']);
                });
              },
              activeColor: AppTheme.primaryColor,
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildActivityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sélectionnez vos activités préférées :', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _activitiesList.map((activity) {
            final isSelected = _selectedActivities.contains(activity['name']);
            return FilterChip(
              label: Text(activity['name']),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedActivities.add(activity['name']);
                  } else {
                    _selectedActivities.remove(activity['name']);
                  }
                });
              },
              avatar: _buildAvatar(activity['image'], activity['icon'], activity['color']),
              backgroundColor: Colors.white,
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCompanionStep() {
    return Column(
      children: _companionsList.map((comp) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: RadioListTile<String>(
          title: Text('${comp['icon']} ${comp['label']}', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(comp['desc']),
          value: comp['label'],
          groupValue: _selectedTravelCompanion,
          onChanged: (value) => setState(() => _selectedTravelCompanion = value!),
          activeColor: AppTheme.primaryColor,
        ),
      )).toList(),
    );
  }

  Widget _buildTransportStep() {
    return Column(
      children: _transportsList.map((trans) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: RadioListTile<String>(
          title: Text('${trans['icon']} ${trans['label']}', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(trans['desc']),
          value: trans['label'],
          groupValue: _selectedTransport,
          onChanged: (value) => setState(() => _selectedTransport = value!),
          activeColor: AppTheme.primaryColor,
        ),
      )).toList(),
    );
  }

  Widget _buildAvatar(String? imagePath, String fallback, int color) {
    if (imagePath != null) {
      return ClipOval(
        child: Image.asset(
          imagePath,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => CircleAvatar(
            backgroundColor: Color(color),
            child: Text(fallback, style: const TextStyle(fontSize: 16)),
          ),
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Color(color),
        child: Text(fallback, style: const TextStyle(fontSize: 16)),
      );
    }
  }

  // BUDGET
  Widget _buildBudgetStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Budget total (DZD) :', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _budgetAmount,
                min: 10000,
                max: 500000,
                divisions: 20,
                label: '${_budgetAmount.round()} DZD',
                onChanged: (value) => setState(() => _budgetAmount = value),
                activeColor: AppTheme.primaryColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('${_budgetAmount.round()} DA', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            _buildBudgetChip('Économique', 30000),
            _buildBudgetChip('Moyen', 150000),
            _buildBudgetChip('Confort', 300000),
            _buildBudgetChip('Luxe', 500000),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetChip(String label, int amount) => FilterChip(
    label: Text('$label ($amount DA)'),
    selected: _budgetAmount.round() == amount,
    onSelected: (selected) => setState(() => _budgetAmount = amount.toDouble()),
    backgroundColor: Colors.white,
    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
  );

  // DURÉE
  Widget _buildDurationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Durée du voyage (jours) :', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle, size: 40),
                onPressed: () => setState(() => _duration > 1 ? _duration-- : null),
                color: AppTheme.primaryColor,
              ),
              Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$_duration', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, size: 40),
                onPressed: () => setState(() => _duration < 21 ? _duration++ : null),
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('Suggestions de durée :', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildDurationChip('Week-end', 2),
            _buildDurationChip('Petite semaine', 5),
            _buildDurationChip('Une semaine', 7),
            _buildDurationChip('10 jours', 10),
            _buildDurationChip('2 semaines', 14),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationChip(String label, int days) => FilterChip(
    label: Text(label),
    selected: _duration == days,
    onSelected: (selected) => setState(() => _duration = days),
    backgroundColor: Colors.white,
    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
  );

  // RÉCAPITULATIF
  Widget _buildSummaryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryCard('🎯 Catégorie', _selectedCategory.isEmpty ? 'Non sélectionnée' : _selectedCategory),
        _buildSummaryCard('🌍 Destination', _selectedDestination.isEmpty ? 'Non sélectionnée' : _selectedDestination),
        _buildSummaryCard(' Activités', _selectedActivities.isEmpty ? 'Aucune' : _selectedActivities.join(', ')),
        _buildSummaryCard('👥 Compagnie', _selectedTravelCompanion.isEmpty ? 'Non sélectionnée' : _selectedTravelCompanion),
        _buildSummaryCard('🚗 Transport', _selectedTransport.isEmpty ? 'Non sélectionné' : _selectedTransport),
        _buildSummaryCard('💰 Budget', '${_budgetAmount.round()} DA'),
        _buildSummaryCard('📅 Durée', '$_duration jours'),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.green),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    ),
  );

  void _showTripSummary() {
    int estimatedCost = (_duration * 5000 + (_budgetAmount * 0.3)).round();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Voyage planifié !'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Récapitulatif de votre voyage :', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('📍 Destination: ${_selectedDestination.isEmpty ? _selectedCategory : _selectedDestination}'),
              Text('🎯 Activités: ${_selectedActivities.take(3).join(', ')}${_selectedActivities.length > 3 ? '...' : ''}'),
              Text('👥 Avec: ${_selectedTravelCompanion.isEmpty ? 'Non spécifié' : _selectedTravelCompanion}'),
              Text('🚗 Transport: ${_selectedTransport.isEmpty ? 'Non spécifié' : _selectedTransport}'),
              Text('📅 Durée: $_duration jours'),
              Text('💰 Budget estimé: $estimatedCost DA'),
              const Divider(),
              const Text(' Suggestions:', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('• Réservez vos hébergements à l\'avance'),
              const Text('• Prévoyez des vêtements adaptés'),
              const Text('• Téléchargez les cartes hors ligne'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Modifier')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voyage enregistré !'), backgroundColor: Colors.green));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}