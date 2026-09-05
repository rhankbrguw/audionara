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

  Future<void> _onFetchLyricsRequested(
    FetchLyricsRequested event,
    Emitter<LyricsState> emit,
  ) async {
    emit(LyricsLoading());
    try {
      final uri = Uri.parse('$baseUrl/api/v1/tracks/lyrics').replace(
        queryParameters: {'artist': event.artist, 'title': event.title},
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final lyricsPayload = body['data'];
        final (plainLyrics, syncedLyrics) = _extractLyricsData(lyricsPayload);

        emit(LyricsLoaded(plainLyrics: plainLyrics, syncedLyrics: syncedLyrics));
      } else if (response.statusCode == 404) {
        emit(const LyricsError(message: 'Lyrics not found.'));
      } else {
        emit(const LyricsError(message: 'Failed to fetch lyrics.'));
      }
    } catch (_) {
      emit(const LyricsError(message: 'Failed to load lyrics. Please check your connection.'));
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

    String? plainLyrics = lrclibData != null ? lrclibData['plainLyrics'] as String? : (lyricsPayload is String ? lyricsPayload : null);
    String? syncedStr = lrclibData?['syncedLyrics'] as String?;

    List<LyricLine>? syncedLyrics;
    if (syncedStr != null && syncedStr.isNotEmpty) {
      syncedLyrics = _parseLrc(syncedStr);
    }
    return (plainLyrics, syncedLyrics);
  }

  List<LyricLine> _parseLrc(String lrc) {
    final lines = lrc.split('\n');
    final lyricLines = <LyricLine>[];
    final regex = RegExp(r'\[(\d{1,2}):(\d{2})[.:](\d{2,3})\](.*)');

    for (final line in lines) {
      final lineItem = _parseSingleLrcLine(regex, line);
      if (lineItem != null) {
        lyricLines.add(lineItem);
      }
    }
    return lyricLines;
  }

  LyricLine? _parseSingleLrcLine(RegExp regex, String line) {
    final match = regex.firstMatch(line);
    if (match == null) return null;

    final minStr = match.group(1);
    final secStr = match.group(2);
    final msStr = match.group(3);
    final text = match.group(4)?.trim() ?? '';

    if (minStr == null || secStr == null || msStr == null) {
      return null;
    }

    final minutes = int.tryParse(minStr) ?? 0;
    final seconds = int.tryParse(secStr) ?? 0;
    final rawMs = int.tryParse(msStr) ?? 0;
    final milliseconds = msStr.length == 2 ? rawMs * 10 : (msStr.length == 1 ? rawMs * 100 : rawMs);

    return LyricLine(
      time: Duration(minutes: minutes, seconds: seconds, milliseconds: milliseconds),
      text: text.isNotEmpty ? text : '♪',
    );
  }
}
