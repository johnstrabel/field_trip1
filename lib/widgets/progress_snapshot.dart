// lib/widgets/progress_snapshot.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/trip.dart' as model;

class ProgressSnapshot extends StatelessWidget {
  final List<model.Trip> trips;
  final List<model.Badge> badges;

  const ProgressSnapshot({
    Key? key,
    required this.trips,
    required this.badges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completedTrips = trips.where((t) => t.completed).length;
    
    // Calculate current streak (mock for now)
    // final currentStreak = _calculateStreak();

    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.check_circle,
            label: 'Trips\nCompleted',
            value: '$completedTrips',
            color: AppColors.success,
            onTap: () => _showStatDetail(context, 'Completed Trips', '$completedTrips trips finished'),
          ),
        ),
        const SizedBox(width: AppDimensions.spaceM),
        Expanded(
          child: _StatTile(
            icon: Icons.emoji_events,
            label: 'Badges\nEarned',
            value: '${badges.length}',
            color: AppColors.warning,
            onTap: () => _showStatDetail(context, 'Badges Earned', '${badges.length} achievements unlocked'),
          ),
        ),
      ],
    );
  }


  void _showStatDetail(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cool!'),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          child: Column(
            children: [
              // Icon with colored background
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceM),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.spaceM),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              
              const SizedBox(height: AppDimensions.spaceM),
              
              // Value
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: AppDimensions.spaceXS),
              
              // Label
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecond,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}