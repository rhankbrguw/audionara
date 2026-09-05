import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/artist_strings.dart';
import '../../../player/domain/entities/album_meta.dart';
import 'artist_album_card.dart';

class ArtistDiscographyViews {
  static List<AlbumMeta> filterAlbums(List<AlbumMeta> list, int tabIndex) {
    if (tabIndex == 1) {
      return list.where((a) {
        final t = a.recordType.toLowerCase();
        final isSingle = t == 'single' || t == 'ep' || (a.trackCount > 0 && a.trackCount <= 3);
        final isCompile = t == 'compile' || a.title.toLowerCase().contains('compilation');
        return (t == 'album' || (t.isEmpty && !isSingle)) && !isSingle && !isCompile;
      }).toList();
    }
    if (tabIndex == 2) {
      return list.where((a) {
        final t = a.recordType.toLowerCase();
        return t == 'single' || t == 'ep' || (a.trackCount > 0 && a.trackCount <= 6) ||
            a.title.toLowerCase().contains('single') || a.title.toLowerCase().contains('ep');
      }).toList();
    }
    if (tabIndex == 3) {
      return list.where((a) {
        final t = a.recordType.toLowerCase();
        final title = a.title.toLowerCase();
        return t == 'compile' || title.contains('hits') || title.contains('best of') ||
            title.contains('compilation') || title.contains('anthology');
      }).toList();
    }
    return list;
  }

  static Widget buildCarousel(List<AlbumMeta> list) {
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Text(ArtistStrings.noAlbums, style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return Semantics(
      container: true,
      child: SizedBox(
        height: 195,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: ArtistAlbumCard(album: list[index]),
            );
          },
        ),
      ),
    );
  }

  static Widget buildGrid(List<AlbumMeta> list) {
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Text(ArtistStrings.noAlbums, style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return Semantics(
      container: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = (constraints.maxWidth - (AppSpacing.md * 3)) / 2;
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: list.map((album) => ArtistAlbumCard(album: album, width: cardWidth)).toList(),
            ),
          );
        },
      ),
    );
  }
}
