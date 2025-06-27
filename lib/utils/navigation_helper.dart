// lib/utils/navigation_helper.dart - CREATE THIS FILE
// This provides helper methods for common navigation patterns

import 'package:flutter/material.dart';

class NavigationHelper {
  // Helper methods for common navigation patterns
  
  static Future<void> navigateToFriendProfile(BuildContext context, String friendId) {
    return Navigator.pushNamed(context, '/friend-profile?id=$friendId');
  }
  
  static Future<void> navigateToChallengeDetail(BuildContext context, String challengeId) {
    return Navigator.pushNamed(context, '/challenge-detail?id=$challengeId');
  }
  
  static Future<void> navigateToChallengeLeaderboard(BuildContext context, String challengeId) {
    return Navigator.pushNamed(context, '/challenge-leaderboard?id=$challengeId');
  }
  
  static Future<void> navigateToBadgeDetail(BuildContext context, String badgeId) {
    return Navigator.pushNamed(context, '/badge-detail?id=$badgeId');
  }
  
  // Quick access to major sections
  static void showSocialMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Social Features',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Friends'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/friends');
              },
            ),
            ListTile(
              leading: const Icon(Icons.dynamic_feed),
              title: const Text('Activity Feed'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/activity-feed');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_search),
              title: const Text('Find Friends'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/friend-search');
              },
            ),
          ],
        ),
      ),
    );
  }
  
  static void showCompetitionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Competition',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: const Text('Leaderboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/leaderboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text('Challenges'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/challenges');
              },
            ),
          ],
        ),
      ),
    );
  }
  
  // Utility for safe navigation with error handling
  static Future<void> safeNavigate(BuildContext context, String route) async {
    try {
      await Navigator.pushNamed(context, route);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigation failed: ${e.toString()}'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}