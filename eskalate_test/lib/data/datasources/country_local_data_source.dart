import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country_model.dart';

abstract class CountryLocalDataSource {
  Future<List<CountryModel>> getFavoriteCountries();
  Future<void> addToFavorites(CountryModel country);
  Future<void> removeFromFavorites(String countryCode);
  Future<bool> isFavorite(String countryCode);
}

class CountryLocalDataSourceImpl implements CountryLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String favoritesKey = 'FAVORITE_COUNTRIES';

  CountryLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CountryModel>> getFavoriteCountries() async {
    final jsonString = sharedPreferences.getString(favoritesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => CountryModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> addToFavorites(CountryModel country) async {
    final favorites = await getFavoriteCountries();
    
    // Check if country is already in favorites
    if (!favorites.any((fav) => fav.cca2 == country.cca2)) {
      favorites.add(country);
      final jsonString = json.encode(favorites.map((c) => c.toJson()).toList());
      await sharedPreferences.setString(favoritesKey, jsonString);
    }
  }

  @override
  Future<void> removeFromFavorites(String countryCode) async {
    final favorites = await getFavoriteCountries();
    favorites.removeWhere((country) => country.cca2 == countryCode);
    
    final jsonString = json.encode(favorites.map((c) => c.toJson()).toList());
    await sharedPreferences.setString(favoritesKey, jsonString);
  }

  @override
  Future<bool> isFavorite(String countryCode) async {
    final favorites = await getFavoriteCountries();
    return favorites.any((country) => country.cca2 == countryCode);
  }
}
