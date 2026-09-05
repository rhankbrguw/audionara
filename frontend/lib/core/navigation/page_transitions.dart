import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/animation_constants.dart';

/// AppPageTransitions provides silky-smooth, hardware-accelerated transitions.
abstract final class AppPageTransitions {
  /// Forward push transition with subtle slide, scale and fade.
  static CustomTransitionPage<void> slideFade({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: AnimationConstants.durationPage,
      reverseTransitionDuration: AnimationConstants.durationPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: AnimationConstants.easeOutCubic,
          reverseCurve: AnimationConstants.easeOutCubic,
        );

        final slideTween = Tween<Offset>(
          begin: const Offset(0.04, 0.0),
          end: Offset.zero,
        ).animate(curvedAnimation);

        final fadeTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(curvedAnimation);

        return SlideTransition(
          position: slideTween,
          child: FadeTransition(
            opacity: fadeTween,
            child: child,
          ),
        );
      },
    );
  }

  /// Modal bottom-up slide transition for player and sheets.
  static CustomTransitionPage<void> modalSheet({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: AnimationConstants.durationModal,
      reverseTransitionDuration: AnimationConstants.durationModal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: AnimationConstants.easeOutCubic,
          reverseCurve: AnimationConstants.easeOutCubic,
        );

        final slideTween = Tween<Offset>(
          begin: const Offset(0.0, 0.2),
          end: Offset.zero,
        ).animate(curvedAnimation);

        final fadeTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(curvedAnimation);

        return SlideTransition(
          position: slideTween,
          child: FadeTransition(
            opacity: fadeTween,
            child: child,
          ),
        );
      },
    );
  }
}
