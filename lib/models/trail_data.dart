// lib/models/trail_data.dart

import 'package:hive/hive.dart';
import 'dart:math' as math;

part 'trail_data.g.dart';

/// Individual GPS point in a trail
@HiveType(typeId: 6) // Using typeId 6 to avoid conflicts
class TrailPoint {
  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final double? accuracy;

  @HiveField(4)
  final double? altitude;

  @HiveField(5)
  final double? speed;

  TrailPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
    this.altitude,
    this.speed,
  });

  /// Convert to Google Maps LatLng for map display
  Map<String, double> toLatLng() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'TrailPoint(lat: ${latitude.toStringAsFixed(6)}, lng: ${longitude.toStringAsFixed(6)}, time: $timestamp)';
  }
}

/// Trail statistics
@HiveType(typeId: 7)
class TrailStats {
  @HiveField(0)
  final double distance; // in meters

  @HiveField(1)
  final Duration duration;

  @HiveField(2)
  final double averageSpeed; // in m/s

  @HiveField(3)
  final int pointCount;

  TrailStats({
    required this.distance,
    required this.duration,
    required this.averageSpeed,
    required this.pointCount,
  });

  /// Distance in kilometers
  double get distanceKm => distance / 1000;

  /// Formatted duration string
  String get durationFormatted {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Speed in km/h
  double get speedKmh => averageSpeed * 3.6;
}

/// Complete trail data for a trip
@HiveType(typeId: 8)
class TrailData {
  @HiveField(0)
  final String tripId;

  @HiveField(1)
  final List<TrailPoint> points;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  final DateTime endTime;

  @HiveField(4)
  final double totalDistance; // in meters

  @HiveField(5)
  final Duration duration;

  TrailData({
    required this.tripId,
    required this.points,
    required this.startTime,
    required this.endTime,
    required this.totalDistance,
    required this.duration,
  });

  /// Factory constructor to create TrailData from tracking session
  factory TrailData.fromTrackingSession(String tripId, List<TrailPoint> points) {
    if (points.isEmpty) {
      final now = DateTime.now();
      return TrailData(
        tripId: tripId,
        points: [],
        startTime: now,
        endTime: now,
        totalDistance: 0,
        duration: Duration.zero,
      );
    }

    final startTime = points.first.timestamp;
    final endTime = points.last.timestamp;
    final duration = endTime.difference(startTime);
    
    double totalDistance = 0;
    for (int i = 1; i < points.length; i++) {
      totalDistance += _calculateDistance(points[i - 1], points[i]);
    }

    return TrailData(
      tripId: tripId,
      points: points,
      startTime: startTime,
      endTime: endTime,
      totalDistance: totalDistance,
      duration: duration,
    );
  }

  /// Get trail statistics
  TrailStats get stats {
    return TrailStats(
      distance: totalDistance,
      duration: duration,
      averageSpeed: duration.inSeconds > 0 ? totalDistance / duration.inSeconds : 0,
      pointCount: points.length,
    );
  }

  /// Calculate distance between two trail points using Haversine formula
  static double _calculateDistance(TrailPoint point1, TrailPoint point2) {
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

  /// Convert trail to polyline coordinates for map display
  List<Map<String, double>> toPolylineCoordinates() {
    return points.map((point) => point.toLatLng()).toList();
  }

  /// Get simplified trail for map display (reduces points for performance)
  List<TrailPoint> getSimplifiedTrail({int maxPoints = 100}) {
    if (points.length <= maxPoints) return points;
    
    final step = points.length / maxPoints;
    final List<TrailPoint> simplified = [];
    
    for (int i = 0; i < points.length; i += step.ceil()) {
      simplified.add(points[i]);
    }
    
    // Always include the last point
    if (simplified.last != points.last) {
      simplified.add(points.last);
    }
    
    return simplified;
  }
}