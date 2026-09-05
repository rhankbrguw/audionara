import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:audionara/features/player/presentation/bloc/lyrics_bloc.dart';
import 'package:audionara/features/player/presentation/bloc/lyrics_event.dart';
import 'package:audionara/features/player/presentation/bloc/lyrics_state.dart';

class MockClient extends http.BaseClient {
  final Future<http.Response> Function(http.BaseRequest request) handler;
  
  MockClient(this.handler);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await handler(request);
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      contentLength: response.bodyBytes.length,
      request: request,
      headers: response.headers,
    );
  }
}

void main() {
  group('LyricsBloc', () {
    late LyricsBloc bloc;

    test('emits [LyricsLoading, LyricsLoaded] when API succeeds', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({
          "data": {
            "plainLyrics": "Hello world",
            "syncedLyrics": null
          }
        }), 200);
      });

      bloc = LyricsBloc(client: mockClient, baseUrl: 'http://test.com');
      
      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<LyricsLoading>(),
          isA<LyricsLoaded>().having((s) => s.plainLyrics, 'plainLyrics', 'Hello world'),
        ]),
      );

      bloc.add(const FetchLyricsRequested(artist: 'Artist', title: 'Title'));
    });
    
    test('emits [LyricsLoading, LyricsError] on 404', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      bloc = LyricsBloc(client: mockClient, baseUrl: 'http://test.com');
      
      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<LyricsLoading>(),
          isA<LyricsError>(),
        ]),
      );

      bloc.add(const FetchLyricsRequested(artist: 'Artist', title: 'Title'));
    });
  });
}
