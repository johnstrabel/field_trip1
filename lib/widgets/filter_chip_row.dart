// lib/widgets/filter_chip_row.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FilterChipRow extends StatelessWidget {
  final List<String> items;
  final String selected;
  final void Function(String) onSelect;

  const FilterChipRow({
    Key? key,
    required this.items,
    required this.selected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceM),
      child: Row(
        children: items.map((item) {
          final isSelected = item == selected;
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spaceS),
            child: ChoiceChip(
              label: Text(
                item,
                style: isSelected
                    ? AppTextStyles.chipText.copyWith(color: Colors.white)
                    : AppTextStyles.chipText,
              ),
              selected: isSelected,
              backgroundColor: AppColors.amethyst100,
              selectedColor: AppColors.amethyst600,
              onSelected: (_) => onSelect(item),
            ),
          );
        }).toList(),
      ),
    );
  }
}
