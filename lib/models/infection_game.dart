// lib/models/infection_game.dart
import 'package:hive/hive.dart';

part 'infection_game.g.dart';

@HiveType(typeId: 14)
enum InfectionMode {
  @HiveField(0)
  arena,      // Fixed boundary, hidden players
  @HiveField(1)
  freeForAll, // Open world, asymmetric visibility
  @HiveField(2)
  crawl       // Drinking variant with special rules
}

@HiveType(typeId: 15)
enum PlayerRole {
  @HiveField(0)
  runner,     // Trying to survive
  @HiveField(1)
  infected,   // Trying to tag runners
  @HiveField(2)
  eliminated  // Out of the game
}

@HiveType(typeId: 16)
enum GameStatus {
  @HiveField(0)
  lobby,      // Waiting for players
  @HiveField(1)
  starting,   // Countdown phase
  @HiveField(2)
  active,     // Game in progress
  @HiveField(3)
  paused,     // Temporarily stopped
  @HiveField(4)
  finished    // Game over
}

@HiveType(typeId: 17)
class GameAction {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String playerId;
  
  @HiveField(2)
  final String actionType; // 'tag', 'drink', 'immunity', 'freeze'
  
  @HiveField(3)
  final DateTime timestamp;
  
  @HiveField(4)
  final Map<String, dynamic> data; // Action-specific data
  
  @HiveField(5)
  final String? targetPlayerId; // For tag actions

  GameAction({
    required this.id,
    required this.playerId,
    required this.actionType,
    required this.timestamp,
    required this.data,
    this.targetPlayerId,
  });
}

@HiveType(typeId: 18)
class PlayerState {
  @HiveField(0)
  final String userId;
  
  @HiveField(1)
  final String displayName;
  
  @HiveField(2)
  final PlayerRole role;
  
  @HiveField(3)
  final DateTime? lastUpdate;
  
  @HiveField(4)
  final double? latitude;
  
  @HiveField(5)
  final double? longitude;
  
  @HiveField(6)
  final List<GameAction> actions;
  
  @HiveField(7)
  final bool isImmune;
  
  @HiveField(8)
  final DateTime? immunityEndsAt;
  
  @HiveField(9)
  final bool isFrozen;
  
  @HiveField(10)
  final DateTime? freezeEndsAt;

  PlayerState({
    required this.userId,
    required this.displayName,
    required this.role,
    this.lastUpdate,
    this.latitude,
    this.longitude,
    required this.actions,
    this.isImmune = false,
    this.immunityEndsAt,
    this.isFrozen = false,
    this.freezeEndsAt,
  });

  // Helper methods
  bool get isActive => role != PlayerRole.eliminated;
  bool get hasLocation => latitude != null && longitude != null;
  
  Duration? get timeAlive {
    if (role != PlayerRole.runner) return null;
    final startTime = actions.isNotEmpty ? actions.first.timestamp : DateTime.now();
    return DateTime.now().difference(startTime);
  }
  
  int get tagCount => actions.where((a) => a.actionType == 'tag').length;
}

@HiveType(typeId: 19)
class GameBoundary {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final List<LatLng> boundaryPoints;
  
  @HiveField(2)
  final double? radius; // For circular boundaries
  
  @HiveField(3)
  final String type; // 'circle', 'polygon', 'custom'
  
  @HiveField(4)
  final LatLng center;

  GameBoundary({
    required this.id,
    required this.boundaryPoints,
    this.radius,
    required this.type,
    required this.center,
  });

  bool containsPoint(LatLng point) {
    if (type == 'circle' && radius != null) {
      final distance = _calculateDistance(center, point);
      return distance <= radius!;
    }
    
    // Polygon containment using ray casting algorithm
    return _pointInPolygon(point, boundaryPoints);
  }

