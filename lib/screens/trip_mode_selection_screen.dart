import 'package:flutter/material.dart';
import 'map_trip_creation_screen.dart';

class TripModeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Trip Mode'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'How would you like to plan your trip?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // Plan From Home option
            Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MapTripCreationScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.home,
                        size: 60,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Plan From Home',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Plan your route in advance by adding waypoints and saving for later',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Live Trip option (for future implementation)
            Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  // For now, also go to the same screen
                  // Later you can create a separate LiveTripScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MapTripCreationScreen(),
                    ),
                  );
                  
                  // Show a message that this is coming soon
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Live trip mode coming soon! For now, use the regular trip creator.'),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.navigation,
                        size: 60,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Start Live Trip',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Begin exploring now and add waypoints as you discover them',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}