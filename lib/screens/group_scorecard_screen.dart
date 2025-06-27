// lib/screens/group_scorecard_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/group_trip.dart';
import '../models/infection_game.dart';
import '../theme/app_theme.dart';
import '../models/trip.dart' as model;

class GroupScorecardScreen extends StatefulWidget {
  final GroupTrip? groupTrip;
  
  const GroupScorecardScreen({
    super.key,
    this.groupTrip,
  });

  @override
  State<GroupScorecardScreen> createState() => _GroupScorecardScreenState();
}

class _GroupScorecardScreenState extends State<GroupScorecardScreen> {
  late GroupTrip _groupTrip;
  
  @override
  void initState() {
    super.initState();
    _groupTrip = widget.groupTrip ?? _createMockGroupTrip();
  }
  
  GroupTrip _createMockGroupTrip() {
    return GroupTrip(
      id: 'mock_trip',
      title: 'Mock Group Trip',
      waypoints: [],
      createdAt: DateTime.now(),
      coreType: model.CoreType.crawl,
      participantIds: ['user1', 'user2'],
      creatorId: 'user1',
      status: GroupTripStatus.active,
      userRoles: {
        'user1': UserRole.creator,
        'user2': UserRole.participant,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Scorecard'),
        backgroundColor: AppColors.crawlCrimson,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip: ${_groupTrip.title}',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            Text(
              'Participants: ${_groupTrip.totalParticipants}',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            const Text(
              'Collaborative scorecard feature coming soon!',
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