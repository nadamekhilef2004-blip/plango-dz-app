import 'package:flutter/material.dart';
import '../models/day_plan.dart';
import '../utils/theme.dart';

class DayCardWidget extends StatelessWidget {
  final DayPlan day;
  final int dayIndex;
  final VoidCallback onEdit;
  final VoidCallback onRegenerate;
  final VoidCallback onToggleLock;

  const DayCardWidget({
    super.key,
    required this.day,
    required this.dayIndex,
    required this.onEdit,
    required this.onRegenerate,
    required this.onToggleLock,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: day.isLocked ? Colors.grey.shade50 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: day.isLocked ? Colors.grey : const Color(0xFF6C7D76),
          child: Text('${day.dayNumber}', style: const TextStyle(color: Colors.white)),
        ),
        title: Text('Day ${day.dayNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: day.isLocked ? const Text('🔒 Locked', style: TextStyle(fontSize: 12)) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(day.isLocked ? Icons.lock : Icons.lock_open, size: 18),
              onPressed: onToggleLock,
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 18),
              onPressed: onEdit,
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildActivityRow(Icons.wb_sunny, 'Morning', day.morningActivity),
                const SizedBox(height: 12),
                _buildActivityRow(Icons.landscape, 'Afternoon', day.afternoonActivity),
                const SizedBox(height: 12),
                _buildActivityRow(Icons.restaurant, 'Evening', day.eveningActivity),
                const SizedBox(height: 12),
                _buildActivityRow(Icons.dinner_dining, 'Restaurant', day.restaurant),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: onRegenerate,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Regenerate this day'),
                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF6C7D76)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6C7D76)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}