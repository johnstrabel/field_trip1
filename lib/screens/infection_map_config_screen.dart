// lib/screens/infection_map_config_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InfectionMapConfigScreen extends StatefulWidget {
  const InfectionMapConfigScreen({super.key});

  @override
  State<InfectionMapConfigScreen> createState() => _InfectionMapConfigScreenState();
}

class _InfectionMapConfigScreenState extends State<InfectionMapConfigScreen> {
  String _boundaryType = 'circle';
  double _radius = 100.0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure Game Area'),
        backgroundColor: AppColors.crawlCrimson,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Game Boundary', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppDimensions.spaceL),
            _buildBoundaryTypeSelector(),
            const SizedBox(height: AppDimensions.spaceL),
            if (_boundaryType == 'circle') _buildRadiusSlider(),
            const Spacer(),
            _buildConfigButtons(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBoundaryTypeSelector() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Circular Area'),
          value: 'circle',
          groupValue: _boundaryType,
          onChanged: (value) => setState(() => _boundaryType = value!),
        ),
        RadioListTile<String>(
          title: const Text('Polygon Area'),
          value: 'polygon',
          groupValue: _boundaryType,
          onChanged: (value) => setState(() => _boundaryType = value!),
        ),
      ],
    );
  }
  
  Widget _buildRadiusSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Radius: ${_radius.round()}m', style: AppTextStyles.body),
        Slider(
          value: _radius,
          min: 50,
          max: 500,
          divisions: 18,
          onChanged: (value) => setState(() => _radius = value),
        ),
      ],
    );
  }
  
  Widget _buildConfigButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _saveConfiguration,
            icon: const Icon(Icons.save),
            label: const Text('Save Configuration'),
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
      ],
    );
  }
  
  void _saveConfiguration() {
    // TODO: Save game area configuration
    Navigator.pop(context);
  }
}
