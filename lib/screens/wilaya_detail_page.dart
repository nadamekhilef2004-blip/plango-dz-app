import 'package:flutter/material.dart';
import '../utils/theme.dart';
<<<<<<< HEAD
import '../models/destination.dart';
import 'recommendation_page.dart';
=======
import 'recommendation_page.dart';
import '../models/destination.dart';
>>>>>>> 4b7ad39b7e8138d7e70f9fbadf5d6a44369d5561

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
    final currentDestination = Destination(
      name: name,
      region: '',
      imageUrl: imagePath,
      description: description,
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(name),
        backgroundColor: color,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.recommend),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecommendationPage(
                    allDestinations: allDestinations ?? [],
                    currentDestination: currentDestination,
                  ),
                ),
              );
            },
            tooltip: 'Recommendations',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
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
=======
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(icon, style: const TextStyle(fontSize: 32)),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212423),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Best time to visit',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(bestTime),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Attractions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212423),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...attractions.map((attraction) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 20, color: color),
                        const SizedBox(width: 12),
                        Expanded(child: Text(attraction)),
                      ],
                    ),
                  )),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.accentLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.restaurant, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Local cuisine',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(famousFood),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
>>>>>>> 4b7ad39b7e8138d7e70f9fbadf5d6a44369d5561
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}