// lib/screens/badge_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';

class BadgeDetailScreen extends StatelessWidget {
  final model.Badge badge;
  
  const BadgeDetailScreen({Key? key, required this.badge}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final typeHelper = TripTypeHelper.fromBadge(badge);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badge Details'),
        backgroundColor: typeHelper.color,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.military_tech, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Badge Showcase', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Detailed badge view coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}
