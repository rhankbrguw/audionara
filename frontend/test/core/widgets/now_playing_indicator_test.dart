import 'package:audionara/core/widgets/now_playing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NowPlayingIndicator renders when active', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NowPlayingIndicator(isPlaying: true, size: 24),
        ),
      ),
    );

    expect(find.byType(NowPlayingIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
  });

  testWidgets('NowPlayingIndicator handles paused state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NowPlayingIndicator(isPlaying: false, size: 20),
        ),
      ),
    );

    expect(find.byType(NowPlayingIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
  });
}
