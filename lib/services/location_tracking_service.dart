// lib/services/location_tracking_service.dart

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import '../models/trail_data.dart';

class LocationTrackingService extends ChangeNotifier {
  static final LocationTrackingService _instance = LocationTrackingService._internal();
  factory LocationTrackingService() => _instance;
  LocationTrackingService._internal();

  final Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  
  bool _isTracking = false;
  String? _activeTripId;
  final List<TrailPoint> _currentTrail = [];
  
  // Getters
  bool get isTracking => _isTracking;
  String? get activeTripId => _activeTripId;
  List<TrailPoint> get currentTrail => List.unmodifiable(_currentTrail);
  
  /// Start tracking for a specific trip
  Future<bool> startTracking(String tripId) async {
    if (_isTracking) {
      debugPrint('Already tracking - stopping current session');
      await stopTracking();
    }

    try {
      // Check permissions
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return false;
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return false;
      }

      // Configure location settings for optimal tracking
      await _location.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 3000, // 3 seconds - balance between accuracy and battery
        distanceFilter: 2.0, // Only log points 2+ meters apart
      );

      // Clear previous trail and start fresh
      _currentTrail.clear();
      _activeTripId = tripId;
      _isTracking = true;

      // Start location stream
      _locationSubscription = _location.onLocationChanged.listen(
        _onLocationUpdate,
        onError: (error) {
          debugPrint('Location tracking error: $error');
          stopTracking();
        },
      );

      debugPrint('Started tracking for trip: $tripId');
      notifyListeners();
      return true;

    } catch (e) {
      debugPrint('Failed to start tracking: $e');
      return false;
    }
  }

  /// Stop tracking and return the completed trail
  Future<List<TrailPoint>> stopTracking() async {
    if (!_isTracking) return [];

    await _locationSubscription?.cancel();
    _locationSubscription = null;
    _isTracking = false;

    final completedTrail = List<TrailPoint>.from(_currentTrail);
    final tripId = _activeTripId;
    
    _activeTripId = null;
    _currentTrail.clear();

    debugPrint('Stopped tracking for trip: $tripId, collected ${completedTrail.length} points');
    notifyListeners();
    
    return completedTrail;
  }

  /// Handle incoming location updates
  void _onLocationUpdate(LocationData locationData) {
    if (!_isTracking || locationData.latitude == null || locationData.longitude == null) {
      return;
    }

    final newPoint = TrailPoint(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
      timestamp: DateTime.now(),
      accuracy: locationData.accuracy,
      altitude: locationData.altitude,
      speed: locationData.speed,
    );

    // Add point and notify listeners for real-time updates
    _currentTrail.add(newPoint);
    
    debugPrint('Trail point added: ${newPoint.latitude}, ${newPoint.longitude} (${_currentTrail.length} total)');
    notifyListeners();
  }

  /// Get trail statistics
  TrailStats getTrailStats() {
    if (_currentTrail.length < 2) {
      return TrailStats(
        distance: 0,
        duration: Duration.zero,
        averageSpeed: 0,
        pointCount: _currentTrail.length,
      );
    }

    double totalDistance = 0;
    for (int i = 1; i < _currentTrail.length; i++) {
      totalDistance += _calculateDistance(
        _currentTrail[i - 1],
        _currentTrail[i],
      );
    }

    final duration = _currentTrail.last.timestamp.difference(_currentTrail.first.timestamp);
    final averageSpeed = duration.inSeconds > 0 ? (totalDistance / duration.inSeconds).toDouble() : 0.0;

    return TrailStats(
      distance: totalDistance,
      duration: duration,
      averageSpeed: averageSpeed,
      pointCount: _currentTrail.length,
    );
  }

  /// Calculate distance between two points using Haversine formula
  double _calculateDistance(TrailPoint point1, TrailPoint point2) {
    const double earthRadius = 6371000; // meters
    
    final lat1Rad = point1.latitude * (math.pi / 180);
    final lat2Rad = point2.latitude * (math.pi / 180);
    final deltaLatRad = (point2.latitude - point1.latitude) * (math.pi / 180);
    final deltaLngRad = (point2.longitude - point1.longitude) * (math.pi / 180);

    final a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
        math.sin(deltaLngRad / 2) * math.sin(deltaLngRad / 2);
    
    final c = 2 * math.asin(math.sqrt(a));
    return earthRadius * c;
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}