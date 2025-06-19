// lib/screens/badge_wall_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';
import '../widgets/filter_chip_row.dart';

class BadgeWallScreen extends StatefulWidget {
  final List<model.Badge>? badges; // Make it optional for navigation

  const BadgeWallScreen({Key? key, this.badges}) : super(key: key);

  @override
  _BadgeWallScreenState createState() => _BadgeWallScreenState();
}

class _BadgeWallScreenState extends State<BadgeWallScreen> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Standard', 'Challenge', 'Barcrawl', 'Fitness'];

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
        title: const Text('Achievements'),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.card,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showBadgeInfo(context);
            },
          ),
        ],
      ),
      backgroundColor: AppColors.surface,
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
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Section with Stats
          _buildHeaderSection(allBadges),
          
          // Filter Section
          if (allBadges.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter by Trip Type',
                    style: AppTextStyles.sectionTitle,
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
          Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: allBadges.isEmpty
                ? _buildEmptyState()
                : filteredBadges.isEmpty
                    ? _buildNoResultsState()
                    : _buildBadgeGrid(filteredBadges),
          ),
        ],
      ),
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
        gradient: const LinearGradient(
          colors: [AppColors.amethyst600, AppColors.amethyst100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceM),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.spaceM),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: AppDimensions.iconSizeL,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achievement Gallery',
                      style: AppTextStyles.heroTitle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      badges.isEmpty
                          ? 'Start earning badges by completing trips!'
                          : 'You\'ve earned ${badges.length} badge${badges.length == 1 ? '' : 's'}',
                      style: AppTextStyles.heroSubtitle.copyWith(
                        fontSize: 14,
                      ),
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
              children: model.TripType.values.map((type) {
                final typeName = type.toString().split('.').last;
                final count = typeStats[type] ?? 0;
                final color = TripTypeHelper.getColor(typeName);
                
                return Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceS),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                        ),
                        child: Icon(
                          TripTypeHelper.getIcon(typeName),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        typeName.substring(0, 3).toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
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
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.amethyst100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_events_outlined,
                size: 64,
                color: AppColors.amethyst600,
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
                // Navigate to Explorer tab (index 2 in NEW navigation structure)
                // Since we're in a bottom navigation context, we need to access the parent
                final navigator = Navigator.of(context);
                
                // Pop back to main navigation and switch to Explorer tab
                navigator.popUntil((route) => route.isFirst);
                
                // Since MainNavigationScreen uses StatefulWidget with _selectedIndex,
                // we'll trigger a rebuild by using a callback or navigator replacement
                navigator.pushReplacementNamed('/', arguments: {'initialIndex': 2});
              },
              icon: const Icon(Icons.explore),
              label: const Text('Start Exploring'),
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
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: AppDimensions.spaceM,
          mainAxisSpacing: AppDimensions.spaceM,
        ),
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          return _BadgeCard(badge: badge);
        },
      ),
    );
  }

  void _showBadgeInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emoji_events, color: AppColors.amethyst600),
            const SizedBox(width: AppDimensions.spaceS),
            const Text('About Badges'),
          ],
        ),
        content: const Text(
          'Badges are earned by completing trips! Each trip type has its own unique badge style:\n\n'
          '🔵 Standard - Blue badges for regular exploration\n'
          '🔴 Challenge - Red badges for difficult routes\n'
          '🟠 Barcrawl - Bronze badges for social adventures\n'
          '🟡 Fitness - Amber badges for active journeys\n\n'
          'Complete more trips to grow your collection!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Got it!',
              style: TextStyle(color: AppColors.amethyst600),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final model.Badge badge;

  const _BadgeCard({required this.badge});

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
    final typeName = badge.type.toString().split('.').last;
    final color = TripTypeHelper.getColor(typeName);
    final icon = TripTypeHelper.getIcon(typeName);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge Icon with Glow Effect
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 12,
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
              style: AppTextStyles.cardTitle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
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
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
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
              'Earned ${_formatDate(badge.earnedAt)}',
              style: AppTextStyles.cardSubtitle.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}