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
  model.CoreType _selectedCoreType = model.CoreType.explore;
  String _selectedSubMode = 'standard';
  bool _isPathStrict = false;
  final List<model.Waypoint> _waypoints = [];
  
  // Sub-mode options for each core type
  final Map<model.CoreType, List<Map<String, String>>> _subModeOptions = {
    model.CoreType.explore: [
      {'id': 'sightseeing', 'name': 'Sightseeing', 'description': 'Casual exploration and discovery'},
      {'id': 'photography', 'name': 'Photography', 'description': 'Photo-focused adventure'},
      {'id': 'cultural', 'name': 'Cultural', 'description': 'Museums, galleries, and cultural sites'},
    ],
    model.CoreType.crawl: [
      {'id': 'social', 'name': 'Social Crawl', 'description': 'Casual bar/pub hopping'},
      {'id': 'beer_golf', 'name': 'Beer Golf', 'description': 'Competitive drinking game with scoring'},
      {'id': 'themed', 'name': 'Themed Crawl', 'description': 'Specific theme (craft beer, cocktails, etc.)'},
    ],
    model.CoreType.active: [
      {'id': 'running', 'name': 'Running', 'description': 'Jogging or running route'},
      {'id': 'cycling', 'name': 'Cycling', 'description': 'Bike route adventure'},
      {'id': 'hiking', 'name': 'Hiking', 'description': 'Walking or hiking trail'},
      {'id': 'time_trial', 'name': 'Time Trial', 'description': 'Timed competitive run'},
    ],
    model.CoreType.game: [
      {'id': 'disc_golf', 'name': 'Disc Golf', 'description': 'Disc golf course with scoring'},
      {'id': 'scavenger_hunt', 'name': 'Scavenger Hunt', 'description': 'Find specific items or locations'},
      {'id': 'quiz_trail', 'name': 'Quiz Trail', 'description': 'Answer questions at each location'},
    ],
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
        waypoints: _waypoints,
        createdAt: DateTime.now(),
        coreType: _selectedCoreType,
        subMode: _selectedSubMode,
        ruleSetId: _getDefaultRuleSetId(),
        isPathStrict: _isPathStrict,
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

  String _getDefaultRuleSetId() {
    switch (_selectedCoreType) {
      case model.CoreType.game:
        return 'standard_${_selectedSubMode}';
      case model.CoreType.crawl:
        return _selectedSubMode == 'beer_golf' ? 'beer_golf_standard' : 'default';
      case model.CoreType.active:
        return _selectedSubMode == 'time_trial' ? 'time_trial_standard' : 'default';
      default:
        return 'default';
    }
  }

  void _addSampleWaypoints() {
    setState(() {
      _waypoints.clear();
      
      switch (_selectedCoreType) {
        case model.CoreType.explore:
          _waypoints.addAll([
            model.Waypoint(name: 'Central Park', note: 'Start your exploration here', latitude: 40.7851, longitude: -73.9683),
            model.Waypoint(name: 'Museum District', note: 'Visit the local museum', latitude: 40.7794, longitude: -73.9632),
            model.Waypoint(name: 'Historic Square', note: 'Learn about local history', latitude: 40.7505, longitude: -73.9934),
          ]);
          break;
        case model.CoreType.crawl:
          _waypoints.addAll([
            model.Waypoint(name: 'The Craft House', note: 'Start with craft beer', latitude: 40.7505, longitude: -73.9934),
            model.Waypoint(name: 'Rooftop Lounge', note: 'Enjoy city views', latitude: 40.7549, longitude: -73.9840),
            model.Waypoint(name: 'Local Pub', note: 'Traditional atmosphere', latitude: 40.7589, longitude: -73.9851),
          ]);
          break;
        case model.CoreType.active:
          _waypoints.addAll([
            model.Waypoint(name: 'Running Track Start', note: 'Begin your fitness journey', latitude: 40.7851, longitude: -73.9683),
            model.Waypoint(name: 'Mile 1 Marker', note: 'First checkpoint', latitude: 40.7739, longitude: -73.9713),
            model.Waypoint(name: 'Finish Line', note: 'Complete your workout', latitude: 40.7794, longitude: -73.9632),
          ]);
          break;
        case model.CoreType.game:
          _waypoints.addAll([
            model.Waypoint(name: 'Hole 1', note: 'Par 3 - Watch the trees', latitude: 40.7282, longitude: -74.0776),
            model.Waypoint(name: 'Hole 2', note: 'Par 4 - Uphill challenge', latitude: 40.7307, longitude: -74.0723),
            model.Waypoint(name: 'Hole 3', note: 'Par 3 - Final hole', latitude: 40.7341, longitude: -74.0675),
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
          if (_currentStep > 0)
            TextButton(
              onPressed: _previousStep,
              child: const Text('Back'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),
          
          // Content
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
          
          // Bottom Navigation
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Row(
        children: [
          for (int i = 0; i < 3; i++) ...[
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: i <= _currentStep ? AppColors.amethyst600 : AppColors.stroke,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (i < 2) const SizedBox(width: AppDimensions.spaceS),
          ],
        ],
      ),
    );
  }

  Widget _buildStepOne() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Adventure Type',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            'Select the type of adventure you want to create',
            style: AppTextStyles.cardSubtitle,
          ),
          const SizedBox(height: AppDimensions.spaceXL),
          
          // Core Type Selection
          Column(
            children: model.CoreType.values.map((coreType) {
              final helper = TripTypeHelper.fromCoreType(coreType);
              final isSelected = _selectedCoreType == coreType;
              
              return Container(
                margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCoreType = coreType;
                      _selectedSubMode = _subModeOptions[coreType]!.first['id']!;
                    });
                  },
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceL),
                    decoration: BoxDecoration(
                      color: isSelected ? helper.color.withOpacity(0.1) : AppColors.card,
                      border: Border.all(
                        color: isSelected ? helper.color : AppColors.stroke,
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
                            color: helper.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
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
                                helper.displayName,
                                style: AppTextStyles.cardTitle,
                              ),
                              const SizedBox(height: AppDimensions.spaceXS),
                              Text(
                                _getCoreTypeDescription(coreType),
                                style: AppTextStyles.cardSubtitle,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: helper.color,
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

  String _getCoreTypeDescription(model.CoreType coreType) {
    switch (coreType) {
      case model.CoreType.explore:
        return 'Casual discovery and sightseeing adventures with XP rewards and badges';
      case model.CoreType.crawl:
        return 'Social bar and pub adventures with optional drinking games and scoring';
      case model.CoreType.active:
        return 'Physical exercise routes: running, biking, hiking with time and distance tracking';
      case model.CoreType.game:
        return 'Structured point-based games like disc golf with competitive scorecards';
    }
  }

  Widget _buildStepTwo() {
    final subModes = _subModeOptions[_selectedCoreType]!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configure ${TripTypeHelper.fromCoreType(_selectedCoreType).displayName} Trip',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          
          // Trip Title
          Text(
            'Trip Title',
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: AppDimensions.spaceS),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Enter a memorable trip name...',
            ),
            onChanged: (value) {
              setState(() {
                _tripTitle = value;
              });
            },
          ),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          // Sub-mode Selection
          Text(
            'Adventure Style',
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          
          Column(
            children: subModes.map((subMode) {
              final isSelected = _selectedSubMode == subMode['id'];
              final helper = TripTypeHelper.fromCoreType(_selectedCoreType);
              
              return Container(
                margin: const EdgeInsets.only(bottom: AppDimensions.spaceS),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedSubMode = subMode['id']!;
                    });
                  },
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceM),
                    decoration: BoxDecoration(
                      color: isSelected ? helper.color.withOpacity(0.1) : AppColors.card,
                      border: Border.all(
                        color: isSelected ? helper.color : AppColors.stroke,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subMode['name']!,
                                style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                              ),
                              const SizedBox(height: AppDimensions.spaceXS),
                              Text(
                                subMode['description']!,
                                style: AppTextStyles.cardSubtitle,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: helper.color,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          // Path Strictness (for Active trips)
          if (_selectedCoreType == model.CoreType.active) ...[
            const SizedBox(height: AppDimensions.spaceL),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceM),
              decoration: BoxDecoration(
                color: AppColors.card,
                border: Border.all(color: AppColors.stroke),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.route,
                    color: TripTypeHelper.fromCoreType(_selectedCoreType).color,
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Strict Path Following',
                          style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                        ),
                        Text(
                          'Require users to follow the exact route order',
                          style: AppTextStyles.cardSubtitle,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isPathStrict,
                    onChanged: (value) {
                      setState(() {
                        _isPathStrict = value;
                      });
                    },
                    activeColor: TripTypeHelper.fromCoreType(_selectedCoreType).color,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepThree() {
    return SingleChildScrollView(
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
            'Add locations for your ${TripTypeHelper.fromCoreType(_selectedCoreType).displayName.toLowerCase()} adventure',
            style: AppTextStyles.cardSubtitle,
          ),
          const SizedBox(height: AppDimensions.spaceL),
          
          // Quick Sample Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addSampleWaypoints,
              icon: const Icon(Icons.auto_awesome),
              label: Text('Add Sample ${TripTypeHelper.fromCoreType(_selectedCoreType).displayName} Waypoints'),
            ),
          ),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          // Waypoints List
          if (_waypoints.isNotEmpty) ...[
            Text(
              'Waypoints (${_waypoints.length})',
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Column(
              children: _waypoints.asMap().entries.map((entry) {
                final index = entry.key;
                final waypoint = entry.value;
                final helper = TripTypeHelper.fromCoreType(_selectedCoreType);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: AppDimensions.spaceS),
                  padding: const EdgeInsets.all(AppDimensions.spaceM),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    border: Border.all(color: helper.color.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: helper.color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              waypoint.name,
                              style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                            ),
                            if (waypoint.note.isNotEmpty) ...[
                              const SizedBox(height: AppDimensions.spaceXS),
                              Text(
                                waypoint.note,
                                style: AppTextStyles.cardSubtitle,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceXL),
              decoration: BoxDecoration(
                color: AppColors.card,
                border: Border.all(color: AppColors.stroke, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 48,
                    color: AppColors.textSecond,
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  Text(
                    'No waypoints added yet',
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: AppDimensions.spaceS),
                  Text(
                    'Add waypoints to create your trip route',
                    style: AppTextStyles.cardSubtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Previous'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep == 2 ? _createTrip : _nextStep,
              child: Text(_currentStep == 2 ? 'Create Trip' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}