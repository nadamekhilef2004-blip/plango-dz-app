import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../utils/theme.dart';
import 'wilaya_detail_page.dart';

class RecommendationPage extends StatelessWidget {
  final List<Destination> allDestinations;
  final Destination? currentDestination;

  const RecommendationPage({
    super.key,
    required this.allDestinations,
    this.currentDestination,
  });

  @override
  Widget build(BuildContext context) {
    List<Destination> recommendations = _getRecommendations();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Recommendations'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: recommendations.isEmpty
          ? const Center(child: Text('No recommendations available'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final dest = recommendations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        dest.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image),
                        ),
                      ),
                    ),
                    title: Text(dest.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(dest.region),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WilayaDetailPage(
                            name: dest.name,
                            icon: '🏛️',
                            color: AppTheme.primaryColor,
                            imagePath: dest.imageUrl,
                            description: dest.description,
                            attractions: [],
                            bestTime: '',
                            famousFood: '',
                            allDestinations: allDestinations,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  List<Destination> _getRecommendations() {
    if (allDestinations.isEmpty) return [];

    if (currentDestination != null) {
      var sameRegion = allDestinations
          .where((d) => d.region == currentDestination!.region && d.name != currentDestination!.name)
          .toList();
      if (sameRegion.isNotEmpty) return sameRegion.take(5).toList();
    }

    return allDestinations.take(5).toList();
  }
}
