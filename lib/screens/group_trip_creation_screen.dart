// lib/screens/group_trip_creation_screen.dart
import 'package:flutter/material.dart';
import '../models/trip.dart' as model;
import '../models/group_trip.dart';
import '../theme/app_theme.dart';

class GroupTripCreationScreen extends StatefulWidget {
  const GroupTripCreationScreen({Key? key}) : super(key: key);

  @override
  _GroupTripCreationScreenState createState() => _GroupTripCreationScreenState();
}

class _GroupTripCreationScreenState extends State<GroupTripCreationScreen> {
  String _tripTitle = '';
  model.CoreType _selectedType = model.CoreType.explore;
  List<String> _selectedFriends = [];
  final List<model.Waypoint> _waypoints = [];

  // Mock friends data - replace with real friend system later
  final List<Map<String, String>> _mockFriends = [
    {'id': 'friend1', 'name': 'Alex Chen', 'avatar': '👤'},
    {'id': 'friend2', 'name': 'Maya Rodriguez', 'avatar': '👤'},
    {'id': 'friend3', 'name': 'Sam Johnson', 'avatar': '👤'},
    {'id': 'friend4', 'name': 'Jordan Lee', 'avatar': '👤'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group Trip'),
        backgroundColor: AppColors.card,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Type Selection
            _buildTripTypeSection(),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Trip Title
            _buildTitleSection(),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Friend Selection
            _buildFriendSelectionSection(),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Quick Waypoints (simplified for now)
            _buildWaypointsSection(),
            
            const SizedBox(height: AppDimensions.spaceXL),
            
            // Create Trip Button
            _buildCreateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTripTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trip Type', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppDimensions.spaceM),
        Row(
          children: model.CoreType.values.map((type) {
            final helper = TripTypeHelper.fromCoreType(type);
            final isSelected = _selectedType == type;
            
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedType = type),
                child: Container(
                  margin: const EdgeInsets.only(right: AppDimensions.spaceS),
                  padding: const EdgeInsets.all(AppDimensions.spaceM),
                  decoration: BoxDecoration(
                    color: isSelected ? helper.color.withOpacity(0.1) : AppColors.card,
                    border: Border.all(
                      color: isSelected ? helper.color : AppColors.border,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Column(
                    children: [
                      Icon(helper.icon, color: helper.color, size: 32),
                      const SizedBox(height: AppDimensions.spaceS),
                      Text(
                        helper.displayName,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: isSelected ? helper.color : AppColors.textMain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trip Title', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppDimensions.spaceM),
        TextField(
          onChanged: (value) => setState(() => _tripTitle = value),
          decoration: InputDecoration(
            hintText: 'Enter trip title...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            filled: true,
            fillColor: AppColors.card,
          ),
        ),
      ],
    );
  }

  Widget _buildFriendSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Invite Friends', style: AppTextStyles.sectionTitle),
            Text(
              '${_selectedFriends.length} selected',
              style: AppTextStyles.cardSubtitle,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceM),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _mockFriends.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final friend = _mockFriends[index];
              final isSelected = _selectedFriends.contains(friend['id']);
              
              return ListTile(
                leading: CircleAvatar(
                  child: Text(friend['avatar']!),
                ),
                title: Text(friend['name']!),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedFriends.add(friend['id']!);
                      } else {
                        _selectedFriends.remove(friend['id']!);
                      }
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedFriends.remove(friend['id']!);
                    } else {
                      _selectedFriends.add(friend['id']!);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWaypointsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Waypoints', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppDimensions.spaceM),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Column(
            children: [
              Icon(
                Icons.add_location,
                size: 48,
                color: AppColors.textSecond,
              ),
              const SizedBox(height: AppDimensions.spaceM),
              Text(
                'Add Waypoints',
                style: AppTextStyles.cardTitle,
              ),
              const SizedBox(height: AppDimensions.spaceS),
              Text(
                'Use map creation or quick templates',
                style: AppTextStyles.cardSubtitle,
              ),
              const SizedBox(height: AppDimensions.spaceM),
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to map creation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Map creation coming soon!')),
                  );
                },
                child: const Text('Add Waypoints'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    final canCreate = _tripTitle.isNotEmpty && _selectedFriends.isNotEmpty;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canCreate ? _createGroupTrip : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: TripTypeHelper.fromCoreType(_selectedType).color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
        ),
        child: Text(
          'Create Group Trip',
          style: AppTextStyles.buttonText,
        ),
      ),
    );
  }

  void _createGroupTrip() {
    // Create the group trip
    final groupTrip = GroupTrip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _tripTitle,
      waypoints: _waypoints,
      createdAt: DateTime.now(),
      coreType: _selectedType,
      participantIds: _selectedFriends,
      creatorId: 'current_user', // TODO: Get actual current user ID
      status: GroupTripStatus.planned,
      userRoles: {
        'current_user': UserRole.creator,
        ..._selectedFriends.asMap().map((_, friendId) => 
          MapEntry(friendId, UserRole.invited)),
      },
      invitedAt: DateTime.now(),
    );

    // TODO: Save to database and send invitations
    
    Navigator.pop(context, groupTrip);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Group trip created! Invitations sent to ${_selectedFriends.length} friends.'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}