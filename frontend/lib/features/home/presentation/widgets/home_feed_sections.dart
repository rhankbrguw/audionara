import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/home_strings.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../data/repositories/home_repository.dart';
import 'home_header.dart';
import 'mix_for_you_banner.dart';
import 'section_header_widget.dart';
import 'vibe_grid.dart';
import 'trending_hits.dart';
import 'favorite_artists.dart';
import 'my_playlists.dart';
import 'my_favourites.dart';

class HomeFeedSections extends StatelessWidget {
  final HomeFeed? feed;
  final VoidCallback onProfileTap;

  const HomeFeedSections({
    super.key,
    required this.feed,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        HomeHeader(onProfileTap: onProfileTap),
        const SliverToBoxAdapter(child: MixForYouBanner()),
        const SectionHeaderWidget(title: HomeStrings.exploreVibes),
        if (feed != null)
          VibeGrid(vibes: feed!.exploreVibes)
        else
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ShimmerCard(width: double.infinity, height: 110),
            ),
          ),
        const SectionHeaderWidget(title: HomeStrings.trendingHits),
        if (feed != null)
          TrendingHits(hits: feed!.trendingHits)
        else
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ShimmerCard(width: double.infinity, height: 180),
            ),
          ),
        const SectionHeaderWidget(title: HomeStrings.favoriteArtists),
        FavoriteArtistsSection(artists: feed?.favoriteArtists ?? []),
        SectionHeaderWidget(
          title: HomeStrings.myPlaylists,
          actionLabel: HomeStrings.seeAll,
          onAction: () => context.push('/playlists'),
        ),
        const MyPlaylists(),
        SectionHeaderWidget(
          title: HomeStrings.myFavourites,
          actionLabel: HomeStrings.seeAll,
          onAction: () => context.push('/favourites'),
        ),
        const MyFavourites(),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}
