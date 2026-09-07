import 'package:flutter/material.dart';
import '../../../../core/constants/search_strings.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../player/domain/entities/multi_search_result.dart';
import 'search_results_section_widget.dart';
import 'search_top_result_card.dart';

class SearchResultsGrid extends StatelessWidget {
  final MultiSearchResult results;
  final String selectedFilter;
  final ValueChanged<String>? onRecordHistory;

  const SearchResultsGrid({
    super.key,
    required this.results,
    this.selectedFilter = 'All',
    this.onRecordHistory,
  });

  @override
  Widget build(BuildContext context) {
    final showTopResult = selectedFilter == 'All' && results.topResult != null;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        if (showTopResult)
          SearchTopResultCard(
            item: results.topResult!,
            queue: results.songs,
            onRecordHistory: onRecordHistory,
          ),
        if ((selectedFilter == 'All' || selectedFilter == 'Songs') && results.songs.isNotEmpty)
          SearchResultsSectionWidget(
            title: SearchStrings.searchSongs,
            items: selectedFilter == 'All' ? results.songs.take(5).toList() : results.songs,
            onRecordHistory: onRecordHistory,
          ),
        if ((selectedFilter == 'All' || selectedFilter == 'Artists') && results.artists.isNotEmpty)
          SearchResultsSectionWidget(
            title: SearchStrings.searchArtists,
            items: selectedFilter == 'All' ? results.artists.take(5).toList() : results.artists,
            onRecordHistory: onRecordHistory,
          ),
        if ((selectedFilter == 'All' || selectedFilter == 'Albums') && results.albums.isNotEmpty)
          SearchResultsSectionWidget(
            title: SearchStrings.searchAlbums,
            items: selectedFilter == 'All' ? results.albums.take(5).toList() : results.albums,
            onRecordHistory: onRecordHistory,
          ),
      ],
    );
  }
}

