// lib/widgets/friends_carousel.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FriendsCarousel extends StatelessWidget {
  const FriendsCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock friend data - replace with real data later
    final mockFriends = [
      {'name': 'Alex', 'avatar': '🟢', 'activity': 'completed Prague Castle Walk', 'time': '2h ago'},
      {'name': 'Maya', 'avatar': '📸', 'activity': 'shared new trail photos', 'time': '4h ago'},
      {'name': 'Sam', 'avatar': '🏃‍♂️', 'activity': 'started fitness challenge', 'time': '6h ago'},
      {'name': 'Emma', 'avatar': '🌟', 'activity': 'earned Explorer badge', 'time': '1d ago'},
    ];

    if (mockFriends.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        // Horizontal Avatar Carousel
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: mockFriends.length + 1, // +1 for "Add Friends" button
            separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.spaceM),
            itemBuilder: (context, index) {
              if (index == mockFriends.length) {
                return _buildAddFriendsButton(context);
              }
              
              final friend = mockFriends[index];
              return _buildFriendAvatar(context, friend);
            },
          ),
        ),
        
        const SizedBox(height: AppDimensions.spaceM),
        
        // Recent Activity Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timeline, color: AppColors.amethyst600, size: 20),
                    const SizedBox(width: AppDimensions.spaceS),
                    Text(
                      'Recent Activity',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceM),
                ...mockFriends.take(2).map((friend) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceS),
                  child: Row(
                    children: [
                      Text(
                        friend['avatar'] as String,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: AppDimensions.spaceS),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.cardSubtitle,
                            children: [
                              TextSpan(
                                text: '${friend['name']} ',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: '${friend['activity']} • '),
                              TextSpan(
                                text: friend['time'] as String,
                                style: TextStyle(color: AppColors.textSecond.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendAvatar(BuildContext context, Map<String, String> friend) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('View ${friend['name']}\'s profile (coming soon!)')),
        );
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.amethyst100,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.amethyst600,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                friend['avatar']!,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Text(
            friend['name']!,
            style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAddFriendsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add friends feature coming soon! 👥')),
        );
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.stroke,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textSecond,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.textSecond,
              size: 24,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Text(
            'Add',
            style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXL),
        child: Column(
          children: [
            const Icon(
              Icons.people_outline,
              size: 48,
              color: AppColors.textSecond,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              'No friends yet',
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              'Add friends to share trips and compete!',
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add friends feature coming soon!')),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Add Friends'),
            ),
          ],
        ),
      ),
    );
  }
}