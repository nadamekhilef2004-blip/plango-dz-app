import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import '../utils/theme.dart';
import '../data/wilaya_data.dart';

class AITripPlannerPage extends StatefulWidget {
  const AITripPlannerPage({super.key});

  @override
  State<AITripPlannerPage> createState() => _AITripPlannerPageState();
}

class _AITripPlannerPageState extends State<AITripPlannerPage> {
  // Étape 1 : Catégorie
  String _selectedCategory = '';
  final List<String> _categories = ['Plage', 'Montagne', 'Sahara', 'Culture'];

  // Étape 2 : Wilaya
  WilayaData? _selectedWilaya;
  List<WilayaData> _filteredWilayas = [];

  // Étape 3 : Activités sélectionnées
  List<String> _selectedActivities = [];

  // Étape 4 : Durée
  int _duration = 3;

  // Étape 5 : Budget
  String _budgetMode = 'auto'; // 'auto', 'manual', 'economy', 'luxury'
  int _manualBudget = 50000;
  String _luxuryLevel = 'Moyen'; // 'Économique', 'Moyen', 'Luxe'

  // Résultat généré
  String _generatedItinerary = '';
  bool _isGenerating = false;

  // Contrôleurs
  final TextEditingController _manualBudgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _manualBudgetController.text = '50000';
  }

  @override
  void dispose() {
    _manualBudgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Planificateur IA'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🤖 Créez votre voyage sur mesure',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Suivez les étapes pour obtenir un itinéraire personnalisé et un PDF élégant.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),

            // Étape 1 : Catégorie
            const Text('1. Quel type de voyage ?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _categories.map((cat) {
                return ChoiceChip(
                  label: Text(cat),
                  selected: _selectedCategory == cat,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? cat : '';
                      _selectedWilaya = null;
                      _filteredWilayas = [];
                      _selectedActivities.clear();
                      if (selected) {
                        _filteredWilayas = allWilayas.where((w) => w.categories.contains(cat)).toList();
                      }
                    });
                  },
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: Colors.white,
                );
              }).toList(),
            ),

            if (_selectedCategory.isNotEmpty) ...[
              const SizedBox(height: 24),
              // Étape 2 : Wilaya
              const Text('2. Choisissez votre destination', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filteredWilayas.length,
                  itemBuilder: (context, index) {
                    final wilaya = _filteredWilayas[index];
                    final isSelected = _selectedWilaya == wilaya;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedWilaya = wilaya;
                          _selectedActivities.clear();
                        });
                      },
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.asset(
                                wilaya.imagePath,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(Icons.location_city, size: 40),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(wilaya.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            if (_selectedWilaya != null) ...[
              const SizedBox(height: 24),
              // Étape 3 : Activités
              const Text('3. Quelles activités souhaitez-vous ?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _selectedWilaya!.activities.map((activity) {
                  final isSelected = _selectedActivities.contains(activity);
                  return FilterChip(
                    label: Text(activity),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedActivities.add(activity);
                        } else {
                          _selectedActivities.remove(activity);
                        }
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Attractions supplémentaires (optionnel)
              const Text('Lieux d’intérêt disponibles :', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Wrap(
                spacing: 4,
                children: _selectedWilaya!.attractions.map((a) => Chip(label: Text(a), backgroundColor: Colors.grey.shade100)).toList(),
              ),

              const SizedBox(height: 24),
              // Étape 4 : Durée
              const Text('4. Durée du séjour (jours)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Row(
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

              const SizedBox(height: 24),
              // Étape 5 : Budget
              const Text('5. Budget', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Auto (estimation)'),
                      selected: _budgetMode == 'auto',
                      onSelected: (s) => setState(() => _budgetMode = 'auto'),
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Je donne un montant'),
                      selected: _budgetMode == 'manual',
                      onSelected: (s) => setState(() => _budgetMode = 'manual'),
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Économique'),
                      selected: _luxuryLevel == 'Économique',
                      onSelected: (s) => setState(() { _budgetMode = 'economy'; _luxuryLevel = 'Économique'; }),
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Moyen'),
                      selected: _luxuryLevel == 'Moyen',
                      onSelected: (s) => setState(() { _budgetMode = 'economy'; _luxuryLevel = 'Moyen'; }),
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Luxe'),
                      selected: _luxuryLevel == 'Luxe',
                      onSelected: (s) => setState(() { _budgetMode = 'economy'; _luxuryLevel = 'Luxe'; }),
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              if (_budgetMode == 'manual') ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _manualBudgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Budget total (DZD)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.money),
                  ),
                  onChanged: (value) => _manualBudget = int.tryParse(value) ?? 0,
                ),
              ],

              const SizedBox(height: 32),
              // Bouton Générer
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isGenerating ? null : _generateTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isGenerating
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('✨ Générer mon itinéraire ✨', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],

            if (_generatedItinerary.isNotEmpty) ...[
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '🗺️ Votre itinéraire personnalisé',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                              onPressed: () => _generateAndSharePDF(),
                              tooltip: 'Exporter en PDF',
                            ),
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () => _shareText(),
                              tooltip: 'Partager',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      _generatedItinerary,
                      style: const TextStyle(height: 1.6),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _generateTrip() async {
    if (_selectedWilaya == null) return;
    setState(() {
      _isGenerating = true;
      _generatedItinerary = '';
    });

    // Calcul du budget si auto
    int totalBudget = 0;
    if (_budgetMode == 'auto') {
      totalBudget = (_selectedWilaya!.defaultPricePerDay * _duration).round();
    } else if (_budgetMode == 'manual') {
      totalBudget = _manualBudget;
    } else {
      // economy / moyen / luxe
      double multiplier = _luxuryLevel == 'Économique' ? 0.7 : (_luxuryLevel == 'Luxe' ? 1.8 : 1.2);
      totalBudget = (_selectedWilaya!.defaultPricePerDay * _duration * multiplier).round();
    }

    // Génération locale (car OpenAI nécessite clé, on utilise un template enrichi)
    String itinerary = _generateLocalItinerary(
      wilaya: _selectedWilaya!,
      duration: _duration,
      activities: _selectedActivities,
      budget: totalBudget,
    );
    setState(() {
      _generatedItinerary = itinerary;
      _isGenerating = false;
    });
  }

  String _generateLocalItinerary({
    required WilayaData wilaya,
    required int duration,
    required List<String> activities,
    required int budget,
  }) {
    StringBuffer sb = StringBuffer();
    sb.writeln('## 🌟 Itinéraire à ${wilaya.name} ($duration jours)\n');
    sb.writeln('**Budget total estimé :** ${NumberFormat('#,##0').format(budget)} DZD\n');
    sb.writeln('**Activités sélectionnées :** ${activities.isEmpty ? 'Toutes les activités suggérées' : activities.join(', ')}\n');
    sb.writeln('---\n');

    for (int day = 1; day <= duration; day++) {
      sb.writeln('### Jour $day');
      sb.writeln('');
      // Choix d’activités cyclique
      int actIndex = (day - 1) % wilaya.activities.length;
      String mainActivity = activities.isNotEmpty && day <= activities.length
          ? activities[day - 1]
          : wilaya.activities[actIndex];
      sb.writeln('- **Matin :** $mainActivity');
      sb.writeln('- **Déjeuner :** ${wilaya.restaurants[day % wilaya.restaurants.length]} (cuisine locale)');
      sb.writeln('- **Après-midi :** Visite de ${wilaya.attractions[(day * 2) % wilaya.attractions.length]}');
      sb.writeln('- **Dîner & Hébergement :** ${wilaya.restaurants[(day + 1) % wilaya.restaurants.length]} – Hôtel recommandé (à partir de ${(budget / duration * 0.4).round()} DA/nuit)');
      sb.writeln('');
    }

    sb.writeln('## 💡 Conseils pratiques');
    sb.writeln('- **Transport :** Sur place, taxis ou location de voiture recommandée.');
    sb.writeln('- **Météo :** Consultez la météo avant votre départ (saison ${wilaya.categories.contains('Plage') ? 'idéale en été' : 'printemps/automne'}).');
    sb.writeln('- **Argent :** Prévoyez des espèces pour les petits commerces.');
    sb.writeln('- **Langue :** Le français est largement compris.');
    sb.writeln('');
    sb.writeln('✨ Profitez de votre séjour à ${wilaya.name} !');

    return sb.toString();
  }

  Future<void> _generateAndSharePDF() async {
    if (_generatedItinerary.isEmpty) return;

    // Utiliser PdfGoogleFonts pour le web (pas besoin de fichiers locaux)
    final poppinsRegular = await PdfGoogleFonts.poppinsRegular();
    final poppinsBold = await PdfGoogleFonts.poppinsBold();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'PlanGo Dz - Itinéraire personnalisé',
              style: pw.TextStyle(font: poppinsBold, fontSize: 24, color: PdfColors.green800),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Généré le ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
            style: pw.TextStyle(font: poppinsRegular, fontSize: 12, color: PdfColors.grey),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            _generatedItinerary,
            style: pw.TextStyle(font: poppinsRegular, fontSize: 11),
          ),
          pw.SizedBox(height: 30),
          pw.Center(
            child: pw.Text(
              'PlanGo Dz – Votre guide de voyage en Algérie',
              style: pw.TextStyle(font: poppinsRegular, fontSize: 10, color: PdfColors.grey),
            ),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'plan_voyage_${_selectedWilaya?.name}.pdf',
    );
  }

  void _shareText() {
    Share.share(_generatedItinerary, subject: 'Mon voyage sur mesure');
  }
}