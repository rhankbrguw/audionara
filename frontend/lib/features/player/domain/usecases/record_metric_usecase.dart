import '../repositories/track_repository.dart';

class RecordMetricUseCase {
  const RecordMetricUseCase(this.repository);

  final TrackRepository repository;

  Future<void> call(String trackId, String vibe, String action) async {
    return repository.recordPlaybackMetric(trackId, vibe, action);
  }
}
