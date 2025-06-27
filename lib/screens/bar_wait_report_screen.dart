// lib/screens/bar_wait_report_screen.dart - FIXED VERSION
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BarWaitReportScreen extends StatefulWidget {
  final String? venueId;
  
  const BarWaitReportScreen({
    super.key,
    this.venueId,
  });

  @override
  State<BarWaitReportScreen> createState() => _BarWaitReportScreenState();
}

class _BarWaitReportScreenState extends State<BarWaitReportScreen> {
  String _waitLevel = 'moderate';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Wait Time'),
        backgroundColor: AppColors.crawlCrimson,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.venueId != null) ...[
              Text(
                'Venue ID: ${widget.venueId}',
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: AppDimensions.spaceL),
            ],
            const Text(
              'How busy is this venue right now?',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            _buildWaitLevelSelector(),
            const SizedBox(height: AppDimensions.spaceXL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.crawlCrimson,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWaitLevelSelector() {
    const options = [
      {'value': 'empty', 'label': 'Empty', 'color': Colors.green},
      {'value': 'light', 'label': 'Light Crowd', 'color': Colors.lightGreen},
      {'value': 'moderate', 'label': 'Moderate', 'color': Colors.orange},
      {'value': 'busy', 'label': 'Busy', 'color': Colors.deepOrange},
      {'value': 'packed', 'label': 'Packed', 'color': Colors.red},
    ];
    
    return Column(
      children: options.map((option) {
        final isSelected = _waitLevel == option['value'];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceS),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => setState(() => _waitLevel = option['value'] as String),
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected ? (option['color'] as Color).withOpacity(0.2) : null,
                side: BorderSide(
                  color: option['color'] as Color,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Text(
                option['label'] as String,
                style: TextStyle(
                  color: option['color'] as Color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  void _submitReport() {
    // TODO: Submit wait time report to backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wait time report submitted!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }
}