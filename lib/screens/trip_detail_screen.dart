// lib/screens/trip_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/trip.dart' as model;
import '../models/trail_data.dart' as trail;
import '../services/location_tracking_service.dart';

class TripDetailScreen extends StatefulWidget {
  final model.Trip trip;
  const TripDetailScreen({Key? key, required this.trip}) : super(key: key);

  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  model.Badge? _badge;
  late LocationTrackingService _trackingService;
  trail.TrailStats? _currentStats;

  @override
  void initState() {
    super.initState();
    _trackingService = LocationTrackingService();
    _trackingService.addListener(_onTrackingUpdate);
  }

  @override
  void dispose() {
    _trackingService.removeListener(_onTrackingUpdate);
    super.dispose();
  }

  void _onTrackingUpdate() {
    if (_trackingService.isTracking && _trackingService.activeTripId == widget.trip.id) {
      setState(() {
        _currentStats = _trackingService.getTrailStats();
      });
    }
  }

  Future<void> _toggleTracking() async {
    if (_trackingService.isTracking && _trackingService.activeTripId == widget.trip.id) {
      // Stop tracking
      final completedTrail = await _trackingService.stopTracking();
      
      if (completedTrail.isNotEmpty) {
        // Save trail data
        final trailData = trail.TrailData.fromTrackingSession(widget.trip.id, completedTrail);
        final trailBox = Hive.box<trail.TrailData>('trail_data');
        await trailBox.put('${widget.trip.id}_${DateTime.now().millisecondsSinceEpoch}', trailData);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Trail saved! ${trailData.stats.distanceKm} in ${trailData.stats.durationFormatted}'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      setState(() {
        _currentStats = null;
      });
    } else {
      // Start tracking
      final success = await _trackingService.startTracking(widget.trip.id);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Live tracking started! 📍'),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to start tracking. Check location permissions.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleCompletion() async {
    // If tracking is active, stop it first
    if (_trackingService.isTracking && _trackingService.activeTripId == widget.trip.id) {
      await _toggleTracking();
    }

    // Handle completion logic
    if (!widget.trip.completed) {
      // First-time completion → award badge
      if (!widget.trip.badgeEarned) {
        widget.trip.completed = true;
        widget.trip.badgeEarned = true;
        _badge = model.Badge(
          id: const Uuid().v4(),
          tripId: widget.trip.id,
          label: 'Badge for "${widget.trip.title}"',
          earnedAt: DateTime.now(),
          type: widget.trip.type,
        );

        // Show the congratulations dialog
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('🎉 Congratulations!'),
            content: Text('You\'ve earned the "${widget.trip.title}" badge!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Awesome!'),
              ),
            ],
          ),
        );

        // Pop back and return the badge
        Navigator.of(context).pop(_badge);
      } else {
        // Already earned → show error
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Hold up!'),
            content: Text(
              'Looks like you\'ve already completed "${widget.trip.title}" and earned that badge. No double-dipping!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got it'),
              ),
            ],
          ),
        );
      }
    } else {
      // Trip is currently completed and user tapped "Mark Incomplete"
      setState(() => widget.trip.completed = false);
      Navigator.of(context).pop(null);
    }
  }

  Widget _buildTrackingControls() {
    final isCurrentlyTracking = _trackingService.isTracking && _trackingService.activeTripId == widget.trip.id;
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCurrentlyTracking ? Icons.stop_circle : Icons.play_circle,
                  color: isCurrentlyTracking ? Colors.red : Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Live Tracking',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (isCurrentlyTracking)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            
            if (isCurrentlyTracking && _currentStats != null) ...[
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.straighten,
                      label: 'Distance',
                      value: _currentStats!.distanceKm,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.timer,
                      label: 'Duration',
                      value: _currentStats!.durationFormatted,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.speed,
                      label: 'Speed',
                      value: _currentStats!.speedKmh,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.place,
                      label: 'Points',
                      value: '${_currentStats!.pointCount}',
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _toggleTracking,
                icon: Icon(isCurrentlyTracking ? Icons.stop : Icons.play_arrow),
                label: Text(isCurrentlyTracking ? 'Stop Tracking' : 'Start Live Tracking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCurrentlyTracking ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            
            if (!isCurrentlyTracking)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Track your real-time movement and create a trail of your exploration!',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.trip.title)),
      body: ListView(
        children: [
          // Trip Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flag, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          'Trip Details',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Type: ${widget.trip.type.toString().split('.').last.toUpperCase()}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Created: ${widget.trip.createdAt.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    if (widget.trip.completed) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text('Completed', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                          if (widget.trip.badgeEarned) ...[
                            const SizedBox(width: 12),
                            const Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text('Badge Earned', style: TextStyle(color: Colors.amber.shade700, fontWeight: FontWeight.w600)),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Live Tracking Controls
          _buildTrackingControls(),

          // Completion Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _handleCompletion,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.trip.completed ? Colors.grey : Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                widget.trip.completed ? 'Mark Incomplete' : 'Mark Completed',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          // Waypoints
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.place, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          'Waypoints (${widget.trip.waypoints.length})',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...widget.trip.waypoints.asMap().entries.map((entry) {
                      final index = entry.key;
                      final waypoint = entry.value;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 16,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(waypoint.name),
                        subtitle: waypoint.note.isNotEmpty ? Text(waypoint.note) : null,
                        trailing: Text(
                          '${waypoint.latitude.toStringAsFixed(4)}, ${waypoint.longitude.toStringAsFixed(4)}',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}