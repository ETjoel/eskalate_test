import '../../domain/entities/country.dart';
import '../../domain/repositories/country_repository.dart';
import '../datasources/country_local_data_source.dart';
import '../datasources/country_remote_data_source.dart';
import '../models/country_model.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryRemoteDataSource remoteDataSource;
  final CountryLocalDataSource localDataSource;

  CountryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Country>> getAllCountries() async {
    try {
      final remoteCountries = await remoteDataSource.getAllCountries();
      return remoteCountries;
    } catch (e) {
      throw Exception('Failed to fetch countries: $e');
    }
  }

  @override
  Future<List<Country>> getFavoriteCountries() async {
    try {
      final favoriteCountries = await localDataSource.getFavoriteCountries();
      return favoriteCountries;
    } catch (e) {
      throw Exception('Failed to fetch favorite countries: $e');
    }
  }

  @override
  Future<void> addToFavorites(Country country) async {
    try {
      final countryModel = CountryModel.fromEntity(country);
      await localDataSource.addToFavorites(countryModel);
    } catch (e) {
      throw Exception('Failed to add country to favorites: $e');
    }
  }

  @override
  Future<void> removeFromFavorites(String countryCode) async {
    try {
      await localDataSource.removeFromFavorites(countryCode);
    } catch (e) {
      throw Exception('Failed to remove country from favorites: $e');
    }
  }

  @override
  Future<bool> isFavorite(String countryCode) async {
    try {
      return await localDataSource.isFavorite(countryCode);
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }
}
