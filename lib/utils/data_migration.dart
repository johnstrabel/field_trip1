// lib/utils/data_migration.dart

import 'package:hive/hive.dart';
import '../models/trip.dart' as model;

class DataMigration {
  static const String _migrationVersionKey = 'migration_version';
  static const int _currentMigrationVersion = 1;

  /// Check if migration is needed and perform it
  static Future<void> performMigrationIfNeeded() async {
    try {
      final Box settingsBox = await Hive.openBox('settings');
      final int currentVersion = settingsBox.get(_migrationVersionKey, defaultValue: 0);

      if (currentVersion < _currentMigrationVersion) {
        print('🔄 Performing data migration from version $currentVersion to $_currentMigrationVersion');
        
        await _migrateToVersion1();

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

  /// Create sample data with new system (for testing)
  static Future<void> createSampleDataNewSystem() async {
    final Box<model.Trip> tripBox = Hive.box<model.Trip>('trips');
    final Box<model.Badge> badgeBox = Hive.box<model.Badge>('badges');
    
    // Create sample trips with new CoreType system
    final sampleTrips = [
      model.Trip(
        id: 'sample_explore_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Downtown Art Walk',
        waypoints: [
          model.Waypoint(name: 'Art Museum', note: 'Check out the modern art exhibit', latitude: 40.7589, longitude: -73.9851),
          model.Waypoint(name: 'Sculpture Park', note: 'Outdoor installations', latitude: 40.7614, longitude: -73.9776),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        coreType: model.CoreType.explore,
        subMode: 'sightseeing',
        completed: true,
        badgeEarned: true,
      ),
      model.Trip(
        id: 'sample_crawl_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Weekend Pub Tour',
        waypoints: [
          model.Waypoint(name: 'The Craft House', note: 'Great IPAs', latitude: 40.7505, longitude: -73.9934),
          model.Waypoint(name: 'Rooftop Lounge', note: 'City views', latitude: 40.7549, longitude: -73.9840),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        coreType: model.CoreType.crawl,
        subMode: 'social',
        completed: true,
        badgeEarned: true,
      ),
    ];

    // Save sample trips
    for (final trip in sampleTrips) {
      await tripBox.put(trip.id, trip);
      
      // Create badges for completed trips
      if (trip.completed && trip.badgeEarned) {
        final badge = model.Badge(
          id: 'badge_${trip.id}',
          tripId: trip.id,
          label: '${trip.coreType.toString().split('.').last.toUpperCase()} Explorer',
          earnedAt: trip.createdAt.add(const Duration(hours: 2)),
          coreType: trip.coreType,
        );
        await badgeBox.put(badge.id, badge);
      }
    }
    
    print('📝 Created ${sampleTrips.length} sample trips with new CoreType system');
  }
}