// lib/screens/map_trip_creation_screen.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import '../models/trip.dart';

class MapTripCreationScreen extends StatefulWidget {
  const MapTripCreationScreen({Key? key}) : super(key: key);

  @override
  _MapTripCreationScreenState createState() => _MapTripCreationScreenState();
}

class _MapTripCreationScreenState extends State<MapTripCreationScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  List<Waypoint> _waypoints = [];
  LatLng _currentLocation = const LatLng(50.0755, 14.4378); // Default to Prague
  bool _locationPermissionGranted = false;
  
  final _titleController = TextEditingController();
  TripType _selectedType = TripType.standard;
  
  Location _location = Location();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        _showLocationPermissionDialog();
        return;
      }
    }

    setState(() {
      _locationPermissionGranted = true;
    });
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      setState(() {
        _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });
      
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _currentLocation,
              zoom: 15.0,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Service'),
        content: const Text(
          'Location service is disabled. Please enable it in your device settings to get your current position.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission'),
        content: const Text(
          'Location access is needed to show your current position and help you create trips. You can still use the app by manually navigating the map.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onMapTapped(LatLng position) {
    _showWaypointDialog(position);
  }

  void _showWaypointDialog(LatLng position) {
    final nameController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Waypoint'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Waypoint Name',
                hintText: 'e.g., Coffee Shop, Viewpoint',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Add any details about this location',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                _addWaypoint(position, nameController.text.trim(), noteController.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addWaypoint(LatLng position, String name, String note) {
    final waypoint = Waypoint(
      name: name,
      note: note,
      latitude: position.latitude,
      longitude: position.longitude,
    );

    final marker = Marker(
      markerId: MarkerId('waypoint_${_waypoints.length}'),
      position: position,
      infoWindow: InfoWindow(
        title: name,
        snippet: note.isNotEmpty ? note : null,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        _getMarkerColor(_selectedType),
      ),
    );

    setState(() {
      _waypoints.add(waypoint);
      _markers.add(marker);
    });
  }

  double _getMarkerColor(TripType type) {
    switch (type) {
      case TripType.standard:
        return BitmapDescriptor.hueBlue;
      case TripType.challenge:
        return BitmapDescriptor.hueMagenta;
      case TripType.barcrawl:
        return BitmapDescriptor.hueOrange;
      case TripType.fitness:
        return BitmapDescriptor.hueGreen;
    }
  }

  void _removeWaypoint(int index) {
    setState(() {
      _waypoints.removeAt(index);
      // Rebuild markers
      _markers = _waypoints.asMap().entries.map((entry) {
        final i = entry.key;
        final waypoint = entry.value;
        return Marker(
          markerId: MarkerId('waypoint_$i'),
          position: LatLng(waypoint.latitude, waypoint.longitude),
          infoWindow: InfoWindow(
            title: waypoint.name,
            snippet: waypoint.note.isNotEmpty ? waypoint.note : null,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getMarkerColor(_selectedType),
          ),
        );
      }).toSet();
    });
  }

  void _saveTrip() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a trip title')),
      );
      return;
    }

    if (_waypoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one waypoint')),
      );
      return;
    }

    final trip = Trip(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      type: _selectedType,
      waypoints: _waypoints,
      createdAt: DateTime.now(),
    );

    Navigator.of(context).pop(trip);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Trip'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _locationPermissionGranted ? _getCurrentLocation : null,
            tooltip: 'Go to my location',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTrip,
          ),
        ],
      ),
      body: Column(
        children: [
          // Trip Settings Panel
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Trip Title',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<TripType>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Trip Type',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onChanged: (TripType? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedType = newValue;
                              // Update marker colors
                              _markers = _waypoints.asMap().entries.map((entry) {
                                final i = entry.key;
                                final waypoint = entry.value;
                                return Marker(
                                  markerId: MarkerId('waypoint_$i'),
                                  position: LatLng(waypoint.latitude, waypoint.longitude),
                                  infoWindow: InfoWindow(
                                    title: waypoint.name,
                                    snippet: waypoint.note.isNotEmpty ? waypoint.note : null,
                                  ),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                    _getMarkerColor(newValue),
                                  ),
                                );
                              }).toSet();
                            });
                          }
                        },
                        items: TripType.values.map((TripType type) {
                          return DropdownMenuItem<TripType>(
                            value: type,
                            child: Text(type.toString().split('.').last.toUpperCase()),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.place, size: 16),
                          const SizedBox(width: 4),
                          Text('${_waypoints.length}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Map
          Expanded(
            flex: 3,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                if (_locationPermissionGranted) {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: _currentLocation,
                        zoom: 15.0,
                      ),
                    ),
                  );
                }
              },
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 13.0,
              ),
              onTap: _onMapTapped,
              markers: _markers,
              myLocationEnabled: _locationPermissionGranted,
              myLocationButtonEnabled: false, // We have our own button
              zoomControlsEnabled: false,
            ),
          ),

          // Waypoint List
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border(top: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.list, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Waypoints (${_waypoints.length})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Text(
                          'Tap map to add',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _waypoints.isEmpty
                        ? const Center(
                            child: Text(
                              'Tap on the map to add waypoints',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _waypoints.length,
                            itemBuilder: (context, index) {
                              final waypoint = _waypoints[index];
                              return ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  radius: 12,
                                  child: Text('${index + 1}'),
                                ),
                                title: Text(waypoint.name),
                                subtitle: waypoint.note.isNotEmpty 
                                    ? Text(waypoint.note, maxLines: 1, overflow: TextOverflow.ellipsis)
                                    : Text('${waypoint.latitude.toStringAsFixed(4)}, ${waypoint.longitude.toStringAsFixed(4)}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, size: 20),
                                  onPressed: () => _removeWaypoint(index),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveTrip,
        icon: const Icon(Icons.save),
        label: const Text('Save Trip'),
      ),
    );
  }
}