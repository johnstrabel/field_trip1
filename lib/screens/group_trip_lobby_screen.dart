// lib/screens/group_trip_lobby_screen.dart
import 'package:flutter/material.dart';
import '../models/group_trip.dart';
import '../theme/app_theme.dart';

class GroupTripLobbyScreen extends StatefulWidget {
  final GroupTrip groupTrip;
  
  const GroupTripLobbyScreen({
    super.key,
    required this.groupTrip,
  });

  @override
  State<GroupTripLobbyScreen> createState() => _GroupTripLobbyScreenState();
}

class _GroupTripLobbyScreenState extends State<GroupTripLobbyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupTrip.title),
        backgroundColor: AppColors.crawlCrimson,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTripInfo(),
            const SizedBox(height: AppDimensions.spaceL),
            _buildParticipantsList(),
            const Spacer(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTripInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trip Details', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppDimensions.spaceM),
            Text('Status: ${widget.groupTrip.status.name.toUpperCase()}'),
            Text('Waypoints: ${widget.groupTrip.waypoints.length}'),
            Text('Type: ${widget.groupTrip.coreType.name.toUpperCase()}'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildParticipantsList() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Participants', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimensions.spaceM),
          Expanded(
            child: ListView.builder(
              itemCount: widget.groupTrip.participantIds.length,
              itemBuilder: (context, index) {
                final participantId = widget.groupTrip.participantIds[index];
                final role = widget.groupTrip.getUserRole(participantId);
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(participantId[0].toUpperCase()),
                  ),
                  title: Text(participantId),
                  subtitle: Text(role?.name ?? 'Unknown'),
                  trailing: role == UserRole.creator 
                    ? const Icon(Icons.star, color: Colors.amber)
                    : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return Column(
      children: [
        if (widget.groupTrip.canStart)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _startTrip,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Trip'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        const SizedBox(height: AppDimensions.spaceM),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/group-scorecard'),
            icon: const Icon(Icons.scoreboard),
            label: const Text('View Scorecard'),
          ),
        ),
      ],
    );
  }
  
  void _startTrip() {
    // TODO: Implement trip start logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting trip...')),
    );
  }
}