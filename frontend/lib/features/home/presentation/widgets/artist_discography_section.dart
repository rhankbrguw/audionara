import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/constants/artist_strings.dart';
import '../../../../core/navigation/route_extras.dart';
import '../../../../core/widgets/interactive_pressable.dart';
import '../../../player/domain/entities/album_meta.dart';
import 'artist_discography_views.dart';

class ArtistDiscographySection extends StatefulWidget {
  final String artistName;
  final List<AlbumMeta> albums;

  const ArtistDiscographySection({
    super.key,
    required this.artistName,
    required this.albums,
  });

  @override
  State<ArtistDiscographySection> createState() => _ArtistDiscographySectionState();
}

class _ArtistDiscographySectionState extends State<ArtistDiscographySection> {
  int _tabIndex = 0;

  final List<String> _tabs = [
    ArtistStrings.allReleases,
    ArtistStrings.albums,
    ArtistStrings.singlesAndEPs,
    ArtistStrings.compilations,
  ];

  void _onSeeAll() {
    context.push(
      '/artist/${widget.albums.firstOrNull?.id ?? "discography"}/discography',
      extra: ArtistDiscographyRouteExtra(
        artistName: widget.artistName,
        albums: widget.albums,
        initialTabIndex: _tabIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.albums.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final filtered = ArtistDiscographyViews.filterAlbums(widget.albums, _tabIndex);
    final horizontalItems = filtered.take(6).toList();

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildTabs(),
          const SizedBox(height: AppSpacing.xs),
          ArtistDiscographyViews.buildCarousel(horizontalItems),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ArtistStrings.discography,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          InteractivePressable(
            onTap: _onSeeAll,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ArtistStrings.seeAll,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, idx) {
          final isSelected = _tabIndex == idx;
          return ChoiceChip(
            label: Text(_tabs[idx]),
            labelStyle: TextStyle(
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            selected: isSelected,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.chip),
              side: BorderSide(color: isSelected ? AppColors.primary : AppColors.surfaceVariant),
            ),
            onSelected: (_) => setState(() => _tabIndex = idx),
          );
        },
      ),
    );
  }
}
