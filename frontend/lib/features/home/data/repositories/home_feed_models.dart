import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'feed_parser_helpers.dart';

class HomeTrending {
  final String title;
  final String subtitle;
  final String badge;
  final Color color1;
  final Color color2;

  const HomeTrending({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.color1,
    required this.color2,
  });

  factory HomeTrending.fromJson(Map<String, dynamic> json) {
    return HomeTrending(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      badge: json['badge'] ?? '',
      color1: parseColor(json['color1'], AppColors.primary),
      color2: parseColor(json['color2'], AppColors.secondary),
    );
  }
}

class HomeExploreVibe {
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color1;
  final Color color2;
  final String cover;

  const HomeExploreVibe({
    required this.name,
    this.subtitle = '',
    required this.icon,
    required this.color1,
    required this.color2,
    this.cover = '',
  });

  factory HomeExploreVibe.fromJson(Map<String, dynamic> json) {
    final iconName = json['icon'] as String? ?? '';
    return HomeExploreVibe(
      name: json['name'] ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      icon: parseIcon(iconName),
      color1: parseColor(json['color1'], AppColors.primary),
      color2: parseColor(json['color2'], AppColors.secondary),
      cover: json['cover'] as String? ?? '',
    );
  }
}

class HomeArtist {
  final int id;
  final String name;
  final String picture;

  const HomeArtist({
    required this.id,
    required this.name,
    required this.picture,
  });

  factory HomeArtist.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return HomeArtist(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '0') ?? 0,
      name: json['name'] as String? ?? '',
      picture: json['picture'] as String? ?? '',
    );
  }
}

class HomeFeed {
  final List<HomeTrending> trendingHits;
  final List<HomeExploreVibe> exploreVibes;
  final List<HomeArtist> favoriteArtists;
  final String baseArtist;
  final List<HomeArtist> similarArtists;

  const HomeFeed({
    required this.trendingHits,
    required this.exploreVibes,
    required this.favoriteArtists,
    this.baseArtist = '',
    this.similarArtists = const [],
  });

  factory HomeFeed.fromJson(Map<String, dynamic> json) {
    final d = json['data'] as Map<String, dynamic>? ?? {};
    final trending = (d['trending_hits'] as List?)
            ?.map((e) => HomeTrending.fromJson(e)).toList() ?? [];
    final vibes = (d['explore_vibes'] as List?)
            ?.map((e) => HomeExploreVibe.fromJson(e)).toList() ?? [];
    final artists = (d['favorite_artists'] as List?)
            ?.map((e) => HomeArtist.fromJson(e)).toList() ?? [];
    final similar = (d['similar_artists'] as List?)
            ?.map((e) => HomeArtist.fromJson(e)).toList() ?? [];
    return HomeFeed(trendingHits: trending, exploreVibes: vibes, favoriteArtists: artists, baseArtist: d['base_artist'] as String? ?? '', similarArtists: similar);
  }
}

