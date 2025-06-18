// lib/screens/badge_wall_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';
import '../widgets/filter_chip_row.dart';
import 'trip_builder_screen.dart';

class BadgeWallScreen extends StatefulWidget {
  final List<model.Badge>? badges; // Make it optional for navigation

  const BadgeWallScreen({Key? key, this.badges}) : super(key: key);

  @override
  _BadgeWallScreenState createState() => _BadgeWallScreenState();
}

class _BadgeWallScreenState extends State<BadgeWallScreen> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Standard', 'Challenge', 'Barcrawl', 'Fitness'];

  /// Returns the border color for each TripType
  Color _getTypeColor(model.TripType type) {
    final typeName = type.toString().split('.').last;
    return TripTypeHelper.getColor(typeName);
  }

  /// Filter badges by trip type
  List<model.Badge> _filterBadges(List<model.Badge> badges) {
    if (_selectedFilter == 'All') return badges;
    
    return badges.where((badge) {
      return badge.type.toString().split('.').last.toLowerCase() == 
             _selectedFilter.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badge Wall'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showBadgeInfo(context);
            },
          ),
        ],
      ),
      body: widget.badges != null 
        ? _buildBadgeContent(widget.badges!)
        : ValueListenableBuilder(
            valueListenable: Hive.box<model.Badge>('badges').listenable(),
            builder: (context, Box<model.Badge> box, _) {
              final badgeList = box.values.toList();
              return _buildBadgeContent(badgeList);
            },
          ),
    );
  }

  Widget _buildBadgeContent(List<model.Badge> allBadges) {
    final filteredBadges = _filterBadges(allBadges);
    
    return Column(
      children: [
        // Header Section with Stats
        _buildHeaderSection(allBadges),
        
        // Filter Section
        if (allBadges.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceL,
              vertical: AppDimensions.spaceM,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by Trip Type',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                FilterChipRow(
                  options: _filterOptions,
                  selectedOption: _selectedFilter,
                  onSelectionChanged: (selected) {
                    setState(() {
                      _selectedFilter = selected;
                    });
                  },
                ),
              ],
            ),
          ),
        
        // Badges Grid or Empty State
        Expanded(
          child: allBadges.isEmpty
              ? _buildEmptyState()
              : filteredBadges.isEmpty
                  ? _buildNoResultsState()
                  : _buildBadgeGrid(filteredBadges),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(List<model.Badge> badges) {
    final typeStats = <model.TripType, int>{};
    for (final badge in badges) {
      typeStats[badge.type] = (typeStats[badge.type] ?? 0) + 1;
    }

    return Container(
      margin: const EdgeInsets.all(AppDimensions.spaceL),
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.warning.withOpacity(0.1),
            AppColors.warning.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceM),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(AppDimensions.spaceM),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: AppDimensions.iconSizeM,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achievement Gallery',
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      badges.isEmpty
                          ? 'Start earning badges by completing trips!'
                          : 'You\'ve earned ${badges.length} badge${badges.length == 1 ? '' : 's'}',
                      style: AppTextStyles.cardSubtitle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (badges.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spaceL),
            
            // Quick Stats Row
            Row(
              children: model.TripType.values.take(4).map((type) {
                final typeName = type.toString().split('.').last;
                final count = typeStats[type] ?? 0;
                final color = TripTypeHelper.getColor(typeName);
                
                return Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceS),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                        ),
                        child: Icon(
                          TripTypeHelper.getIcon(typeName),
                          color: color,
                          size: 16,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      Text(
                        '$count',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        typeName.substring(0, 3).toUpperCase(),
                        style: TextStyle(
                          color: AppColors.textSecond,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
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
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceXL),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_events_outlined,
                size: 64,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXL),
            Text(
              'No badges yet!',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              'Complete trips to earn your first badge and start building your achievement collection.',
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceXL),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to trip builder
                DefaultTabController.of(context)?.animateTo(2);
              },
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: AppColors.textSecond,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              'No $_selectedFilter badges found',
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              'Try completing more ${_selectedFilter.toLowerCase()} trips to earn badges in this category.',
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
              child: const Text('Show All Badges'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeGrid(List<model.Badge> badges) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: AppDimensions.spaceM,
        mainAxisSpacing: AppDimensions.spaceM,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return _BadgeCard(badge: badge);
      },
    );
  }

  void _showBadgeInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏆 About Badges'),
        content: const Text(
          'Badges are earned by completing trips! Each trip type has its own unique badge style:\n\n'
          '🔵 Standard - Blue badges for regular exploration\n'
          '🔴 Challenge - Red badges for difficult routes\n'
          '🟠 Barcrawl - Orange badges for social adventures\n'
          '🟢 Fitness - Green badges for active journeys\n\n'
          'Complete more trips to grow your collection!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final model.Badge badge;

  const _BadgeCard({required this.badge});

  @override
  Widget build(BuildContext context) {
    final typeName = badge.type.toString().split('.').last;
    final color = TripTypeHelper.getColor(typeName);
    final icon = TripTypeHelper.getIcon(typeName);
    
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: color, width: 3),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Badge Icon with Glow Effect
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceM),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: AppDimensions.iconSizeL,
                ),
              ),
              
              const SizedBox(height: AppDimensions.spaceM),
              
              // Badge Title
              Text(
                badge.label,
                textAlign: TextAlign.center,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: AppDimensions.spaceS),
              
              // Trip Type Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceS,
                  vertical: AppDimensions.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      color: color,
                      size: 12,
                    ),
                    const SizedBox(width: AppDimensions.spaceXS),
                    Text(
                      typeName.toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppDimensions.spaceS),
              
              // Earned Date
              Text(
                'Earned ${badge.earnedAt.toLocal().toString().split(' ')[0]}',
                style: AppTextStyles.cardSubtitle.copyWith(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}