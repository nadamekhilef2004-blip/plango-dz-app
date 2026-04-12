import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;
  
  const RatingStars({
    super.key, 
    required this.rating, 
    this.starCount = 5,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: Colors.amber, size: size);
        } else if (index < rating.ceil() && rating % 1 != 0) {
          return Icon(Icons.star_half, color: Colors.amber, size: size);
        } else {
          return Icon(Icons.star_border, color: Colors.amber, size: size);
        }
      }),
    );
  }
}