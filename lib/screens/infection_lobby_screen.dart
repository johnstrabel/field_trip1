// lib/screens/infection_lobby_screen.dart - FIXED VERSION
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/infection_game.dart';
import '../theme/app_theme.dart';

class InfectionLobbyScreen extends StatefulWidget {
  final GameSession? existingSession;
  
  const InfectionLobbyScreen({
    super.key,
    this.existingSession,
  });

  @override
  State<InfectionLobbyScreen> createState() => _InfectionLobbyScreenState();
}

class _InfectionLobbyScreenState extends State<InfectionLobbyScreen> {
  late GameSession _gameSession;
  late Duration _gameDuration;
  final TextEditingController _gameNameController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    if (widget.existingSession != null) {
      _gameSession = widget.existingSession!;
      _gameNameController.text = _gameSession.name;
    } else {
      _createNewSession();
    }
    _gameDuration = Duration(seconds: _gameSession.rules['gameDuration'] ?? 1800);
  }
  
  void _createNewSession() {
    _gameSession = GameSession(
      id: 'game_${DateTime.now().millisecondsSinceEpoch}',
      name: 'New Infection Game',
      mode: InfectionMode.freeForAll,
      players: [],
      createdAt: DateTime.now(),
      rules: {
        'maxPlayers': 10,
        'initialInfected': 1,
        'tagRange': 10.0,
        'gameDuration': 1800, // 30 minutes
      },
      status: GameStatus.lobby,
      creatorId: 'current_user',
      gameLog: [],
    );
    _gameNameController.text = _gameSession.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infection Game Lobby'),
        backgroundColor: AppColors.crawlCrimson,
        foregroundColor: Colors.white,
        actions: [
          if (widget.existingSession == null)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showGameSettings,
            ),
        ],
      ),
      body: Column(
        children: [
          _buildGameInfo(),
          Expanded(child: _buildPlayerList()),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildGameInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.crawlCrimson.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.crawlCrimson),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_gameSession.name, style: AppTextStyles.sectionTitle),
              Chip(
                label: Text(_getModeTitle(_gameSession.mode)),
                backgroundColor: AppColors.crawlCrimson,
                labelStyle: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoChip(Icons.people, '${_gameSession.totalPlayers} Players'),
              _buildInfoChip(Icons.timer, '${_gameDuration.inMinutes} min'),
              _buildInfoChip(Icons.play_circle, _getStatusText(_gameSession.status)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceM,
        vertical: AppDimensions.spaceS,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecond),
          const SizedBox(width: AppDimensions.spaceS),
          Text(text, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildPlayerList() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Players', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimensions.spaceM),
          Expanded(
            child: _gameSession.players.isEmpty 
              ? const Center(
                  child: Text(
                    'No players yet. Invite friends to join!',
                    style: AppTextStyles.body,
                  ),
                )
              : ListView.builder(
                  itemCount: _gameSession.players.length,
                  itemBuilder: (context, index) {
                    final player = _gameSession.players[index];
                    return _buildPlayerTile(player);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerTile(PlayerState player) {
    Color roleColor;
    IconData roleIcon;
    
    switch (player.role) {
      case PlayerRole.runner:
        roleColor = Colors.blue;
        roleIcon = Icons.directions_run;
        break;
      case PlayerRole.infected:
        roleColor = Colors.red;
        roleIcon = Icons.coronavirus;
        break;
      case PlayerRole.eliminated:
        roleColor = Colors.grey;
        roleIcon = Icons.close;
        break;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.spaceS),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: roleColor,
          child: Icon(roleIcon, color: Colors.white),
        ),
        title: Text(player.displayName),
        subtitle: Text(_getRoleText(player.role)),
        trailing: player.userId == _gameSession.creatorId
          ? const Icon(Icons.star, color: Colors.amber)
          : null,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        children: [
          if (widget.existingSession == null) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addMockPlayers,
                icon: const Icon(Icons.add),
                label: const Text('Add Mock Players'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.exploreTeal,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _gameSession.players.length >= 2 ? _startGame : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Game'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.crawlCrimson,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addMockPlayers() {
    final mockPlayers = [
      PlayerState(
        userId: 'player_1',
        displayName: 'Alice',
        role: PlayerRole.runner,
        actions: [],
      ),
      PlayerState(
        userId: 'player_2',
        displayName: 'Bob',
        role: PlayerRole.infected,
        actions: [],
      ),
      PlayerState(
        userId: 'player_3',
        displayName: 'Charlie',
        role: PlayerRole.runner,
        actions: [],
      ),
    ];
    
    setState(() {
      _gameSession = GameSession(
        id: _gameSession.id,
        name: _gameSession.name,
        mode: _gameSession.mode,
        players: [..._gameSession.players, ...mockPlayers],
        createdAt: _gameSession.createdAt,
        rules: _gameSession.rules,
        status: _gameSession.status,
        creatorId: _gameSession.creatorId,
        gameLog: _gameSession.gameLog,
      );
    });
  }

  void _startGame() {
    // TODO: Navigate to active game screen
    Navigator.pushNamed(context, '/infection-game');
  }

  void _showGameSettings() {
    // TODO: Show game configuration dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Settings'),
        content: const Text('Game configuration options coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getModeTitle(InfectionMode mode) {
    switch (mode) {
      case InfectionMode.arena:
        return 'Arena';
      case InfectionMode.freeForAll:
        return 'Free for All';
      case InfectionMode.crawl:
        return 'Crawl Mode';
    }
  }

  String _getStatusText(GameStatus status) {
    switch (status) {
      case GameStatus.lobby:
        return 'Waiting';
      case GameStatus.starting:
        return 'Starting';
      case GameStatus.active:
        return 'Active';
      case GameStatus.paused:
        return 'Paused';
      case GameStatus.finished:
        return 'Finished';
    }
  }

  String _getRoleText(PlayerRole role) {
    switch (role) {
      case PlayerRole.runner:
        return 'Runner';
      case PlayerRole.infected:
        return 'Infected';
      case PlayerRole.eliminated:
        return 'Eliminated';
    }
  }

  @override
  void dispose() {
    _gameNameController.dispose();
    super.dispose();
  }
}