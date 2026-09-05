import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

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
  final IconData icon;
  final Color color1;
  final Color color2;

  const HomeExploreVibe({
    required this.name,
    required this.icon,
    required this.color1,
    required this.color2,
  });

  factory HomeExploreVibe.fromJson(Map<String, dynamic> json) {
    final iconName = json['icon'] as String? ?? '';
    return HomeExploreVibe(
      name: json['name'] ?? '',
      icon: parseIcon(iconName),
      color1: parseColor(json['color1'], AppColors.primary),
      color2: parseColor(json['color2'], AppColors.secondary),
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
    return HomeFeed(
      trendingHits: trending,
      exploreVibes: vibes,
      favoriteArtists: artists,
      baseArtist: d['base_artist'] as String? ?? '',
      similarArtists: similar,
    );
  }
}

Color parseColor(dynamic hex, Color fallback) {
  if (hex == null || hex is! String || hex.isEmpty) return fallback;
  try {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  } catch (_) {
    return fallback;
  }
}

IconData parseIcon(String name) {
  switch (name) {
    case 'coffee':
      return Icons.coffee;
    case 'headphones':
      return Icons.headphones;
    case 'fitness_center':
      return Icons.fitness_center;
    case 'bedtime':
      return Icons.bedtime;
    case 'celebration':
      return Icons.celebration;
    case 'holiday':
      return Icons.card_giftcard;
    case 'sunny':
      return Icons.sunny;
    case 'cloud':
      return Icons.cloud;
    case 'ac_unit':
      return Icons.ac_unit;
    default:
      return Icons.music_note;
  }
}
