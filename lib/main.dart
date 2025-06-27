// lib/main.dart - FINAL FIXED VERSION
// All parameter issues resolved, clean syntax

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math' as math;

// Core models and utilities
import 'models/trip.dart' as model;
import 'models/trail_data.dart';
import 'utils/data_migration.dart';
import 'screens/main_navigation_screen.dart';
import 'theme/app_theme.dart';

// NEW: Advanced feature models
import 'models/group_trip.dart';
import 'models/infection_game.dart';

// Existing screens that we know work
import 'screens/badge_wall_screen.dart';

// Authentication screens
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';

// Social screens
import 'screens/friends_screen.dart';
import 'screens/friend_profile_screen.dart';
import 'screens/activity_feed_screen.dart';
import 'screens/friend_search_screen.dart';

// Competition screens
import 'screens/leaderboard_screen.dart';
import 'screens/challenge_list_screen.dart';
import 'screens/challenge_detail_screen.dart';
import 'screens/challenge_create_screen.dart';
import 'screens/challenge_leaderboard_screen.dart';

// Discovery screens
import 'screens/community_hub_screen.dart';
import 'screens/trip_template_screen.dart';

// Utility screens
import 'screens/settings_screen.dart';
import 'screens/help_feedback_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/stats_detail_screen.dart';
import 'screens/badge_detail_screen.dart';
import 'screens/trip_active_screen.dart';

// NEW: Group trip screens
import 'screens/group_trip_creation_screen.dart';
import 'screens/group_trip_invite_screen.dart';
import 'screens/group_scorecard_screen.dart';
import 'screens/group_trip_lobby_screen.dart';

// NEW: Infection game screens
import 'screens/infection_lobby_screen.dart';
import 'screens/infection_map_config_screen.dart';
import 'screens/infection_game_screen.dart';
import 'screens/infection_results_screen.dart';

