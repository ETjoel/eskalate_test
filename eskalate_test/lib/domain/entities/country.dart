import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String name;
  final String flag;
  final int population;
  final double area;
  final String region;
  final String subregion;
  final List<String> timezones;
  final String cca2; // Country code for unique identification

  const Country({
    required this.name,
    required this.flag,
    required this.population,
    required this.area,
    required this.region,
    required this.subregion,
    required this.timezones,
    required this.cca2,
  });

  @override
  List<Object?> get props => [
        name,
        flag,
        population,
        area,
        region,
        subregion,
        timezones,
        cca2,
      ];
}
