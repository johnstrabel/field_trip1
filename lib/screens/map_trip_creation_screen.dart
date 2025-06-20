// lib/screens/map_trip_creation_screen.dart

import 'package:flutter/material.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';

class MapTripCreationScreen extends StatefulWidget {
  const MapTripCreationScreen({Key? key}) : super(key: key);

  @override
  _MapTripCreationScreenState createState() => _MapTripCreationScreenState();
}

class _MapTripCreationScreenState extends State<MapTripCreationScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Trip configuration
  String _tripTitle = '';
  model.TripType _selectedTripType = model.TripType.standard;
  final List<model.Waypoint> _waypoints = [];

  // Trip type descriptions
  final Map<model.TripType, Map<String, String>> _tripTypeInfo = {
    model.TripType.standard: {
      'name': 'Standard',
      'description': 'Casual exploration and sightseeing adventures',
    },
    model.TripType.challenge: {
      'name': 'Challenge',
      'description': 'Difficult routes with competitive elements',
    },
    model.TripType.barcrawl: {
      'name': 'Bar Crawl',
      'description': 'Social bar and pub adventures',
    },
    model.TripType.fitness: {
      'name': 'Fitness',
      'description': 'Physical exercise routes with tracking',
    },
  };

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _createTrip() {
    if (_tripTitle.isEmpty || _waypoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a title and at least one waypoint'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final trip = model.Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _tripTitle,
      waypoints: _waypoints,
      createdAt: DateTime.now(),
      completed: false,
      badgeEarned: false,
      coreType: _migrateTripTypeToCore(_selectedTripType),
      subMode: _getSubModeForType(_selectedTripType),
      ruleSetId: 'default',
      isPathStrict: false,
    );
    Navigator.of(context).pop(trip);
  }

  model.CoreType _migrateTripTypeToCore(model.TripType old) {
    switch (old) {
      case model.TripType.standard:
        return model.CoreType.explore;
      case model.TripType.barcrawl:
        return model.CoreType.crawl;
      case model.TripType.fitness:
        return model.CoreType.active;
      case model.TripType.challenge:
        return model.CoreType.game;
    }
  }

  String _getSubModeForType(model.TripType type) {
    switch (type) {
      case model.TripType.standard:
        return 'sightseeing';
      case model.TripType.barcrawl:
        return 'social';
      case model.TripType.fitness:
        return 'exercise';
      case model.TripType.challenge:
        return 'competitive';
    }
  }

  void _addSampleWaypoints() {
    setState(() {
      _waypoints.clear();
      switch (_selectedTripType) {
        case model.TripType.standard:
          _waypoints.addAll([
            model.Waypoint(
                name: 'Central Park',
                note: 'Start your exploration here',
                latitude: 40.7851,
                longitude: -73.9683),
            model.Waypoint(
                name: 'Museum District',
                note: 'Visit the local museum',
                latitude: 40.7794,
                longitude: -73.9632),
            model.Waypoint(
                name: 'Historic Square',
                note: 'Learn about local history',
                latitude: 40.7505,
                longitude: -73.9934),
          ]);
          break;
        case model.TripType.barcrawl:
          _waypoints.addAll([
            model.Waypoint(
                name: 'The Craft House',
                note: 'Great IPAs',
                latitude: 40.7505,
                longitude: -73.9934),
            model.Waypoint(
                name: 'Rooftop Lounge',
                note: 'City views',
                latitude: 40.7549,
                longitude: -73.9840),
            model.Waypoint(
                name: 'Local Pub',
                note: 'Traditional atmosphere',
                latitude: 40.7589,
                longitude: -73.9851),
          ]);
          break;
        case model.TripType.fitness:
          _waypoints.addAll([
            model.Waypoint(
                name: 'Running Track Start',
                note: 'Begin your fitness journey',
                latitude: 40.7851,
                longitude: -73.9683),
            model.Waypoint(
                name: 'Mile 1 Marker',
                note: 'First checkpoint',
                latitude: 40.7739,
                longitude: -73.9713),
            model.Waypoint(
                name: 'Finish Line',
                note: 'Complete your workout',
                latitude: 40.7794,
                longitude: -73.9632),
          ]);
          break;
        case model.TripType.challenge:
          _waypoints.addAll([
            model.Waypoint(
                name: 'Challenge Start',
                note: 'Begin the difficult route',
                latitude: 40.7282,
                longitude: -74.0776),
            model.Waypoint(
                name: 'Checkpoint 1',
                note: 'Halfway point',
                latitude: 40.7307,
                longitude: -74.0723),
            model.Waypoint(
                name: 'Challenge End',
                note: 'You made it!',
                latitude: 40.7341,
                longitude: -74.0675),
          ]);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Trip'),
        backgroundColor: AppColors.card,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            child: Row(
              children: List.generate(3, (index) {
                final active = index <= _currentStep;
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(right: index < 2 ? AppDimensions.spaceS : 0),
                    decoration: BoxDecoration(
                      color: active ? AppColors.amethyst600 : AppColors.stroke,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStepOne(),
                _buildStepTwo(),
                _buildStepThree(),
              ],
            ),
          ),

          // Navigation
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentStep == 2 ? _createTrip : _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.amethyst600,
                    ),
                    child: Text(_currentStep == 2 ? 'Create Trip' : 'Next'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STEP 1: scrollable
  Widget _buildStepOne() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trip Details', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimensions.spaceL),
          TextField(
            onChanged: (v) => setState(() => _tripTitle = v),
            decoration: const InputDecoration(
              labelText: 'Trip Title',
              hintText: 'Enter a memorable name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXL),
          Text('Select Trip Type', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimensions.spaceM),
          ...model.TripType.values.map((type) {
            final selected = type == _selectedTripType;
            final helper = TripTypeHelper.fromCoreType(_migrateTripTypeToCore(type));
            return Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
              child: InkWell(
                onTap: () => setState(() => _selectedTripType = type),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceM),
                  decoration: BoxDecoration(
                    color: selected ? helper.color.withOpacity(0.1) : AppColors.card,
                    border: Border.all(
                      color: selected ? helper.color : AppColors.stroke,
                      width: selected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Row(
                    children: [
                      Icon(helper.icon, color: helper.color, size: 24),
                      const SizedBox(width: AppDimensions.spaceM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_tripTypeInfo[type]!['name']!),
                            Text(
                              _tripTypeInfo[type]!['description']!,
                              style: TextStyle(color: AppColors.textSecond),
                            ),
                          ],
                        ),
                      ),
                      if (selected) Icon(Icons.check_circle, color: helper.color),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // STEP 2: uses Expanded for list
  Widget _buildStepTwo() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add Waypoints', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimensions.spaceM),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addSampleWaypoints,
              icon: const Icon(Icons.auto_fix_high),
              label: const Text('Add Sample Waypoints'),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          Expanded(
            child: _waypoints.isEmpty
                ? Center(child: Text('No waypoints yet.', style: TextStyle(color: AppColors.textSecond)))
                : ListView.builder(
                    itemCount: _waypoints.length,
                    itemBuilder: (_, i) {
                      final w = _waypoints[i];
                      final helper = TripTypeHelper.fromCoreType(_migrateTripTypeToCore(_selectedTripType));
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: helper.color,
                            child: Text('${i + 1}'),
                          ),
                          title: Text(w.name),
                          subtitle: Text(w.note),
                          trailing: IconButton(
                            onPressed: () => setState(() => _waypoints.removeAt(i)),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // STEP 3: scrollable
  Widget _buildStepThree() {
    final helper = TripTypeHelper.fromCoreType(_migrateTripTypeToCore(_selectedTripType));
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review & Create', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimensions.spaceL),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            decoration: BoxDecoration(
              color: helper.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_tripTitle.isEmpty ? 'Untitled Trip' : _tripTitle, style: AppTextStyles.cardTitle),
                const SizedBox(height: AppDimensions.spaceM),
                // with this:
..._waypoints
    .asMap()
    .entries
    .map((entry) {
      final i = entry.key;
      final w = entry.value;
      return Text('${i + 1}. ${w.name}');
    })
    .toList(),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXL),
        ],
      ),
    );
  }
}
