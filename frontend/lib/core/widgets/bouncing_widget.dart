import 'package:flutter/material.dart';
import '../constants/animation_constants.dart';
import 'interactive_pressable.dart';

/// BouncingWidget provides unified tactile spring-scale feedback.
class BouncingWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scaleFactor;

  const BouncingWidget({
    super.key,
    required this.child,
    required this.onTap,
    this.scaleFactor = AnimationConstants.pressedScale,
  });

  @override
  Widget build(BuildContext context) {
    return InteractivePressable(
      onTap: onTap,
      scaleFactor: scaleFactor,
      child: child,
    );
  }
}
