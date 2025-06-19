// lib/screens/trip_completion_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;
import '../models/trail_data.dart';
import '../theme/app_theme.dart';

class TripCompletionScreen extends StatefulWidget {
  final model.Trip trip;
  final TrailData trailData;

  const TripCompletionScreen({
    Key? key,
    required this.trip,
    required this.trailData,
  }) : super(key: key);

  @override
  _TripCompletionScreenState createState() => _TripCompletionScreenState();
}

class _TripCompletionScreenState extends State<TripCompletionScreen> {
  bool _isPrivate = false;

  Future<void> _saveAndComplete() async {
    try {
      // Update trip as completed
      final tripBox = Hive.box<model.Trip>('trips');
      
      // Mark the existing trip as completed and badge earned
      widget.trip.completed = true;
      widget.trip.badgeEarned = true;
      
      await tripBox.put(widget.trip.id, widget.trip);

      // Create and save badge using your actual Badge model
      final badgeBox = Hive.box<model.Badge>('badges');
      final badge = model.Badge(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tripId: widget.trip.id,  // Using your actual field name
        label: '${widget.trip.type.toString().split('.').last} Explorer', // Using 'label' not 'name'
        earnedAt: DateTime.now(),
        type: widget.trip.type,  // Using 'type' not 'tripType'
      );
      await badgeBox.put(badge.id, badge);

      // Show success and navigate back
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Trip completed! Badge earned!'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // Navigate back to main app
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving trip: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _discardTrip() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Trip?'),
        content: const Text('Are you sure you want to discard this adventure? All tracking data will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.of(context).popUntil((route) => route.isFirst); // Back to main
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  // Helper methods to format stats data
  String _getFormattedDistance() {
    final distance = widget.trailData.stats.distance;
    if (distance >= 1000) {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    } else {
      return '${distance.toStringAsFixed(0)} m';
    }
  }

  String _getFormattedSpeed() {
    final speed = widget.trailData.stats.speed;
    return '${speed.toStringAsFixed(1)} km/h';
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.trailData.stats;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Complete!'),
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.success, AppColors.successLight],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Success Header
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceXXL),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    Text(
                      'Adventure Complete!',
                      style: AppTextStyles.heading.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceS),
                    Text(
                      widget.trip.title,  // Using your actual field name
                      style: AppTextStyles.subtitle.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Stats Summary
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(AppDimensions.spaceL),
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Adventure Stats',
                        style: AppTextStyles.sectionTitle,
                      ),
                      const SizedBox(height: AppDimensions.spaceL),
                      
                      // Stats Grid
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.straighten,
                              title: 'Distance',
                              value: _getFormattedDistance(),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceM),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.schedule,
                              title: 'Duration',
                              value: _formatDuration(stats.duration),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceM),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.speed,
                              title: 'Avg Speed',
                              value: _getFormattedSpeed(),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceM),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.place,
                              title: 'Points',
                              value: '${widget.trailData.points.length}',
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppDimensions.spaceXXL),
                      
                      // Privacy Toggle
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceL),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isPrivate ? Icons.lock : Icons.public,
                              color: AppColors.textSecond,
                            ),
                            const SizedBox(width: AppDimensions.spaceM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isPrivate ? 'Private Trip' : 'Share with Friends',
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _isPrivate 
                                        ? 'Only you can see this adventure'
                                        : 'Friends can see and try this trip',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecond,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: !_isPrivate,
                              onChanged: (value) {
                                setState(() {
                                  _isPrivate = !value;
                                });
                              },
                              activeColor: AppColors.amethyst600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spaceL),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveAndComplete,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Adventure'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.amethyst600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(AppDimensions.spaceL),
                          textStyle: AppTextStyles.button,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceM),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _discardTrip,
                        child: Text(
                          'Discard Trip',
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.amethyst600,
            size: AppDimensions.iconSizeM,
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            value,
            style: AppTextStyles.subtitle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecond,
            ),
          ),
        ],
      ),
    );
  }
}