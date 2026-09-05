import 'package:flutter/material.dart';
import '../../../../core/constants/search_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../data/repositories/home_repository.dart';
import 'search_artist_fisheye_tile.dart';

class SearchArtistFisheye extends StatelessWidget {
  final String baseArtist;
  final List<HomeArtist> artists;
  final ValueChanged<HomeArtist> onSelectArtist;

  const SearchArtistFisheye({
    super.key,
    required this.baseArtist,
    required this.artists,
    required this.onSelectArtist,
  });

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        SearchStrings.becauseYouListen(baseArtist),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildGrid() {
    final displayArtists = artists.take(5).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayArtists.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        mainAxisExtent: 52,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemBuilder: (context, index) {
        return SearchArtistFisheyeTile(
          artist: displayArtists[index],
          onTap: () => onSelectArtist(displayArtists[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (artists.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        _buildGrid(),
      ],
    );
  }
}
