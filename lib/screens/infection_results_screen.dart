// lib/screens/infection_results_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InfectionResultsScreen extends StatelessWidget {
  const InfectionResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Results'),
        backgroundColor: AppColors.crawlCrimson,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          children: [
            _buildGameSummary(),
            const SizedBox(height: AppDimensions.spaceL),
            Expanded(child: _buildPlayerResults()),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGameSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          children: [
            Text('Game Complete!', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppDimensions.spaceM),
            const Text('Duration: 28:43'),
            const Text('Total Players: 8'),
            const Text('Final Infected: 6'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPlayerResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Final Rankings', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppDimensions.spaceM),
        Expanded(
          child: ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              return _buildPlayerResultTile(index);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildPlayerResultTile(int index) {
    final playerNames = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve', 'Frank', 'Grace', 'Henry'];
    final isWinner = index < 2; // Top 2 survivors
    
    return Card(
      color: isWinner ? Colors.amber.withValues(alpha: 0.1) : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isWinner ? Colors.amber : Colors.grey,
          child: Text('${index + 1}'),
        ),
        title: Text(playerNames[index]),
        subtitle: Text(isWinner ? 'Survivor' : 'Infected'),
        trailing: isWinner ? const Icon(Icons.emoji_events, color: Colors.amber) : null,
      ),
    );
  }
  
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _playAgain(context),
            icon: const Icon(Icons.refresh),
            label: const Text('Play Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.crawlCrimson,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceM),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text('Back to Home'),
          ),
        ),
      ],
    );
  }
  
  void _playAgain(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/infection-lobby');
  }
}