import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/theme.dart';
import '../data/wilaya_data.dart';
import '../services/trip_ai_service.dart';
import '../models/trip_plan.dart';
import '../widgets/day_card_widget.dart';

class SmartTripPlannerPage extends StatefulWidget {
  const SmartTripPlannerPage({super.key});

  @override
  State<SmartTripPlannerPage> createState() => _SmartTripPlannerPageState();
}

class _SmartTripPlannerPageState extends State<SmartTripPlannerPage> {
  final TripAIService _aiService = TripAIService();
  
  // User preferences
  String _selectedCategory = '';
  final List<String> _categories = ['Plage', 'Montagne', 'Sahara', 'Culture'];
  
  int _duration = 3;
  String _budgetMode = 'auto';
  int _manualBudget = 50000;
  String _luxuryLevel = 'Normal';
  List<String> _selectedActivities = [];
  
  // Result
  TripPlan? _currentTrip;
  bool _isGenerating = false;
  
  final TextEditingController _manualBudgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _manualBudgetController.text = '50000';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Smart Trip Planner'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isGenerating
          ? const Center(child: CircularProgressIndicator())
          : _currentTrip == null
              ? _buildPreferencesForm()
              : _buildTripView(),
    );
  }

  Widget _buildPreferencesForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('1. Choose your category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _categories.map((cat) => ChoiceChip(
              label: Text(cat),
              selected: _selectedCategory == cat,
              onSelected: (selected) => setState(() => _selectedCategory = selected ? cat : ''),
              selectedColor: AppTheme.primaryColor,
            )).toList(),
          ),
          const SizedBox(height: 20),
          
          const Text('2. Duration (days)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle, size: 40),
                onPressed: () => setState(() => _duration > 1 ? _duration-- : null),
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
                onPressed: () => setState(() => _duration < 14 ? _duration++ : null),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          const Text('3. Budget', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: ChoiceChip(
                label: const Text('Auto'),
                selected: _budgetMode == 'auto',
                onSelected: (s) => setState(() => _budgetMode = 'auto'),
              )),
              const SizedBox(width: 8),
              Expanded(child: ChoiceChip(
                label: const Text('Manual'),
                selected: _budgetMode == 'manual',
                onSelected: (s) => setState(() => _budgetMode = 'manual'),
              )),
            ],
          ),
          if (_budgetMode == 'manual') ...[
            const SizedBox(height: 8),
            TextField(
              controller: _manualBudgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Budget (DZD)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (v) => _manualBudget = int.tryParse(v) ?? 0,
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Économique', 'Normal', 'Luxe'].map((level) => ChoiceChip(
              label: Text(level),
              selected: _luxuryLevel == level,
              onSelected: (s) => setState(() => _luxuryLevel = s ? level : 'Normal'),
              selectedColor: AppTheme.primaryColor,
            )).toList(),
          ),
          const SizedBox(height: 20),
          
          const Text('4. Activities (optional)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Randonnée', 'Baignade', 'Visite', 'Photographie', 'Shopping', 'Camping'].map((act) => FilterChip(
              label: Text(act),
              selected: _selectedActivities.contains(act),
              onSelected: (s) => setState(() {
                if (s) _selectedActivities.add(act);
                else _selectedActivities.remove(act);
              }),
            )).toList(),
          ),
          const SizedBox(height: 32),
          
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _generateTrip,
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
              child: const Text('✨ Generate My Trip ✨', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  void _generateTrip() {
    if (_selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }
    
    setState(() => _isGenerating = true);
    
    Future.delayed(const Duration(seconds: 1), () {
      final trip = _aiService.generateTrip(
        category: _selectedCategory,
        duration: _duration,
        budgetMode: _budgetMode,
        manualBudget: _budgetMode == 'manual' ? _manualBudget : null,
        luxuryLevel: _luxuryLevel,
        selectedActivities: _selectedActivities,
      );
      setState(() {
        _currentTrip = trip;
        _isGenerating = false;
      });
    });
  }

  Widget _buildTripView() {
    return Column(
      children: [
        // Header with trip info
        Container(
          padding: const EdgeInsets.all(16),
          color: AppTheme.primaryColor,
          child: Column(
            children: [
              Text(
                _currentTrip!.wilaya.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                '${_currentTrip!.duration} days | ${_currentTrip!.totalBudget} DZD',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        
        // Days list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _currentTrip!.days.length,
            itemBuilder: (context, index) {
              final day = _currentTrip!.days[index];
              return DayCardWidget(
                day: day,
                dayIndex: index,
                onEdit: () => _showEditDialog(index),
                onRegenerate: () => _regenerateDay(index),
                onToggleLock: () => _toggleLockDay(index),
              );
            },
          ),
        ),
        
        // Export button
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _exportPDF(),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Export PDF'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareTrip(),
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(int dayIndex) {
    final day = _currentTrip!.days[dayIndex];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Day ${day.dayNumber}'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildEditField('Morning', day.morningActivity, (v) => day.morningActivity = v),
              const SizedBox(height: 12),
              _buildEditField('Afternoon', day.afternoonActivity, (v) => day.afternoonActivity = v),
              const SizedBox(height: 12),
              _buildEditField('Evening', day.eveningActivity, (v) => day.eveningActivity = v),
              const SizedBox(height: 12),
              _buildEditField('Restaurant', day.restaurant, (v) => day.restaurant = v),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEditField(String label, String value, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      controller: TextEditingController(text: value),
      onChanged: onChanged,
    );
  }

  void _regenerateDay(int dayIndex) {
    setState(() {
      final newDay = _aiService.regenerateDay(
        _currentTrip!.wilaya,
        dayIndex + 1,
        _currentTrip!.days.map((d) => d.morningActivity).toList(),
      );
      _currentTrip!.days[dayIndex] = newDay;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Day regenerated!')));
  }

  void _toggleLockDay(int dayIndex) {
    setState(() {
      _currentTrip!.days[dayIndex].isLocked = !_currentTrip!.days[dayIndex].isLocked;
    });
  }

  void _exportPDF() async {
    // Simple PDF export
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Text('Trip to ${_currentTrip!.wilaya.name}'),
        ),
      ),
    );
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'trip_plan.pdf');
  }

  void _shareTrip() {
    String text = 'Trip to ${_currentTrip!.wilaya.name}\n';
    text += 'Duration: ${_currentTrip!.duration} days\n';
    text += 'Budget: ${_currentTrip!.totalBudget} DZD\n\n';
    for (var day in _currentTrip!.days) {
      text += 'Day ${day.dayNumber}:\n';
      text += '  Morning: ${day.morningActivity}\n';
      text += '  Afternoon: ${day.afternoonActivity}\n';
      text += '  Evening: ${day.eveningActivity}\n\n';
    }
    Share.share(text, subject: 'My Trip Plan');
  }
}
