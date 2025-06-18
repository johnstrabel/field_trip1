// lib/models/trail_data.dart

import 'package:hive/hive.dart';
import 'dart:math' as math;

part 'trail_data.g.dart';

/// Individual GPS point in a trail
@HiveType(typeId: 4)
class TrailPoint extends HiveObject {
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

/// Complete trail data for a trip
@HiveType(typeId: 5)
class TrailData extends HiveObject {
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

  /// Get coordinates for map polyline rendering
  List<Map<String, double>> get coordinates {
    return points.map((point) => point.toLatLng()).toList();
  }

  /// Calculate distance between two trail points using Haversine formula
  static double _calculateDistance(TrailPoint point1, TrailPoint point2) {
    const double earthRadius = 6371000; // meters
    
    final lat1Rad = point1.latitude * (math.pi / 180);
    final lat2Rad = point2.latitude * (math.pi / 180);
    final deltaLatRad = (point2.latitude - point1.latitude) * (math.pi / 180);
    final deltaLngRad = (point2.longitude - point1.longitude) * (math.pi / 180);

    final a = math.pow(math.sin(deltaLatRad / 2), 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
        math.pow(math.sin(deltaLngRad / 2), 2);
    
    final c = 2 * math.asin(math.sqrt(a));
    return earthRadius * c;
  }
}

/// Trail statistics for display
class TrailStats {
  final double distance; // meters
  final Duration duration;
  final double averageSpeed; // m/s
  final int pointCount;

  TrailStats({
    required this.distance,
    required this.duration,
    required this.averageSpeed,
    required this.pointCount,
  });

  /// Distance in kilometers with formatting
  String get distanceKm {
    return '${(distance / 1000).toStringAsFixed(2)} km';
  }

  /// Speed in km/h with formatting
  String get speedKmh {
    return '${(averageSpeed * 3.6).toStringAsFixed(1)} km/h';
  }

  /// Duration formatted as HH:MM:SS
  String get durationFormatted {
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60);
    final seconds = (duration.inSeconds % 60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}