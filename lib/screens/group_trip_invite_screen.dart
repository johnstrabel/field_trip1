// lib/screens/group_trip_invite_screen.dart
import 'package:flutter/material.dart';
import '../models/group_trip.dart';
import '../theme/app_theme.dart';

class GroupTripInviteScreen extends StatefulWidget {
  final GroupTrip groupTrip;
  
  const GroupTripInviteScreen({Key? key, required this.groupTrip}) : super(key: key);

  @override
  _GroupTripInviteScreenState createState() => _GroupTripInviteScreenState();
}

class _GroupTripInviteScreenState extends State<GroupTripInviteScreen> {
  @override
  Widget build(BuildContext context) {
    final typeHelper = TripTypeHelper.fromCoreType(widget.groupTrip.coreType);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Invitation'),
        backgroundColor: typeHelper.color,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          children: [
            // Trip Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              decoration: BoxDecoration(
                color: typeHelper.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(color: typeHelper.color),
              ),
              child: Column(
                children: [
                  Icon(typeHelper.icon, size: 48, color: typeHelper.color),
                  const SizedBox(height: AppDimensions.spaceM),
                  Text(
                    widget.groupTrip.title,
                    style: AppTextStyles.sectionTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spaceS),
                  Text(
                    '${typeHelper.displayName} Trip',
                    style: AppTextStyles.cardSubtitle,
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  Text(
                    'You\'ve been invited to join this group trip!',
                    style: AppTextStyles.cardTitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Trip Details
            _buildTripDetails(),
            
            const Spacer(),
            
            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _acceptInvitation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                    ),
                    child: const Text('Accept Invitation'),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _declineInvitation,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripDetails() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trip Details', style: AppTextStyles.cardTitle),
          const SizedBox(height: AppDimensions.spaceM),
          
          _buildDetailRow(Icons.people, 'Participants', '${widget.groupTrip.totalParticipants} friends'),
          const SizedBox(height: AppDimensions.spaceS),
          
          _buildDetailRow(Icons.schedule, 'Created', _formatDate(widget.groupTrip.createdAt)),
          const SizedBox(height: AppDimensions.spaceS),
          
          _buildDetailRow(Icons.location_on, 'Waypoints', '${widget.groupTrip.waypoints.length} stops'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecond),
        const SizedBox(width: AppDimensions.spaceM),
        Text(label, style: AppTextStyles.cardSubtitle),
        const Spacer(),
        Text(value, style: AppTextStyles.cardTitle),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _acceptInvitation() {
    // TODO: Update group trip status and user role
    Navigator.pop(context, 'accepted');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invitation accepted! You\'ll be notified when the trip starts.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _declineInvitation() {
    // TODO: Update group trip status
    Navigator.pop(context, 'declined');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invitation declined.'),
        backgroundColor: AppColors.warning,
      ),
    );
  }
}