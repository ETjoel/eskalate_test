import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/country.dart';
import '../../../domain/usecases/get_all_countries.dart';
import '../../../domain/usecases/get_favorite_countries.dart';
import '../../../domain/usecases/toggle_favorite_country.dart';
import 'countries_event.dart';
import 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  final GetAllCountries getAllCountries;
  final GetFavoriteCountries getFavoriteCountries;
  final ToggleFavoriteCountry toggleFavoriteCountry;

  CountriesBloc({
    required this.getAllCountries,
    required this.getFavoriteCountries,
    required this.toggleFavoriteCountry,
  }) : super(CountriesInitial()) {
    on<LoadCountriesEvent>(_onLoadCountries);
    on<SearchCountriesEvent>(_onSearchCountries);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<LoadFavoriteCountriesEvent>(_onLoadFavoriteCountries);
  }

  Future<void> _onLoadCountries(
    LoadCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    emit(CountriesLoading());
    try {
      final countries = await getAllCountries(NoParams());
      final favoriteCountries = await getFavoriteCountries(NoParams());
      
      emit(CountriesLoaded(
        countries: countries,
        filteredCountries: countries,
        favoriteCountries: favoriteCountries,
      ));
    } catch (e) {
      emit(CountriesError(e.toString()));
    }
  }

  Future<void> _onSearchCountries(
    SearchCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    if (state is CountriesLoaded) {
      final currentState = state as CountriesLoaded;
      final filteredCountries = event.query.isEmpty
          ? currentState.countries
          : currentState.countries
              .where((country) =>
                  country.name.toLowerCase().contains(event.query.toLowerCase()))
              .toList();

      emit(currentState.copyWith(
        filteredCountries: filteredCountries,
        searchQuery: event.query,
      ));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<CountriesState> emit,
  ) async {
    if (state is CountriesLoaded) {
      try {
        await toggleFavoriteCountry(ToggleFavoriteParams(country: event.country));
        
        // Reload favorite countries
        final favoriteCountries = await getFavoriteCountries(NoParams());
        final currentState = state as CountriesLoaded;
        
        emit(currentState.copyWith(favoriteCountries: favoriteCountries));
      } catch (e) {
        emit(CountriesError(e.toString()));
      }
    }
  }

  Future<void> _onLoadFavoriteCountries(
    LoadFavoriteCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    if (state is CountriesLoaded) {
      try {
        final favoriteCountries = await getFavoriteCountries(NoParams());
        final currentState = state as CountriesLoaded;
        
        emit(currentState.copyWith(favoriteCountries: favoriteCountries));
      } catch (e) {
        emit(CountriesError(e.toString()));
      }
    }
  }
}
