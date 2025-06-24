import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/country_model.dart';

abstract class CountryRemoteDataSource {
  Future<List<CountryModel>> getAllCountries();
}

class CountryRemoteDataSourceImpl implements CountryRemoteDataSource {
  final http.Client client;

  CountryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CountryModel>> getAllCountries() async {
    try {
      final response = await client
          .get(
            Uri.parse(ApiConstants.allCountriesUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        if (jsonList.isEmpty) {
          throw Exception('No countries data received from API');
        }

        return jsonList
            .map((json) => CountryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception('Countries API endpoint not found');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error: ${response.statusCode}');
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Network error occurred. Please try again.');
    } on FormatException {
      throw Exception('Invalid data format received from server.');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }
}
