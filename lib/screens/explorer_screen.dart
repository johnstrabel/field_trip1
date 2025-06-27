// lib/screens/explorer_screen.dart - FIXED VERSION
// Fixed FilterChipRow property names and added Live Adventure

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';
import '../widgets/filter_chip_row.dart';
import 'map_trip_creation_screen.dart';
import 'trip_detail_screen.dart';
import 'live_tracking_screen.dart'; // Import for Live Adventure

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({Key? key}) : super(key: key);

  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Planned', 'In Progress', 'Completed'];

  Future<void> _createNewTrip(BuildContext context) async {
    final tripBox = Hive.box<model.Trip>('trips');
    final model.Trip? newTrip = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapTripCreationScreen()),
    );
    if (newTrip != null) {
      tripBox.put(newTrip.id, newTrip);
    }
  }

  // NEW: Start Live Adventure - immediate GPS tracking without planning
  Future<void> _startLiveAdventure() async {
    // Show adventure type selection dialog
    final selectedType = await showDialog<model.CoreType>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🚀 Start Live Adventure'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('What type of adventure are you starting?'),
            const SizedBox(height: 16),
            ...model.CoreType.values.map((type) {
              final helper = TripTypeHelper.fromCoreType(type);
              return Card(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: helper.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(helper.icon, color: helper.color),
                  ),
                  title: Text(helper.displayName),
                  subtitle: Text(_getTypeDescription(type)),
                  onTap: () => Navigator.pop(context, type),
                ),
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selectedType != null) {
      // Create a spontaneous trip for Live Adventure
      final liveTrip = model.Trip(
        id: 'live_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Live ${TripTypeHelper.fromCoreType(selectedType).displayName} Adventure',
        waypoints: [], // No pre-planned waypoints for live adventures
        createdAt: DateTime.now(),
        coreType: selectedType,
        subMode: 'live_adventure',
      );

      // Save the trip
      final tripBox = Hive.box<model.Trip>('trips');
      await tripBox.put(liveTrip.id, liveTrip);

      // Immediately start live tracking
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LiveTrackingScreen(trip: liveTrip),
        ),
      );
    }
  }

  String _getTypeDescription(model.CoreType type) {
    switch (type) {
      case model.CoreType.explore:
        return 'Discover new places and sights';
      case model.CoreType.crawl:
        return 'Nightlife and social adventures';
      case model.CoreType.sport:
        return 'Fitness and competitive activities';
    }
  }

  Future<void> _openTripDetail(BuildContext context, model.Trip trip) async {
    final badgeBox = Hive.box<model.Badge>('badges');
    final badge = badgeBox.values
        .where((b) => b.tripId == trip.id)
        .isNotEmpty 
        ? badgeBox.values.firstWhere((b) => b.tripId == trip.id)
        : null;
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TripDetailScreen(trip: trip, badge: badge),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Explorer'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Header with both action buttons
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan, track, and complete your adventures',
                  style: AppTextStyles.cardSubtitle,
                ),
                const SizedBox(height: AppDimensions.spaceL),
                
                // Action Buttons Row
                Row(
                  children: [
                    // Plan New Trip Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _createNewTrip(context),
                        icon: const Icon(Icons.add_location_alt),
                        label: const Text('Plan New Trip'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.amethyst600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceM),
                    // NEW: Live Adventure Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _startLiveAdventure,
                        icon: const Icon(Icons.play_circle, color: AppColors.success),
                        label: const Text(
                          'Live Adventure',
                          style: TextStyle(color: AppColors.success),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.success),
                          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.spaceM),
                
                // Info card explaining Live Adventure
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceM),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(color: AppColors.success.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.success,
                        size: 20,
                      ),
                      const SizedBox(width: AppDimensions.spaceM),
                      Expanded(
                        child: Text(
                          'Live Adventure: Start GPS tracking instantly for spontaneous exploration!',
                          style: AppTextStyles.cardSubtitle.copyWith(
                            color: AppColors.success,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // FIXED: Filter Row with correct property names
          FilterChipRow(
            items: _filterOptions,           // FIXED: Was 'options', now 'items'
            selected: _selectedFilter,       // FIXED: Was 'selectedOption', now 'selected'
            onSelect: (option) {             // FIXED: Was 'onOptionSelected', now 'onSelect'
              setState(() {
                _selectedFilter = option;
              });
            },
          ),
          
          const SizedBox(height: AppDimensions.spaceM),
          
          // Trip List
          Expanded(
            child: ValueListenableBuilder<Box<model.Trip>>(
              valueListenable: Hive.box<model.Trip>('trips').listenable(),
              builder: (context, box, child) {
                final trips = box.values.toList();
                final filteredTrips = _filterTrips(trips);
                
                if (filteredTrips.isEmpty) {
                  return _buildEmptyState();
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
                  itemCount: filteredTrips.length,
                  itemBuilder: (context, index) {
                    final trip = filteredTrips[index];
                    return _buildTripCard(trip);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<model.Trip> _filterTrips(List<model.Trip> trips) {
    if (_selectedFilter == 'All') return trips;
    
    return trips.where((trip) {
      switch (_selectedFilter) {
        case 'Planned':
          return !trip.completed;
        case 'In Progress':
          // For now, assume in progress means created recently but not completed
          return !trip.completed && 
                 DateTime.now().difference(trip.createdAt).inHours < 24;
        case 'Completed':
          return trip.completed;
        default:
          return true;
      }
    }).toList();
  }

  Widget _buildTripCard(model.Trip trip) {
    final typeHelper = TripTypeHelper.fromTrip(trip);
    final isLiveAdventure = trip.subMode == 'live_adventure';
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _openTripDetail(context, trip),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          child: Row(
            children: [
              // Trip Type Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: typeHelper.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(
                  typeHelper.icon,
                  color: typeHelper.color,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: AppDimensions.spaceL),
              
              // Trip Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          typeHelper.displayName,
                          style: AppTextStyles.caption.copyWith(
                            color: typeHelper.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceS),
                        Text(
                          '• ${trip.waypoints.length} waypoints',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(width: AppDimensions.spaceS),
                        if (isLiveAdventure)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Text(
                          '• ${trip.subMode}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceS),
                    Text(
                      trip.title,
                      style: AppTextStyles.cardTitle,
                    ),
                    Text(
                      _formatTripDate(trip.createdAt),
                      style: AppTextStyles.cardSubtitle,
                    ),
                  ],
                ),
              ),
              
              // Status indicator
              Column(
                children: [
                  if (trip.completed) ...[
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 24,
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      'Completed',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else if (isLiveAdventure) ...[
                    Icon(
                      Icons.play_circle,
                      color: AppColors.success,
                      size: 24,
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      'Ready',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else ...[
                    Icon(
                      Icons.radio_button_unchecked,
                      color: AppColors.textSecond,
                      size: 24,
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      'Planned',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecond,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  
                  if (trip.badgeEarned) ...[
                    const SizedBox(height: AppDimensions.spaceS),
                    Icon(
                      Icons.emoji_events,
                      color: AppColors.warning,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_selectedFilter != 'All') {
      return _buildNoFilterResultsState();
    }
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore,
              size: 64,
              color: AppColors.textSecond,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            Text(
              'Ready for Adventure?',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              'Create your first trip to start exploring! Choose from different adventure types and discover amazing places.',
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceXL),
            ElevatedButton.icon(
              onPressed: () => _createNewTrip(context),
              icon: const Icon(Icons.add_location),
              label: const Text('Create Your First Trip'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.amethyst600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceXL,
                  vertical: AppDimensions.spaceM,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            OutlinedButton.icon(
              onPressed: _startLiveAdventure,
              icon: const Icon(Icons.play_circle, color: AppColors.success),
              label: const Text(
                'Start Live Adventure',
                style: TextStyle(color: AppColors.success),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.success),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceXL,
                  vertical: AppDimensions.spaceM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoFilterResultsState() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: AppColors.textSecond,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              'No $_selectedFilter trips found',
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              _getFilterEmptyMessage(),
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'All';
                });
              },
              child: const Text('Show All Trips'),
            ),
          ],
        ),
      ),
    );
  }

  String _getFilterEmptyMessage() {
    switch (_selectedFilter) {
      case 'Planned':
        return 'You don\'t have any planned trips yet. Create a new trip to get started!';
      case 'In Progress':
        return 'No trips are currently in progress. Start a planned trip to begin tracking!';
      case 'Completed':
        return 'You haven\'t completed any trips yet. Finish your planned adventures to see them here!';
      default:
        return 'No trips found matching this filter.';
    }
  }

  String _formatTripDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}