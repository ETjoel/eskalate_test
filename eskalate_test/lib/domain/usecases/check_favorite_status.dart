import 'package:equatable/equatable.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/country_repository.dart';

class CheckFavoriteStatus implements UseCase<bool, CheckFavoriteParams> {
  final CountryRepository repository;

  CheckFavoriteStatus(this.repository);

  @override
  Future<bool> call(CheckFavoriteParams params) async {
    return await repository.isFavorite(params.countryCode);
  }
}

class CheckFavoriteParams extends Equatable {
  final String countryCode;

  const CheckFavoriteParams({required this.countryCode});

  @override
  List<Object> get props => [countryCode];
}
