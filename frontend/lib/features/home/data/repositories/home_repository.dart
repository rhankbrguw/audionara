import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/auth_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import 'home_feed_models.dart';

export 'home_feed_models.dart';

class HomeRepository {
  final AuthClient _authClient;
  HomeFeed? _cachedFeed;

  HomeRepository(this._authClient);

  Future<HomeFeed> getHomeFeed({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedFeed != null) return _cachedFeed!;
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceId = prefs.getString('device_id') ?? '';
      final url = Uri.parse('${AppConstants.apiBaseUrl}/api/v1/home/feed?device_id=$deviceId');
      final response = await _authClient.get(url);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final feed = HomeFeed.fromJson(body);
        if (feed.trendingHits.isNotEmpty && feed.exploreVibes.isNotEmpty) {
          _cachedFeed = feed;
          return feed;
        }
      }
    } catch (_) {}

    return _fallbackFeed();
  }

  HomeFeed _fallbackFeed() => const HomeFeed(
    trendingHits: [
      HomeTrending(
        title: 'Global Top 50',
        subtitle: 'The most played tracks globally',
        badge: 'HOT',
        color1: AppColors.primary,
        color2: AppColors.secondary,
      ),
      HomeTrending(
        title: 'Viral 50',
        subtitle: 'Trending on the internet right now',
        badge: 'VIRAL',
        color1: AppColors.secondary,
        color2: AppColors.primary,
      ),
      HomeTrending(
        title: 'New Releases',
        subtitle: 'Freshly dropped tracks this week',
        badge: 'NEW',
        color1: AppColors.accent,
        color2: AppColors.primary,
      ),
    ],
    exploreVibes: [
      HomeExploreVibe(name: 'Lo-Fi', icon: Icons.coffee, color1: AppColors.primary, color2: AppColors.secondary),
      HomeExploreVibe(name: 'Deep Focus', icon: Icons.headphones, color1: AppColors.accent, color2: AppColors.primary),
      HomeExploreVibe(name: 'Workout', icon: Icons.fitness_center, color1: AppColors.secondary, color2: AppColors.primary),
      HomeExploreVibe(name: 'Sleep', icon: Icons.bedtime, color1: AppColors.surfaceVariant, color2: AppColors.surface),
      HomeExploreVibe(name: 'Acoustic', icon: Icons.music_note, color1: AppColors.primary, color2: AppColors.accent),
      HomeExploreVibe(name: 'Party', icon: Icons.celebration, color1: AppColors.accent, color2: AppColors.secondary),
    ],
    favoriteArtists: [
      HomeArtist(id: 12246, name: 'Taylor Swift', picture: 'https://cdn-images.dzcdn.net/images/artist/e528e270424103b527f8a27ac625563b/500x500-000000-80-0-0.jpg'),
      HomeArtist(id: 4050205, name: 'The Weeknd', picture: 'https://cdn-images.dzcdn.net/images/artist/581693b4724a7fcfa754455101e13a44/500x500-000000-80-0-0.jpg'),
      HomeArtist(id: 384236, name: 'Ed Sheeran', picture: 'https://cdn-images.dzcdn.net/images/artist/d6bb84390641d8ae9118228d9544e53d/500x500-000000-80-0-0.jpg'),
      HomeArtist(id: 1562681, name: 'Ariana Grande', picture: 'https://cdn-images.dzcdn.net/images/artist/721d8fab84b315502de422b8d0901509/500x500-000000-80-0-0.jpg'),
      HomeArtist(id: 288166, name: 'Justin Bieber', picture: 'https://cdn-images.dzcdn.net/images/artist/fe097f693cebf1f882e3da79e99e3bf9/500x500-000000-80-0-0.jpg'),
      HomeArtist(id: 6982223, name: 'BTS', picture: 'https://cdn-images.dzcdn.net/images/artist/b5c64fa8216ca158e52b4d88bd9388ff/500x500-000000-80-0-0.jpg'),
    ],
  );
}
