import 'package:equatable/equatable.dart';
import '../../../domain/entities/country.dart';

abstract class CountriesEvent extends Equatable {
  const CountriesEvent();

  @override
  List<Object> get props => [];
}

class LoadCountriesEvent extends CountriesEvent {}

class SearchCountriesEvent extends CountriesEvent {
  final String query;

  const SearchCountriesEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ToggleFavoriteEvent extends CountriesEvent {
  final Country country;

  const ToggleFavoriteEvent(this.country);

  @override
  List<Object> get props => [country];
}

class LoadFavoriteCountriesEvent extends CountriesEvent {}
