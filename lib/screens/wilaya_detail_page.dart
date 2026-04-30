import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../models/destination.dart';
import 'recommendation_page.dart';

class WilayaDetailPage extends StatelessWidget {
  final String name;
  final String icon;
  final Color color;
  final String imagePath;
  final String description;
  final List<String> attractions;
  final String bestTime;
  final String famousFood;
  final List<Destination>? allDestinations;

  const WilayaDetailPage({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.imagePath,
    required this.description,
    required this.attractions,
    required this.bestTime,
    required this.famousFood,
    this.allDestinations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(name),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: color.withOpacity(0.3),
                  child: Center(child: Text(icon, style: const TextStyle(fontSize: 64))),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Name
            Text(
              name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Description
            Text(
              description,
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            
            // Best time
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Best time: $bestTime')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Attractions
            const Text('Attractions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...attractions.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: color),
                  const SizedBox(width: 8),
                  Expanded(child: Text(a)),
                ],
              ),
            )),
            const SizedBox(height: 16),
            
            // Cuisine
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.restaurant),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Cuisine: $famousFood')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
