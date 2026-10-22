import 'package:flutter/material.dart';
import '../constants/animation_constants.dart';

/// InteractivePressable wraps any widget with tactile spring-scale micro-feedback.
class InteractivePressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final double scaleFactor;

  const InteractivePressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.scaleFactor = AnimationConstants.pressedScale,
  });

  @override
  State<InteractivePressable> createState() => _InteractivePressableState();
}

class _InteractivePressableState extends State<InteractivePressable> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onTap != null || widget.onLongPress != null) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (_isPressed) setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (_isPressed) setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? widget.scaleFactor : AnimationConstants.restingScale,
        duration: AnimationConstants.durationFast,
        curve: AnimationConstants.springCurve,
        child: AnimatedOpacity(
          opacity: _isPressed ? AnimationConstants.activeOpacity : AnimationConstants.restingOpacity,
          duration: AnimationConstants.durationFast,
          curve: AnimationConstants.springCurve,
          child: widget.child,
        ),
      ),
    );
  }
}
