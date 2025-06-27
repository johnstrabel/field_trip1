// lib/screens/trip_active_screen.dart
import 'package:flutter/material.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';

class TripActiveScreen extends StatelessWidget {
  final model.Trip trip;
  
  const TripActiveScreen({Key? key, required this.trip}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final typeHelper = TripTypeHelper.fromTrip(trip);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Trip'),
        backgroundColor: typeHelper.color,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_run, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Active Trip Management', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Real-time trip control coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}