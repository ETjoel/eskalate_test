import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/country.dart';
import '../bloc/countries/countries_bloc.dart';
import '../bloc/countries/countries_event.dart';
import '../bloc/countries/countries_state.dart';
import '../widgets/country_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'country_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    context.read<CountriesBloc>().add(LoadCountriesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      context.read<CountriesBloc>().add(SearchCountriesEvent(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search countries...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<CountriesBloc>().add(
                                const SearchCountriesEvent(''),
                              );
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                _onSearchChanged(query);
                setState(() {}); // To update the clear button visibility
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<CountriesBloc, CountriesState>(
              builder: (context, state) {
                if (state is CountriesLoading) {
                  return const LoadingWidget(
                    message: 'Loading countries...',
                  );
                } else if (state is CountriesError) {
                  return CustomErrorWidget(
                    title: 'Error Loading Countries',
                    message: state.message,
                    onRetry: () {
                      context.read<CountriesBloc>().add(LoadCountriesEvent());
                    },
                  );
                } else if (state is CountriesLoaded) {
                  if (state.filteredCountries.isEmpty) {
                    return EmptyStateWidget(
                      title: state.searchQuery.isEmpty
                          ? 'No Countries Available'
                          : 'No Countries Found',
                      message: state.searchQuery.isEmpty
                          ? 'Please check your internet connection and try again'
                          : 'Try searching with different keywords or clear the search',
                      icon: state.searchQuery.isEmpty
                          ? Icons.public_off
                          : Icons.search_off,
                      action: state.searchQuery.isNotEmpty
                          ? ElevatedButton(
                              onPressed: () {
                                _searchController.clear();
                                context.read<CountriesBloc>().add(
                                      const SearchCountriesEvent(''),
                                    );
                              },
                              child: const Text('Clear Search'),
                            )
                          : null,
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: state.filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = state.filteredCountries[index];
                      final isFavorite = state.favoriteCountries
                          .any((fav) => fav.cca2 == country.cca2);

                      return CountryCard(
                        country: country,
                        isFavorite: isFavorite,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CountryDetailScreen(
                                country: country,
                                isFavorite: isFavorite,
                              ),
                            ),
                          );
                        },
                        onFavoriteToggle: () {
                          context.read<CountriesBloc>().add(
                                ToggleFavoriteEvent(country),
                              );
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
