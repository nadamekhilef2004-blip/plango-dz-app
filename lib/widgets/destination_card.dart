import 'package:flutter/material.dart';
import '../models/destination.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback? onTap;
  
  const DestinationCard({
    super.key,
    required this.destination,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        // Default behavior if no onTap provided
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tap on ${destination.name} to see details'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Placeholder image
                    Center(
                      child: Icon(
                        Icons.landscape,
                        size: 40,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    // Favorite button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            size: 18,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Add to favorites functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${destination.name} added to favorites'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Content section
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    destination.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          destination.region,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.grey,
                      ),
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
}