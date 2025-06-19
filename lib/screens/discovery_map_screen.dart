// lib/screens/discovery_map_screen.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class DiscoveryMapScreen extends StatefulWidget {
  const DiscoveryMapScreen({Key? key}) : super(key: key);

  @override
  _DiscoveryMapScreenState createState() => _DiscoveryMapScreenState();
}

class _DiscoveryMapScreenState extends State<DiscoveryMapScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _filterController;
  
  String _selectedFilter = 'All';
  bool _showFriends = true;
  bool _showHotspots = true;
  bool _showTrips = true;
  bool _isFilterExpanded = false;
  
  final List<String> _filterOptions = ['All', 'Standard', 'Challenge', 'Barcrawl', 'Fitness'];

  // Mock map data - replace with real data later
  final List<MapLocation> _mapLocations = [
    MapLocation(
      id: '1',
      type: MapLocationType.friend,
      title: 'Alex Chen',
      subtitle: 'Currently exploring downtown',
      latitude: 40.7589,
      longitude: -73.9851,
      friendData: FriendMapData(
        avatar: Icons.person,
        isOnline: true,
        currentActivity: 'Urban Walk',
        timeStarted: DateTime.now().subtract(const Duration(minutes: 23)),
      ),
    ),
    MapLocation(
      id: '2',
      type: MapLocationType.hotspot,
      title: 'Central Park Loop',
      subtitle: '12 explorers visited today',
      latitude: 40.7829,
      longitude: -73.9654,
      hotspotData: HotspotData(
        visitorsToday: 12,
        averageRating: 4.8,
        popularTimes: '9AM - 6PM',
        category: 'Nature',
      ),
    ),
    MapLocation(
      id: '3',
      type: MapLocationType.trip,
      title: 'Historic District Tour',
      subtitle: 'Shared by Maya • 2.3km',
      latitude: 40.7505,
      longitude: -73.9934,
      tripData: TripMapData(
        authorName: 'Maya Rodriguez',
        authorAvatar: Icons.person_2,
        distance: '2.3 km',
        duration: '45 min',
        difficulty: 'Easy',
        tripType: 'Standard',
        completedBy: 8,
      ),
    ),
    MapLocation(
      id: '4',
      type: MapLocationType.friend,
      title: 'Sam Johnson',
      subtitle: 'Completed Brooklyn Bridge walk',
      latitude: 40.7061,
      longitude: -73.9969,
      friendData: FriendMapData(
        avatar: Icons.person_3,
        isOnline: false,
        currentActivity: 'Brooklyn Bridge Walk',
        timeStarted: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ),
    MapLocation(
      id: '5',
      type: MapLocationType.hotspot,
      title: 'High Line Trail',
      subtitle: '8 explorers visited today',
      latitude: 40.7480,
      longitude: -74.0048,
      hotspotData: HotspotData(
        visitorsToday: 8,
        averageRating: 4.6,
        popularTimes: '10AM - 8PM',
        category: 'Urban',
      ),
    ),
    MapLocation(
      id: '6',
      type: MapLocationType.trip,
      title: 'Riverside Challenge',
      subtitle: 'Shared by Alex • 5.1km',
      latitude: 40.8176,
      longitude: -73.9482,
      tripData: TripMapData(
        authorName: 'Alex Chen',
        authorAvatar: Icons.person,
        distance: '5.1 km',
        duration: '1h 20m',
        difficulty: 'Moderate',
        tripType: 'Challenge',
        completedBy: 15,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _filterController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Map Container (Placeholder)
          _buildMapContainer(),
          
          // Top Controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              child: Column(
                children: [
                  // Header with Back Button and Title
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceM),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spaceL,
                            vertical: AppDimensions.spaceM,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.explore,
                                color: AppColors.amethyst600,
                                size: 20,
                              ),
                              const SizedBox(width: AppDimensions.spaceS),
                              Text(
                                'Discovery Map',
                                style: AppTextStyles.cardTitle.copyWith(
                                  color: AppColors.amethyst600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.spaceS,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                                ),
                                child: Text(
                                  '${_getVisibleLocationsCount()} nearby',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppDimensions.spaceM),
                  
                  // Filter Controls
                  _buildFilterControls(),
                ],
              ),
            ),
          ),
          
          // Bottom Sheet for Location Details
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.1,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusXL),
                    topRight: Radius.circular(AppDimensions.radiusXL),
                  ),
                ),
                child: Column(
                  children: [
                    // Drag Handle
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.stroke,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    // Content
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(AppDimensions.spaceL),
                        children: [
                          // Quick Stats
                          Row(
                            children: [
                              Expanded(
                                child: _QuickStatCard(
                                  icon: Icons.people,
                                  title: 'Friends Nearby',
                                  value: '${_mapLocations.where((l) => l.type == MapLocationType.friend).length}',
                                  color: AppColors.success,
                                ),
                              ),
                              const SizedBox(width: AppDimensions.spaceM),
                              Expanded(
                                child: _QuickStatCard(
                                  icon: Icons.local_fire_department,
                                  title: 'Hotspots',
                                  value: '${_mapLocations.where((l) => l.type == MapLocationType.hotspot).length}',
                                  color: AppColors.challengeCrimson,
                                ),
                              ),
                              const SizedBox(width: AppDimensions.spaceM),
                              Expanded(
                                child: _QuickStatCard(
                                  icon: Icons.map,
                                  title: 'Shared Trips',
                                  value: '${_mapLocations.where((l) => l.type == MapLocationType.trip).length}',
                                  color: AppColors.info,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: AppDimensions.spaceL),
                          
                          // Nearby Locations List
                          Text(
                            'Nearby Locations',
                            style: AppTextStyles.sectionTitle,
                          ),
                          const SizedBox(height: AppDimensions.spaceM),
                          
                          ..._getFilteredLocations().map((location) {
                            return _LocationCard(
                              location: location,
                              onTap: () => _showLocationDetails(location),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Floating Action Button for My Location
          Positioned(
            bottom: 100,
            right: 20,
            child: FloatingActionButton(
              onPressed: _centerOnMyLocation,
              backgroundColor: AppColors.amethyst600,
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapContainer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade100,
            Colors.green.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Grid lines to simulate map
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: _MapGridPainter(),
          ),
          
          // Location Markers
          ..._getFilteredLocations().map((location) {
            return _buildLocationMarker(location);
          }).toList(),
          
          // User's current location
          Positioned(
            left: MediaQuery.of(context).size.width * 0.5 - 12,
            top: MediaQuery.of(context).size.height * 0.6 - 12,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pulse effect
                    Container(
                      width: 24 + (_pulseController.value * 20),
                      height: 24 + (_pulseController.value * 20),
                      decoration: BoxDecoration(
                        color: AppColors.amethyst600.withOpacity(0.3 - (_pulseController.value * 0.3)),
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Main dot
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.amethyst600,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControls() {
    return Column(
      children: [
        // Main Filter Row
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceM),
                  child: Row(
                    children: _filterOptions.map((filter) {
                      final isSelected = filter == _selectedFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: AppDimensions.spaceS),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(filter),
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          backgroundColor: Colors.transparent,
                          selectedColor: AppColors.amethyst100,
                          checkmarkColor: AppColors.amethyst600,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.amethyst600 : AppColors.textSecond,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 12,
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceM),
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _toggleFilterExpansion,
                icon: Icon(
                  _isFilterExpanded ? Icons.expand_less : Icons.tune,
                  color: AppColors.amethyst600,
                ),
              ),
            ),
          ],
        ),
        
        // Expanded Filter Options
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: _isFilterExpanded ? _buildExpandedFilters() : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildExpandedFilters() {
    return Container(
      margin: const EdgeInsets.only(top: AppDimensions.spaceM),
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Show on Map',
            style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
          ),
          const SizedBox(height: AppDimensions.spaceM),
          
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Friends', style: TextStyle(fontSize: 12)),
                  value: _showFriends,
                  onChanged: (value) {
                    setState(() {
                      _showFriends = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.amethyst600,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Hotspots', style: TextStyle(fontSize: 12)),
                  value: _showHotspots,
                  onChanged: (value) {
                    setState(() {
                      _showHotspots = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.amethyst600,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Trips', style: TextStyle(fontSize: 12)),
                  value: _showTrips,
                  onChanged: (value) {
                    setState(() {
                      _showTrips = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.amethyst600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMarker(MapLocation location) {
    // Calculate position based on lat/lng (simplified for demo)
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Simple projection (not accurate, just for demo)
    final x = ((location.longitude + 74.0) * 1000) % screenWidth;
    final y = ((40.8 - location.latitude) * 1500) % (screenHeight - 200);
    
    return Positioned(
      left: x - 12,
      top: y + 100, // Account for header
      child: GestureDetector(
        onTap: () => _showLocationDetails(location),
        child: _MarkerWidget(location: location),
      ),
    );
  }

  List<MapLocation> _getFilteredLocations() {
    return _mapLocations.where((location) {
      // Type filter
      bool typeVisible = true;
      if (!_showFriends && location.type == MapLocationType.friend) typeVisible = false;
      if (!_showHotspots && location.type == MapLocationType.hotspot) typeVisible = false;
      if (!_showTrips && location.type == MapLocationType.trip) typeVisible = false;
      
      // Category filter
      bool categoryMatch = _selectedFilter == 'All';
      if (!categoryMatch && location.type == MapLocationType.trip) {
        categoryMatch = location.tripData?.tripType.toLowerCase() == _selectedFilter.toLowerCase();
      }
      
      return typeVisible && categoryMatch;
    }).toList();
  }

  int _getVisibleLocationsCount() {
    return _getFilteredLocations().length;
  }

  void _toggleFilterExpansion() {
    setState(() {
      _isFilterExpanded = !_isFilterExpanded;
    });
    
    if (_isFilterExpanded) {
      _filterController.forward();
    } else {
      _filterController.reverse();
    }
  }

  void _showLocationDetails(MapLocation location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationDetailsSheet(location: location),
    );
  }

  void _centerOnMyLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Centered on your location'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

// Helper Widgets
class _MarkerWidget extends StatelessWidget {
  final MapLocation location;

  const _MarkerWidget({required this.location});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    
    switch (location.type) {
      case MapLocationType.friend:
        color = AppColors.success;
        icon = Icons.person;
        break;
      case MapLocationType.hotspot:
        color = AppColors.challengeCrimson;
        icon = Icons.local_fire_department;
        break;
      case MapLocationType.trip:
        color = AppColors.info;
        icon = Icons.map;
        break;
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 14,
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _QuickStatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppDimensions.spaceXS),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final MapLocation location;
  final VoidCallback onTap;

  const _LocationCard({required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    
    switch (location.type) {
      case MapLocationType.friend:
        color = AppColors.success;
        icon = Icons.person;
        break;
      case MapLocationType.hotspot:
        color = AppColors.challengeCrimson;
        icon = Icons.local_fire_department;
        break;
      case MapLocationType.trip:
        color = AppColors.info;
        icon = Icons.map;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.spaceM),
        leading: Container(
          padding: const EdgeInsets.all(AppDimensions.spaceS),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.spaceS),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(location.title, style: AppTextStyles.cardTitle),
        subtitle: Text(location.subtitle, style: AppTextStyles.cardSubtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _LocationDetailsSheet extends StatelessWidget {
  final MapLocation location;

  const _LocationDetailsSheet({required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXL),
          topRight: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.stroke,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.title,
                    style: AppTextStyles.sectionTitle,
                  ),
                  Text(
                    location.subtitle,
                    style: AppTextStyles.cardSubtitle,
                  ),
                  
                  const SizedBox(height: AppDimensions.spaceL),
                  
                  // Type-specific content
                  if (location.type == MapLocationType.friend)
                    _buildFriendDetails(location.friendData!),
                  if (location.type == MapLocationType.hotspot)
                    _buildHotspotDetails(location.hotspotData!),
                  if (location.type == MapLocationType.trip)
                    _buildTripDetails(location.tripData!),
                  
                  const Spacer(),
                  
                  // Action Buttons
                  _buildActionButtons(context, location),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendDetails(FriendMapData friendData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.amethyst100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                friendData.avatar,
                color: AppColors.amethyst600,
                size: 30,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friendData.currentActivity,
                    style: AppTextStyles.cardTitle,
                  ),
                  Text(
                    friendData.isOnline ? 'Active now' : 'Completed ${_formatTime(friendData.timeStarted)}',
                    style: AppTextStyles.cardSubtitle.copyWith(
                      color: friendData.isOnline ? AppColors.success : AppColors.textSecond,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHotspotDetails(HotspotData hotspotData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _DetailItem(
              icon: Icons.people,
              title: 'Visitors Today',
              value: '${hotspotData.visitorsToday}',
            ),
            _DetailItem(
              icon: Icons.star,
              title: 'Rating',
              value: '${hotspotData.averageRating}',
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceM),
        _DetailItem(
          icon: Icons.access_time,
          title: 'Popular Times',
          value: hotspotData.popularTimes,
        ),
        _DetailItem(
          icon: Icons.category,
          title: 'Category',
          value: hotspotData.category,
        ),
      ],
    );
  }

  Widget _buildTripDetails(TripMapData tripData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.amethyst100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                tripData.authorAvatar,
                color: AppColors.amethyst600,
                size: 24,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Created by ${tripData.authorName}',
                    style: AppTextStyles.cardTitle,
                  ),
                  Text(
                    '${tripData.completedBy} people completed this trip',
                    style: AppTextStyles.cardSubtitle,
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppDimensions.spaceL),
        
        Row(
          children: [
            _DetailItem(
              icon: Icons.straighten,
              title: 'Distance',
              value: tripData.distance,
            ),
            _DetailItem(
              icon: Icons.access_time,
              title: 'Duration',
              value: tripData.duration,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceM),
        Row(
          children: [
            _DetailItem(
              icon: Icons.signal_cellular_alt,
              title: 'Difficulty',
              value: tripData.difficulty,
            ),
            _DetailItem(
              icon: Icons.category,
              title: 'Type',
              value: tripData.tripType,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, MapLocation location) {
    return Row(
      children: [
        if (location.type == MapLocationType.friend) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening chat with ${location.title}...')),
                );
              },
              icon: const Icon(Icons.message),
              label: const Text('Message'),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Challenging ${location.title}...')),
                );
              },
              icon: const Icon(Icons.emoji_events),
              label: const Text('Challenge'),
            ),
          ),
        ] else if (location.type == MapLocationType.trip) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copying trip to your collection...')),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy Trip'),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Starting navigation...')),
                );
              },
              icon: const Icon(Icons.navigation),
              label: const Text('Navigate'),
            ),
          ),
        ] else ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Getting directions...')),
                );
              },
              icon: const Icon(Icons.directions),
              label: const Text('Get Directions'),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to favorites!')),
                );
              },
              icon: const Icon(Icons.favorite),
              label: const Text('Favorite'),
            ),
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecond),
          const SizedBox(width: AppDimensions.spaceXS),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.cardSubtitle),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    // Draw grid lines
    const spacing = 50.0;
    
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Data Models
enum MapLocationType { friend, hotspot, trip }

class MapLocation {
  final String id;
  final MapLocationType type;
  final String title;
  final String subtitle;
  final double latitude;
  final double longitude;
  final FriendMapData? friendData;
  final HotspotData? hotspotData;
  final TripMapData? tripData;

  MapLocation({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.latitude,
    required this.longitude,
    this.friendData,
    this.hotspotData,
    this.tripData,
  });
}

class FriendMapData {
  final IconData avatar;
  final bool isOnline;
  final String currentActivity;
  final DateTime timeStarted;

  FriendMapData({
    required this.avatar,
    required this.isOnline,
    required this.currentActivity,
    required this.timeStarted,
  });
}

class HotspotData {
  final int visitorsToday;
  final double averageRating;
  final String popularTimes;
  final String category;

  HotspotData({
    required this.visitorsToday,
    required this.averageRating,
    required this.popularTimes,
    required this.category,
  });
}

class TripMapData {
  final String authorName;
  final IconData authorAvatar;
  final String distance;
  final String duration;
  final String difficulty;
  final String tripType;
  final int completedBy;

  TripMapData({
    required this.authorName,
    required this.authorAvatar,
    required this.distance,
    required this.duration,
    required this.difficulty,
    required this.tripType,
    required this.completedBy,
  });
}