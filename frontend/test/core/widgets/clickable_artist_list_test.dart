import 'package:audionara/core/widgets/clickable_artist_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ClickableArtistList renders single artist', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ClickableArtistList(artistString: 'The Strokes'),
        ),
      ),
    );

    expect(find.text('The Strokes'), findsOneWidget);
  });

  testWidgets('ClickableArtistList parses and splits featuring artists with comma', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ClickableArtistList(
            artistString: 'The Weeknd ft. Daft Punk',
          ),
        ),
      ),
    );

    expect(find.byType(RichText), findsOneWidget);
    final richText = tester.widget<RichText>(find.byType(RichText));
    final plainText = richText.text.toPlainText();
    expect(plainText, equals('The Weeknd, Daft Punk'));
  });

  testWidgets('ClickableArtistList extracts featuring artist from track title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ClickableArtistList(
            artistString: 'Daft Punk',
            trackTitle: 'Get Lucky (feat. Pharrell Williams)',
          ),
        ),
      ),
    );

    expect(find.byType(RichText), findsOneWidget);
    final richText = tester.widget<RichText>(find.byType(RichText));
    final plainText = richText.text.toPlainText();
    expect(plainText, equals('Daft Punk, Pharrell Williams'));
  });

  testWidgets('ClickableArtistList preserves band names with commas and ampersands', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ClickableArtistList(
            artistString: 'Earth, Wind & Fire',
          ),
        ),
      ),
    );

    expect(find.text('Earth, Wind & Fire'), findsOneWidget);
  });

  testWidgets('ClickableArtistList preserves Tyler, The Creator with comma', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ClickableArtistList(
            artistString: 'Tyler, The Creator',
          ),
        ),
      ),
    );

    expect(find.text('Tyler, The Creator'), findsOneWidget);
  });
}
