import '../entities/track.dart';
import '../repositories/track_repository.dart';

class LogHistoryUseCase {
  final TrackRepository repository;

  LogHistoryUseCase(this.repository);

  Future<void> call(Track track) async {
    await repository.logHistory(track);
  }
}
