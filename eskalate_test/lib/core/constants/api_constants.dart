class ApiConstants {
  static const String baseUrl = 'https://restcountries.com/v3.1';
  static const String allCountriesEndpoint = '/all';
  static const String fieldsQuery = 'fields=name,flags,population,area,region,subregion,timezones,cca2';
  
  static String get allCountriesUrl => '$baseUrl$allCountriesEndpoint?$fieldsQuery';
  
  // Timeout constants
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
