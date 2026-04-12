import 'package:flutter/material.dart';

class RegionCard extends StatelessWidget {
  final String title;
  final Color color;
  final List<String> cities;
  final VoidCallback onTap;
  
  const RegionCard({
    super.key,
    required this.title,
    required this.color,
    required this.cities,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.8), color],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cities.take(3).join(' • '),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  if (cities.length > 3)
                    Text(
                      '+${cities.length - 3} more',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}