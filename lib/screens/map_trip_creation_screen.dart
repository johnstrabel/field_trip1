// lib/screens/map_trip_creation_screen.dart - Updated for 3-Type System

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
  model.CoreType _selectedCoreType = model.CoreType.explore; // UPDATED: Use CoreType
  final List<model.Waypoint> _waypoints = [];

  // UPDATED: Trip type descriptions for 3-type system
  final Map<model.CoreType, Map<String, String>> _tripTypeInfo = {
    model.CoreType.explore: {
      'name': 'Explore',
      'description': 'Traditional exploration and sightseeing adventures',
    },
    model.CoreType.crawl: {
      'name': 'Crawl',
      'description': 'Nightlife adventures: bars, beer golf, subway surfers',
    },
    model.CoreType.sport: {
      'name': 'Sport',
      'description': 'Fitness, time trials, golf, frisbee golf with scorecards',
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

    // UPDATED: Create trip with new CoreType system
    final trip = model.Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _tripTitle,
      waypoints: _waypoints,
      createdAt: DateTime.now(),
      completed: false,
      badgeEarned: false,
      coreType: _selectedCoreType,
      subMode: _getSubModeForType(_selectedCoreType),
      ruleSetId: 'default',
      isPathStrict: false,
    );
    Navigator.of(context).pop(trip);
  }

  String _getSubModeForType(model.CoreType type) {
    switch (type) {
      case model.CoreType.explore:
        return 'sightseeing';
      case model.CoreType.crawl:
        return 'social';
      case model.CoreType.sport:
        return 'fitness';
    }
  }

  void _addSampleWaypoints() {
    setState(() {
      _waypoints.clear();
      switch (_selectedCoreType) {
        case model.CoreType.explore:
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
        case model.CoreType.crawl:
          _waypoints.addAll([
            model.Waypoint(
                name: 'The Craft House',
                note: 'Hole 1: Great IPAs',
                latitude: 40.7505,
                longitude: -73.9934),
            model.Waypoint(
                name: 'Rooftop Lounge',
                note: 'Hole 2: City views',
                latitude: 40.7549,
                longitude: -73.9840),
            model.Waypoint(
                name: 'Underground Bar',
                note: 'Final hole: Victory drink',
                latitude: 40.7589,
                longitude: -73.9851),
          ]);
          break;
        case model.CoreType.sport:
          _waypoints.addAll([
            model.Waypoint(
                name: 'Tee 1',
                note: 'Drive across the meadow',
                latitude: 40.7851,
                longitude: -73.9683),
            model.Waypoint(
                name: 'Basket 3',
                note: 'Around the pond',
                latitude: 40.7739,
                longitude: -73.9713),
            model.Waypoint(
                name: 'Final Basket',
                note: 'Championship hole',
                latitude: 40.7794,
                longitude: -73.9632),
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
                      backgroundColor: TripTypeHelper.fromCoreType(_selectedCoreType).color,
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

  // STEP 1: Trip details and type selection
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
          
          // UPDATED: Show only 3 core types
          ...model.CoreType.values.map((type) {
            final selected = type == _selectedCoreType;
            final helper = TripTypeHelper.fromCoreType(type);
            final info = _tripTypeInfo[type]!;
            
            return Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
              child: InkWell(
                onTap: () => setState(() => _selectedCoreType = type),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
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
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceM),
                        decoration: BoxDecoration(
                          color: helper.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.spaceM),
                        ),
                        child: Icon(
                          helper.icon, 
                          color: helper.color, 
                          size: 24
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
                                color: selected ? helper.color : AppColors.textPrimary,
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
                      if (selected) 
                        Icon(
                          Icons.check_circle, 
                          color: helper.color, 
                          size: 24
                        ),
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

  // STEP 2: Waypoint management
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
              label: Text('Add Sample ${_tripTypeInfo[_selectedCoreType]!['name']} Waypoints'),
              style: OutlinedButton.styleFrom(
                foregroundColor: TripTypeHelper.fromCoreType(_selectedCoreType).color,
                side: BorderSide(
                  color: TripTypeHelper.fromCoreType(_selectedCoreType).color,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          
          Expanded(
            child: _waypoints.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_location_alt_outlined,
                          size: 64,
                          color: AppColors.textSecond,
                        ),
                        const SizedBox(height: AppDimensions.spaceM),
                        Text(
                          'No waypoints yet',
                          style: AppTextStyles.cardTitle.copyWith(
                            color: AppColors.textSecond,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceS),
                        Text(
                          'Add sample waypoints or create custom ones',
                          style: AppTextStyles.cardSubtitle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _waypoints.length,
                    itemBuilder: (_, i) {
                      final w = _waypoints[i];
                      final helper = TripTypeHelper.fromCoreType(_selectedCoreType);
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: helper.color,
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(w.name),
                          subtitle: Text(w.note.isEmpty ? 'No notes' : w.note),
                          trailing: IconButton(
                            onPressed: () => setState(() => _waypoints.removeAt(i)),
                            icon: const Icon(Icons.delete_outline, color: AppColors.error),
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

  // STEP 3: Review and create
  Widget _buildStepThree() {
    final helper = TripTypeHelper.fromCoreType(_selectedCoreType);
    final info = _tripTypeInfo[_selectedCoreType]!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review & Create', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimensions.spaceL),
          
          // Trip Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            decoration: BoxDecoration(
              color: helper.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: helper.color, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceS),
                      decoration: BoxDecoration(
                        color: helper.color,
                        borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                      ),
                      child: Icon(
                        helper.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _tripTitle.isEmpty ? 'Untitled Trip' : _tripTitle,
                            style: AppTextStyles.cardTitle.copyWith(
                              color: helper.color,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            info['name']!,
                            style: AppTextStyles.cardSubtitle.copyWith(
                              color: helper.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.spaceL),
                
                // Trip description
                Text(
                  info['description']!,
                  style: AppTextStyles.cardSubtitle,
                ),
                
                const SizedBox(height: AppDimensions.spaceL),
                
                // Waypoints preview
                Text(
                  'Waypoints (${_waypoints.length})',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                
                if (_waypoints.isEmpty)
                  Text(
                    'No waypoints added yet',
                    style: AppTextStyles.cardSubtitle.copyWith(
                      color: AppColors.error,
                    ),
                  )
                else
                  ..._waypoints.asMap().entries.map((entry) {
                    final i = entry.key;
                    final w = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.spaceXS),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: helper.color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceM),
                          Expanded(
                            child: Text(
                              w.name,
                              style: AppTextStyles.cardSubtitle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.spaceXL),
          
          // Additional info
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.info,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: Text(
                    'Your trip will be saved and available in the Explorer tab. You can start tracking when you\'re ready to begin your adventure!',
                    style: AppTextStyles.cardSubtitle.copyWith(
                      color: AppColors.info,
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