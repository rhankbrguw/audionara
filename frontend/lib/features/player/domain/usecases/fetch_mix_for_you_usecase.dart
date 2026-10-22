import '../../domain/entities/track.dart';
import '../repositories/track_repository.dart';

class FetchMixForYouUseCase {
  const FetchMixForYouUseCase({required this.repository});

  final TrackRepository repository;

  Future<List<Track>> call() async {
    return repository.fetchMixForYou();
  }
}
