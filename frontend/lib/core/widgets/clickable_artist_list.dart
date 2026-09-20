import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import '../navigation/app_router.dart';
import '../theme/app_colors.dart';

class ClickableArtistList extends StatelessWidget {
  final String artistString;
  final String? trackTitle;
  final String? artistId;
  final TextStyle? style;

  const ClickableArtistList({
    super.key,
    required this.artistString,
    this.trackTitle,
    this.artistId,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final artists = _extractArtists();
    if (artists.isEmpty) {
      return const SizedBox.shrink();
    }
    if (artists.length == 1) {
      return _buildSingle(context, artists.first);
    }
    return _buildMulti(context, artists);
  }

  List<_ArtistItem> _extractArtists() {
    final list = <_ArtistItem>[];
    final seen = <String>{};

    void add(String name, String id) {
      final clean = name.trim();
      if (clean.isNotEmpty && seen.add(clean.toLowerCase())) {
        list.add(_ArtistItem(name: clean, id: id));
      }
    }

    final targetId = (artistId != null && artistId!.isNotEmpty && artistId != 'unknown')
        ? artistId!
        : 'unknown';

    final featRegex = RegExp(r'\s+(?:feat\.?|ft\.?|featuring|with)\s+', caseSensitive: false);
    final baseSplit = artistString.split(featRegex);
    for (int i = 0; i < baseSplit.length; i++) {
      add(baseSplit[i], i == 0 ? targetId : 'unknown');
    }

    if (trackTitle != null && trackTitle!.isNotEmpty) {
      _extractTitleFeatures(trackTitle!, add);
    }

    return list;
  }

  void _extractTitleFeatures(String title, void Function(String, String) add) {
    final featMatch = RegExp(
      r'[\(\[\{]?(?:feat\.?|ft\.?|featuring|with)\s+([^\)\]\}]+)[\)\]\}]?',
      caseSensitive: false,
    ).firstMatch(title);
    if (featMatch == null) return;
    final featGroup = featMatch.group(1) ?? '';
    final feats = featGroup.split(RegExp(r'\s*(?:&|\band\b)\s*', caseSensitive: false));
    for (final f in feats) {
      add(f, 'unknown');
    }
  }

  Widget _buildSingle(BuildContext context, _ArtistItem artist) {
    return GestureDetector(
      onTap: () => _navigateToArtist(context, artist),
      child: Text(artist.name, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _buildMulti(BuildContext context, List<_ArtistItem> artists) {
    final spans = <TextSpan>[];
    for (int i = 0; i < artists.length; i++) {
      spans.add(_buildSpan(context, artists[i]));
      if (i < artists.length - 1) {
        spans.add(TextSpan(
          text: ', ',
          style: (style ?? const TextStyle()).copyWith(color: AppColors.textSecondary),
        ));
      }
    }
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(style: style, children: spans),
    );
  }

  TextSpan _buildSpan(BuildContext context, _ArtistItem artist) {
    return TextSpan(
      text: artist.name,
      style: (style ?? const TextStyle()).copyWith(
        decoration: TextDecoration.underline,
        decorationColor: AppColors.textSecondary.withValues(alpha: 0.4),
      ),
      recognizer: TapGestureRecognizer()..onTap = () => _navigateToArtist(context, artist),
    );
  }

  void _navigateToArtist(BuildContext context, _ArtistItem artist) {
    context.push(
      '/artist/${artist.id}',
      extra: ArtistRouteExtra(id: artist.id, name: artist.name, genre: ''),
    );
  }
}

class _ArtistItem {
  final String name;
  final String id;
  const _ArtistItem({required this.name, required this.id});
}
