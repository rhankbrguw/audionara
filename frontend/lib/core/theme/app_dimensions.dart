/// Design token library for spacing values.
///
/// All layout spacing should reference these constants.
/// Never use ad-hoc EdgeInsets with magic numbers in widgets.
abstract final class AppSpacing {
  // Base unit = 4px
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Design token library for border radius values.
///
/// All rounded corners should reference these constants.
abstract final class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double chip = 24.0;
  static const double circular = 999.0;
}

/// Design token library for icon sizes.
abstract final class AppIconSize {
  static const double sm = 18.0;
  static const double md = 24.0;
  static const double lg = 32.0;
  static const double xl = 48.0;
}