// NEW: Bar wait time screens
import 'screens/bar_wait_report_screen.dart';
import 'screens/bar_detail_enhanced_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Hive
    await Hive.initFlutter();

    // EXISTING: Register core adapters
    Hive.registerAdapter(model.TripTypeAdapter());      // typeId: 0 (old)
    Hive.registerAdapter(model.WaypointAdapter());      // typeId: 1
    Hive.registerAdapter(model.TripAdapter());          // typeId: 2 (updated)
    Hive.registerAdapter(model.BadgeAdapter());         // typeId: 3 (updated)
    Hive.registerAdapter(model.CoreTypeAdapter());      // typeId: 4 (new)
    Hive.registerAdapter(model.ScoreCardAdapter());     // typeId: 5 (new)
    
    // EXISTING: Trail data adapters
    Hive.registerAdapter(TrailPointAdapter());          // typeId: 6
    Hive.registerAdapter(TrailStatsAdapter());          // typeId: 7
    Hive.registerAdapter(TrailDataAdapter());           // typeId: 8

    // NEW: Group trip adapters
    Hive.registerAdapter(GroupTripStatusAdapter());     // typeId: 9
    Hive.registerAdapter(UserRoleAdapter());            // typeId: 10
    Hive.registerAdapter(GroupTripAdapter());           // typeId: 11
    Hive.registerAdapter(ScoreEntryAdapter());          // typeId: 12
    Hive.registerAdapter(SharedScoreCardAdapter());     // typeId: 13

    // NEW: Infection game adapters
    Hive.registerAdapter(InfectionModeAdapter());       // typeId: 14
    Hive.registerAdapter(PlayerRoleAdapter());          // typeId: 15
    Hive.registerAdapter(GameStatusAdapter());          // typeId: 16
    Hive.registerAdapter(GameActionAdapter());          // typeId: 17
    Hive.registerAdapter(PlayerStateAdapter());         // typeId: 18
    Hive.registerAdapter(GameBoundaryAdapter());        // typeId: 19
    Hive.registerAdapter(LatLngAdapter());              // typeId: 20
    Hive.registerAdapter(GameSessionAdapter());         // typeId: 21

    // Open existing boxes
    await Hive.openBox<model.Trip>('trips');
    await Hive.openBox<model.Badge>('badges');
    await Hive.openBox<model.ScoreCard>('scorecards');
    await Hive.openBox<TrailData>('trails');

    // NEW: Open advanced feature boxes
    await Hive.openBox<GroupTrip>('group_trips');
    await Hive.openBox<SharedScoreCard>('shared_scorecards');
    await Hive.openBox<GameSession>('infection_games');
    await Hive.openBox<PlayerState>('player_states');

    // Perform data migration if needed
    await DataMigration.performMigrationIfNeeded();

    debugPrint('✅ Hive initialization and migration completed successfully');
    debugPrint('📦 Loaded ${Hive.box<model.Trip>('trips').length} trips');
    debugPrint('🎮 Loaded ${Hive.box<GroupTrip>('group_trips').length} group trips');
    debugPrint('🦠 Loaded ${Hive.box<GameSession>('infection_games').length} infection games');

  } catch (e) {
    debugPrint('❌ Error during initialization: $e');
    
    // If there's a critical error, clear all data and start fresh
    try {
      // Clear existing boxes
      await Hive.deleteBoxFromDisk('trips');
      await Hive.deleteBoxFromDisk('badges');
      await Hive.deleteBoxFromDisk('scorecards');
      await Hive.deleteBoxFromDisk('trails');
      await Hive.deleteBoxFromDisk('settings');
      
      // Clear new feature boxes
      await Hive.deleteBoxFromDisk('group_trips');
      await Hive.deleteBoxFromDisk('shared_scorecards');
      await Hive.deleteBoxFromDisk('infection_games');
      await Hive.deleteBoxFromDisk('player_states');
      
      // Re-initialize
      await Hive.initFlutter();
      
      // Re-register all adapters
      Hive.registerAdapter(model.TripTypeAdapter());
      Hive.registerAdapter(model.WaypointAdapter());
      Hive.registerAdapter(model.TripAdapter());
      Hive.registerAdapter(model.BadgeAdapter());
      Hive.registerAdapter(model.CoreTypeAdapter());
      Hive.registerAdapter(model.ScoreCardAdapter());
      Hive.registerAdapter(TrailPointAdapter());
      Hive.registerAdapter(TrailStatsAdapter());
      Hive.registerAdapter(TrailDataAdapter());
      
      // Re-register new adapters
      Hive.registerAdapter(GroupTripStatusAdapter());
      Hive.registerAdapter(UserRoleAdapter());
      Hive.registerAdapter(GroupTripAdapter());
      Hive.registerAdapter(ScoreEntryAdapter());
      Hive.registerAdapter(SharedScoreCardAdapter());
      Hive.registerAdapter(InfectionModeAdapter());
      Hive.registerAdapter(PlayerRoleAdapter());
      Hive.registerAdapter(GameStatusAdapter());
      Hive.registerAdapter(GameActionAdapter());
      Hive.registerAdapter(PlayerStateAdapter());
      Hive.registerAdapter(GameBoundaryAdapter());
      Hive.registerAdapter(LatLngAdapter());
      Hive.registerAdapter(GameSessionAdapter());
      
      // Re-open all boxes
      await Hive.openBox<model.Trip>('trips');
      await Hive.openBox<model.Badge>('badges');
      await Hive.openBox<model.ScoreCard>('scorecards');
      await Hive.openBox<TrailData>('trails');
      await Hive.openBox<GroupTrip>('group_trips');
      await Hive.openBox<SharedScoreCard>('shared_scorecards');
      await Hive.openBox<GameSession>('infection_games');
      await Hive.openBox<PlayerState>('player_states');
      
      // Create sample data for testing
      await DataMigration.createSampleDataNewSystem();
      await _createSampleAdvancedData();
      
      debugPrint('🔄 Fresh start completed with sample data');
    } catch (resetError) {
      debugPrint('💥 Critical error during reset: $resetError');
    }
  }

  runApp(const FieldTripApp());
}

