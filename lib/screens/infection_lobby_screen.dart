// lib/screens/infection_lobby_screen.dart
import 'package:flutter/material.dart';
import '../models/infection_game.dart';
import '../theme/app_theme.dart';

class InfectionLobbyScreen extends StatefulWidget {
  final GameSession? existingSession;
  
  const InfectionLobbyScreen({Key? key, this.existingSession}) : super(key: key);

  @override
  _InfectionLobbyScreenState createState() => _InfectionLobbyScreenState();
}

class _InfectionLobbyScreenState extends State<InfectionLobbyScreen> {
  late GameSession _gameSession;
  InfectionMode _selectedMode = InfectionMode.freeForAll;
  String _gameName = '';
  Duration _gameDuration = const Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    if (widget.existingSession != null) {
      _gameSession = widget.existingSession!;
      _selectedMode = _gameSession.mode;
      _gameName = _gameSession.name;
    } else {
      _createNewSession();
    }
  }

  void _createNewSession() {
    _gameSession = GameSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _gameName.isEmpty ? 'Infection Game' : _gameName,
      mode: _selectedMode,
      players: [],
      createdAt: DateTime.now(),
      rules: _getDefaultRules(),
      status: GameStatus.lobby,
      creatorId: 'current_user', // TODO: Get actual user ID
      gameLog: [],
    );
  }

  Map<String, dynamic> _getDefaultRules() {
    switch (_selectedMode) {
      case InfectionMode.arena:
        return {
          'maxPlayers': 20,
          'initialInfected': 1,
          'tagRange': 5.0, // meters
          'boundaryRequired': true,
        };
      case InfectionMode.freeForAll:
        return {
          'maxPlayers': 50,
          'initialInfected': 1,
          'tagRange': 10.0,
          'allowPublicTransport': false, // For runners
        };
      case InfectionMode.crawl:
        return {
          'maxPlayers': 30,
          'initialInfected': 1,
          'tagRange': 10.0,
          'drinkImmunityDuration': 300, // 5 minutes in seconds
          'drinkFreezeDuration': 300,
          'requireDrinkProof': true,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infection Game'),
        backgroundColor: AppColors.crawlCrimson,
        foregroundColor: Colors.white,
        actions: [
          if (_gameSession.creatorId == 'current_user')
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showGameSettings,
            ),
        ],
      ),
      body: Column(
        children: [
          // Game Mode Selection (only for creator)
          if (_gameSession.creatorId == 'current_user' && _gameSession.status == GameStatus.lobby)
            _buildModeSelection(),
          
          // Game Info
          _buildGameInfo(),
          
          // Player List
          Expanded(child: _buildPlayerList()),
          
          // Bottom Actions
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildModeSelection() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spaceL),
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Game Mode', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimensions.spaceM),
          Column(
            children: InfectionMode.values.map((mode) => 
              RadioListTile<InfectionMode>(
                title: Text(_getModeTitle(mode)),
                subtitle: Text(_getModeDescription(mode)),
                value: mode,
                groupValue: _selectedMode,
                onChanged: (value) {
                  setState(() {
                    _selectedMode = value!;
                    _createNewSession();
                  });
                },
              ),
            ).toList(),
          ),
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
              ? _buildEmptyPlayerList()
              : _buildActivePlayerList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlayerList() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.textSecond,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              'Waiting for players...',
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              'Share the game code to invite friends',
              style: AppTextStyles.cardSubtitle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlayerList() {
    return ListView.builder(
      itemCount: _gameSession.players.length,
      itemBuilder: (context, index) {
        final player = _gameSession.players[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _getRoleColor(player.role),
            child: Icon(
              _getRoleIcon(player.role),
              color: Colors.white,
            ),
          ),
          title: Text(player.displayName),
          subtitle: Text(_getRoleText(player.role)),
          trailing: player.userId == _gameSession.creatorId
            ? const Icon(Icons.crown, color: AppColors.warning)
            : null,
        );
      },
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        children: [
          if (_gameSession.creatorId == 'current_user' && _gameSession.status == GameStatus.lobby)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _gameSession.players.length >= 2 ? _startGame : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                ),
                child: Text('Start Game (${_gameSession.players.length}/2 min)'),
              ),
            ),
          
          const SizedBox(height: AppDimensions.spaceM),
          
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _shareGameCode,
              child: const Text('Share Game Code'),
            ),
          ),
        ],
      ),
    );
  }

  String _getModeTitle(InfectionMode mode) {
    switch (mode) {
      case InfectionMode.arena:
        return 'Arena Mode';
      case InfectionMode.freeForAll:
        return 'Free-for-All';
      case InfectionMode.crawl:
        return 'Drinking Variant';
    }
  }

  String _getModeDescription(InfectionMode mode) {
    switch (mode) {
      case InfectionMode.arena:
        return 'Fixed boundary, no player visibility';
      case InfectionMode.freeForAll:
        return 'Open world, infected see runners';
      case InfectionMode.crawl:
        return 'Bar crawl with drink immunity/freeze';
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

  Color _getRoleColor(PlayerRole role) {
    switch (role) {
      case PlayerRole.runner:
        return AppColors.success;
      case PlayerRole.infected:
        return AppColors.error;
      case PlayerRole.eliminated:
        return AppColors.textSecond;
    }
  }

  IconData _getRoleIcon(PlayerRole role) {
    switch (role) {
      case PlayerRole.runner:
        return Icons.directions_run;
      case PlayerRole.infected:
        return Icons.coronavirus;
      case PlayerRole.eliminated:
        return Icons.close;
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

  void _showGameSettings() {
    // TODO: Show game settings dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Settings'),
        content: const Text('Game settings coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _startGame() {
    // TODO: Implement game start logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting infection game...'),
        backgroundColor: AppColors.success,
      ),
    );
    
    // Navigate to active game screen
    Navigator.pushReplacementNamed(context, '/infection-game');
  }

  void _shareGameCode() {
    // TODO: Implement game code sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Game Code: ${_gameSession.id.substring(0, 6).toUpperCase()}'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            // TODO: Copy to clipboard
          },
        ),
      ),
    );
  }
}