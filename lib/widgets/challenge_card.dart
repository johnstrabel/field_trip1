// lib/widgets/challenge_card.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock challenge data - replace with real data later
    const challengeTitle = 'Urban Explorer';
    const challengeDescription = 'Complete 3 different trip types this week';
    const progress = 2;
    const total = 3;
    const participants = 47;
    const leader = 'Maya';

    final progressPercentage = progress / total;

    return Card(
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          gradient: LinearGradient(
            colors: [
              AppColors.amethyst600.withOpacity(0.05),
              AppColors.amethyst100.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceS),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This Week: "$challengeTitle"',
                          style: AppTextStyles.cardTitle.copyWith(
                            color: AppColors.amethyst600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceXS),
                        Text(
                          challengeDescription,
                          style: AppTextStyles.cardSubtitle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spaceL),
              
              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$progress/$total complete',
                        style: AppTextStyles.cardSubtitle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${(progressPercentage * 100).round()}%',
                        style: AppTextStyles.cardSubtitle.copyWith(
                          color: AppColors.amethyst600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceS),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.spaceXS),
                    child: LinearProgressIndicator(
                      value: progressPercentage,
                      backgroundColor: AppColors.stroke,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.amethyst600),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spaceL),
              
              // Challenge Stats and Action
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$participants people joined',
                          style: AppTextStyles.cardSubtitle,
                        ),
                        const SizedBox(height: AppDimensions.spaceXS),
                        Row(
                          children: [
                            const Icon(
                              Icons.emoji_events,
                              size: 16,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: AppDimensions.spaceXS),
                            Text(
                              '$leader leads',
                              style: AppTextStyles.cardSubtitle.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _joinChallenge(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.amethyst600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spaceL,
                        vertical: AppDimensions.spaceM,
                      ),
                    ),
                    child: Text(
                      progress > 0 ? 'Continue' : 'Join Challenge',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              
              // Hint for completion
              if (progress < total) ...[
                const SizedBox(height: AppDimensions.spaceM),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceM),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                    border: Border.all(
                      color: AppColors.info.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.info,
                        size: 16,
                      ),
                      const SizedBox(width: AppDimensions.spaceS),
                      Expanded(
                        child: Text(
                          _getNextStepHint(progress),
                          style: AppTextStyles.cardSubtitle.copyWith(
                            color: AppColors.info,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getNextStepHint(int progress) {
    switch (progress) {
      case 0:
        return 'Start with any trip type to begin the challenge!';
      case 1:
        return 'Great start! Try a different trip type for your next adventure.';
      case 2:
        return 'Almost there! One more trip type to complete the challenge.';
      default:
        return 'Challenge completed! 🎉';
    }
  }

  void _joinChallenge(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏆 Join Challenge'),
        content: const Text(
          'Challenge system is coming soon! For now, create and complete trips to earn badges and track your progress.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}