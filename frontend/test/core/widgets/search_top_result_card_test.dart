import 'package:audionara/core/constants/search_strings.dart';
import 'package:audionara/features/home/presentation/widgets/search_top_result_card.dart';
import 'package:audionara/features/player/domain/entities/multi_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SearchTopResultCard renders artist top result correctly', (tester) async {
    const item = TopResultItem(
      type: 'artist',
      id: '123',
      title: 'Queen',
      subtitle: 'Artist',
      coverArt: 'https://example.com/pic.jpg',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SearchTopResultCard(item: item, queue: []),
        ),
      ),
    );

    expect(find.text(SearchStrings.topResult), findsOneWidget);
    expect(find.text('Queen'), findsOneWidget);
    expect(find.text(SearchStrings.artistBadge), findsOneWidget);
  });
}
