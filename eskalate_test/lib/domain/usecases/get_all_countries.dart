import '../../core/usecases/usecase.dart';
import '../entities/country.dart';
import '../repositories/country_repository.dart';

class GetAllCountries implements UseCase<List<Country>, NoParams> {
  final CountryRepository repository;

  GetAllCountries(this.repository);

  @override
  Future<List<Country>> call(NoParams params) async {
    return await repository.getAllCountries();
  }
}
