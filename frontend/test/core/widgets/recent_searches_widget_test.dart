import 'package:audionara/core/constants/search_strings.dart';
import 'package:audionara/core/theme/app_colors.dart';
import 'package:audionara/features/home/data/repositories/home_repository.dart';
import 'package:audionara/features/home/presentation/widgets/recent_searches_widget.dart';
import 'package:audionara/features/home/presentation/widgets/search_artist_fisheye.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeHomeRepository implements HomeRepository {
  @override
  Future<HomeFeed> getHomeFeed({bool forceRefresh = false, int seed = 0}) async {
    return const HomeFeed(
      trendingHits: [],
      exploreVibes: [
        HomeExploreVibe(name: 'Synthwave', icon: Icons.waves, color1: AppColors.primary, color2: AppColors.secondary),
        HomeExploreVibe(name: 'Lo-Fi', icon: Icons.coffee, color1: AppColors.secondary, color2: AppColors.primary),
      ],
      favoriteArtists: [
        HomeArtist(id: 412, name: 'Nirvana', picture: ''),
      ],
      baseArtist: 'Nirvana',
      similarArtists: [
        HomeArtist(id: 123, name: 'Pearl Jam', picture: ''),
      ],
    );
  }
}

void main() {
  testWidgets('RecentSearchesWidget renders similar artists fisheye and recent searches', (tester) async {
    String? searchedQuery;
    bool cleared = false;

    await tester.pumpWidget(
      RepositoryProvider<HomeRepository>(
        create: (_) => FakeHomeRepository(),
        child: MaterialApp(
          home: Scaffold(
            body: RecentSearchesWidget(
              recentSearches: const ['Radiohead'],
              onClearAll: () => cleared = true,
              onSearch: (q) => searchedQuery = q,
              narrativeSeed: 0,
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text(SearchStrings.recentSearchesLabel), findsOneWidget);
    expect(find.text('Radiohead'), findsOneWidget);
    expect(find.text(SearchStrings.becauseYouListen('Nirvana')), findsOneWidget);
    expect(find.byType(SearchArtistFisheye), findsOneWidget);
    expect(find.text('Pearl Jam'), findsOneWidget);

    await tester.tap(find.text(SearchStrings.clearAll));
    await tester.pump();
    expect(cleared, isTrue);

    await tester.tap(find.text('Radiohead'));
    await tester.pump();
    expect(searchedQuery, 'Radiohead');
  });

  testWidgets('RecentSearchesWidget shows searchPrompt when recentSearches is empty', (tester) async {
    await tester.pumpWidget(
      RepositoryProvider<HomeRepository>(
        create: (_) => FakeHomeRepository(),
        child: MaterialApp(
          home: Scaffold(
            body: RecentSearchesWidget(
              recentSearches: const [],
              onClearAll: () {},
              onSearch: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text(SearchStrings.searchPrompt), findsOneWidget);
  });
}
