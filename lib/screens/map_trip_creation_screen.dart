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
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _createTrip() {
    if (_tripTitle.isNotEmpty && _waypoints.isNotEmpty) {
      final trip = model.Trip(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _tripTitle,
        oldType: _selectedTripType,
        waypoints: _waypoints,
        createdAt: DateTime.now(),
        completed: false,
        badgeEarned: false,
        coreType: _convertTripTypeToCore(_selectedTripType),
      );
      
      Navigator.of(context).pop(trip);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a title and at least one waypoint'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // Helper method to convert old TripType to new CoreType
  model.CoreType _convertTripTypeToCore(model.TripType oldType) {
    switch (oldType) {
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

  void _addSampleWaypoints() {
    setState(() {
      _waypoints.clear();
      
      switch (_selectedTripType) {
        case model.TripType.standard:
          _waypoints.addAll([
            model.Waypoint(name: 'Central Park', note: 'Start your exploration here', latitude: 40.7851, longitude: -73.9683),
            model.Waypoint(name: 'Museum District', note: 'Visit the local museum', latitude: 40.7794, longitude: -73.9632),
            model.Waypoint(name: 'Historic Square', note: 'Learn about local history', latitude: 40.7505, longitude: -73.9934),
          ]);
          break;
        case model.TripType.barcrawl:
          _waypoints.addAll([
            model.Waypoint(name: 'The Craft House', note: 'Start with craft beer', latitude: 40.7505, longitude: -73.9934),
            model.Waypoint(name: 'Rooftop Lounge', note: 'Enjoy city views', latitude: 40.7549, longitude: -73.9840),
            model.Waypoint(name: 'Local Pub', note: 'Traditional atmosphere', latitude: 40.7589, longitude: -73.9851),
          ]);
          break;
        case model.TripType.fitness:
          _waypoints.addAll([
            model.Waypoint(name: 'Running Track Start', note: 'Begin your fitness journey', latitude: 40.7851, longitude: -73.9683),
            model.Waypoint(name: 'Mile 1 Marker', note: 'First checkpoint', latitude: 40.7739, longitude: -73.9713),
            model.Waypoint(name: 'Finish Line', note: 'Complete your workout', latitude: 40.7794, longitude: -73.9632),
          ]);
          break;
        case model.TripType.challenge:
          _waypoints.addAll([
            model.Waypoint(name: 'Challenge Start', note: 'Begin the difficult route', latitude: 40.7282, longitude: -74.0776),
            model.Waypoint(name: 'Checkpoint 1', note: 'Halfway point', latitude: 40.7307, longitude: -74.0723),
            model.Waypoint(name: 'Challenge End', note: 'You made it!', latitude: 40.7341, longitude: -74.0675),
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
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            child: Row(
              children: List.generate(3, (index) {
                final isActive = index <= _currentStep;
                final isCompleted = index < _currentStep;
                
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(
                      right: index < 2 ? AppDimensions.spaceS : 0,
                    ),
                    decoration: BoxDecoration(
                      color: isActive 
                          ? AppColors.amethyst600 
                          : AppColors.stroke,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // Page Content
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
          
          // Navigation Buttons
          Container(
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
                      foregroundColor: Colors.white,
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

  Widget _buildStepOne() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Details',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceL),
          
          // Trip Title Input
          TextField(
            onChanged: (value) => setState(() => _tripTitle = value),
            decoration: const InputDecoration(
              labelText: 'Trip Title',
              hintText: 'Enter a memorable name for your trip',
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: AppDimensions.spaceXL),
          
          // Trip Type Selection
          Text(
            'Select Trip Type',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          
          Column(
            children: model.TripType.values.map((tripType) {
              final isSelected = tripType == _selectedTripType;
              final typeHelper = TripTypeHelper.fromType(tripType);
              
              return Container(
                margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedTripType = tripType;
                    });
                  },
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceM),
                    decoration: BoxDecoration(
                      color: isSelected ? typeHelper.color.withOpacity(0.1) : AppColors.card,
                      border: Border.all(
                        color: isSelected ? typeHelper.color : AppColors.stroke,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: typeHelper.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          ),
                          child: Icon(
                            typeHelper.icon,
                            color: typeHelper.color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _tripTypeInfo[tripType]!['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.spaceXS),
                              Text(
                                _tripTypeInfo[tripType]!['description']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecond,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: typeHelper.color,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTwo() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Waypoints',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          
          Text(
            'Add locations you want to visit during your trip.',
            style: TextStyle(
              color: AppColors.textSecond,
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          // Sample Waypoints Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addSampleWaypoints,
              icon: const Icon(Icons.auto_fix_high),
              label: const Text('Add Sample Waypoints'),
            ),
          ),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          // Waypoints List
          Expanded(
            child: _waypoints.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 64,
                          color: AppColors.textSecond,
                        ),
                        const SizedBox(height: AppDimensions.spaceM),
                        Text(
                          'No waypoints added yet',
                          style: TextStyle(
                            color: AppColors.textSecond,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceS),
                        Text(
                          'Add sample waypoints to get started',
                          style: TextStyle(
                            color: AppColors.textSecond,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _waypoints.length,
                    itemBuilder: (context, index) {
                      final waypoint = _waypoints[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: TripTypeHelper.fromType(_selectedTripType).color,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(waypoint.name),
                          subtitle: Text(waypoint.note),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              setState(() {
                                _waypoints.removeAt(index);
                              });
                            },
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

  Widget _buildStepThree() {
    final typeHelper = TripTypeHelper.fromType(_selectedTripType);
    
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Create',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceL),
          
          // Trip Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            decoration: BoxDecoration(
              color: typeHelper.color.withOpacity(0.1),
              border: Border.all(color: typeHelper.color.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      typeHelper.icon,
                      color: typeHelper.color,
                      size: 32,
                    ),
                    const SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _tripTitle.isEmpty ? 'Untitled Trip' : _tripTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _tripTypeInfo[_selectedTripType]!['name']!,
                            style: TextStyle(
                              color: typeHelper.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.spaceL),
                
                Text(
                  'Waypoints (${_waypoints.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                
                const SizedBox(height: AppDimensions.spaceS),
                
                ..._waypoints.asMap().entries.map((entry) {
                  final index = entry.key;
                  final waypoint = entry.value;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.spaceXS),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}.',
                          style: TextStyle(
                            color: typeHelper.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceS),
                        Expanded(
                          child: Text(waypoint.name),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Final Instructions
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceM),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.info,
                ),
                const SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: Text(
                    'Ready to create your trip! You can start tracking and earn badges by completing waypoints.',
                    style: TextStyle(
                      color: AppColors.info,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}