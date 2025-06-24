import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/country_local_data_source.dart';
import '../../data/datasources/country_remote_data_source.dart';
import '../../data/repositories/country_repository_impl.dart';
import '../../domain/repositories/country_repository.dart';
import '../../domain/usecases/check_favorite_status.dart';
import '../../domain/usecases/get_all_countries.dart';
import '../../domain/usecases/get_favorite_countries.dart';
import '../../domain/usecases/toggle_favorite_country.dart';
import '../../presentation/bloc/countries/countries_bloc.dart';

class InjectionContainer {
  static late SharedPreferences _sharedPreferences;
  static late http.Client _httpClient;
  
  // Data sources
  static late CountryRemoteDataSource _remoteDataSource;
  static late CountryLocalDataSource _localDataSource;
  
  // Repository
  static late CountryRepository _repository;
  
  // Use cases
  static late GetAllCountries _getAllCountries;
  static late GetFavoriteCountries _getFavoriteCountries;
  static late ToggleFavoriteCountry _toggleFavoriteCountry;
  static late CheckFavoriteStatus _checkFavoriteStatus;
  
  // Bloc
  static late CountriesBloc _countriesBloc;

  static Future<void> init() async {
    // External dependencies
    _sharedPreferences = await SharedPreferences.getInstance();
    _httpClient = http.Client();
    
    // Data sources
    _remoteDataSource = CountryRemoteDataSourceImpl(client: _httpClient);
    _localDataSource = CountryLocalDataSourceImpl(sharedPreferences: _sharedPreferences);
    
    // Repository
    _repository = CountryRepositoryImpl(
      remoteDataSource: _remoteDataSource,
      localDataSource: _localDataSource,
    );
    
    // Use cases
    _getAllCountries = GetAllCountries(_repository);
    _getFavoriteCountries = GetFavoriteCountries(_repository);
    _toggleFavoriteCountry = ToggleFavoriteCountry(_repository);
    _checkFavoriteStatus = CheckFavoriteStatus(_repository);
    
    // Bloc
    _countriesBloc = CountriesBloc(
      getAllCountries: _getAllCountries,
      getFavoriteCountries: _getFavoriteCountries,
      toggleFavoriteCountry: _toggleFavoriteCountry,
    );
  }

  // Getters
  static CountriesBloc get countriesBloc => _countriesBloc;
  static CheckFavoriteStatus get checkFavoriteStatus => _checkFavoriteStatus;
}
