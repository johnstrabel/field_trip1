// lib/screens/infection_game_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InfectionGameScreen extends StatefulWidget {
  const InfectionGameScreen({super.key});

  @override
  State<InfectionGameScreen> createState() => _InfectionGameScreenState();
}

class _InfectionGameScreenState extends State<InfectionGameScreen> {
  bool _isGameActive = true;
  int _timeRemaining = 1800; // 30 minutes in seconds
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infection Game'),
        backgroundColor: AppColors.crawlCrimson,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: _pauseGame,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildGameStatus(),
          Expanded(child: _buildGameMap()),
          _buildActionButtons(),
        ],
      ),
    );
  }
  
  Widget _buildGameStatus() {
    final minutes = _timeRemaining ~/ 60;
    final seconds = _timeRemaining % 60;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      color: AppColors.crawlCrimson.withOpacity(0.1),
      child: Column(
        children: [
          Text(
            'Time Remaining: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatusChip('Runners', 5, Colors.blue),
              _buildStatusChip('Infected', 2, Colors.red),
              _buildStatusChip('Eliminated', 1, Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusChip(String label, int count, Color color) {
    return Chip(
      label: Text('$label: $count'),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }
  
  Widget _buildGameMap() {
    return Container(
      width: double.infinity,
      color: Colors.grey[300],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 64, color: Colors.grey),
            SizedBox(height: AppDimensions.spaceM),
            Text('Game Map Coming Soon!'),
            Text('Real-time player tracking'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isGameActive ? _tagPlayer : null,
              icon: const Icon(Icons.touch_app),
              label: const Text('Tag Player'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _showGameMenu,
              icon: const Icon(Icons.menu),
              label: const Text('Menu'),
            ),
          ),
        ],
      ),
    );
  }
  
  void _pauseGame() {
    setState(() => _isGameActive = !_isGameActive);
  }
  
  void _tagPlayer() {
    // TODO: Implement player tagging
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Player tagged!')),
    );
  }
  
  void _showGameMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.pause),
              title: const Text('Pause Game'),
              onTap: () {
                Navigator.pop(context);
                _pauseGame();
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Leave Game'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
