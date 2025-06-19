// lib/widgets/hero_banner.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HeroBanner extends StatelessWidget {
  // Removed onCreateTrip and onJoinChallenge callbacks since we're removing the buttons
  const HeroBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.amethyst600,
            AppColors.amethyst600.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.amethyst600.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceS),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                ),
                child: const Icon(
                  Icons.explore,
                  color: Colors.white,
                  size: AppDimensions.iconSizeL,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to Explore?',
                      style: AppTextStyles.heroTitle,
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      'Continue where you left off or try something new.',
                      style: AppTextStyles.heroSubtitle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spaceM),
          
          // Additional motivational text (replacing the buttons)
          Text(
            'Discover new places, track your adventures, and collect badges as you explore the world around you.',
            style: AppTextStyles.heroSubtitle.copyWith(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}