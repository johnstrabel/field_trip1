// lib/screens/trip_creation_screen.dart - Updated for 3-Type System

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/trip.dart';
import '../theme/app_theme.dart';

class TripCreationScreen extends StatefulWidget {
  const TripCreationScreen({Key? key}) : super(key: key);

  @override
  _TripCreationScreenState createState() => _TripCreationScreenState();
}

class _TripCreationScreenState extends State<TripCreationScreen> {
  final _titleController = TextEditingController();
  final _nameController = TextEditingController();
  final List<Waypoint> _waypoints = [];
  
  // UPDATED: Use CoreType for new 3-type system, default to explore
  CoreType _selectedCoreType = CoreType.explore;

  // Helper map for display names and descriptions
  final Map<CoreType, Map<String, String>> _typeInfo = {
    CoreType.explore: {
      'name': 'Explore',
      'description': 'Traditional exploration and sightseeing adventures',
    },
    CoreType.crawl: {
      'name': 'Crawl',
      'description': 'Nightlife adventures: bars, beer golf, subway surfers',
    },
    CoreType.sport: {
      'name': 'Sport',
      'description': 'Fitness, time trials, golf, frisbee golf with scorecards',
    },
  };

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

    // UPDATED: Use new Trip constructor with CoreType
    final trip = Trip(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      waypoints: _waypoints,
      createdAt: DateTime.now(),
      coreType: _selectedCoreType,
      subMode: _getSubModeForType(_selectedCoreType),
    );

    Navigator.pop(context, trip);
  }

  String _getSubModeForType(CoreType type) {
    switch (type) {
      case CoreType.explore:
        return 'sightseeing';
      case CoreType.crawl:
        return 'social';
      case CoreType.sport:
        return 'fitness';
    }
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

            // UPDATED: Trip Type Selection with new 3-type system
            Text(
              'Trip Type',
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: 8),
            
            ...CoreType.values.map((type) => _buildTypeCard(type)),
            
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
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _waypoints.length,
                      itemBuilder: (context, index) {
                        final waypoint = _waypoints[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: TripTypeHelper.fromCoreType(_selectedCoreType).color,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(waypoint.name),
                            subtitle: Text(
                              'Default coordinates (Use Map Creator for GPS)',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
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
              label: Text('Save ${_typeInfo[_selectedCoreType]!['name']} Trip'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TripTypeHelper.fromCoreType(_selectedCoreType).color,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(CoreType type) {
    final info = _typeInfo[type]!;
    final helper = TripTypeHelper.fromCoreType(type);
    final isSelected = _selectedCoreType == type;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      child: InkWell(
        onTap: () => setState(() => _selectedCoreType = type),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          decoration: BoxDecoration(
            color: isSelected ? helper.color.withOpacity(0.1) : AppColors.card,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: isSelected ? helper.color : AppColors.stroke,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceM),
                decoration: BoxDecoration(
                  color: helper.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.spaceM),
                ),
                child: Icon(
                  helper.icon,
                  color: helper.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info['name']!,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: isSelected ? helper.color : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      info['description']!,
                      style: AppTextStyles.cardSubtitle,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: helper.color,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}