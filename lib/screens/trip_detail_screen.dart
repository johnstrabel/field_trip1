// lib/screens/trip_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/trip.dart' as model;

class TripDetailScreen extends StatefulWidget {
  final model.Trip trip;
  const TripDetailScreen({Key? key, required this.trip}) : super(key: key);

  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  model.Badge? _badge;

  Future<void> _handleButton() async {
    // If not yet completed: attempt to complete
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
            title: const Text('Congratulations!'),
            content: Text('You’ve earned the "${widget.trip.title}" badge!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Sweet!'),
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
              'Looks like you’ve already completed "${widget.trip.title}" and earned that badge. No double-dipping!',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.trip.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Type: ${widget.trip.type.toString().split('.').last.toUpperCase()}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _handleButton,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.trip.completed ? Colors.grey : Colors.green,
            ),
            child: Text(widget.trip.completed
                ? 'Mark Incomplete'
                : 'Mark Completed'),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          const Text('Waypoints',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...widget.trip.waypoints.map((w) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(w.name),
                  subtitle: Text(w.note),
                ),
              )),
        ],
      ),
    );
  }
}
