// lib/screens/bar_detail_enhanced_screen.dart - MISSING SCREEN
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BarDetailEnhancedScreen extends StatelessWidget {
  final String barId;
  
  const BarDetailEnhancedScreen({
    super.key,
    required this.barId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bar Details'),
        backgroundColor: AppColors.crawlCrimson,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bar ID: $barId',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            const Text(
              'Enhanced bar details screen - coming soon!',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}