import '../entities/country.dart';

abstract class CountryRepository {
  Future<List<Country>> getAllCountries();
  Future<List<Country>> getFavoriteCountries();
  Future<void> addToFavorites(Country country);
  Future<void> removeFromFavorites(String countryCode);
  Future<bool> isFavorite(String countryCode);
}
