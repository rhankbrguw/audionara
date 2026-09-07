import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:audionara/features/player/domain/entities/track.dart';
import 'package:audionara/features/player/presentation/widgets/queue_track_tile.dart';

void main() {
  const testTrack = Track(
    id: 'track-1',
    title: 'Kangen',
    artist: 'Dewa 19',
    streamUrl: 'https://example.com/audio.mp3',
    coverArt: '',
    durationMs: 300000,
  );

  testWidgets('QueueTrackTile renders title and artist correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QueueTrackTile(
            track: testTrack,
            index: 0,
            isPlaying: false,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Kangen'), findsOneWidget);
    expect(find.text('Dewa 19'), findsOneWidget);
    expect(find.byIcon(Icons.drag_handle), findsOneWidget);
  });

  testWidgets('QueueTrackTile shows equalizer when playing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QueueTrackTile(
            track: testTrack,
            index: 0,
            isPlaying: true,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.equalizer), findsOneWidget);
    expect(find.byIcon(Icons.drag_handle), findsNothing);
  });
}
