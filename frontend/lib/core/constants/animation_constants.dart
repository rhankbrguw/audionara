import 'package:flutter/animation.dart';

/// Centralized animation constants for fluid UI transitions and micro-interactions.
abstract final class AnimationConstants {
  static const Duration durationFast = Duration(milliseconds: 120);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationPage = Duration(milliseconds: 320);
  static const Duration durationModal = Duration(milliseconds: 380);

  static const double pressedScale = 0.96;
  static const double activeOpacity = 0.88;
  static const double restingScale = 1.0;
  static const double restingOpacity = 1.0;

  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
  static const Curve springCurve = Curves.easeInOutCubic;
}
