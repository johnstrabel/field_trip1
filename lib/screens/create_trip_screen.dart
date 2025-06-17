import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/trip.dart';

class CreateTripScreen extends StatefulWidget {
  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _titleController = TextEditingController();
  final List<Waypoint> _waypoints = [];
  final _waypointNameController = TextEditingController();
  final _waypointNoteController = TextEditingController();

  TripType _selectedType = TripType.standard;

  void _addWaypoint() {
    if (_waypointNameController.text.isEmpty) return;

    setState(() {
      _waypoints.add(
        Waypoint(
          name: _waypointNameController.text,
          note: _waypointNoteController.text,
          latitude: 50.0755, // Default Prague coordinates
          longitude: 14.4378,
        ),
      );
      _waypointNameController.clear();
      _waypointNoteController.clear();
    });
  }

  void _saveTrip() {
    if (_titleController.text.isEmpty || _waypoints.isEmpty) return;

    final trip = Trip(
      id: const Uuid().v4(),
      title: _titleController.text,
      type: _selectedType,
      waypoints: _waypoints,
      createdAt: DateTime.now(),
    );

    // Just go back with trip for now
    Navigator.pop(context, trip);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Trip (Legacy)'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveTrip,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Trip Title'),
            ),
            SizedBox(height: 16),
            DropdownButton<TripType>(
              value: _selectedType,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedType = newValue;
                  });
                }
              },
              items: TripType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last.toUpperCase()),
                );
              }).toList(),
            ),
            Divider(),
            Text('Waypoints', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _waypointNameController,
              decoration: InputDecoration(labelText: 'Location Name'),
            ),
            TextField(
              controller: _waypointNoteController,
              decoration: InputDecoration(labelText: 'Notes'),
            ),
            ElevatedButton(
              onPressed: _addWaypoint,
              child: Text('Add Waypoint'),
            ),
            Text(
              'Note: This legacy screen uses default coordinates. Use Map Trip Creation for GPS.',
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
            SizedBox(height: 8),
            ..._waypoints.map((w) => ListTile(
              title: Text(w.name),
              subtitle: Text(w.note),
            )),
          ],
        ),
      ),
    );
  }
}