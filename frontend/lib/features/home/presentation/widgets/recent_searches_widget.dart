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
  final int? narrativeSeed;

  const RecentSearchesWidget({
    super.key,
    required this.recentSearches,
    required this.onClearAll,
    required this.onSearch,
    this.onRecordHistory,
    this.narrativeSeed,
  });

  @override
  State<RecentSearchesWidget> createState() => _RecentSearchesWidgetState();
}

class _RecentSearchesWidgetState extends State<RecentSearchesWidget> {
  late Future<HomeFeed> _feedFuture;
  int _narrativeSeed = 0;

  @override
  void initState() {
    super.initState();
    final wib = DateTime.now().toUtc().add(const Duration(hours: 7));
    _narrativeSeed = widget.narrativeSeed ?? (wib.day * 24 + wib.hour);
    _feedFuture = context.read<HomeRepository>().getHomeFeed(forceRefresh: true, seed: _narrativeSeed);
  }

  Future<void> _onRefresh() async {
    setState(() {
      _narrativeSeed = DateTime.now().millisecondsSinceEpoch;
      _feedFuture = context.read<HomeRepository>().getHomeFeed(forceRefresh: true, seed: _narrativeSeed);
    });
    await _feedFuture;
  }

  void _onSelectArtist(HomeArtist artist) {
    widget.onRecordHistory?.call(artist.name);
    final extra = ArtistRouteExtra(id: artist.id.toString(), name: artist.name, genre: '');
    context.push('/artist/${artist.id}', extra: extra);
  }

  Widget _buildFeedFisheye(HomeFeed? feed) {
    if (feed == null || feed.similarArtists.isEmpty) return const SizedBox.shrink();
    return SearchArtistFisheye(
      baseArtist: feed.baseArtist,
      artists: feed.similarArtists,
      onSelectArtist: _onSelectArtist,
      narrativeSeed: _narrativeSeed,
    );
  }

  Widget _buildRecentSection() {
    if (widget.recentSearches.isEmpty) return _buildEmptyPrompt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRecentHeader(),
        const SizedBox(height: AppSpacing.sm),
        _buildRecentChips(),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeFeed>(
      future: _feedFuture,
      builder: (context, snapshot) {
        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: _onRefresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.md),
            children: [
              _buildRecentSection(),
              _buildFeedFisheye(snapshot.data),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyPrompt() {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.xs, bottom: AppSpacing.md),
      child: Text(
        SearchStrings.searchPrompt,
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildRecentHeader() {
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(SearchStrings.recentSearchesLabel, style: titleStyle),
        TextButton(
          onPressed: widget.onClearAll,
          child: const Text(SearchStrings.clearAll, style: TextStyle(color: AppColors.primary)),
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
