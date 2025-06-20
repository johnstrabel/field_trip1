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

      // Create and save badge using new model
      final badgeBox = Hive.box<model.Badge>('badges');
      final typeHelper = TripTypeHelper.fromTrip(widget.trip);
      
      final badge = model.Badge(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tripId: widget.trip.id,
        label: '${typeHelper.displayName} Explorer',
        earnedAt: DateTime.now(),
        coreType: widget.trip.currentType,  // Use currentType, not both oldType and coreType
      );
      await badgeBox.put(badge.id, badge);

      // Save trail data
      final trailBox = await Hive.openBox<TrailData>('trails');
      await trailBox.put(widget.trip.id, widget.trailData);

      // Create score card for competitive modes
      if (widget.trip.currentType == model.CoreType.game && !_isPrivate) {
        final scoreCardBox = Hive.box<model.ScoreCard>('scorecards');
        final scoreCard = model.ScoreCard(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          tripId: widget.trip.id,
          userId: 'current_user', // Replace with actual user ID
          perWaypointScores: List.generate(widget.trip.waypoints.length, (i) => 100),
          totalScore: widget.trip.waypoints.length * 100,
          penalties: [],
          bonuses: ['Completion Bonus'],
          createdAt: DateTime.now(),
        );
        await scoreCardBox.put(scoreCard.id, scoreCard);
      }

      // Show success and navigate back
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 ${typeHelper.displayName} trip completed! Badge earned!'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeHelper = TripTypeHelper.fromTrip(widget.trip);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Complete!'),
        backgroundColor: typeHelper.color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            child: Column(
              children: [
                // Celebration Header
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceXL),
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: typeHelper.color.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.emoji_events,
                          size: 60,
                          color: typeHelper.color,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceL),
                      Text(
                        'Adventure Complete!',
                        style: AppTextStyles.heroTitle.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spaceM),
                      Text(
                        widget.trip.title,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      // Show sub-mode if not standard
                      if (widget.trip.subMode != 'standard') ...[
                        const SizedBox(height: AppDimensions.spaceS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spaceM,
                            vertical: AppDimensions.spaceXS,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          ),
                          child: Text(
                            widget.trip.subMode.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Stats Card
                Container(
                  margin: const EdgeInsets.symmetric(vertical: AppDimensions.spaceL),
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(typeHelper.icon, color: typeHelper.color),
                          const SizedBox(width: AppDimensions.spaceS),
                          Text(
                            '${typeHelper.displayName} Adventure',
                            style: AppTextStyles.cardTitle,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceL),
                      
                      // Trip Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn(
                            'Waypoints',
                            '${widget.trip.waypoints.length}',
                            Icons.location_on,
                          ),
                          _buildStatColumn(
                            'Distance',
                            '${(widget.trailData.totalDistance / 1000).toStringAsFixed(1)} km',
                            Icons.straighten,
                          ),
                          _buildStatColumn(
                            'Duration',
                            _formatDuration(widget.trailData.duration),
                            Icons.timer,
                          ),
                        ],
                      ),
                      
                      // Additional stats for competitive modes
                      if (widget.trip.currentType == model.CoreType.game) ...[
                        const SizedBox(height: AppDimensions.spaceL),
                        const Divider(),
                        const SizedBox(height: AppDimensions.spaceL),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn(
                              'Points',
                              '${widget.trip.waypoints.length * 100}',
                              Icons.star,
                            ),
                            _buildStatColumn(
                              'Avg Speed',
                              '${widget.trailData.stats.speedKmh.toStringAsFixed(1)} km/h',
                              Icons.speed,
                            ),
                            _buildStatColumn(
                              'GPS Points',
                              '${widget.trailData.points.length}',
                              Icons.gps_fixed,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Privacy Toggle
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceM),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isPrivate ? Icons.lock : Icons.public,
                        color: typeHelper.color,
                      ),
                      const SizedBox(width: AppDimensions.spaceM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Share Adventure',
                              style: AppTextStyles.cardTitle,
                            ),
                            Text(
                              _isPrivate 
                                ? 'Keep this adventure private'
                                : 'Share with friends on leaderboard',
                              style: AppTextStyles.cardSubtitle,
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
                        activeColor: typeHelper.color,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.spaceXL),

                // Action Buttons
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveAndComplete,
                        icon: const Icon(Icons.save),
                        label: const Text('Save & Earn Badge'),
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
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _discardTrip,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Discard Trip'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.spaceM,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
    final typeHelper = TripTypeHelper.fromTrip(widget.trip);
    
    return Column(
      children: [
        Icon(
          icon,
          color: typeHelper.color,
          size: 24,
        ),
        const SizedBox(height: AppDimensions.spaceS),
        Text(
          value,
          style: AppTextStyles.cardTitle.copyWith(
            color: typeHelper.color,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}