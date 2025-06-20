// lib/screens/trip_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';
import 'live_tracking_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final model.Trip trip;
  final model.Badge? badge;

  const TripDetailScreen({
    Key? key, 
    required this.trip,
    this.badge,
  }) : super(key: key);

  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  bool _isTracking = false;

  Future<void> _startLiveTracking() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LiveTrackingScreen(trip: widget.trip),
      ),
    );
    
    // Refresh the screen when returning from tracking
    if (result != null && mounted) {
      setState(() {});
    }
  }

  Future<void> _markAsCompleted() async {
    try {
      final tripBox = Hive.box<model.Trip>('trips');
      
      // Update trip
      widget.trip.completed = true;
      widget.trip.badgeEarned = true;
      await tripBox.put(widget.trip.id, widget.trip);

      // Create badge using the new model structure
      final badgeBox = Hive.box<model.Badge>('badges');
      final typeHelper = TripTypeHelper.fromTrip(widget.trip);
      
      final badge = model.Badge(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tripId: widget.trip.id,
        label: '${typeHelper.displayName} Explorer',
        earnedAt: DateTime.now(),
        coreType: widget.trip.currentType,  // Use the current type
      );
      await badgeBox.put(badge.id, badge);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 ${typeHelper.displayName} trip completed! Badge earned!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing trip: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeHelper = TripTypeHelper.fromTrip(widget.trip);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.title),
        backgroundColor: typeHelper.color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    typeHelper.color,
                    typeHelper.color.withOpacity(0.1),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spaceL),
                child: Column(
                  children: [
                    // Trip Type Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: typeHelper.color.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(
                        typeHelper.icon,
                        size: 40,
                        color: typeHelper.color,
                      ),
                    ),
                    
                    const SizedBox(height: AppDimensions.spaceM),
                    
                    // Trip Title
                    Text(
                      widget.trip.title,
                      style: AppTextStyles.heroTitle.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: AppDimensions.spaceS),
                    
                    // Trip Type and Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spaceM,
                            vertical: AppDimensions.spaceS,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          ),
                          child: Text(
                            typeHelper.displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceM),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spaceM,
                            vertical: AppDimensions.spaceS,
                          ),
                          decoration: BoxDecoration(
                            color: widget.trip.completed 
                                ? AppColors.success.withOpacity(0.2)
                                : AppColors.warning.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          ),
                          child: Text(
                            widget.trip.completed ? 'Completed' : 'Planned',
                            style: TextStyle(
                              color: widget.trip.completed 
                                  ? AppColors.success 
                                  : AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Sub-mode indicator (if not default)
                    if (widget.trip.subMode != 'standard') ...[
                      const SizedBox(height: AppDimensions.spaceS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spaceM,
                          vertical: AppDimensions.spaceXS,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                        ),
                        child: Text(
                          'Mode: ${widget.trip.subMode}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Stats Section
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatTile(
                    icon: Icons.location_on,
                    label: 'Waypoints',
                    value: '${widget.trip.waypoints.length}',
                    color: typeHelper.color,
                  ),
                  _StatTile(
                    icon: Icons.calendar_today,
                    label: 'Created',
                    value: _formatDate(widget.trip.createdAt),
                    color: typeHelper.color,
                  ),
                  if (widget.trip.badgeEarned)
                    _StatTile(
                      icon: Icons.emoji_events,
                      label: 'Badge',
                      value: 'Earned',
                      color: AppColors.success,
                    ),
                ],
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
              child: Column(
                children: [
                  // Live Tracking Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _startLiveTracking,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Live Tracking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: typeHelper.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.spaceM,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppDimensions.spaceM),
                  
                  // Complete Trip Button (only if not completed)
                  if (!widget.trip.completed)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _markAsCompleted,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Mark as Completed'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.success,
                          side: const BorderSide(color: AppColors.success),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.spaceM,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.spaceL),

            // Waypoints Section
            Container(
              margin: const EdgeInsets.all(AppDimensions.spaceL),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(color: AppColors.stroke),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.spaceL),
                    child: Row(
                      children: [
                        Icon(Icons.route, color: typeHelper.color),
                        const SizedBox(width: AppDimensions.spaceS),
                        Text(
                          'Route Waypoints',
                          style: AppTextStyles.sectionTitle,
                        ),
                        const Spacer(),
                        if (widget.trip.isPathStrict)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spaceS,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock,
                                  size: 12,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Strict Path',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ...widget.trip.waypoints.asMap().entries.map((entry) {
                    final index = entry.key;
                    final waypoint = entry.value;
                    
                    return Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceL),
                      decoration: BoxDecoration(
                        border: index < widget.trip.waypoints.length - 1
                            ? const Border(bottom: BorderSide(color: AppColors.stroke))
                            : null,
                      ),
                      child: Row(
                        children: [
                          // Waypoint Number
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: typeHelper.color,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: AppDimensions.spaceM),
                          
                          // Waypoint Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  waypoint.name,
                                  style: AppTextStyles.cardTitle,
                                ),
                                if (waypoint.note.isNotEmpty) ...[
                                  const SizedBox(height: AppDimensions.spaceXS),
                                  Text(
                                    waypoint.note,
                                    style: AppTextStyles.cardSubtitle,
                                  ),
                                ],
                                const SizedBox(height: AppDimensions.spaceXS),
                                Text(
                                  '${waypoint.latitude.toStringAsFixed(4)}, ${waypoint.longitude.toStringAsFixed(4)}',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            // Badge Section (if earned)
            if (widget.trip.badgeEarned) ...[
              Container(
                margin: const EdgeInsets.all(AppDimensions.spaceL),
                padding: const EdgeInsets.all(AppDimensions.spaceL),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 48,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: AppDimensions.spaceM),
                    Text(
                      'Achievement Unlocked!',
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceS),
                    Text(
                      '${typeHelper.displayName} Explorer Badge',
                      style: AppTextStyles.cardSubtitle,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '${difference}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            value,
            style: AppTextStyles.cardTitle.copyWith(
              color: color,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
} // <- Add this closing brace here