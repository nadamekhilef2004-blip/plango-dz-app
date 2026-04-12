import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../utils/theme.dart';
import '../screens/map_navigation_page.dart';
import '../screens/virtual_tour_page.dart';
import '../screens/destination_detail_page.dart';

class ModernDestinationCard extends StatelessWidget {
  final Destination destination;
  
  const ModernDestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DestinationDetailPage(destination: destination),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C7D76).withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    color: const Color(0xFFC1D3C6),
                    child: const Center(
                      child: Icon(
                        Icons.landscape,
                        size: 50,
                        color: Color(0xFF6C7D76),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.navigation,
                          color: const Color(0xFF6C7D76),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapNavigationPage(destination: destination),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.video_library,
                          color: const Color(0xFF91A8B0),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VirtualTourPage(destination: destination),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.favorite_border,
                          color: const Color(0xFFA39C7C),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${destination.name} added to favorites'),
                                backgroundColor: const Color(0xFF6C7D76),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212423),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    destination.description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF414836),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF2E8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          destination.region,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF6C7D76),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 12, color: Color(0xFFA39C7C)),
                      const SizedBox(width: 2),
                      const Text('4.8', style: TextStyle(fontSize: 11, color: Color(0xFF212423))),
                      const SizedBox(width: 4),
                      const Text('(124)', style: TextStyle(fontSize: 10, color: Color(0xFF91A8B0))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 16, color: color),
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      ),
    );
  }
}
