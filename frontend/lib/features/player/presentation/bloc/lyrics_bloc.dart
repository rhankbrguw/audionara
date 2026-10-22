import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import 'lyrics_event.dart';
import 'lyrics_state.dart';

class LyricsBloc extends Bloc<LyricsEvent, LyricsState> {
  final http.Client client;
  final String baseUrl;

  LyricsBloc({required this.client, String? baseUrl})
    : baseUrl = baseUrl ?? AppConstants.apiBaseUrl,
      super(LyricsInitial()) {
    on<FetchLyricsRequested>(_onFetchLyricsRequested);
  }

  String? _lastLoadedArtist;
  String? _lastLoadedTitle;

  Future<void> _onFetchLyricsRequested(
    FetchLyricsRequested event,
    Emitter<LyricsState> emit,
  ) async {
    if (state is LyricsLoaded &&
        _lastLoadedArtist == event.artist &&
        _lastLoadedTitle == event.title) {
      return;
    }
    emit(LyricsLoading());
    try {
      final qParams = <String, String>{
        'artist': event.artist,
        'title': event.title,
      };
      if (event.durationMs > 0) {
        qParams['duration'] = '${event.durationMs ~/ 1000}';
      }
      final uri = Uri.parse('$baseUrl/api/v1/tracks/lyrics').replace(
        queryParameters: qParams,
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final lyricsPayload = body['data'];
        final (plainLyrics, syncedLyrics) = _extractLyricsData(lyricsPayload);

        _lastLoadedArtist = event.artist;
        _lastLoadedTitle = event.title;
        emit(LyricsLoaded(plainLyrics: plainLyrics, syncedLyrics: syncedLyrics));
      } else {
        _lastLoadedArtist = null;
        _lastLoadedTitle = null;
        final isNotFound = response.statusCode == 404;
        emit(LyricsError(
          message: isNotFound ? 'Lyrics not found.' : 'Failed to fetch lyrics.',
        ));
      }
    } catch (_) {
      _lastLoadedArtist = null;
      _lastLoadedTitle = null;
      emit(const LyricsError(
        message: 'Failed to load lyrics. Please check your connection.',
      ));
    }
  }

  (String?, List<LyricLine>?) _extractLyricsData(dynamic lyricsPayload) {
    Map<String, dynamic>? lrclibData;
    if (lyricsPayload is String) {
      try {
        lrclibData = jsonDecode(lyricsPayload) as Map<String, dynamic>;
      } catch (_) {
        lrclibData = null;
      }
    } else if (lyricsPayload is Map<String, dynamic>) {
      lrclibData = lyricsPayload;
    }

    String? plain = lrclibData != null
        ? lrclibData['plainLyrics'] as String?
        : (lyricsPayload is String ? lyricsPayload : null);
    String? syncedStr = lrclibData?['syncedLyrics'] as String?;

    List<LyricLine>? syncedLyrics;
    if (syncedStr != null && syncedStr.isNotEmpty) {
      syncedLyrics = _parseLrc(syncedStr);
    }
    return (plain, syncedLyrics);
  }

  List<LyricLine> _parseLrc(String lrc) {
    final lines = lrc.split('\n');
    final lyricLines = <LyricLine>[];
    final offsetRegex = RegExp(r'\[offset:\s*(-?\d+)\]', caseSensitive: false);
    final timeRegex = RegExp(r'\[(\d{1,2}):(\d{2})(?:[.:](\d{1,3}))?\]');
    int offsetMs = 0;

    for (final rawLine in lines) {
      final line = rawLine.trim();
      final offsetMatch = offsetRegex.firstMatch(line);
      if (offsetMatch != null) {
        offsetMs = int.tryParse(offsetMatch.group(1) ?? '0') ?? 0;
        continue;
      }
      final matches = timeRegex.allMatches(line).toList();
      if (matches.isEmpty) continue;

      final text = line.replaceAll(timeRegex, '').trim();
      final lyricText = text.isNotEmpty ? text : '♪';

      for (final match in matches) {
        final item = _buildLyricLine(match, lyricText, offsetMs);
        if (item != null) lyricLines.add(item);
      }
    }
    lyricLines.sort((a, b) => a.time.compareTo(b.time));
    return lyricLines;
  }

  LyricLine? _buildLyricLine(Match match, String text, int offsetMs) {
    final minStr = match.group(1);
    final secStr = match.group(2);
    final msStr = match.group(3);
    if (minStr == null || secStr == null) return null;

    final mins = int.tryParse(minStr) ?? 0;
    final secs = int.tryParse(secStr) ?? 0;
    int ms = 0;
    if (msStr != null) {
      final raw = int.tryParse(msStr) ?? 0;
      ms = msStr.length == 1 ? raw * 100 : (msStr.length == 2 ? raw * 10 : raw);
    }
    final totalMs = (mins * 60 + secs) * 1000 + ms - offsetMs;
    return LyricLine(
      time: Duration(milliseconds: totalMs > 0 ? totalMs : 0),
      text: text,
    );
  }
}
