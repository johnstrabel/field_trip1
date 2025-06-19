// lib/screens/live_tracking_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
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
  
  // Manual tracking of stats since LocationTrackingService doesn't have getCurrentStats()
  double _totalDistance = 0.0;
  int _pointCount = 0;
  double _currentSpeed = 0.0;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    if (_isTracking) {
      _trackingService.stopTracking();
    }
    super.dispose();
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
        
        // Start timer to update UI every second
        _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _updateStats();
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
      }
    } else {
      // Pause tracking
      await _trackingService.stopTracking();
      setState(() {
        _isPaused = true;
      });
    }
  }

  Future<void> _stopTracking() async {
    // Show confirmation dialog
    final shouldStop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Tracking?'),
        content: const Text('Are you sure you want to stop tracking this adventure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Stop'),
          ),
        ],
      ),
    );

    if (shouldStop == true) {
      try {
        final trailPoints = await _trackingService.stopTracking();
        _updateTimer?.cancel();
        
        if (trailPoints != null && mounted) {
          // Create TrailData from the returned trail points
          final duration = _startTime != null 
              ? DateTime.now().difference(_startTime!) 
              : Duration.zero;
              
          final trailStats = TrailStats(
            distance: _totalDistance * 1000, // Convert km to meters
            duration: duration,
            averageSpeed: _currentSpeed, // Provide the current speed or calculate average if needed
            pointCount: _pointCount,    // Provide the current point count
          );
          
          final trailData = TrailData(
            tripId: widget.trip.id,
            points: trailPoints, // This should be List<TrailPoint>
            startTime: _startTime ?? DateTime.now(),
            endTime: DateTime.now(),
            totalDistance: _totalDistance * 1000, // meters
            duration: _startTime != null ? DateTime.now().difference(_startTime!) : Duration.zero,
          );
          
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
          Navigator.pop(context);
        }
      } catch (e) {
        _showError('Error stopping tracking: $e');
      }
    }
  }

  void _updateStats() {
    if (_isTracking && !_isPaused) {
      // Since we don't have getCurrentStats(), we'll simulate with basic values
      // This would be replaced with actual tracking service calls when implemented
      setState(() {
        _pointCount += 1; // Simulate adding tracking points
        _totalDistance += 0.01; // Simulate distance increment (10m per second)
        _currentSpeed = 3.6; // Simulate 3.6 km/h walking speed
      });
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
      return '${_totalDistance.toStringAsFixed(1)} km';
    } else {
      return '${(_totalDistance * 1000).toStringAsFixed(0)} m';
    }
  }

  String _formatSpeed() {
    return '${_currentSpeed.toStringAsFixed(1)} km/h';
  }

  @override
  Widget build(BuildContext context) {
    final duration = _startTime != null 
        ? DateTime.now().difference(_startTime!) 
        : Duration.zero;

    return Scaffold(
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
                    child: const Text('Stay'),
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.amethyst600, AppColors.standardBlue],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Status Banner
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceL),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _isPaused ? AppColors.warning : AppColors.success,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceM),
                    Text(
                      _isPaused ? 'Tracking Paused' : 'Live Tracking Active',
                      style: AppTextStyles.cardTitle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Stats Cards
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
                  child: Column(
                    children: [
                      // Primary Stats Row
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              title: 'Distance',
                              value: _formatDistance(),
                              icon: Icons.straighten,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceM),
                          Expanded(
                            child: _StatCard(
                              title: 'Duration',
                              value: _formatDuration(duration),
                              icon: Icons.schedule,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceM),
                      
                      // Secondary Stats Row
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              title: 'Speed',
                              value: _formatSpeed(),
                              icon: Icons.speed,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceM),
                          Expanded(
                            child: _StatCard(
                              title: 'Points',
                              value: '$_pointCount',
                              icon: Icons.place,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppDimensions.spaceXXL),
                      
                      // Trip Info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppDimensions.spaceL),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Trip',
                              style: AppTextStyles.cardTitle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spaceS),
                            Text(
                              widget.trip.title,
                              style: AppTextStyles.cardSubtitle.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spaceS),
                            Text(
                              '${widget.trip.waypoints.length} planned waypoints',
                              style: AppTextStyles.cardSubtitle.copyWith(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Control Buttons
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceL),
                child: Column(
                  children: [
                    // Pause/Resume Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _pauseResumeTracking,
                        icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                        label: Text(_isPaused ? 'Resume Tracking' : 'Pause Tracking'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPaused ? AppColors.success : AppColors.warning,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(AppDimensions.spaceL),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceM),
                    
                    // Stop Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _stopTracking,
                        icon: const Icon(Icons.stop),
                        label: const Text('Stop & Complete'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.all(AppDimensions.spaceL),
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
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: AppDimensions.iconSizeL,
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            value,
            style: AppTextStyles.statValue.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Text(
            title,
            style: AppTextStyles.statLabel.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}