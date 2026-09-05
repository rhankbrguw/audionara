import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../player/domain/entities/track.dart';
import 'search_result_tile.dart';

class SearchResultsSectionWidget extends StatelessWidget {
  final String title;
  final List<Track> items;
  final ValueChanged<String>? onRecordHistory;

  const SearchResultsSectionWidget({
    super.key,
    required this.title,
    required this.items,
    this.onRecordHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items.map(
          (track) => SearchResultTile(
            track: track,
            queue: items,
            sectionTitle: title,
            onRecordHistory: onRecordHistory,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
