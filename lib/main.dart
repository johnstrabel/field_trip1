// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/trip.dart' as model;
import 'models/trail_data.dart';
import 'utils/data_migration.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/friends_management_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/discovery_map_screen.dart';
import 'screens/badge_wall_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters (both old and new for migration)
    Hive.registerAdapter(model.TripTypeAdapter());      // typeId: 0 (old)
    Hive.registerAdapter(model.WaypointAdapter());      // typeId: 1
    Hive.registerAdapter(model.TripAdapter());          // typeId: 2 (updated)
    Hive.registerAdapter(model.BadgeAdapter());         // typeId: 3 (updated)
    Hive.registerAdapter(model.CoreTypeAdapter());      // typeId: 4 (new)
    Hive.registerAdapter(model.ScoreCardAdapter());     // typeId: 5 (new)
    
    // ADD THESE THREE LINES - Trail data adapters
    Hive.registerAdapter(TrailPointAdapter());          // typeId: 6
    Hive.registerAdapter(TrailStatsAdapter());          // typeId: 7
    Hive.registerAdapter(TrailDataAdapter());           // typeId: 8

    // Open boxes
    await Hive.openBox<model.Trip>('trips');
    await Hive.openBox<model.Badge>('badges');
    await Hive.openBox<model.ScoreCard>('scorecards');
    await Hive.openBox<TrailData>('trails');

    // Perform data migration if needed
    await DataMigration.performMigrationIfNeeded();

    print('✅ Hive initialization and migration completed successfully');

  } catch (e) {
    print('❌ Error during initialization: $e');
    
    // If there's a critical error, clear all data and start fresh
    try {
      await Hive.deleteBoxFromDisk('trips');
      await Hive.deleteBoxFromDisk('badges');
      await Hive.deleteBoxFromDisk('scorecards');
      await Hive.deleteBoxFromDisk('trails');
      await Hive.deleteBoxFromDisk('settings');
      
      // Re-initialize
      await Hive.initFlutter();
      Hive.registerAdapter(model.TripTypeAdapter());
      Hive.registerAdapter(model.WaypointAdapter());
      Hive.registerAdapter(model.TripAdapter());
      Hive.registerAdapter(model.BadgeAdapter());
      Hive.registerAdapter(model.CoreTypeAdapter());
      Hive.registerAdapter(model.ScoreCardAdapter());
      Hive.registerAdapter(TrailPointAdapter());
      Hive.registerAdapter(TrailStatsAdapter());
      Hive.registerAdapter(TrailDataAdapter());
      
      // Open fresh boxes
      await Hive.openBox<model.Trip>('trips');
      await Hive.openBox<model.Badge>('badges');
      await Hive.openBox<model.ScoreCard>('scorecards');
      await Hive.openBox<TrailData>('trails');
      
      // Create sample data for testing
      await DataMigration.createSampleDataNewSystem();
      
      print('🔄 Fresh start completed with sample data');
    } catch (resetError) {
      print('💥 Critical error during reset: $resetError');
    }
  }

  runApp(const FieldTripApp());
}

class FieldTripApp extends StatelessWidget {
  const FieldTripApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Trip',
      theme: AppTheme.theme,
      home: const MainNavigationScreen(),
      routes: {
        '/friends': (context) => const FriendsManagementScreen(),
        '/leaderboard': (context) => const LeaderboardScreen(),
        '/map-discover': (context) => const DiscoveryMapScreen(),
        '/badges': (context) => const BadgeWallScreen(),
      },
    );
  }
}