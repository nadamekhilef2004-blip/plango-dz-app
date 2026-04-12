import 'package:flutter/material.dart';
import '../utils/colors.dart';

class WeatherWidget extends StatelessWidget {
  final String city;
  final String temperature;
  final String condition;
  final String icon;
  
  const WeatherWidget({
    super.key, 
    required this.city,
    this.temperature = '25°C',
    this.condition = 'Sunny',
    this.icon = '☀️',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  temperature,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 24, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  condition,
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ],
      ),
    );
  }
}