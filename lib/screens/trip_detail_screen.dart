// lib/screens/trip_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';

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

  Future<void> _toggleTracking() async {
    setState(() {
      _isTracking = !_isTracking;
    });

    if (_isTracking) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎯 Live tracking started for ${widget.trip.title}!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📍 Tracking stopped'),
          backgroundColor: AppColors.warning,
        ),
      );
    }
  }

  Future<void> _markAsCompleted() async {
    try {
      final tripBox = Hive.box<model.Trip>('trips');
      
      // Update trip
      widget.trip.completed = true;
      widget.trip.badgeEarned = true;
      await tripBox.put(widget.trip.id, widget.trip);

      // Create badge using backward compatibility method
      final badgeBox = Hive.box<model.Badge>('badges');
      final badge = model.Badge.fromOldType(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tripId: widget.trip.id,
        label: '${widget.trip.type.toString().split('.').last.toUpperCase()} Explorer',
        earnedAt: DateTime.now(),
        type: widget.trip.type,
      );
      await badgeBox.put(badge.id, badge);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Trip completed! Badge earned!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error completing trip: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeHelper = TripTypeHelper.fromType(widget.trip.type);
    
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
                      onPressed: _toggleTracking,
                      icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
                      label: Text(_isTracking ? 'Stop Live Tracking' : 'Start Live Tracking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isTracking ? AppColors.error : typeHelper.color,
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
}