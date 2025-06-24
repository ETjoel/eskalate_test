import 'package:equatable/equatable.dart';
import '../../core/usecases/usecase.dart';
import '../entities/country.dart';
import '../repositories/country_repository.dart';

class ToggleFavoriteCountry implements UseCase<void, ToggleFavoriteParams> {
  final CountryRepository repository;

  ToggleFavoriteCountry(this.repository);

  @override
  Future<void> call(ToggleFavoriteParams params) async {
    final isFavorite = await repository.isFavorite(params.country.cca2);
    
    if (isFavorite) {
      await repository.removeFromFavorites(params.country.cca2);
    } else {
      await repository.addToFavorites(params.country);
    }
  }
}

class ToggleFavoriteParams extends Equatable {
  final Country country;

  const ToggleFavoriteParams({required this.country});

  @override
  List<Object> get props => [country];
}
