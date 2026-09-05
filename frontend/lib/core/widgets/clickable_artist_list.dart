import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import '../navigation/app_router.dart';

class ClickableArtistList extends StatelessWidget {
  final String artistString;
  final String? artistId;
  final TextStyle? style;

  const ClickableArtistList({
    super.key,
    required this.artistString,
    this.artistId,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final pattern = RegExp(r'(,\s*|\s+&\s+|\s+feat\.?\s+|\s+ft\.?\s+)', caseSensitive: false);
    final matches = pattern.allMatches(artistString);
    final targetId = (artistId != null && artistId!.isNotEmpty && artistId != 'unknown')
        ? artistId!
        : 'unknown';

    if (matches.isEmpty) {
      return _buildSingle(context, targetId);
    }
    return _buildMulti(context, matches, targetId);
  }

  Widget _buildSingle(BuildContext context, String targetId) {
    return GestureDetector(
      onTap: () => context.push(
        '/artist/$targetId',
        extra: ArtistRouteExtra(id: targetId, name: artistString.trim(), genre: ''),
      ),
      child: Text(artistString, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _buildMulti(BuildContext context, Iterable<RegExpMatch> matches, String targetId) {
    final spans = _buildSpans(context, matches, targetId);
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(style: style, children: spans),
    );
  }

  List<TextSpan> _buildSpans(BuildContext context, Iterable<RegExpMatch> matches, String targetId) {
    int lastEnd = 0;
    final spans = <TextSpan>[];
    for (final match in matches) {
      final name = artistString.substring(lastEnd, match.start);
      final id = spans.isEmpty ? targetId : 'unknown';
      if (name.trim().isNotEmpty) {
        spans.add(_buildSpan(context, name.trim(), id));
      }
      spans.add(TextSpan(text: match.group(0)));
      lastEnd = match.end;
    }
    if (lastEnd < artistString.length) {
      final name = artistString.substring(lastEnd);
      final id = spans.isEmpty ? targetId : 'unknown';
      if (name.trim().isNotEmpty) {
        spans.add(_buildSpan(context, name.trim(), id));
      }
    }
    return spans;
  }

  TextSpan _buildSpan(BuildContext context, String name, String id) {
    return TextSpan(
      text: name,
      recognizer: TapGestureRecognizer()
        ..onTap = () => context.push(
          '/artist/$id',
          extra: ArtistRouteExtra(id: id, name: name, genre: ''),
        ),
    );
  }
}
