// lib/screens/explorer_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';
import '../widgets/filter_chip_row.dart';
import 'map_trip_creation_screen.dart';
import 'trip_detail_screen.dart';

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

  Future<void> _startLiveAdventure() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live Adventure mode coming soon! Use "Plan New Trip" for now.'),
        backgroundColor: AppColors.gameCrimson,
      ),
    );
  }

  Future<void> _openTripDetail(BuildContext context, model.Trip trip) async {
    final badgeBox = Hive.box<model.Badge>('badges');
    final badge = badgeBox.values
        .where((b) => b.tripId == trip.id)
        .isNotEmpty 
        ? badgeBox.values.where((b) => b.tripId == trip.id).first 
        : null;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TripDetailScreen(trip: trip, badge: badge),
      ),
    );
  }

  List<model.Trip> _filterTrips(List<model.Trip> trips) {
    switch (_selectedFilter) {
      case 'Planned':
        return trips.where((trip) => !trip.completed).toList();
      case 'In Progress':
        return []; // TODO: Implement in-progress tracking
      case 'Completed':
        return trips.where((trip) => trip.completed).toList();
      default:
        return trips;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Quick Actions
            _buildHeader(),
            
            // Filter Section
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceL,
                vertical: AppDimensions.spaceM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Adventures',
                    style: AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  FilterChipRow(
                    items: _filterOptions,
                    selected: _selectedFilter,
                    onSelect: (selected) {
                      setState(() {
                        _selectedFilter = selected;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            // Trip List
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<model.Trip>('trips').listenable(),
                builder: (context, Box<model.Trip> box, _) {
                  final trips = box.values.toList()
                    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  final filteredTrips = _filterTrips(trips);
                  
                  if (trips.isEmpty) {
                    return _buildEmptyState();
                  }
                  
                  if (filteredTrips.isEmpty && _selectedFilter != 'All') {
                    return _buildNoFilterResultsState();
                  }
                  
                  return _buildTripList(filteredTrips);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explorer',
            style: AppTextStyles.heroTitle.copyWith(fontSize: 28),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            'Plan, track, and complete your adventures',
            style: AppTextStyles.cardSubtitle,
          ),
          const SizedBox(height: AppDimensions.spaceL),
          
          // Quick Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _createNewTrip(context),
                  icon: const Icon(Icons.add_location),
                  label: const Text('Plan New Trip'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amethyst600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spaceM,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _startLiveAdventure,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Live Adventure'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.amethyst600,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spaceM,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_outlined,
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

  Widget _buildTripList(List<model.Trip> trips) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceL,
        vertical: AppDimensions.spaceM,
      ),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return _TripCard(
          trip: trip,
          onTap: () => _openTripDetail(context, trip),
        );
      },
    );
  }
}

class _TripCard extends StatelessWidget {
  final model.Trip trip;
  final VoidCallback onTap;

  const _TripCard({
    required this.trip,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '${difference}d ago';
    if (difference < 30) return '${(difference / 7).round()}w ago';
    return '${(difference / 30).round()}mo ago';
  }

  @override
  Widget build(BuildContext context) {
    final typeHelper = TripTypeHelper.fromTrip(trip);
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: typeHelper.color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceM),
            child: Row(
              children: [
                // Trip Type Icon
                Container(
                  width: 48,
                  height: 48,
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
                
                const SizedBox(width: AppDimensions.spaceM),
                
                // Trip Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.title,
                        style: AppTextStyles.cardTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
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
                            '•',
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(width: AppDimensions.spaceS),
                          Text(
                            '${trip.waypoints.length} waypoints',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      Text(
                        _formatDate(trip.createdAt),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                
                // Status Indicators
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (trip.completed) ...[
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 20,
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      Text(
                        'Completed',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else ...[
                      Icon(
                        Icons.schedule,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      Text(
                        'Planned',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    
                    if (trip.badgeEarned) ...[
                      const SizedBox(height: AppDimensions.spaceS),
                      Icon(
                        Icons.emoji_events,
                        color: typeHelper.color,
                        size: 16,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}