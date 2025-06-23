// lib/utils/data_migration.dart - Updated for 3-Type System

import 'package:hive/hive.dart';
import '../models/trip.dart' as model;

class DataMigration {
  static const String _migrationVersionKey = 'migration_version';
  static const int _currentMigrationVersion = 2; // Updated for 3-type system

  /// Check if migration is needed and perform it
  static Future<void> performMigrationIfNeeded() async {
    try {
      final Box settingsBox = await Hive.openBox('settings');
      final int currentVersion = settingsBox.get(_migrationVersionKey, defaultValue: 0);

      if (currentVersion < _currentMigrationVersion) {
        print('🔄 Performing data migration from version $currentVersion to $_currentMigrationVersion');
        
        if (currentVersion < 1) {
          await _migrateToVersion1();
        }
        if (currentVersion < 2) {
          await _migrateToVersion2();
        }

        // Update migration version
        await settingsBox.put(_migrationVersionKey, _currentMigrationVersion);
        print('✅ Migration completed successfully');
      } else {
        print('✅ Data is up to date (version $currentVersion)');
      }
    } catch (e) {
      print('❌ Migration error: $e');
      // Continue anyway - app should still work
    }
  }

  /// Migration from old TripType system to new CoreType system
  static Future<void> _migrateToVersion1() async {
    print('📦 Migrating trips to new CoreType system...');
    
    try {
      // This migration is handled automatically by the compatibility layer
      // in the Trip and Badge classes, so no explicit migration needed
      print('📦 Migration handled by compatibility layer');
    } catch (e) {
      print('❌ Migration failed: $e');
      rethrow;
    }
  }

  /// Migration to 3-type system (Explore, Crawl, Sport)
  static Future<void> _migrateToVersion2() async {
    print('📦 Migrating to 3-type system (Explore, Crawl, Sport)...');
    
    try {
      final Box<model.Trip> tripBox = Hive.box<model.Trip>('trips');
      final Box<model.Badge> badgeBox = Hive.box<model.Badge>('badges');
      
      // Migration is handled by the model's compatibility layer
      // Old 'active' and 'game' types automatically map to 'sport'
      print('📦 3-type migration handled by compatibility layer');
      print('📦 Active + Game → Sport, Explore stays, Crawl stays');
    } catch (e) {
      print('❌ 3-type migration failed: $e');
      rethrow;
    }
  }

  /// Create sample data with new 3-type system (for testing)
  static Future<void> createSampleDataNewSystem() async {
    final Box<model.Trip> tripBox = Hive.box<model.Trip>('trips');
    final Box<model.Badge> badgeBox = Hive.box<model.Badge>('badges');
    
    // Clear existing data for fresh start
    await tripBox.clear();
    await badgeBox.clear();
    
    // Create sample trips with new 3-type CoreType system
    final sampleTrips = [
      // EXPLORE - Traditional sightseeing
      model.Trip(
        id: 'sample_explore_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Historic Downtown Walk',
        waypoints: [
          model.Waypoint(name: 'City Hall', note: 'Beautiful architecture', latitude: 40.7589, longitude: -73.9851),
          model.Waypoint(name: 'Old Library', note: 'Rich history', latitude: 40.7505, longitude: -73.9934),
          model.Waypoint(name: 'Historic Square', note: 'Perfect photo spot', latitude: 40.7549, longitude: -73.9840),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        coreType: model.CoreType.explore,
        subMode: 'sightseeing',
        completed: true,
        badgeEarned: true,
      ),
      
      // CRAWL - Nightlife adventures
      model.Trip(
        id: 'sample_crawl_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Beer Golf Night Tour',
        waypoints: [
          model.Waypoint(name: 'The Craft House', note: 'Hole 1: Try the IPA', latitude: 40.7505, longitude: -73.9934),
          model.Waypoint(name: 'Rooftop Lounge', note: 'Hole 2: City views', latitude: 40.7549, longitude: -73.9840),
          model.Waypoint(name: 'Underground Bar', note: 'Final hole: Victory drink', latitude: 40.7589, longitude: -73.9851),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        coreType: model.CoreType.crawl,
        subMode: 'beer_golf',
        completed: true,
        badgeEarned: true,
      ),
      
      // SPORT - Fitness and games (combines old fitness + challenge)
      model.Trip(
        id: 'sample_sport_fitness_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Central Park Running Circuit',
        waypoints: [
          model.Waypoint(name: 'Start Line', note: 'Begin your fitness journey', latitude: 40.7851, longitude: -73.9683),
          model.Waypoint(name: 'Mile 1 Marker', note: 'First checkpoint', latitude: 40.7739, longitude: -73.9713),
          model.Waypoint(name: 'Finish Line', note: 'Complete your workout', latitude: 40.7794, longitude: -73.9632),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        coreType: model.CoreType.sport,
        subMode: 'time_trial',
        completed: false,
        badgeEarned: false,
      ),
      
      // SPORT - Game variant (frisbee golf)
      model.Trip(
        id: 'sample_sport_game_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Prospect Park Frisbee Golf',
        waypoints: [
          model.Waypoint(name: 'Tee 1', note: 'Drive across the meadow', latitude: 40.6602, longitude: -73.9690),
          model.Waypoint(name: 'Basket 3', note: 'Around the pond', latitude: 40.6612, longitude: -73.9680),
          model.Waypoint(name: 'Final Basket', note: 'Championship hole', latitude: 40.6622, longitude: -73.9670),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        coreType: model.CoreType.sport,
        subMode: 'frisbee_golf',
        completed: true,
        badgeEarned: true,
      ),
    ];

    // Save sample trips
    for (final trip in sampleTrips) {
      await tripBox.put(trip.id, trip);
      
      // Create badges for completed trips
      if (trip.completed && trip.badgeEarned) {
        final helper = _getTypeDisplayName(trip.coreType);
        final badge = model.Badge(
          id: 'badge_${trip.id}',
          tripId: trip.id,
          label: '$helper Explorer',
          earnedAt: trip.createdAt.add(const Duration(hours: 2)),
          coreType: trip.coreType,
        );
        await badgeBox.put(badge.id, badge);
      }
    }
    
    print('📝 Created ${sampleTrips.length} sample trips with new 3-type system (Explore, Crawl, Sport)');
    print('📝 Sample data includes:');
    print('   • Explore: Historic Downtown Walk (sightseeing)');
    print('   • Crawl: Beer Golf Night Tour (nightlife games)');
    print('   • Sport: Running Circuit (fitness) + Frisbee Golf (games)');
  }

  /// Helper to get display name for CoreType
  static String _getTypeDisplayName(model.CoreType coreType) {
    switch (coreType) {
      case model.CoreType.explore:
        return 'EXPLORE';
      case model.CoreType.crawl:
        return 'CRAWL';
      case model.CoreType.sport:
        return 'SPORT';
    }
  }

  /// Helper to migrate old data if needed (called during app startup)
  static Future<void> ensureDataCompatibility() async {
    try {
      final Box<model.Trip> tripBox = Hive.box<model.Trip>('trips');
      final trips = tripBox.values.toList();
      
      bool needsUpdate = false;
      
      for (final trip in trips) {
        // Check if any trips still use old type system
        if (trip.oldType != null && trip.coreType == model.CoreType.explore) {
          needsUpdate = true;
          break;
        }
      }
      
      if (needsUpdate) {
        print('🔄 Ensuring data compatibility with 3-type system...');
        // The model's compatibility layer handles this automatically
        print('✅ Data compatibility ensured');
      }
    } catch (e) {
      print('❌ Compatibility check failed: $e');
    }
  }
}