import 'package:flutter/material.dart';

Color parseColor(dynamic hex, Color fallback) {
  if (hex is! String || hex.isEmpty) return fallback;
  try {
    final clean = hex.replaceFirst('#', '');
    final val = clean.length == 6 ? 'ff$clean' : clean;
    return Color(int.parse(val, radix: 16));
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
    case 'directions_car':
      return Icons.directions_car;
    case 'sunset':
      return Icons.wb_twilight;
    case 'hot':
      return Icons.local_fire_department;
    default:
      return Icons.music_note;
  }
}
