// lib/utils/navigation_helper.dart
// Super simple helper - just placeholders for now

import 'package:flutter/material.dart';

class NavigationHelper {
  // Navigate to Friend Profile - placeholder for now
  static void goToFriendProfile(BuildContext context, {dynamic friend}) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Friend Profile coming soon!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Navigate to Challenge Detail - placeholder for now
  static void goToChallengeDetail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Challenge Detail coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Simple sample friends data for dashboard (no complex objects)
  static final List<Map<String, dynamic>> sampleFriends = [
    {
      'name': 'Alex',
      'avatar': Icons.person,
      'id': '1',
    },
    {
      'name': 'Maya',
      'avatar': Icons.person_2,
      'id': '2',
    },
    {
      'name': 'Sam',
      'avatar': Icons.person_3,
      'id': '3',
    },
  ];
}