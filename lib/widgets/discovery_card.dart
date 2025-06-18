// lib/widgets/discovery_card.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DiscoveryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const DiscoveryCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceM),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.amethyst600).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.spaceM),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.amethyst600,
                  size: AppDimensions.iconSizeL,
                ),
              ),
              
              const SizedBox(height: AppDimensions.spaceM),
              
              // Title
              Text(
                title,
                style: AppTextStyles.cardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: AppDimensions.spaceXS),
              
              // Subtitle
              Text(
                subtitle,
                style: AppTextStyles.cardSubtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: AppDimensions.spaceM),
              
              // Arrow indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textSecond,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}