// NEW: Create sample data for advanced features
Future<void> _createSampleAdvancedData() async {
  try {
    final groupTripBox = Hive.box<GroupTrip>('group_trips');
    final gameSessionBox = Hive.box<GameSession>('infection_games');
    
    // Sample group trip
    final sampleGroupTrip = GroupTrip(
      id: 'sample_group_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Downtown Bar Crawl Squad',
      waypoints: [
        model.Waypoint(
          name: 'The Tipsy Cow',
          note: 'Start here - great happy hour',
          latitude: 40.7589,
          longitude: -73.9851,
        ),
        model.Waypoint(
          name: 'Rooftop Lounge',
          note: 'Mid-point with city views',
          latitude: 40.7549,
          longitude: -73.9840,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      coreType: model.CoreType.crawl,
      participantIds: ['friend1', 'friend2', 'friend3'],
      creatorId: 'current_user',
      status: GroupTripStatus.planned,
      userRoles: {
        'current_user': UserRole.creator,
        'friend1': UserRole.participant,
        'friend2': UserRole.invited,
        'friend3': UserRole.participant,
      },
      subMode: 'beer_golf',
    );
    
    await groupTripBox.put(sampleGroupTrip.id, sampleGroupTrip);
    
    // Sample infection game session
    final sampleGameSession = GameSession(
      id: 'sample_game_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Campus Infection Battle',
      mode: InfectionMode.freeForAll,
      players: [
        PlayerState(
          userId: 'current_user',
          displayName: 'You',
          role: PlayerRole.runner,
          actions: [],
        ),
        PlayerState(
          userId: 'player2',
          displayName: 'Alex',
          role: PlayerRole.infected,
          actions: [],
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      rules: {
        'maxPlayers': 20,
        'initialInfected': 1,
        'tagRange': 10.0,
        'gameDuration': 1800, // 30 minutes
      },
      status: GameStatus.lobby,
      creatorId: 'current_user',
      gameLog: [],
    );
    
    await gameSessionBox.put(sampleGameSession.id, sampleGameSession);
    
    debugPrint('📝 Created sample advanced data:');
    debugPrint('   • 1 group trip (${sampleGroupTrip.title})');
    debugPrint('   • 1 infection game (${sampleGameSession.name})');
    
  } catch (e) {
    debugPrint('❌ Failed to create sample advanced data: $e');
  }
}

class FieldTripApp extends StatelessWidget {
  const FieldTripApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Trip',
      theme: AppTheme.theme,
      home: const MainNavigationScreen(),
      routes: {
        // EXISTING: Core app routes
        '/home': (context) => const MainNavigationScreen(),
        '/badges': (context) => const BadgeWallScreen(),
        
        // EXISTING: Authentication routes
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        
        // EXISTING: Social routes
        '/friends': (context) => const FriendsScreen(),
        '/activity-feed': (context) => const ActivityFeedScreen(),
        '/friend-search': (context) => const FriendSearchScreen(),
        
        // EXISTING: Competition routes
        '/leaderboard': (context) => const LeaderboardScreen(),
        '/challenges': (context) => const ChallengeListScreen(),
        '/challenge-create': (context) => const ChallengeCreateScreen(),
        
        // EXISTING: Discovery routes
        '/community-hub': (context) => const CommunityHubScreen(),
        '/trip-templates': (context) => const TripTemplateScreen(),
        
        // EXISTING: Utility routes
        '/settings': (context) => const SettingsScreen(),
        '/help': (context) => const HelpFeedbackScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/stats': (context) => const StatsDetailScreen(),

        // NEW: Group trip routes
        '/group-trip-create': (context) => const GroupTripCreationScreen(),
        '/group-scorecard': (context) => const GroupScorecardScreen(),

        // NEW: Infection game routes
        '/infection-lobby': (context) => const InfectionLobbyScreen(),
        '/infection-map-config': (context) => const InfectionMapConfigScreen(),
        '/infection-game': (context) => const InfectionGameScreen(),
        '/infection-results': (context) => const InfectionResultsScreen(),

        // NEW: Bar wait time routes
        '/bar-wait-report': (context) => const BarWaitReportScreen(),
      },
      onGenerateRoute: (settings) {
        // Handle routes with parameters
        final uri = Uri.parse(settings.name!);
        
        switch (uri.path) {
          // EXISTING: Parameterized routes - FIXED TO USE STRING PARAMETERS
          case '/friend-profile':
            final friendId = uri.queryParameters['id'] ?? '';
            return MaterialPageRoute(
              builder: (_) => FriendProfileScreen(friendId: friendId), // FIXED: String parameter
            );
            
          case '/challenge-detail':
            final challengeId = uri.queryParameters['id'] ?? '';
            return MaterialPageRoute(
              builder: (_) => ChallengeDetailScreen(challengeId: challengeId), // FIXED: String parameter
            );
            
          case '/challenge-leaderboard':
            final challengeId = uri.queryParameters['id'] ?? '';
            return MaterialPageRoute(
              builder: (_) => ChallengeLeaderboardScreen(challengeId: challengeId),
            );
            
          case '/badge-detail':
            final mockBadge = model.Badge(
              id: 'temp',
              tripId: 'temp',
              label: 'Sample Badge',
              earnedAt: DateTime.now(),
              coreType: model.CoreType.explore,
            );
            return MaterialPageRoute(
              builder: (_) => BadgeDetailScreen(badge: mockBadge),
            );
            
          case '/trip-active':
            final mockTrip = model.Trip(
              id: 'temp',
              title: 'Sample Trip',
              waypoints: [],
              createdAt: DateTime.now(),
              coreType: model.CoreType.explore,
            );
            return MaterialPageRoute(
              builder: (_) => TripActiveScreen(trip: mockTrip),
            );

          // NEW: Group trip parameterized routes
          case '/group-trip-invite':
            final tripId = uri.queryParameters['tripId'] ?? '';
            final groupTripBox = Hive.box<GroupTrip>('group_trips');
            GroupTrip? groupTrip;
            
            try {
              groupTrip = groupTripBox.values.firstWhere((trip) => trip.id == tripId);
            } catch (e) {
              // Create mock group trip if not found
              groupTrip = GroupTrip(
                id: 'mock',
                title: 'Sample Group Trip',
                waypoints: [],
                createdAt: DateTime.now(),
                coreType: model.CoreType.explore,
                participantIds: [],
                creatorId: 'mock_user',
                status: GroupTripStatus.planned,
                userRoles: {},
              );
            }
            
            return MaterialPageRoute(
              builder: (_) => GroupTripInviteScreen(groupTrip: groupTrip!),
            );

          case '/group-trip-lobby':
          case '/group-trip-detail':
            final tripId = uri.queryParameters['tripId'] ?? '';
            final groupTripBox = Hive.box<GroupTrip>('group_trips');
            GroupTrip? groupTrip;
            
            try {
              groupTrip = groupTripBox.values.firstWhere((trip) => trip.id == tripId);
            } catch (e) {
              // Create mock group trip if not found
              groupTrip = GroupTrip(
                id: tripId,
                title: 'Sample Group Trip',
                waypoints: [],
                createdAt: DateTime.now(),
                coreType: model.CoreType.crawl,
                participantIds: ['friend1', 'friend2'],
                creatorId: 'current_user',
                status: GroupTripStatus.active,
                userRoles: {
                  'current_user': UserRole.creator,
                  'friend1': UserRole.participant,
                  'friend2': UserRole.participant,
                },
              );
            }
            
            return MaterialPageRoute(
              builder: (_) => GroupTripLobbyScreen(groupTrip: groupTrip!),
            );

          // NEW: Infection game parameterized routes
          case '/infection-lobby-join':
            final gameId = uri.queryParameters['gameId'] ?? '';
            final gameSessionBox = Hive.box<GameSession>('infection_games');
            GameSession? gameSession;
            
            try {
              gameSession = gameSessionBox.values.firstWhere((game) => game.id == gameId);
            } catch (e) {
              // Create mock game session if not found
              gameSession = GameSession(
                id: gameId,
                name: 'Sample Infection Game',
                mode: InfectionMode.freeForAll,
                players: [],
                createdAt: DateTime.now(),
                rules: {},
                status: GameStatus.lobby,
                creatorId: 'mock_user',
                gameLog: [],
              );
            }
            
            return MaterialPageRoute(
              builder: (_) => InfectionLobbyScreen(existingSession: gameSession),
            );

          case '/infection-game-active':
            return MaterialPageRoute(
              builder: (_) => const InfectionGameScreen(),
            );

          // NEW: Bar wait time parameterized routes
          case '/bar-detail':
          case '/bar-detail-enhanced':
            final barId = uri.queryParameters['barId'] ?? 'default_bar';
            return MaterialPageRoute(
              builder: (_) => BarDetailEnhancedScreen(barId: barId),
            );

          case '/bar-wait-report-venue':
            final venueId = uri.queryParameters['venueId'] ?? '';
            return MaterialPageRoute(
              builder: (_) => BarWaitReportScreen(venueId: venueId),
            );
        }
        
        return null;
      },
    );
  }
}

// NEW: Enhanced navigation helper with advanced features
class AdvancedNavigationHelper {
  // Group trip navigation
  static Future<void> navigateToGroupTripCreation(BuildContext context) {
    return Navigator.pushNamed(context, '/group-trip-create');
  }
  
  static Future<void> navigateToGroupTripInvite(BuildContext context, String tripId) {
    return Navigator.pushNamed(context, '/group-trip-invite?tripId=$tripId');
  }
  
  static Future<void> navigateToGroupTripDetail(BuildContext context, String tripId) {
    return Navigator.pushNamed(context, '/group-trip-detail?tripId=$tripId');
  }

  // Infection game navigation
  static Future<void> navigateToInfectionLobby(BuildContext context) {
    return Navigator.pushNamed(context, '/infection-lobby');
  }
  
  static Future<void> joinInfectionGame(BuildContext context, String gameId) {
    return Navigator.pushNamed(context, '/infection-lobby-join?gameId=$gameId');
  }
  
  static Future<void> navigateToActiveInfectionGame(BuildContext context, String gameId) {
    return Navigator.pushNamed(context, '/infection-game-active?gameId=$gameId');
  }

  // Bar wait time navigation
  static Future<void> navigateToBarDetail(BuildContext context, String barId) {
    return Navigator.pushNamed(context, '/bar-detail?barId=$barId');
  }
  
  static Future<void> reportBarWaitTime(BuildContext context, String venueId) {
    return Navigator.pushNamed(context, '/bar-wait-report-venue?venueId=$venueId');
  }

  // Quick action menus
  static void showGroupTripMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Group Trips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('Create Group Trip'),
              onTap: () {
                Navigator.pop(context);
                navigateToGroupTripCreation(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('My Group Trips'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to group trip list
              },
            ),
            ListTile(
              leading: const Icon(Icons.scoreboard),
              title: const Text('Group Scorecard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/group-scorecard');
              },
            ),
          ],
        ),
      ),
    );
  }
  
  static void showInfectionGameMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Infection Games',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text('Create Game'),
              onTap: () {
                Navigator.pop(context);
                navigateToInfectionLobby(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Join Game'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show game search/join interface
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Game History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/infection-results');
              },
            ),
          ],
        ),
      ),
    );
  }
}