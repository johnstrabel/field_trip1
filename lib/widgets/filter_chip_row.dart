// lib/widgets/filter_chip_row.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FilterChipRow extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onSelectionChanged;

  const FilterChipRow({
    Key? key,
    required this.options,
    required this.selectedOption,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.spaceS),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == selectedOption;
          
          return FilterChip(
            label: Text(
              option,
              style: AppTextStyles.chipText.copyWith(
                color: isSelected ? Colors.white : AppColors.textMain,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                onSelectionChanged(option);
              }
            },
            backgroundColor: AppColors.card,
            selectedColor: AppColors.amethyst600,
            side: BorderSide(
              color: isSelected ? AppColors.amethyst600 : AppColors.stroke,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceM,
              vertical: AppDimensions.spaceS,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }
}