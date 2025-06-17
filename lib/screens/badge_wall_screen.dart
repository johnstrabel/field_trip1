// lib/screens/badge_wall_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;

class BadgeWallScreen extends StatelessWidget {
  final List<model.Badge>? badges; // Make it optional for navigation

  const BadgeWallScreen({Key? key, this.badges}) : super(key: key);

  /// Returns the border color for each TripType; falls back to grey.
  Color _borderColor(model.TripType type) {
    switch (type) {
      case model.TripType.standard:
        return Colors.teal;
      case model.TripType.challenge:
        return Colors.deepPurple;
      case model.TripType.barcrawl:
        return Colors.orange;
      case model.TripType.fitness:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Badge Wall'),
        automaticallyImplyLeading: false, // Remove back button for navigation
      ),
      body: badges != null 
        ? _buildBadgeGrid(badges!)
        : ValueListenableBuilder(
            valueListenable: Hive.box<model.Badge>('badges').listenable(),
            builder: (context, Box<model.Badge> box, _) {
              final badgeList = box.values.toList();
              return _buildBadgeGrid(badgeList);
            },
          ),
    );
  }

  Widget _buildBadgeGrid(List<model.Badge> badgeList) {
    if (badgeList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No badges yet!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Complete a trip to earn your first badge.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0, // square cells
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: badgeList.length,
      itemBuilder: (ctx, i) {
        final badge = badgeList[i];
        final borderClr = _borderColor(badge.type);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderClr, width: 4),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 4),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, size: 36, color: borderClr),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  badge.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                badge.earnedAt
                    .toLocal()
                    .toString()
                    .split(' ')
                    .first,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
        );
      },
    );
  }
}