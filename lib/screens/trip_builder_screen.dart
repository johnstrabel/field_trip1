// lib/screens/trip_builder_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';
import '../widgets/filter_chip_row.dart';
import 'map_trip_creation_screen.dart';
import 'trip_detail_screen.dart';

class TripBuilderScreen extends StatefulWidget {
  const TripBuilderScreen({Key? key}) : super(key: key);

  @override
  _TripBuilderScreenState createState() => _TripBuilderScreenState();
}

class _TripBuilderScreenState extends State<TripBuilderScreen> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Standard', 'Challenge', 'Barcrawl', 'Fitness'];

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

  Future<void> _openTripDetail(BuildContext context, model.Trip trip) async {
    final badgeBox = Hive.box<model.Badge>('badges');
    final model.Badge? earned = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TripDetailScreen(trip: trip)),
    );
    if (earned != null) {
      badgeBox.put(earned.id, earned);
    }
  }

  void _startLiveTrip() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live trip mode coming soon! Use "Plan From Home" for now.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  List<model.Trip> _filterTrips(List<model.Trip> trips) {
    if (_selectedFilter == 'All') return trips;
    
    return trips.where((trip) {
      return trip.type.toString().split('.').last.toLowerCase() == 
             _selectedFilter.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Builder'),
        automaticallyImplyLeading: false,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<model.Trip>('trips').listenable(),
        builder: (context, Box<model.Trip> box, _) {
          final allTrips = box.values.toList();
          final filteredTrips = _filterTrips(allTrips);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Actions Section
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: AppTextStyles.sectionTitle,
                      ),
                      const SizedBox(height: AppDimensions.spaceL),
                      
                      // Action Cards Row
                      Row(
                        children: [
                          Expanded(
                            child: _ActionCard(
                              icon: Icons.map_outlined,
                              title: 'Plan From Home',
                              subtitle: 'Create routes with GPS waypoints',
                              color: AppColors.standardBlue,
                              onTap: () => _createNewTrip(context),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceM),
                          Expanded(
                            child: _ActionCard(
                              icon: Icons.play_circle_outline,
                              title: 'Start Live Trip',
                              subtitle: 'Begin exploring now',
                              color: AppColors.fitnessAmber,
                              onTap: _startLiveTrip,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  height: 8,
                  color: AppColors.surface,
                ),

                // Saved Trips Section
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Saved Trips (${allTrips.length})',
                            style: AppTextStyles.sectionTitle,
                          ),
                          if (allTrips.isNotEmpty)
                            TextButton.icon(
                              onPressed: () => _createNewTrip(context),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('New'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.amethyst600,
                              ),
                            ),
                        ],
                      ),
                      
                      if (allTrips.isNotEmpty) ...[
                        const SizedBox(height: AppDimensions.spaceM),
                        
                        // Filter Chips
                        FilterChipRow(
                          options: _filterOptions,
                          selectedOption: _selectedFilter,
                          onSelectionChanged: (selected) {
                            setState(() {
                              _selectedFilter = selected;
                            });
                          },
                        ),
                        
                        const SizedBox(height: AppDimensions.spaceL),
                      ],
                    ],
                  ),
                ),

                // Trips List or Empty State
                if (allTrips.isEmpty)
                  _buildEmptyState()
                else if (filteredTrips.isEmpty)
                  _buildNoResultsState()
                else
                  _buildTripsList(filteredTrips),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceXL),
              decoration: BoxDecoration(
                color: AppColors.amethyst100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.explore_outlined,
                size: 64,
                color: AppColors.amethyst600,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXL),
            Text(
              'No trips yet!',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              'Start your exploration journey by creating your first trip.',
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceXL),
            ElevatedButton.icon(
              onPressed: () => _createNewTrip(context),
              icon: const Icon(Icons.add_location),
              label: const Text('Create Your First Trip'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      child: Center(
        child: Column(
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
              'Try a different filter or create a new trip.',
              style: AppTextStyles.cardSubtitle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripsList(List<model.Trip> trips) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trips.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.spaceS),
      itemBuilder: (context, index) {
        final trip = trips[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
          child: _TripCard(
            trip: trip,
            onTap: () => _openTripDetail(context, trip),
          ),
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceM),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.spaceM),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: AppDimensions.iconSizeL,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceM),
              Text(
                title,
                style: AppTextStyles.cardTitle,
              ),
              const SizedBox(height: AppDimensions.spaceXS),
              Text(
                subtitle,
                style: AppTextStyles.cardSubtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    final tripTypeName = trip.type.toString().split('.').last;
    final tripColor = TripTypeHelper.getColor(tripTypeName);
    final tripIcon = TripTypeHelper.getIcon(tripTypeName);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          child: Row(
            children: [
              // Trip Type Icon
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceM),
                decoration: BoxDecoration(
                  color: tripColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                ),
                child: Icon(
                  tripIcon,
                  color: tripColor,
                  size: AppDimensions.iconSizeM,
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
                          tripTypeName.toUpperCase(),
                          style: AppTextStyles.cardSubtitle.copyWith(
                            color: tripColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' • ${trip.waypoints.length} waypoint${trip.waypoints.length == 1 ? '' : 's'}',
                          style: AppTextStyles.cardSubtitle,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      'Created ${trip.createdAt.toLocal().toString().split(' ')[0]}',
                      style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              
              // Status Indicators + Arrow
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (trip.completed)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      if (trip.badgeEarned) ...[
                        if (trip.completed) const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.warning,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceS),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecond,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}