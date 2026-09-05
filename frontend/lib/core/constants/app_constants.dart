import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

abstract final class AppConstants {
  static const exploreVibes = [
    {
      'name': 'Synthwave',
      'icon': Icons.waves,
      'color1': AppColors.vibeSynthwave1,
      'color2': AppColors.vibeSynthwave2,
    },
    {
      'name': 'Lofi',
      'icon': Icons.coffee,
      'color1': AppColors.vibeLofi1,
      'color2': AppColors.vibeLofi2,
    },
    {
      'name': 'Deep Focus',
      'icon': Icons.headphones,
      'color1': AppColors.vibeFocus1,
      'color2': AppColors.vibeFocus2,
    },
    {
      'name': 'Workout',
      'icon': Icons.fitness_center,
      'color1': AppColors.vibeWorkout1,
      'color2': AppColors.vibeWorkout2,
    },
    {
      'name': 'Acoustic',
      'icon': Icons.music_note,
      'color1': AppColors.vibeAcoustic1,
      'color2': AppColors.vibeAcoustic2,
    },
    {
      'name': 'Night Drive',
      'icon': Icons.directions_car,
      'color1': AppColors.vibeNight1,
      'color2': AppColors.vibeNight2,
    },
  ];

  static const commonEmailTypos = [
    '@gmail.co', '@gmail.con', '@gmai.com', '@gmal.com',
    '@yahoo.co', '@yahoo.con', '@hotmail.co', '@hotmail.con',
  ];

  static String get apiBaseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) return envUrl;

    if (const bool.fromEnvironment('dart.vm.product')) {
      return 'https://api-audionara.rhankbrguw.xyz';
    }

    return Platform.isAndroid
        ? 'http://10.0.2.2:8080'
        : 'http://127.0.0.1:8080';
  }
}
