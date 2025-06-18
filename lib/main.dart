import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/trip.dart' as model;
import 'models/trail_data.dart' as trail;
import 'screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters for Trip models
  Hive.registerAdapter(model.TripTypeAdapter());
  Hive.registerAdapter(model.WaypointAdapter());
  Hive.registerAdapter(model.TripAdapter());
  Hive.registerAdapter(model.BadgeAdapter());

  // Register adapters for Trail models
  Hive.registerAdapter(trail.TrailPointAdapter());
  Hive.registerAdapter(trail.TrailDataAdapter());

  try {
    // Open existing boxes
    await Hive.openBox<model.Trip>('trips');
    await Hive.openBox<model.Badge>('badges');
    
    // Open new trail data box
    await Hive.openBox<trail.TrailData>('trail_data');
    
  } catch (e) {
    // If there's an error opening boxes (due to schema changes), clear them
    debugPrint('Error opening boxes, clearing data: $e');
    
    try {
      // Delete the old boxes
      await Hive.deleteBoxFromDisk('trips');
      await Hive.deleteBoxFromDisk('badges');
      await Hive.deleteBoxFromDisk('trail_data');
      
      // Open fresh boxes
      await Hive.openBox<model.Trip>('trips');
      await Hive.openBox<model.Badge>('badges');
      await Hive.openBox<trail.TrailData>('trail_data');
      
      debugPrint('Successfully reset Hive boxes');
    } catch (resetError) {
      debugPrint('Error resetting boxes: $resetError');
      // Continue anyway - boxes will be created on first access
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
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}