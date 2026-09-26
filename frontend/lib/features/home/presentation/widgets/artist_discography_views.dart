import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/artist_strings.dart';
import '../../../player/domain/entities/album_meta.dart';
import 'artist_album_card.dart';

class ArtistDiscographyViews {
  static List<AlbumMeta> sortLatestFirst(List<AlbumMeta> list) {
    final sorted = List<AlbumMeta>.from(list);
    sorted.sort((a, b) {
      final dateA = a.releaseDate.isNotEmpty ? a.releaseDate : a.year;
      final dateB = b.releaseDate.isNotEmpty ? b.releaseDate : b.year;
      return dateB.compareTo(dateA);
    });
    return sorted;
  }

  static List<AlbumMeta> filterAlbums(List<AlbumMeta> list, int tabIndex) {
    List<AlbumMeta> filtered;
    if (tabIndex == 1) {
      filtered = list.where((a) {
        final t = a.recordType.toLowerCase();
        final isSingle = t == 'single' || t == 'ep' || (a.trackCount > 0 && a.trackCount <= 3);
        final isCompile = t == 'compile' || a.title.toLowerCase().contains('compilation');
        return (t == 'album' || (t.isEmpty && !isSingle)) && !isSingle && !isCompile;
      }).toList();
    } else if (tabIndex == 2) {
      filtered = list.where((a) {
        final t = a.recordType.toLowerCase();
        return t == 'single' || t == 'ep' || (a.trackCount > 0 && a.trackCount <= 6) ||
            a.title.toLowerCase().contains('single') || a.title.toLowerCase().contains('ep');
      }).toList();
    } else if (tabIndex == 3) {
      filtered = list.where((a) {
        final t = a.recordType.toLowerCase();
        final title = a.title.toLowerCase();
        return t == 'compile' || title.contains('hits') || title.contains('best of') ||
            title.contains('compilation') || title.contains('anthology');
      }).toList();
    } else {
      filtered = list;
    }
    return sortLatestFirst(filtered);
  }

  static Widget buildCarousel(List<AlbumMeta> list) {
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Text(ArtistStrings.noAlbums, style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    final sorted = sortLatestFirst(list);
    return Semantics(
      container: true,
      child: SizedBox(
        height: 195,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: ArtistAlbumCard(album: sorted[index]),
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
    final sorted = sortLatestFirst(list);
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
              children: sorted.map((album) => ArtistAlbumCard(album: album, width: cardWidth)).toList(),
            ),
          );
        },
      ),
    );
  }
}
