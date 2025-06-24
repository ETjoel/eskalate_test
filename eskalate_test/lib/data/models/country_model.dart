import '../../domain/entities/country.dart';

class CountryModel extends Country {
  const CountryModel({
    required super.name,
    required super.flag,
    required super.population,
    required super.area,
    required super.region,
    required super.subregion,
    required super.timezones,
    required super.cca2,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    // Safely extract name
    String countryName = '';
    if (json['name'] != null && json['name']['common'] != null) {
      countryName = json['name']['common'].toString();
    }

    // Safely extract flag URL
    String flagUrl = '';
    if (json['flags'] != null) {
      flagUrl = json['flags']['png']?.toString() ??
                json['flags']['svg']?.toString() ?? '';
    }

    // Safely extract population
    int population = 0;
    if (json['population'] != null) {
      population = (json['population'] is int)
          ? json['population']
          : int.tryParse(json['population'].toString()) ?? 0;
    }

    // Safely extract area
    double area = 0.0;
    if (json['area'] != null) {
      area = (json['area'] is double)
          ? json['area']
          : double.tryParse(json['area'].toString()) ?? 0.0;
    }

    // Safely extract timezones
    List<String> timezones = [];
    if (json['timezones'] != null && json['timezones'] is List) {
      timezones = (json['timezones'] as List)
          .map((tz) => tz.toString())
          .toList();
    }

    return CountryModel(
      name: countryName,
      flag: flagUrl,
      population: population,
      area: area,
      region: json['region']?.toString() ?? '',
      subregion: json['subregion']?.toString() ?? '',
      timezones: timezones,
      cca2: json['cca2']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'flags': {'png': flag},
      'population': population,
      'area': area,
      'region': region,
      'subregion': subregion,
      'timezones': timezones,
      'cca2': cca2,
    };
  }

  factory CountryModel.fromEntity(Country country) {
    return CountryModel(
      name: country.name,
      flag: country.flag,
      population: country.population,
      area: country.area,
      region: country.region,
      subregion: country.subregion,
      timezones: country.timezones,
      cca2: country.cca2,
    );
  }
}
