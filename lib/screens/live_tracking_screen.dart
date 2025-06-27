// lib/screens/live_tracking_screen.dart - FIXED VERSION
// Properly integrates with LocationTrackingService for real GPS data

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;
import '../models/trail_data.dart';
import '../services/location_tracking_service.dart';
import '../theme/app_theme.dart';
import 'trip_completion_screen.dart';

class LiveTrackingScreen extends StatefulWidget {
  final model.Trip trip;
  
  const LiveTrackingScreen({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final LocationTrackingService _trackingService = LocationTrackingService();
  Timer? _updateTimer;
  bool _isTracking = false;
  bool _isPaused = false;
  DateTime? _startTime;
  
  // Current stats from GPS service
  double _totalDistance = 0.0;
  int _pointCount = 0;
  double _currentSpeed = 0.0;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupTrackingListener();
    _startTracking();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _trackingService.removeListener(_onTrackingUpdate);
    if (_isTracking) {
      _trackingService.stopTracking();
    }
    super.dispose();
  }

  // FIXED: Listen to actual GPS updates from tracking service
  void _setupTrackingListener() {
    _trackingService.addListener(_onTrackingUpdate);
  }

  void _onTrackingUpdate() {
    if (!mounted) return;
    
    setState(() {
      _pointCount = _trackingService.currentTrail.length;
      _totalDistance = _calculateTrailDistance(_trackingService.currentTrail);
      
      // Calculate current speed from last few GPS points
      _currentSpeed = _calculateCurrentSpeed(_trackingService.currentTrail);
      
      // Update duration
      if (_startTime != null) {
        _duration = DateTime.now().difference(_startTime!);
      }
    });
  }

  // FIXED: Calculate real distance from GPS trail points
  double _calculateTrailDistance(List<TrailPoint> trail) {
    if (trail.length < 2) return 0.0;
    
    double totalDistance = 0.0;
    for (int i = 1; i < trail.length; i++) {
      totalDistance += _calculateDistance(trail[i - 1], trail[i]);
    }
    return totalDistance / 1000; // Convert to kilometers
  }

  // FIXED: Calculate distance between two GPS points using Haversine formula
  double _calculateDistance(TrailPoint point1, TrailPoint point2) {
    const double earthRadius = 6371000; // Earth radius in meters
    
    final double lat1Rad = point1.latitude * (math.pi / 180);
    final double lat2Rad = point2.latitude * (math.pi / 180);
    final double deltaLatRad = (point2.latitude - point1.latitude) * (math.pi / 180);
    final double deltaLngRad = (point2.longitude - point1.longitude) * (math.pi / 180);

    final double a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
        math.sin(deltaLngRad / 2) * math.sin(deltaLngRad / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  // FIXED: Calculate current speed from recent GPS points
  double _calculateCurrentSpeed(List<TrailPoint> trail) {
    if (trail.length < 2) return 0.0;
    
    // Use last few points to calculate current speed
    final int pointsToUse = math.min(5, trail.length);
    final recentPoints = trail.sublist(trail.length - pointsToUse);
    
    if (recentPoints.length < 2) return 0.0;
    
    double totalDistance = 0.0;
    Duration totalTime = Duration.zero;
    
    for (int i = 1; i < recentPoints.length; i++) {
      totalDistance += _calculateDistance(recentPoints[i - 1], recentPoints[i]);
      totalTime += recentPoints[i].timestamp.difference(recentPoints[i - 1].timestamp);
    }
    
    if (totalTime.inSeconds == 0) return 0.0;
    
    // Return speed in km/h
    final speedMs = totalDistance / totalTime.inSeconds;
    return speedMs * 3.6;
  }

  Future<void> _startTracking() async {
    try {
      final success = await _trackingService.startTracking(widget.trip.id);
      if (success) {
        setState(() {
          _isTracking = true;
          _isPaused = false;
          _startTime = DateTime.now();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🚀 Live tracking started!'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        _showError('Failed to start tracking. Please check location permissions.');
      }
    } catch (e) {
      _showError('Error starting tracking: $e');
    }
  }

  Future<void> _pauseResumeTracking() async {
    if (_isPaused) {
      // Resume tracking
      final success = await _trackingService.startTracking(widget.trip.id);
      if (success) {
        setState(() {
          _isPaused = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('▶️ Tracking resumed'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } else {
      // Pause tracking
      await _trackingService.stopTracking();
      setState(() {
        _isPaused = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⏸️ Tracking paused'),
          backgroundColor: AppColors.warning,
        ),
      );
    }
  }

  Future<void> _stopTracking() async {
    // Show confirmation dialog
    final shouldStop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Adventure?'),
        content: const Text('Are you sure you want to finish this adventure? Your GPS trail will be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Complete'),
          ),
        ],
      ),
    );

    if (shouldStop == true) {
      try {
        // Stop tracking and get final trail
        final trailPoints = await _trackingService.stopTracking();
        
        if (trailPoints.isNotEmpty && mounted) {
          // FIXED: Create proper TrailData with real GPS data
          final trailData = TrailData(
            tripId: widget.trip.id,
            points: trailPoints,
            startTime: _startTime ?? DateTime.now(),
            endTime: DateTime.now(),
            totalDistance: _totalDistance * 1000, // Convert km to meters
            duration: _duration,
          );
          
          // FIXED: Save trail data to Hive
          await _saveTrailData(trailData);
          
          // FIXED: Mark trip as completed and award badge
          await _completeTrip();
          
          // Navigate to completion screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => TripCompletionScreen(
                trip: widget.trip,
                trailData: trailData,
              ),
            ),
          );
        } else {
          _showError('No GPS data recorded. Please try again.');
          Navigator.pop(context);
        }
      } catch (e) {
        _showError('Error completing trip: $e');
      }
    }
  }

  // FIXED: Save trail data to Hive database
  Future<void> _saveTrailData(TrailData trailData) async {
    try {
      final trailBox = Hive.box<TrailData>('trails');
      await trailBox.put(trailData.tripId, trailData);
      debugPrint('✅ Trail data saved: ${trailData.points.length} points, ${trailData.totalDistance}m');
    } catch (e) {
      debugPrint('❌ Failed to save trail data: $e');
      rethrow;
    }
  }

  // FIXED: Mark trip as completed and award badge
  Future<void> _completeTrip() async {
    try {
      final tripBox = Hive.box<model.Trip>('trips');
      final badgeBox = Hive.box<model.Badge>('badges');
      
      // Update trip status
      widget.trip.completed = true;
      widget.trip.badgeEarned = true;
      await tripBox.put(widget.trip.id, widget.trip);
      
      // Award badge based on trip type
      final typeHelper = TripTypeHelper.fromTrip(widget.trip);
      final badge = model.Badge(
        id: 'badge_${widget.trip.id}_${DateTime.now().millisecondsSinceEpoch}',
        tripId: widget.trip.id,
        label: '${typeHelper.displayName} GPS Explorer',
        earnedAt: DateTime.now(),
        coreType: widget.trip.currentType,
      );
      await badgeBox.put(badge.id, badge);
      
      debugPrint('✅ Trip completed and badge awarded: ${badge.label}');
    } catch (e) {
      debugPrint('❌ Failed to complete trip: $e');
      rethrow;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String _formatDistance() {
    if (_totalDistance >= 1.0) {
      return '${_totalDistance.toStringAsFixed(2)} km';
    } else {
      return '${(_totalDistance * 1000).toStringAsFixed(0)} m';
    }
  }

  String _formatSpeed() {
    return '${_currentSpeed.toStringAsFixed(1)} km/h';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(widget.trip.title),
        backgroundColor: AppColors.amethyst600,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Show warning before closing
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Leave Live Tracking?'),
                content: const Text('Tracking will continue in the background. You can return to this screen from the trip detail.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Close tracking screen
                    },
                    child: const Text('Leave'),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: _pauseResumeTracking,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isPaused 
                    ? [AppColors.warning, AppColors.warning.withOpacity(0.8)]
                    : [AppColors.success, AppColors.success.withOpacity(0.8)],
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _isPaused ? Icons.pause_circle : Icons.gps_fixed,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: AppDimensions.spaceS),
                  Text(
                    _isPaused ? 'TRACKING PAUSED' : 'LIVE TRACKING',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _isPaused ? 'Tap play to resume' : 'Recording your adventure',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Stats Grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.spaceL),
                child: Column(
                  children: [
                    // Primary Stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Duration',
                            _formatDuration(_duration),
                            Icons.timer,
                            AppColors.info,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceM),
                        Expanded(
                          child: _buildStatCard(
                            'Distance',
                            _formatDistance(),
                            Icons.straighten,
                            AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppDimensions.spaceM),
                    
                    // Secondary Stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Speed',
                            _formatSpeed(),
                            Icons.speed,
                            AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceM),
                        Expanded(
                          child: _buildStatCard(
                            'GPS Points',
                            '$_pointCount',
                            Icons.location_on,
                            AppColors.amethyst600,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppDimensions.spaceXL),
                    
                    // Trip Info
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.spaceL),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppDimensions.spaceS),
                                decoration: BoxDecoration(
                                  color: TripTypeHelper.fromTrip(widget.trip).color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                                ),
                                child: Icon(
                                  TripTypeHelper.fromTrip(widget.trip).icon,
                                  color: TripTypeHelper.fromTrip(widget.trip).color,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: AppDimensions.spaceM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.trip.title,
                                      style: AppTextStyles.cardTitle,
                                    ),
                                    Text(
                                      '${TripTypeHelper.fromTrip(widget.trip).displayName} • ${widget.trip.waypoints.length} waypoints',
                                      style: AppTextStyles.cardSubtitle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          if (widget.trip.waypoints.isNotEmpty) ...[
                            const SizedBox(height: AppDimensions.spaceL),
                            const Divider(),
                            const SizedBox(height: AppDimensions.spaceM),
                            Text(
                              'Planned Route',
                              style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: AppDimensions.spaceS),
                            ...widget.trip.waypoints.asMap().entries.map((entry) {
                              final index = entry.key;
                              final waypoint = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppDimensions.spaceS),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: AppColors.amethyst600,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppDimensions.spaceM),
                                    Expanded(
                                      child: Text(
                                        waypoint.name,
                                        style: AppTextStyles.cardSubtitle,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pauseResumeTracking,
                      icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                      label: Text(_isPaused ? 'Resume' : 'Pause'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _stopTracking,
                      icon: const Icon(Icons.stop),
                      label: const Text('Complete Adventure'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}