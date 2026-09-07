import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/search_strings.dart';
import '../../../player/domain/entities/multi_search_result.dart';
import 'recent_searches_widget.dart';
import 'search_filter_chips.dart';
import 'search_results_grid.dart';

class SearchPageBody extends StatelessWidget {
  final bool isLoading;
  final String error;
  final MultiSearchResult? results;
  final String searchQuery;
  final List<String> recentSearches;
  final String selectedFilter;
  final VoidCallback onClearRecent;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onFilterSelected;
  final ValueChanged<String>? onRecordHistory;

  const SearchPageBody({
    super.key,
    required this.isLoading,
    required this.error,
    required this.results,
    required this.searchQuery,
    required this.recentSearches,
    required this.selectedFilter,
    required this.onClearRecent,
    required this.onSearch,
    required this.onFilterSelected,
    this.onRecordHistory,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (error.isNotEmpty) {
      return Center(
        child: Text(error, style: const TextStyle(color: AppColors.error)),
      );
    }
    if (results == null || searchQuery.trim().isEmpty) {
      return RecentSearchesWidget(
        recentSearches: recentSearches,
        onClearAll: onClearRecent,
        onSearch: onSearch,
        onRecordHistory: onRecordHistory,
      );
    }

    final hasResults = results!.songs.isNotEmpty ||
        results!.artists.isNotEmpty ||
        results!.albums.isNotEmpty;

    if (!hasResults) {
      return const Center(
        child: Text(
          SearchStrings.noResultsFound,
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      children: [
        SearchFilterChips(
          selectedFilter: selectedFilter,
          onFilterSelected: onFilterSelected,
        ),
        Expanded(
          child: SearchResultsGrid(
            results: results!,
            selectedFilter: selectedFilter,
            onRecordHistory: onRecordHistory,
          ),
        ),
      ],
    );
  }
}
