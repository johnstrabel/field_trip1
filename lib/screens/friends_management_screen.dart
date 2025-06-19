// lib/screens/friends_management_screen.dart

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
      requestTime: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    FriendRequest(
      id: '2',
      name: 'Jake Miller',
      username: '@jake_hikes',
      avatar: Icons.person,
      mutualFriends: 0,
      requestTime: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        backgroundColor: AppColors.card,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: _showQRCode,
            tooltip: 'My QR Code',
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanQRCode,
            tooltip: 'Scan QR Code',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.amethyst600,
          labelColor: AppColors.amethyst600,
          unselectedLabelColor: AppColors.textSecond,
          tabs: [
            Tab(
              text: 'Friends (${_friends.length})',
              icon: const Icon(Icons.people, size: 20),
            ),
            Tab(
              text: 'Requests (${_pendingRequests.length})',
              icon: const Icon(Icons.person_add, size: 20),
            ),
            const Tab(
              text: 'Add Friends',
              icon: Icon(Icons.search, size: 20),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsTab(),
          _buildRequestsTab(),
          _buildAddFriendsTab(),
        ],
      ),
    );
  }

  Widget _buildFriendsTab() {
    final filteredFriends = _friends.where((friend) {
      return friend.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          friend.username.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search friends...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
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
        ),

        // Friends List
        Expanded(
          child: filteredFriends.isEmpty
              ? _buildEmptyFriendsState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
                  itemCount: filteredFriends.length,
                  itemBuilder: (context, index) {
                    return _FriendCard(
                      friend: filteredFriends[index],
                      onTap: () => _viewFriendProfile(filteredFriends[index]),
                      onMessage: () => _messageFriend(filteredFriends[index]),
                      onChallenge: () => _challengeFriend(filteredFriends[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRequestsTab() {
    return _pendingRequests.isEmpty
        ? _buildEmptyRequestsState()
        : ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            itemCount: _pendingRequests.length,
            itemBuilder: (context, index) {
              return _FriendRequestCard(
                request: _pendingRequests[index],
                onAccept: () => _acceptFriendRequest(_pendingRequests[index]),
                onDecline: () => _declineFriendRequest(_pendingRequests[index]),
              );
            },
          );
  }

  Widget _buildAddFriendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // QR Code Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.amethyst600, AppColors.amethyst100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.qr_code,
                  color: Colors.white,
                  size: 64,
                ),
                const SizedBox(height: AppDimensions.spaceM),
                Text(
                  'Share Your QR Code',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceS),
                Text(
                  'Let friends scan your code to add you instantly',
                  style: AppTextStyles.cardSubtitle.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spaceL),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showQRCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.amethyst600,
                        ),
                        icon: const Icon(Icons.qr_code, size: 20),
                        label: const Text('Show QR'),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _scanQRCode,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                        ),
                        icon: const Icon(Icons.qr_code_scanner, size: 20),
                        label: const Text('Scan QR'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spaceL),

          // Search by Username
          Text(
            'Search by Username',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter username (e.g., @username)',
              prefixIcon: const Icon(Icons.alternate_email),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _searchByUsername,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spaceL),

          // Suggested Friends
          Text(
            'Suggested Friends',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          _buildSuggestedFriends(),

          const SizedBox(height: AppDimensions.spaceL),

          // Import Contacts
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.contacts,
                  color: AppColors.amethyst600,
                  size: 48,
                ),
                const SizedBox(height: AppDimensions.spaceM),
                Text(
                  'Import from Contacts',
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: AppDimensions.spaceS),
                Text(
                  'Find friends who are already using Field Trip',
                  style: AppTextStyles.cardSubtitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spaceL),
                ElevatedButton.icon(
                  onPressed: _importContacts,
                  icon: const Icon(Icons.contacts),
                  label: const Text('Import Contacts'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amethyst600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedFriends() {
    final suggestions = [
      FriendSuggestion(
        name: 'Jordan Smith',
        username: '@jordan_trails',
        avatar: Icons.person,
        mutualFriends: 2,
        reason: '2 mutual friends',
      ),
      FriendSuggestion(
        name: 'Casey Taylor',
        username: '@casey_adventures',
        avatar: Icons.person_2,
        mutualFriends: 1,
        reason: 'Similar interests',
      ),
    ];

    return Column(
      children: suggestions.map((suggestion) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.amethyst100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  suggestion.avatar,
                  color: AppColors.amethyst600,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(suggestion.name, style: AppTextStyles.cardTitle),
                    Text(suggestion.username, style: AppTextStyles.caption),
                    Text(suggestion.reason, style: AppTextStyles.cardSubtitle),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => _sendFriendRequest(suggestion),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.amethyst600,
                  side: BorderSide(color: AppColors.amethyst600),
                ),
                child: const Text('Add'),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyFriendsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.textSecond,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            Text(
              'No Friends Yet',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              'Start building your exploration network by adding friends!',
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(2),
              icon: const Icon(Icons.person_add),
              label: const Text('Add Friends'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRequestsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.textSecond,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            Text(
              'No Friend Requests',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              'Friend requests will appear here when someone wants to connect with you.',
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${friend.name}\'s profile...')),
    );
  }

  void _messageFriend(FriendModel friend) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Messaging ${friend.name}...')),
    );
  }

  void _challengeFriend(FriendModel friend) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Challenging ${friend.name}...')),
    );
  }

  void _acceptFriendRequest(FriendRequest request) {
    setState(() {
      _pendingRequests.remove(request);
      // Add to friends list
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
      SnackBar(content: Text('${request.name} is now your friend!')),
    );
  }

  void _declineFriendRequest(FriendRequest request) {
    setState(() {
      _pendingRequests.remove(request);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Declined ${request.name}\'s friend request')),
    );
  }

  void _sendFriendRequest(FriendSuggestion suggestion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend request sent to ${suggestion.name}!')),
    );
  }
}

// Helper Widgets
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
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.spaceM),
        leading: Stack(
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
        title: Text(friend.name, style: AppTextStyles.cardTitle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(friend.username, style: AppTextStyles.caption),
            Text(
              friend.isOnline ? 'Online' : _formatLastSeen(friend.lastSeen),
              style: AppTextStyles.cardSubtitle.copyWith(
                color: friend.isOnline ? AppColors.success : AppColors.textSecond,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: onMessage,
              child: const Row(
                children: [
                  Icon(Icons.message),
                  SizedBox(width: 8),
                  Text('Message'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: onChallenge,
              child: const Row(
                children: [
                  Icon(Icons.emoji_events),
                  SizedBox(width: 8),
                  Text('Challenge'),
                ],
              ),
            ),
          ],
        ),
        onTap: onTap,
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
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.amethyst600.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.amethyst100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  request.avatar,
                  color: AppColors.amethyst600,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.name, style: AppTextStyles.cardTitle),
                    Text(request.username, style: AppTextStyles.caption),
                    if (request.mutualFriends > 0)
                      Text(
                        '${request.mutualFriends} mutual friends',
                        style: AppTextStyles.cardSubtitle,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDecline,
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Decline'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAccept,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Accept'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amethyst600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
  final DateTime requestTime;

  FriendRequest({
    required this.id,
    required this.name,
    required this.username,
    required this.avatar,
    required this.mutualFriends,
    required this.requestTime,
  });
}

class FriendSuggestion {
  final String name;
  final String username;
  final IconData avatar;
  final int mutualFriends;
  final String reason;

  FriendSuggestion({
    required this.name,
    required this.username,
    required this.avatar,
    required this.mutualFriends,
    required this.reason,
  });
}