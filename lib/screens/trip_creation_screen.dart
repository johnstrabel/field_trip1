// lib/screens/trip_creation_screen.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/trip.dart';

class TripCreationScreen extends StatefulWidget {
  const TripCreationScreen({Key? key}) : super(key: key);

  @override
  _TripCreationScreenState createState() => _TripCreationScreenState();
}

class _TripCreationScreenState extends State<TripCreationScreen> {
  final _titleController = TextEditingController();
  final _nameController = TextEditingController();
  final List<Waypoint> _waypoints = [];
  
  TripType _selectedType = TripType.standard;

  void _addWaypoint() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        _waypoints.add(
          Waypoint(
            name: name,
            note: "", // Empty note for now
            latitude: 50.0755, // Default Prague coordinates
            longitude: 14.4378,
          ),
        );
        _nameController.clear();
      });
    }
  }

  void _saveTrip() {
    if (_titleController.text.trim().isEmpty || _waypoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a title and at least one waypoint'),
        ),
      );
      return;
    }

    final trip = Trip(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      type: _selectedType,
      waypoints: _waypoints,
      createdAt: DateTime.now(),
    );

    Navigator.pop(context, trip);
  }

  void _removeWaypoint(int index) {
    setState(() {
      _waypoints.removeAt(index);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Trip (Simple)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTrip,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning about using map version
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This is the simple trip creator. For GPS-based trips, use the Map Trip Creator.',
                      style: TextStyle(color: Colors.orange.shade700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Trip Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Trip Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Trip Type
            DropdownButtonFormField<TripType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Trip Type',
                border: OutlineInputBorder(),
              ),
              onChanged: (TripType? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedType = newValue;
                  });
                }
              },
              items: TripType.values.map((TripType type) {
                return DropdownMenuItem<TripType>(
                  value: type,
                  child: Text(type.toString().split('.').last.toUpperCase()),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Add Waypoint Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Waypoint Name',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addWaypoint(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addWaypoint,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Waypoints List
            const Text(
              'Waypoints',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            Expanded(
              child: _waypoints.isEmpty
                  ? const Center(
                      child: Text(
                        'No waypoints added yet.\nAdd some locations to your trip!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _waypoints.length,
                      itemBuilder: (context, index) {
                        final waypoint = _waypoints[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text(waypoint.name),
                            subtitle: Text('Default location (no GPS)'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeWaypoint(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            
            const SizedBox(height: 16),
            
            // Save Button
            ElevatedButton.icon(
              onPressed: _saveTrip,
              icon: const Icon(Icons.save),
              label: const Text('Save Trip'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}