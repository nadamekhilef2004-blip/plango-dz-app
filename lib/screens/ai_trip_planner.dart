import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AITripPlannerPage extends StatefulWidget {
  const AITripPlannerPage({super.key});

  @override
  State<AITripPlannerPage> createState() => _AITripPlannerPageState();
}

class _AITripPlannerPageState extends State<AITripPlannerPage> {
  int _days = 3;
  String _selectedRegion = 'All';
  DateTime? _startDate;
  int _travelers = 1;
  List<Map<String, dynamic>> _itinerary = [];
  bool _isGenerating = false;
  final List<String> _selectedInterests = [];
  
  final List<String> regions = ['All', 'Central', 'North East', 'Saharan Algeria'];
  final List<Map<String, dynamic>> interests = [
    {'icon': '🏛️', 'name': 'History', 'emoji': '🏛️'},
    {'icon': '🏖️', 'name': 'Beach', 'emoji': '🏖️'},
    {'icon': '🏔️', 'name': 'Mountains', 'emoji': '🏔️'},
    {'icon': '🏜️', 'name': 'Desert', 'emoji': '🏜️'},
    {'icon': '🍽️', 'name': 'Food', 'emoji': '🍽️'},
    {'icon': '🎨', 'name': 'Culture', 'emoji': '🎨'},
    {'icon': '📸', 'name': 'Photography', 'emoji': '📸'},
    {'icon': '🕌', 'name': 'Architecture', 'emoji': '🕌'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Trip Planner'),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'AI-Powered Trip Planner',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let AI create your perfect Algerian adventure',
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ),
            
            // Trip Configuration
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Duration
                  const Text(
                    '📅 Trip Duration',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (_days > 1) setState(() => _days--);
                          },
                        ),
                        Text(
                          '$_days ${_days == 1 ? 'Day' : 'Days'}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (_days < 14) setState(() => _days++);
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Start Date
                  const Text(
                    '📆 Start Date',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Color(0xFF2E7D32)),
                          const SizedBox(width: 12),
                          Text(
                            _startDate == null
                                ? 'Select start date'
                                : DateFormat('EEEE, MMMM d, yyyy').format(_startDate!),
                            style: TextStyle(
                              color: _startDate == null ? Colors.grey : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Travelers
                  const Text(
                    '👥 Travelers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Number of travelers', style: TextStyle(fontSize: 16)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (_travelers > 1) setState(() => _travelers--);
                              },
                            ),
                            Text(
                              '$_travelers',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                if (_travelers < 10) setState(() => _travelers++);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Region
                  const Text(
                    '🗺️ Region Preference',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: regions.length,
                      itemBuilder: (context, index) {
                        final region = regions[index];
                        final isSelected = _selectedRegion == region;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(region),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedRegion = region;
                              });
                            },
                            backgroundColor: Colors.grey.shade200,
                            selectedColor: const Color(0xFF2E7D32),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Interests
                  const Text(
                    '⭐ Interests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: interests.map((interest) {
                      final isSelected = _selectedInterests.contains(interest['name']);
                      return FilterChip(
                        label: Text('${interest['icon']} ${interest['name']}'),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedInterests.add(interest['name'] as String);
                            } else {
                              _selectedInterests.remove(interest['name']);
                            }
                          });
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: const Color(0xFF2E7D32).withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF2E7D32) : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Generate Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _generateItinerary,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isGenerating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              '✨ Generate My Trip ✨',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Generated Itinerary
            if (_itinerary.isNotEmpty) ...[
              const Divider(height: 32),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Personalized Itinerary',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '✨ AI-generated plan based on your preferences',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    if (_startDate != null)
                      Text(
                        '📅 Starting ${DateFormat('MMMM d, yyyy').format(_startDate!)}',
                        style: TextStyle(color: const Color(0xFF2E7D32), fontWeight: FontWeight.w500),
                      ),
                    const SizedBox(height: 16),
                    ..._itinerary.map((day) => _buildDayCard(day)),
                    
                    // Summary Card
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0xFF2E7D32).withOpacity(0.1), Colors.white],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Trip Summary',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow('Total Days', '$_days days'),
                          _buildSummaryRow('Travelers', '$_travelers person${_travelers > 1 ? 's' : ''}'),
                          _buildSummaryRow('Region', _selectedRegion),
                          _buildSummaryRow('Interests', _selectedInterests.isEmpty ? 'All' : _selectedInterests.join(', ')),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Trip saved to My Trips!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.save),
                              label: const Text('Save This Trip'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _generateItinerary() {
    setState(() {
      _isGenerating = true;
    });
    
    // Simulate AI generation delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _itinerary = _createSampleItinerary();
        _isGenerating = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✨ Your personalized itinerary is ready! ✨'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  List<Map<String, dynamic>> _createSampleItinerary() {
    List<Map<String, dynamic>> itinerary = [];
    
    for (int i = 1; i <= _days; i++) {
      itinerary.add({
        'day': i,
        'title': _getDayTitle(i),
        'activities': _getActivitiesForDay(i),
        'meals': _getMealsForDay(i),
        'accommodation': _getAccommodationForDay(i),
        'highlights': _getHighlightsForDay(i),
        'weather': _getWeatherForDay(i),
      });
    }
    
    return itinerary;
  }

  String _getDayTitle(int day) {
    if (day == 1) return '🌅 Arrival & Discovery';
    if (day == _days) return '🎁 Culture & Departure';
    if (day == 2 && _days > 2) return '🏛️ Historical Exploration';
    if (day == 3 && _days > 3) return '🍽️ Culinary Experience';
    if (day == 4 && _days > 4) return '🏔️ Adventure Day';
    return '🗺️ Exploration Day';
  }

  List<String> _getActivitiesForDay(int day) {
    List<String> activities = [
      'Morning: Visit historical landmarks and museums',
      'Afternoon: Local cuisine tasting and shopping',
      'Evening: Cultural performance or sunset view',
    ];
    
    if (_selectedRegion == 'Saharan Algeria') {
      activities.add('🌙 Night: Stargazing in the desert');
    }
    if (_selectedInterests.contains('Beach')) {
      activities.add('🏖️ Beach time and water activities');
    }
    if (_selectedInterests.contains('Mountains')) {
      activities.add('⛰️ Mountain hiking and scenic views');
    }
    if (day == 1) {
      activities.insert(0, '🛎️ Check-in and welcome briefing');
    }
    if (day == _days) {
      activities.add('🎁 Souvenir shopping');
      activities.add('✈️ Transfer to airport/station');
    }
    
    return activities;
  }

  List<String> _getMealsForDay(int day) {
    List<String> meals = [
      '🍳 Breakfast: Traditional Algerian breakfast with msemen and honey',
      '🍲 Lunch: Local restaurant - Try couscous or chorba',
      '🍽️ Dinner: Authentic mechoui (roasted lamb) or tajine',
    ];
    
    if (_selectedInterests.contains('Food')) {
      meals.add('🍰 Dessert: Traditional baklava or makroud');
    }
    
    return meals;
  }

  String _getAccommodationForDay(int day) {
    if (day == 1) return '🏨 Central hotel with traditional architecture';
    if (_selectedRegion == 'Saharan Algeria') return '🏜️ Desert camp experience';
    if (_selectedInterests.contains('Beach')) return '🏖️ Beachfront resort';
    return '🏨 Local riad or boutique hotel';
  }

  List<String> _getHighlightsForDay(int day) {
    List<String> highlights = [];
    
    if (day == 1) highlights.add('Welcome dinner with traditional music');
    if (day == 2 && _selectedRegion == 'Central') highlights.add('Casbah guided tour');
    if (day == 3 && _selectedInterests.contains('Photography')) highlights.add('Sunset photography session');
    if (day == _days) highlights.add('Farewell ceremony');
    
    return highlights;
  }

  String _getWeatherForDay(int day) {
    if (_selectedRegion == 'Saharan Algeria') return '☀️ Hot and sunny, 25-35°C';
    if (_selectedRegion == 'North East') return '🌊 Mild Mediterranean, 18-25°C';
    return '🌤️ Pleasant weather, 20-28°C';
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDayCard(Map<String, dynamic> day) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2E7D32),
          child: Text('${day['day']}', style: const TextStyle(color: Colors.white)),
        ),
        title: Text(day['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(day['weather'], style: const TextStyle(fontSize: 12)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Accommodation
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.hotel, size: 20, color: Color(0xFF2E7D32)),
                      const SizedBox(width: 12),
                      Expanded(child: Text(day['accommodation'])),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Activities
                const Text(
                  '📋 Activities',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ...(day['activities'] as List).map((activity) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: Color(0xFF2E7D32)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(activity)),
                    ],
                  ),
                )),
                
                const SizedBox(height: 16),
                
                // Meals
                const Text(
                  '🍽️ Meals',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ...(day['meals'] as List).map((meal) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $meal'),
                )),
                
                // Highlights
                if ((day['highlights'] as List).isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    '⭐ Highlights',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  ...(day['highlights'] as List).map((highlight) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(highlight),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}