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
  
  // Updated filter options using new taxonomy
  final List<String> _filterOptions = TripTypeHelper.getCoreTypeDisplayNames();

  /// Filter badges by core type
  List<model.Badge> _filterBadges(List<model.Badge> badges) {
    if (_selectedFilter == 'All') return badges;
    
    return badges.where((badge) {
      final typeHelper = TripTypeHelper.fromBadge(badge);
      return typeHelper.displayName == _selectedFilter;
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
                    'Filter by Type',
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
    // Calculate stats using CoreType
    final Map<model.CoreType, int> typeStats = {};
    for (final badge in badges) {
      final coreType = badge.currentType;
      typeStats[coreType] = (typeStats[coreType] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        children: [
          // Total badges count
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceXL,
              vertical: AppDimensions.spaceL,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Column(
              children: [
                Text(
                  '${badges.length}',
                  style: AppTextStyles.heroTitle.copyWith(
                    color: AppColors.amethyst600,
                    fontSize: 36,
                  ),
                ),
                Text(
                  badges.length == 1 ? 'Badge Earned' : 'Badges Earned',
                  style: AppTextStyles.cardSubtitle,
                ),
              ],
            ),
          ),
          
          // Type breakdown (if we have badges)
          if (badges.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spaceL),
            Text(
              'Badge Collection',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            _buildTypeStatsRow(typeStats),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeStatsRow(Map<model.CoreType, int> typeStats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: model.CoreType.values.map((coreType) {
        final helper = TripTypeHelper.fromCoreType(coreType);
        final count = typeStats[coreType] ?? 0;
        
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceXS),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceS,
              vertical: AppDimensions.spaceM,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: helper.color.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(
                  helper.icon,
                  color: helper.color,
                  size: 20,
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                Text(
                  '$count',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: helper.color,
                    fontSize: 16,
                  ),
                ),
                Text(
                  helper.displayName,
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
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
              Icons.emoji_events_outlined,
              size: 64,
              color: AppColors.textSecond,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            Text(
              'No Badges Yet',
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
                final navigator = Navigator.of(context);
                navigator.popUntil((route) => route.isFirst);
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
          '🔵 Explore - Blue badges for discovery adventures\n'
          '🟠 Crawl - Bronze badges for social journeys\n'
          '🟡 Active - Amber badges for fitness activities\n'
          '🔴 Game - Crimson badges for competitive challenges\n\n'
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
    final helper = TripTypeHelper.fromBadge(badge);
    
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: helper.color,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Badge icon with colored background
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: helper.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Icon(
                  helper.icon,
                  color: helper.color,
                  size: 28,
                ),
              ),
              
              const SizedBox(height: AppDimensions.spaceM),
              
              // Badge label
              Text(
                badge.label,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: AppDimensions.spaceS),
              
              // Type and date
              Text(
                helper.displayName,
                style: AppTextStyles.caption.copyWith(
                  color: helper.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              Text(
                _formatDate(badge.earnedAt),
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}