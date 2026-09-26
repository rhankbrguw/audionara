/// Typed enum for player vibe/source identifiers.
///
/// Replaces bare string literals ('playlist', 'mix_for_you') in the BLoC
/// to prevent typo-driven logic bugs and enable exhaustive switch statements.
enum VibeType {
  playlist,
  mixForYou,
  custom;

  /// Serialised identifier sent to the backend metrics endpoint.
  String get key {
    switch (this) {
      case VibeType.playlist:
        return 'playlist';
      case VibeType.mixForYou:
        return 'mix_for_you';
      case VibeType.custom:
        return 'custom';
    }
  }

  static VibeType fromKey(String key) {
    switch (key) {
      case 'playlist':
        return VibeType.playlist;
      case 'mix_for_you':
        return VibeType.mixForYou;
      default:
        return VibeType.custom;
    }
  }
}
