import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/countries/countries_bloc.dart';
import '../bloc/countries/countries_event.dart';
import '../bloc/countries/countries_state.dart';
import '../widgets/country_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'country_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // Load favorite countries when screen is initialized
    context.read<CountriesBloc>().add(LoadFavoriteCountriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Countries'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
          if (state is CountriesLoading) {
            return const LoadingWidget(
              message: 'Loading favorite countries...',
            );
          } else if (state is CountriesError) {
            return CustomErrorWidget(
              title: 'Error Loading Favorites',
              message: state.message,
              onRetry: () {
                context.read<CountriesBloc>().add(LoadFavoriteCountriesEvent());
              },
            );
          } else if (state is CountriesLoaded) {
            if (state.favoriteCountries.isEmpty) {
              return const EmptyStateWidget(
                title: 'No Favorite Countries',
                message: 'Add countries to your favorites by tapping the heart icon on the home screen',
                icon: Icons.favorite_border,
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
              itemCount: state.favoriteCountries.length,
              itemBuilder: (context, index) {
                final country = state.favoriteCountries[index];

                return CountryCard(
                  country: country,
                  isFavorite: true, // All countries in this screen are favorites
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CountryDetailScreen(
                          country: country,
                          isFavorite: true,
                        ),
                      ),
                    );
                  },
                  onFavoriteToggle: () {
                    // Show confirmation dialog before removing from favorites
                    _showRemoveFromFavoritesDialog(context, country);
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showRemoveFromFavoritesDialog(BuildContext context, country) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Remove from Favorites'),
          content: Text(
            'Are you sure you want to remove ${country.name} from your favorites?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<CountriesBloc>().add(
                      ToggleFavoriteEvent(country),
                    );
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
