import 'package:equatable/equatable.dart';
import '../../../domain/entities/country.dart';

abstract class CountriesState extends Equatable {
  const CountriesState();

  @override
  List<Object> get props => [];
}

class CountriesInitial extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesLoaded extends CountriesState {
  final List<Country> countries;
  final List<Country> filteredCountries;
  final List<Country> favoriteCountries;
  final String searchQuery;

  const CountriesLoaded({
    required this.countries,
    required this.filteredCountries,
    required this.favoriteCountries,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [countries, filteredCountries, favoriteCountries, searchQuery];

  CountriesLoaded copyWith({
    List<Country>? countries,
    List<Country>? filteredCountries,
    List<Country>? favoriteCountries,
    String? searchQuery,
  }) {
    return CountriesLoaded(
      countries: countries ?? this.countries,
      filteredCountries: filteredCountries ?? this.filteredCountries,
      favoriteCountries: favoriteCountries ?? this.favoriteCountries,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class CountriesError extends CountriesState {
  final String message;

  const CountriesError(this.message);

  @override
  List<Object> get props => [message];
}
