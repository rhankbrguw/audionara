import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/search_strings.dart';
import '../../../../core/navigation/route_extras.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../data/repositories/home_repository.dart';
import 'search_artist_fisheye.dart';

class RecentSearchesWidget extends StatefulWidget {
  final List<String> recentSearches;
  final VoidCallback onClearAll;
  final ValueChanged<String> onSearch;
  final ValueChanged<String>? onRecordHistory;

  const RecentSearchesWidget({
    super.key,
    required this.recentSearches,
    required this.onClearAll,
    required this.onSearch,
    this.onRecordHistory,
  });

  @override
  State<RecentSearchesWidget> createState() => _RecentSearchesWidgetState();
}

class _RecentSearchesWidgetState extends State<RecentSearchesWidget> {
  late Future<HomeFeed> _feedFuture;

  @override
  void initState() {
    super.initState();
    _feedFuture = context.read<HomeRepository>().getHomeFeed();
  }

  void _onSelectArtist(HomeArtist artist) {
    widget.onRecordHistory?.call(artist.name);
    context.push(
      '/artist/${artist.id}',
      extra: ArtistRouteExtra(
        id: artist.id.toString(),
        name: artist.name,
        genre: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeFeed>(
      future: _feedFuture,
      builder: (context, snapshot) {
        final feed = snapshot.data;
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            if (widget.recentSearches.isNotEmpty) ...[
              _buildRecentHeader(),
              const SizedBox(height: AppSpacing.sm),
              _buildRecentChips(),
              const SizedBox(height: AppSpacing.md),
            ] else ...[
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                  horizontal: AppSpacing.xs,
                ),
                child: Text(
                  SearchStrings.searchPrompt,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (feed != null && feed.similarArtists.isNotEmpty)
              SearchArtistFisheye(
                baseArtist: feed.baseArtist,
                artists: feed.similarArtists,
                onSelectArtist: _onSelectArtist,
              ),
          ],
        );
      },
    );
  }

  Widget _buildRecentHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          SearchStrings.recentSearchesLabel,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        TextButton(
          onPressed: widget.onClearAll,
          child: const Text(
            SearchStrings.clearAll,
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentChips() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: widget.recentSearches.map((query) {
        return ActionChip(
          backgroundColor: AppColors.surface,
          label: Text(
            query,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          onPressed: () => widget.onSearch(query),
        );
      }).toList(),
    );
  }
}
