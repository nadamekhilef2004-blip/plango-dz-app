import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../utils/theme.dart';

class VirtualTourPage extends StatefulWidget {
  final Destination destination;
  const VirtualTourPage({super.key, required this.destination});

  @override
  State<VirtualTourPage> createState() => _VirtualTourPageState();
}

class _VirtualTourPageState extends State<VirtualTourPage> {
  int _selectedVideo = 0;

  final Map<String, List<Map<String, String>>> _videos = {
    'Algiers': [
      {'title': 'Algiers City Tour', 'duration': '5:30', 'description': 'Explore the beautiful capital'},
      {'title': 'Casbah of Algiers', 'duration': '8:15', 'description': 'UNESCO World Heritage site'},
      {'title': 'Notre Dame d\'Afrique', 'duration': '4:45', 'description': 'Iconic basilica'},
    ],
    'Constantine': [
      {'title': 'City of Bridges', 'duration': '6:20', 'description': 'Suspended bridges tour'},
      {'title': 'Sidi M\'Cid Bridge', 'duration': '3:50', 'description': 'Famous landmark'},
    ],
    'Tamanrasset': [
      {'title': 'Sahara Desert Tour', 'duration': '10:00', 'description': 'Experience the desert'},
      {'title': 'Hoggar Mountains', 'duration': '7:30', 'description': 'Mountain landscapes'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final videos = _videos[widget.destination.name] ?? [
      {'title': 'Virtual Tour', 'duration': 'Coming Soon', 'description': 'Tour available soon'},
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Virtual Tour: ${widget.destination.name}'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade900, Colors.grey.shade800],
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_circle_filled, size: 64, color: Colors.white),
                        SizedBox(height: 8),
                        Text(
                          'Click play to start virtual tour',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _show3DModelDialog,
              icon: const Icon(Icons.view_in_ar),
              label: const Text('View in 3D'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.play_circle, color: AppTheme.primaryColor, size: 30),
                    ),
                    title: Text(
                      video['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(video['description']!),
                        Text(
                          'Duration: ${video['duration']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.play_arrow, color: AppTheme.primaryColor),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Playing: ${video['title']}'),
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _show3DModelDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 300,
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                '3D Model Viewer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.accentLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.view_in_ar, size: 80, color: AppTheme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '3D model of ${widget.destination.name} coming soon!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