  double distanceToEdge(LatLng point) {
    if (type == 'circle' && radius != null) {
      final distance = _calculateDistance(center, point);
      return (distance - radius!).abs();
    }
    
    // For polygons, calculate minimum distance to any edge
    double minDistance = double.infinity;
    for (int i = 0; i < boundaryPoints.length; i++) {
      final p1 = boundaryPoints[i];
      final p2 = boundaryPoints[(i + 1) % boundaryPoints.length];
      final distance = _distanceToLineSegment(point, p1, p2);
      minDistance = math.min(minDistance, distance);
    }
    return minDistance;
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    // Haversine formula for distance between two points on Earth
    const double earthRadius = 6371000; // meters
    final double lat1Rad = p1.latitude * math.pi / 180;
    final double lat2Rad = p2.latitude * math.pi / 180;
    final double deltaLat = (p2.latitude - p1.latitude) * math.pi / 180;
    final double deltaLng = (p2.longitude - p1.longitude) * math.pi / 180;

    final double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
        math.sin(deltaLng / 2) * math.sin(deltaLng / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  bool _pointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;
    for (int i = 0; i < polygon.length; i++) {
      final p1 = polygon[i];
      final p2 = polygon[(i + 1) % polygon.length];
      
      if (_rayIntersectsSegment(point, p1, p2)) {
        intersectCount++;
      }
    }
    return intersectCount % 2 == 1;
  }

  bool _rayIntersectsSegment(LatLng point, LatLng p1, LatLng p2) {
    if (p1.latitude > point.latitude == p2.latitude > point.latitude) return false;
    
    final double intersectX = (p2.longitude - p1.longitude) * 
        (point.latitude - p1.latitude) / (p2.latitude - p1.latitude) + p1.longitude;
    
    return intersectX > point.longitude;
  }

  double _distanceToLineSegment(LatLng point, LatLng lineStart, LatLng lineEnd) {
    // Implementation for distance from point to line segment
    // Simplified for demonstration - use proper geospatial calculation in production
    return _calculateDistance(point, lineStart);
  }
}

@HiveType(typeId: 20)
class LatLng {
  @HiveField(0)
  final double latitude;
  
  @HiveField(1)
  final double longitude;

  LatLng(this.latitude, this.longitude);
}

@HiveType(typeId: 21)
class GameSession {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final InfectionMode mode;
  
  @HiveField(3)
  final List<PlayerState> players;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  final DateTime? startTime;
  
  @HiveField(6)
  final DateTime? endTime;
  
  @HiveField(7)
  final Duration? gameDuration;
  
  @HiveField(8)
  final Map<String, dynamic> rules;
  
  @HiveField(9)
  final GameBoundary? boundary;
  
  @HiveField(10)
  final GameStatus status;
  
  @HiveField(11)
  final String creatorId;
  
  @HiveField(12)
  final List<GameAction> gameLog;

  GameSession({
    required this.id,
    required this.name,
    required this.mode,
    required this.players,
    required this.createdAt,
    this.startTime,
    this.endTime,
    this.gameDuration,
    required this.rules,
    this.boundary,
    required this.status,
    required this.creatorId,
    required this.gameLog,
  });

  // Helper methods
  List<PlayerState> get runners => players.where((p) => p.role == PlayerRole.runner).toList();
  List<PlayerState> get infected => players.where((p) => p.role == PlayerRole.infected).toList();
  List<PlayerState> get eliminated => players.where((p) => p.role == PlayerRole.eliminated).toList();
  
  bool get isActive => status == GameStatus.active;
  bool get isFinished => status == GameStatus.finished;
  
  int get totalPlayers => players.length;
  int get activePlayers => players.where((p) => p.isActive).length;
  
  Duration? get elapsedTime {
    if (startTime == null) return null;
    final endTime = this.endTime ?? DateTime.now();
    return endTime.difference(startTime!);
  }
  
  PlayerState? getPlayer(String userId) {
    try {
      return players.firstWhere((p) => p.userId == userId);
    } catch (e) {
      return null;
    }
  }
  
  bool canPlayerSee(String viewerId, String targetId) {
    final viewer = getPlayer(viewerId);
    final target = getPlayer(targetId);
    
    if (viewer == null || target == null) return false;
    if (viewer.userId == target.userId) return true; // Can always see yourself
    
    switch (mode) {
      case InfectionMode.arena:
        return false; // No one can see anyone in arena mode
      case InfectionMode.freeForAll:
        return viewer.role == PlayerRole.infected; // Only infected can see others
      case InfectionMode.crawl:
        return viewer.role == PlayerRole.infected; // Same as FFA for now
    }
  }
}