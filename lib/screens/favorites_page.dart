import 'package:flutter/material.dart';
import '../models/destination.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Destination> favorites = [];
  
  @override
  void initState() {
    super.initState();
    // Load favorites from shared preferences would go here
    _loadSampleFavorites();
  }
  
  void _loadSampleFavorites() {
    // Sample data for demonstration
    favorites = [
      Destination(
        name: 'Algiers',
        region: 'Central',
        imageUrl: 'assets/images/algiers.jpg',
        description: 'Beautiful capital with rich history',
      ),
      Destination(
        name: 'Constantine',
        region: 'North East',
        imageUrl: 'assets/images/constantine.jpg',
        description: 'City of Bridges',
      ),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start adding destinations to your favorites',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                    ),
                    child: const Text('Explore Destinations'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final destination = favorites[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.landscape),
                    ),
                    title: Text(
                      destination.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(destination.region),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          favorites.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from favorites'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      // Navigate to destination detail
                    },
                  ),
                );
              },
            ),
    );
  }
}