// lib/screens/explorer_screen.dart - SYNTAX ERRORS FIXED

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
        backgroundColor: AppColors.challengeCrimson,
      ),
    );
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

  List<model.Trip> _filterTrips(List<model.Trip> trips) {
    switch (_selectedFilter) {
      case 'Planned':
        return trips.where((trip) => !trip.completed && !_isInProgress(trip)).toList();
      case 'In Progress':
        return trips.where((trip) => _isInProgress(trip)).toList();
      case 'Completed':
        return trips.where((trip) => trip.completed).toList();
      default:
        return trips;
    }
  }

  bool _isInProgress(model.Trip trip) {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorer'),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.card,
        elevation: 0,
      ),
      backgroundColor: AppColors.surface,
      body: ValueListenableBuilder(
        valueListenable: Hive.box<model.Trip>('trips').listenable(),
        builder: (context, Box<model.Trip> tripBox, _) {
          final allTrips = tripBox.values.toList();
          final filteredTrips = _filterTrips(allTrips);

          return SingleChildScrollView(
            child: Column(
              children: [
                // Hero Actions Section
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
                  color: AppColors.card,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What\'s your next adventure?',
                        style: AppTextStyles.sectionTitle,
                      ),
                      const SizedBox(height: AppDimensions.spaceM),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionCard(
                              icon: Icons.map_outlined,
                              title: 'Plan New Trip',
                              subtitle: 'Create with map',
                              gradient: const LinearGradient(
                                colors: [AppColors.amethyst600, AppColors.standardBlue],
                              ),
                              onTap: () => _createNewTrip(context),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceM),
                          Expanded(
                            child: _ActionCard(
                              icon: Icons.explore_outlined,
                              title: 'Live Adventure',
                              subtitle: 'Start tracking now',
                              gradient: const LinearGradient(
                                colors: [AppColors.challengeCrimson, AppColors.fitnessAmber],
                              ),
                              onTap: _startLiveAdventure,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Trips Section
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Trips',
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

                      // Trip List or Empty State
                      if (filteredTrips.isEmpty)
                        _buildEmptyState(allTrips.isEmpty)
                      else
                        _buildTripList(filteredTrips),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool noTripsAtAll) {
    if (noTripsAtAll) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.spaceXXL),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: AppColors.amethyst100),
        ),
        child: Column(
          children: [
            Icon(
              Icons.explore_outlined,
              size: 48,
              color: AppColors.amethyst600,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              'Start Your First Adventure!',
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              'Create your first trip to begin exploring',
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            ElevatedButton.icon(
              onPressed: () => _createNewTrip(context),
              icon: const Icon(Icons.add),
              label: const Text('Plan New Trip'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.amethyst600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceL,
                  vertical: AppDimensions.spaceM,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          children: [
            Icon(
              Icons.filter_list_off,
              size: 32,
              color: AppColors.textSecond,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              'No ${_selectedFilter.toLowerCase()} trips',
              style: AppTextStyles.cardSubtitle,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTripList(List<model.Trip> trips) {
    return Column(
      children: trips.map((trip) => _TripCard(
        trip: trip,
        onTap: () => _openTripDetail(context, trip),
      )).toList(),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              title,
              style: AppTextStyles.cardTitle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXS),
            Text(
              subtitle,
              style: AppTextStyles.cardSubtitle.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
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
    final tripTypeHelper = TripTypeHelper.fromType(trip.type);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: trip.completed ? AppColors.success : AppColors.stroke,
              width: trip.completed ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: tripTypeHelper.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                    child: Icon(
                      tripTypeHelper.icon,
                      color: tripTypeHelper.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.title,
                          style: AppTextStyles.cardTitle,
                        ),
                        const SizedBox(height: AppDimensions.spaceXS),
                        Text(
                          tripTypeHelper.displayName,
                          style: AppTextStyles.cardSubtitle.copyWith(
                            color: tripTypeHelper.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trip.completed)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                      ),
                      child: Text(
                        'Completed',
                        style: AppTextStyles.cardSubtitle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceM),
              Row(
                children: [
                  Icon(
                    Icons.place,
                    size: 16,
                    color: AppColors.textSecond,
                  ),
                  const SizedBox(width: AppDimensions.spaceXS),
                  Text(
                    '${trip.waypoints.length} waypoints',
                    style: AppTextStyles.cardSubtitle,
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecond,
                  ),
                  const SizedBox(width: AppDimensions.spaceXS),
                  Text(
                    _formatDate(trip.createdAt),
                    style: AppTextStyles.cardSubtitle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '${difference}d ago';
    if (difference < 30) return '${(difference / 7).round()}w ago';
    return '${(difference / 30).round()}mo ago';
  }
}