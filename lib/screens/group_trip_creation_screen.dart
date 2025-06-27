// lib/screens/group_trip_creation_screen.dart - FIXED VERSION
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/group_trip.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';

class GroupTripCreationScreen extends StatefulWidget {
  const GroupTripCreationScreen({super.key});

  @override
  State<GroupTripCreationScreen> createState() => _GroupTripCreationScreenState();
}

class _GroupTripCreationScreenState extends State<GroupTripCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _waypointController = TextEditingController();
  
  model.CoreType _selectedType = model.CoreType.crawl;
  String? _selectedSubMode;
  List<model.Waypoint> _waypoints = [];
  List<String> _selectedFriends = [];
  
  // Mock friend data - replace with real friend system later
  final List<Map<String, String>> _mockFriends = [
    {'id': 'friend1', 'name': 'Alice Johnson'},
    {'id': 'friend2', 'name': 'Bob Smith'},
    {'id': 'friend3', 'name': 'Charlie Brown'},
    {'id': 'friend4', 'name': 'Diana Prince'},
    {'id': 'friend5', 'name': 'Ethan Hunt'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group Trip'),
        backgroundColor: AppColors.crawlCrimson,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfo(),
              const SizedBox(height: AppDimensions.spaceXL),
              _buildTripTypeSelector(),
              const SizedBox(height: AppDimensions.spaceXL),
              _buildWaypointSection(),
              const SizedBox(height: AppDimensions.spaceXL),
              _buildFriendSelector(),
              const SizedBox(height: AppDimensions.spaceXL),
              _buildCreateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trip Details', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppDimensions.spaceM),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Trip Title',
            hintText: 'Enter a name for your group trip',
            prefixIcon: Icon(Icons.title),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a trip title';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTripTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trip Type', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppDimensions.spaceM),
        ...model.CoreType.values.map((type) {
          return RadioListTile<model.CoreType>(
            title: Text(_getTypeTitle(type)),
            subtitle: Text(_getTypeDescription(type)),
            value: type,
            groupValue: _selectedType,
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
                _selectedSubMode = null; // Reset submode when type changes
              });
            },
            activeColor: _getTypeColor(type),
          );
        }).toList(),
        if (_selectedType == model.CoreType.crawl) ...[
          const SizedBox(height: AppDimensions.spaceM),
          Text('Crawl Mode', style: AppTextStyles.sectionSubtitle),
          const SizedBox(height: AppDimensions.spaceS),
          Wrap(
            spacing: AppDimensions.spaceS,
            children: ['beer_golf', 'bar_hop', 'pub_crawl'].map((mode) {
              final isSelected = _selectedSubMode == mode;
              return FilterChip(
                label: Text(_getSubModeTitle(mode)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedSubMode = selected ? mode : null;
                  });
                },
                backgroundColor: isSelected ? AppColors.crawlCrimson.withOpacity(0.2) : null,
                selectedColor: AppColors.crawlCrimson.withOpacity(0.3),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildWaypointSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Waypoints', style: AppTextStyles.sectionTitle),
            IconButton(
              onPressed: _addWaypoint,
              icon: const Icon(Icons.add_location_alt),
              color: AppColors.crawlCrimson,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceM),
        if (_waypoints.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Column(
              children: [
                Icon(Icons.location_on, size: 48, color: AppColors.textSecond),
                const SizedBox(height: AppDimensions.spaceM),
                Text('No waypoints added yet', style: AppTextStyles.body),
                const SizedBox(height: AppDimensions.spaceS),
                Text('Tap the + button to add locations', style: AppTextStyles.caption),
              ],
            ),
          )
        else
          Column(
            children: _waypoints.asMap().entries.map((entry) {
              return _buildWaypointCard(entry.key, entry.value);
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildWaypointCard(int index, model.Waypoint waypoint) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceS),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.crawlCrimson,
          foregroundColor: Colors.white,
          child: Text('${index + 1}'),
        ),
        title: Text(waypoint.name),
        subtitle: waypoint.note.isNotEmpty ? Text(waypoint.note) : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeWaypoint(index),
        ),
      ),
    );
  }

  Widget _buildFriendSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Invite Friends', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppDimensions.spaceM),
        Text(
          'Select friends to invite to this group trip:',
          style: AppTextStyles.body,
        ),
        const SizedBox(height: AppDimensions.spaceM),
        ..._mockFriends.map((friend) {
          final isSelected = _selectedFriends.contains(friend['id']);
          return CheckboxListTile(
            title: Text(friend['name']!),
            value: isSelected,
            onChanged: (selected) {
              setState(() {
                if (selected == true) {
                  _selectedFriends.add(friend['id']!);
                } else {
                  _selectedFriends.remove(friend['id']);
                }
              });
            },
            activeColor: AppColors.crawlCrimson,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _createGroupTrip,
        icon: const Icon(Icons.group_add),
        label: const Text('Create Group Trip'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.crawlCrimson,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceL),
        ),
      ),
    );
  }

  void _addWaypoint() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Waypoint'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _waypointController,
              decoration: const InputDecoration(
                labelText: 'Waypoint Name',
                hintText: 'e.g., The Irish Pub',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_waypointController.text.trim().isNotEmpty) {
                setState(() {
                  _waypoints.add(model.Waypoint(
                    name: _waypointController.text.trim(),
                    note: '',
                    latitude: 40.7589 + (_waypoints.length * 0.001), // Mock coordinates
                    longitude: -73.9851 + (_waypoints.length * 0.001),
                  ));
                });
                _waypointController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeWaypoint(int index) {
    setState(() {
      _waypoints.removeAt(index);
    });
  }

  void _createGroupTrip() {
    if (!_formKey.currentState!.validate()) return;
    
    if (_waypoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one waypoint'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedFriends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one friend to invite'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final groupTrip = GroupTrip(
      id: 'group_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      waypoints: _waypoints,
      createdAt: DateTime.now(),
      coreType: _selectedType,
      participantIds: _selectedFriends,
      creatorId: 'current_user',
      status: GroupTripStatus.planned,
      userRoles: {
        'current_user': UserRole.creator,
        ..._selectedFriends.asMap().map((_, friendId) => MapEntry(friendId, UserRole.invited)),
      },
      subMode: _selectedSubMode ?? 'standard', // FIX: Provide default value for nullable String
    );

    // Save to Hive
    try {
      final box = Hive.box<GroupTrip>('group_trips');
      box.put(groupTrip.id, groupTrip);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group trip created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating group trip: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getTypeTitle(model.CoreType type) {
    switch (type) {
      case model.CoreType.explore:
        return 'Explore';
      case model.CoreType.crawl:
        return 'Crawl';
      case model.CoreType.sport:
        return 'Sport';
    }
  }

  String _getTypeDescription(model.CoreType type) {
    switch (type) {
      case model.CoreType.explore:
        return 'Sightseeing and discovery adventures';
      case model.CoreType.crawl:
        return 'Social nightlife and bar experiences';
      case model.CoreType.sport:
        return 'Competitive events with scoring';
    }
  }

  Color _getTypeColor(model.CoreType type) {
    switch (type) {
      case model.CoreType.explore:
        return AppColors.exploreTeal;
      case model.CoreType.crawl:
        return AppColors.crawlCrimson;
      case model.CoreType.sport:
        return AppColors.sportGold;
    }
  }

  String _getSubModeTitle(String mode) {
    switch (mode) {
      case 'beer_golf':
        return 'Beer Golf';
      case 'bar_hop':
        return 'Bar Hop';
      case 'pub_crawl':
        return 'Pub Crawl';
      default:
        return mode;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _waypointController.dispose();
    super.dispose();
  }
}