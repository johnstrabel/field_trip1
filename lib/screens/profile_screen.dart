// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<model.Trip>('trips').listenable(),
        builder: (context, Box<model.Trip> tripBox, _) {
          return ValueListenableBuilder(
            valueListenable: Hive.box<model.Badge>('badges').listenable(),
            builder: (context, Box<model.Badge> badgeBox, _) {
              final trips = tripBox.values.toList();
              final badges = badgeBox.values.toList();
              final completedTrips = trips.where((t) => t.completed).length;
              final completionRate = trips.isEmpty ? 0.0 : (completedTrips / trips.length) * 100;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.teal,
                              child: Text(
                                'FT', // Field Trip initials
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Explorer',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'Online',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Stats Section
                    const Text(
                      'Stats',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Trips Completed',
                            value: '$completedTrips',
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Badges Earned',
                            value: '${badges.length}',
                            icon: Icons.emoji_events,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Total Trips',
                            value: '${trips.length}',
                            icon: Icons.map,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Completion Rate',
                            value: '${completionRate.toStringAsFixed(0)}%',
                            icon: Icons.trending_up,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Trip Type Breakdown
                    const Text(
                      'Trip Types Completed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ...model.TripType.values.map((type) {
                      final count = trips.where((t) => t.type == type && t.completed).length;
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.flag,
                            color: _getTypeColor(type),
                          ),
                          title: Text(
                            type.toString().split('.').last.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: Text(
                            '$count',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    
                    const SizedBox(height: 24),
                    
                    // Friends Section (Coming Soon)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.people, color: Colors.teal),
                                const SizedBox(width: 8),
                                const Text(
                                  'Friends',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Connect with friends to share trips and compete on leaderboards.',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Friends system coming soon!'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add Friends'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getTypeColor(model.TripType type) {
    switch (type) {
      case model.TripType.standard:
        return Colors.teal;
      case model.TripType.challenge:
        return Colors.deepPurple;
      case model.TripType.barcrawl:
        return Colors.orange;
      case model.TripType.fitness:
        return Colors.green;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}