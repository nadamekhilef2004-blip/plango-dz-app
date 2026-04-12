import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/destination.dart';
import '../utils/theme.dart';

class MapNavigationPage extends StatefulWidget {
  final Destination? destination;
  const MapNavigationPage({super.key, this.destination});

  @override
  State<MapNavigationPage> createState() => _MapNavigationPageState();
}

class _MapNavigationPageState extends State<MapNavigationPage> {
  Position? _currentPosition;
  bool _isLoading = true;

  final Map<String, Map<String, double>> _destinationsCoordinates = {
    'Algiers': {'lat': 36.7538, 'lng': 3.0588},
    'Constantine': {'lat': 36.3650, 'lng': 6.6147},
    'Annaba': {'lat': 36.9028, 'lng': 7.7558},
    'Oran': {'lat': 35.6973, 'lng': -0.6336},
    'Tlemcen': {'lat': 34.8828, 'lng': -1.3167},
    'Setif': {'lat': 36.1911, 'lng': 5.4097},
    'Biskra': {'lat': 34.8500, 'lng': 5.7333},
    'Tamanrasset': {'lat': 22.7850, 'lng': 5.5228},
    'Ghardaia': {'lat': 32.4833, 'lng': 3.6667},
  };

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _isLoading = false;
    });
  }

  void _openInGoogleMaps() {
    if (widget.destination == null) return;
    
    final coords = _destinationsCoordinates[widget.destination!.name];
    if (coords == null) return;
    
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${coords['lat']},${coords['lng']}';
    launchUrl(Uri.parse(url));
  }

  Map<String, dynamic>? _getDestinationCoords() {
    if (widget.destination == null) return null;
    return _destinationsCoordinates[widget.destination!.name];
  }

  @override
  Widget build(BuildContext context) {
    final destinationCoords = _getDestinationCoords();

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.destination != null 
          ? 'Navigate to ${widget.destination!.name}' 
          : 'Explore Algeria'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.directions_car),
            onPressed: _openInGoogleMaps,
            tooltip: 'Open in Google Maps',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppTheme.accentLight,
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 64, color: Color(0xFF6C7D76)),
                    SizedBox(height: 8),
                    Text('Interactive Map View'),
                    Text('(Google Maps will open)', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          
          if (widget.destination != null && destinationCoords != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.destination!.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF212423)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '📍 Coordinates: ${destinationCoords['lat']}, ${destinationCoords['lng']}',
                    style: const TextStyle(color: Color(0xFF6C7D76)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Distance & Time',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF212423)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoChip(Icons.directions_car, 'By Car', '~2-3 hours'),
                      _buildInfoChip(Icons.train, 'By Train', '~3-4 hours'),
                      _buildInfoChip(Icons.flight, 'By Air', '~1 hour'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _openInGoogleMaps,
                      icon: const Icon(Icons.navigation),
                      label: const Text('Start Navigation'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.accentLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💡 Travel Tips',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF212423)),
                ),
                const SizedBox(height: 8),
                const Text('• Best time to visit: Spring (March-May) or Autumn (September-November)', style: TextStyle(color: Color(0xFF414836))),
                const Text('• Local transport: Taxis, buses, and trains available', style: TextStyle(color: Color(0xFF414836))),
                const Text('• Language: Arabic, French, and Berber', style: TextStyle(color: Color(0xFF414836))),
                const Text('• Currency: Algerian Dinar (DZD)', style: TextStyle(color: Color(0xFF414836))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.accentLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF414836))),
          Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
        ],
      ),
    );
  }
}
