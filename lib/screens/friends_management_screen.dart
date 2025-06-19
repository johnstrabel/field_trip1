// lib/screens/friends_management_screen.dart - Complete version with navigation wiring

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class FriendsManagementScreen extends StatefulWidget {
  const FriendsManagementScreen({Key? key}) : super(key: key);

  @override
  _FriendsManagementScreenState createState() => _FriendsManagementScreenState();
}

class _FriendsManagementScreenState extends State<FriendsManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data - replace with real data later
  final List<FriendModel> _friends = [
    FriendModel(
      id: '1',
      name: 'Alex Chen',
      username: '@alexc',
      avatar: Icons.person,
      isOnline: true,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
      mutualFriends: 3,
      tripCount: 12,
    ),
    FriendModel(
      id: '2',
      name: 'Maya Rodriguez',
      username: '@maya_explores',
      avatar: Icons.person_2,
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      mutualFriends: 1,
      tripCount: 8,
    ),
    FriendModel(
      id: '3',
      name: 'Sam Johnson',
      username: '@sam_adventures',
      avatar: Icons.person_3,
      isOnline: true,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 1)),
      mutualFriends: 5,
      tripCount: 15,
    ),
  ];

  final List<FriendRequest> _pendingRequests = [
    FriendRequest(
      id: '1',
      name: 'Emma Wilson',
      username: '@emma_w',
      avatar: Icons.person_4,
      mutualFriends: 2,
      sentAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    FriendRequest(
      id: '2',
      name: 'David Park',
      username: '@david_explorer',
      avatar: Icons.person,
      mutualFriends: 1,
      sentAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Friends'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.amethyst600,
          labelColor: AppColors.amethyst600,
          unselectedLabelColor: AppColors.textSecond,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Friends'),
                  if (_friends.isNotEmpty) ...[
                    const SizedBox(width: AppDimensions.spaceXS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.amethyst600,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_friends.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Requests'),
                  if (_pendingRequests.isNotEmpty) ...[
                    const SizedBox(width: AppDimensions.spaceXS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.challengeCrimson,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_pendingRequests.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Add Friends Section
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search friends...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.card,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                
                const SizedBox(height: AppDimensions.spaceM),
                
                // Add Friends Options
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.qr_code,
                        label: 'Show QR',
                        onTap: _showQRCode,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.qr_code_scanner,
                        label: 'Scan QR',
                        onTap: _scanQRCode,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.person_search,
                        label: 'Search',
                        onTap: _searchByUsername,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.contacts,
                        label: 'Contacts',
                        onTap: _importContacts,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsList(),
                _buildRequestsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    final filteredFriends = _friends.where((friend) {
      if (_searchQuery.isEmpty) return true;
      return friend.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             friend.username.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredFriends.isEmpty && _searchQuery.isEmpty) {
      return _buildEmptyFriendsState();
    }

    if (filteredFriends.isEmpty && _searchQuery.isNotEmpty) {
      return _buildNoSearchResults();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      itemCount: filteredFriends.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.spaceM),
      itemBuilder: (context, index) {
        final friend = filteredFriends[index];
        return _FriendCard(
          friend: friend,
          onTap: () => _viewFriendProfile(friend),
          onMessage: () => _messageFriend(friend),
          onChallenge: () => _challengeFriend(friend),
        );
      },
    );
  }

  Widget _buildRequestsList() {
    if (_pendingRequests.isEmpty) {
      return _buildEmptyRequestsState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      itemCount: _pendingRequests.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.spaceM),
      itemBuilder: (context, index) {
        final request = _pendingRequests[index];
        return _FriendRequestCard(
          request: request,
          onAccept: () => _acceptRequest(request),
          onDecline: () => _declineRequest(request),
        );
      },
    );
  }

  Widget _buildEmptyFriendsState() {
    return Padding(
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
                Icons.people_outline,
                size: 60,
                color: AppColors.amethyst600,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceL),
            Text(
              'No friends yet',
              style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              'Start connecting with fellow explorers using the options above. Share your QR code or scan others to begin building your adventure network!',
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRequestsState() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_add_outlined,
                size: 60,
                color: AppColors.info,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceL),
            Text(
              'No pending requests',
              style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              'Friend requests will appear here when other explorers want to connect with you.',
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60,
              color: AppColors.textSecond,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            Text(
              'No results found',
              style: AppTextStyles.cardTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              'Try searching with a different name or username.',
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to convert FriendModel to FriendProfile for navigation
  FriendProfile _friendModelToProfile(FriendModel friend) {
    return FriendProfile(
      id: friend.id,
      name: friend.name,
      username: friend.username,
      avatar: friend.avatar,
      isOnline: friend.isOnline,
      lastSeen: friend.lastSeen,
      totalTrips: friend.tripCount,
      badges: 8, // Mock data
      currentStreak: 5, // Mock data
      mutualFriends: friend.mutualFriends,
      isFollowing: true, // Mock data
      location: 'Unknown', // Mock data
      bio: 'Fellow explorer and adventurer',
    );
  }

  // Action Methods
  void _showQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('My QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(color: AppColors.stroke),
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code,
                  size: 150,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            const Text('Share this QR code with friends to connect instantly'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: 'fieldtrip://user/myprofile'));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile link copied to clipboard')),
              );
            },
            child: const Text('Copy Link'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _scanQRCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR code scanner would open here'),
        backgroundColor: AppColors.amethyst600,
      ),
    );
  }

  void _searchByUsername() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Username search coming soon!')),
    );
  }

  void _importContacts() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact import coming soon!')),
    );
  }

  void _viewFriendProfile(FriendModel friend) {
    final friendProfile = _friendModelToProfile(friend);
    Navigator.pushNamed(
      context,
      '/friend-profile',
      arguments: friendProfile,
    );
  }

  void _messageFriend(FriendModel friend) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening chat with ${friend.name}...')),
    );
  }

  void _challengeFriend(FriendModel friend) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Challenging ${friend.name}...')),
    );
  }

  void _acceptRequest(FriendRequest request) {
    setState(() {
      _pendingRequests.removeWhere((r) => r.id == request.id);
      _friends.add(FriendModel(
        id: request.id,
        name: request.name,
        username: request.username,
        avatar: request.avatar,
        isOnline: false,
        lastSeen: DateTime.now(),
        mutualFriends: request.mutualFriends,
        tripCount: 0,
      ));
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added ${request.name} as a friend!')),
    );
  }

  void _declineRequest(FriendRequest request) {
    setState(() {
      _pendingRequests.removeWhere((r) => r.id == request.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Declined friend request from ${request.name}')),
    );
  }
}

// Helper Widgets
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.amethyst600, size: 24),
            const SizedBox(height: AppDimensions.spaceXS),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.amethyst600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FriendCard extends StatelessWidget {
  final FriendModel friend;
  final VoidCallback onTap;
  final VoidCallback onMessage;
  final VoidCallback onChallenge;

  const _FriendCard({
    required this.friend,
    required this.onTap,
    required this.onMessage,
    required this.onChallenge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar with online status
                Stack(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.amethyst100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        friend.avatar,
                        color: AppColors.amethyst600,
                        size: 24,
                      ),
                    ),
                    if (friend.isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(width: AppDimensions.spaceM),
                
                // Friend info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(friend.name, style: AppTextStyles.cardTitle),
                      Text(friend.username, style: AppTextStyles.cardSubtitle),
                      const SizedBox(height: AppDimensions.spaceXS),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 14,
                            color: AppColors.textSecond,
                          ),
                          const SizedBox(width: AppDimensions.spaceXS),
                          Text(
                            '${friend.mutualFriends} mutual',
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(width: AppDimensions.spaceM),
                          Icon(
                            Icons.map,
                            size: 14,
                            color: AppColors.textSecond,
                          ),
                          const SizedBox(width: AppDimensions.spaceXS),
                          Text(
                            '${friend.tripCount} trips',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Status indicator
                Column(
                  children: [
                    Text(
                      friend.isOnline ? 'Online' : _formatLastSeen(friend.lastSeen),
                      style: AppTextStyles.caption.copyWith(
                        color: friend.isOnline ? AppColors.success : AppColors.textSecond,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spaceM),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onMessage,
                    icon: const Icon(Icons.message, size: 16),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceS),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onChallenge,
                    icon: const Icon(Icons.emoji_events, size: 16),
                    label: const Text('Challenge'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.amethyst600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceS),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class _FriendRequestCard extends StatelessWidget {
  final FriendRequest request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _FriendRequestCard({
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.challengeCrimson.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.challengeCrimson.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  request.avatar,
                  color: AppColors.challengeCrimson,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: AppDimensions.spaceM),
              
              // Request info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.name, style: AppTextStyles.cardTitle),
                    Text(request.username, style: AppTextStyles.cardSubtitle),
                    const SizedBox(height: AppDimensions.spaceXS),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 14,
                          color: AppColors.textSecond,
                        ),
                        const SizedBox(width: AppDimensions.spaceXS),
                        Text(
                          '${request.mutualFriends} mutual friends',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Time indicator
              Text(
                _formatRequestTime(request.sentAt),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecond,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spaceM),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  child: const Text('Decline'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceS),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  child: const Text('Accept'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceS),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatRequestTime(DateTime sentAt) {
    final now = DateTime.now();
    final difference = now.difference(sentAt);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

// Data Models
class FriendModel {
  final String id;
  final String name;
  final String username;
  final IconData avatar;
  final bool isOnline;
  final DateTime lastSeen;
  final int mutualFriends;
  final int tripCount;

  FriendModel({
    required this.id,
    required this.name,
    required this.username,
    required this.avatar,
    required this.isOnline,
    required this.lastSeen,
    required this.mutualFriends,
    required this.tripCount,
  });
}

class FriendRequest {
  final String id;
  final String name;
  final String username;
  final IconData avatar;
  final int mutualFriends;
  final DateTime sentAt;

  FriendRequest({
    required this.id,
    required this.name,
    required this.username,
    required this.avatar,
    required this.mutualFriends,
    required this.sentAt,
  });
}

class FriendProfile {
  final String id;
  final String name;
  final String username;
  final IconData avatar;
  final bool isOnline;
  final DateTime lastSeen;
  final int totalTrips;
  final int badges;
  final int currentStreak;
  final int mutualFriends;
  final bool isFollowing;
  final String location;
  final String bio;

  FriendProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.avatar,
    required this.isOnline,
    required this.lastSeen,
    required this.totalTrips,
    required this.badges,
    required this.currentStreak,
    required this.mutualFriends,
    required this.isFollowing,
    required this.location,
    required this.bio,
  });
}