// lib/screens/trip_list_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;
import 'map_trip_creation_screen.dart';
import 'trip_detail_screen.dart';
import 'badge_wall_screen.dart';

class TripListScreen extends StatelessWidget {
  const TripListScreen({Key? key}) : super(key: key);

  Future<void> _addNewTrip(BuildContext context) async {
    final tripBox = Hive.box<model.Trip>('trips');
    final model.Trip? newTrip = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapTripCreationScreen()),
    );
    if (newTrip != null) {
      tripBox.put(newTrip.id, newTrip);
    }
  }

  Future<void> _openTripDetail(BuildContext context, model.Trip trip) async {
    final badgeBox = Hive.box<model.Badge>('badges');
    final model.Badge? earned = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TripDetailScreen(trip: trip)),
    );
    if (earned != null) {
      badgeBox.put(earned.id, earned);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripBox = Hive.box<model.Trip>('trips');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Trips'),
        automaticallyImplyLeading: false,
        // Removed the actions section - no more redundant badge button!
      ),
      body: ValueListenableBuilder(
        valueListenable: tripBox.listenable(),
        builder: (context, Box<model.Trip> box, _) {
          final trips = box.values.toList();
          if (trips.isEmpty) {
            return const Center(
              child: Text(
                'No trips yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (ctx, i) {
              final trip = trips[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(trip.title),
                  subtitle: Text(
                    '${trip.waypoints.length} waypoint${trip.waypoints.length == 1 ? '' : 's'} • '
                    '${trip.type.toString().split('.').last.toUpperCase()}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (trip.completed)
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      if (trip.badgeEarned)
                        const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => _openTripDetail(context, trip),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTrip(context),
        tooltip: 'Create Trip',
        child: const Icon(Icons.add),
      ),
    );
  }
}