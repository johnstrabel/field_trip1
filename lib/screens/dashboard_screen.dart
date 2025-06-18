// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';
import 'map_trip_creation_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedFilter = 'Filter 1';
  final List<String> _filterOptions = ['Filter 1', 'Filter 2', 'Filter 3'];

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

  void _joinChallenge() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Joining weekly challenge...'),
        backgroundColor: AppColors.amethyst600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          children: [
            // Hero Banner
            _buildHeroBanner(),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Filter Chips
            _buildFilterChips(),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Discovery Card
            _buildDiscoveryCard(),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Friends Activity
            _buildFriendsActivity(),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Progress Snapshot
            _buildProgressSnapshot(),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Weekly Challenge
            _buildWeeklyChallenge(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.amethyst600,
            AppColors.amethyst600.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.amethyst600.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Explore Icon
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceM),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.explore,
              color: Colors.white,
              size: 32,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          // Title
          Text(
            'Ready to Explore?',
            style: AppTextStyles.heroTitle.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.spaceS),
          
          // Subtitle
          Text(
            'Continue where you left off or try something new.',
            style: AppTextStyles.heroSubtitle.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.spaceXL),
          
          // Action Buttons Row
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _createNewTrip(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.amethyst600,
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    ),
                  ),
                  child: const Text(
                    'Create Trip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: OutlinedButton(
                  onPressed: _joinChallenge,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    ),
                  ),
                  child: const Text(
                    'Join Challenge',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Widget _buildFilterChips() {
    return Row(
      children: _filterOptions.map((filter) {
        final isSelected = filter == _selectedFilter;
        return Padding(
          padding: const EdgeInsets.only(right: AppDimensions.spaceM),
          child: FilterChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedFilter = filter;
              });
            },
            backgroundColor: Colors.white,
            selectedColor: AppColors.amethyst100,
            checkmarkColor: AppColors.amethyst600,
            labelStyle: TextStyle(
              color: isSelected ? AppColors.amethyst600 : AppColors.textSecond,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              side: BorderSide(
                color: isSelected ? AppColors.amethyst600 : Colors.grey.shade300,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDiscoveryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Map Preview (placeholder)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Stack(
              children: [
                // Map-like pattern
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade100,
                        Colors.blue.shade100,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Path line
                CustomPaint(
                  size: const Size(80, 80),
                  painter: _MapPathPainter(),
                ),
                // Location pin
                const Positioned(
                  top: 20,
                  right: 25,
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: AppDimensions.spaceL),
          
          // Trip Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trips Near You',
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                Text(
                  '5 trips within 2 km',
                  style: AppTextStyles.cardSubtitle,
                ),
              ],
            ),
          ),
          
          // Arrow
          Icon(
            Icons.chevron_right,
            color: AppColors.textSecond,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsActivity() {
    final friends = [
      {'name': 'Alex', 'avatar': Icons.person},
      {'name': 'Maya', 'avatar': Icons.person_2},
      {'name': 'Sam', 'avatar': Icons.person_3},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Friends Activity',
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          // Friends Avatars
          Row(
            children: friends.map((friend) {
              return Padding(
                padding: const EdgeInsets.only(right: AppDimensions.spaceM),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.amethyst100,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.amethyst600, width: 2),
                  ),
                  child: Icon(
                    friend['avatar'] as IconData,
                    color: AppColors.amethyst600,
                    size: 24,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSnapshot() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress Snapshot',
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.route,
                  value: '10',
                  label: 'Trips Completed',
                  color: AppColors.amethyst600,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceL),
              Expanded(
                child: _StatItem(
                  icon: Icons.emoji_events,
                  value: '5',
                  label: 'Badges',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.local_fire_department,
                  value: '7',
                  label: 'Streak Days',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceL),
              Expanded(
                child: _StatItem(
                  icon: Icons.trending_up,
                  value: '80%',
                  label: 'Completion Rate',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChallenge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.amethyst600.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Challenge Icon
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceM),
            decoration: BoxDecoration(
              color: AppColors.amethyst100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              color: AppColors.amethyst600,
              size: 24,
            ),
          ),
          
          const SizedBox(width: AppDimensions.spaceL),
          
          // Challenge Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Challenge',
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                Text(
                  'Complete 3 different trip types',
                  style: AppTextStyles.cardSubtitle,
                ),
              ],
            ),
          ),
          
          // Join Button
          ElevatedButton(
            onPressed: _joinChallenge,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.amethyst600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceL,
                vertical: AppDimensions.spaceM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
            ),
            child: const Text(
              'Join',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceM),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXS),
        Text(
          label,
          style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _MapPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.3,
      size.width * 0.8, size.height * 0.6,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}