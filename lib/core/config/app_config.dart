import 'environment_config.dart';

class AppConfig {
  // Configuración de la URL base de la API REST Countries
  static String get baseUrl => EnvironmentConfig.baseUrl;

  // URLs específicas para la API REST Countries
  static String get allCountriesUrl =>
      '$baseUrl/all?fields=name,flags,capital,languages,area,borders,population,region,subregion,cca3';
  static String searchCountriesByNameUrl(String name) =>
      '$baseUrl/name/$name?fields=name,flags,capital,languages,area,borders,population,region,subregion,cca3';

  // Otras configuraciones de la app
  static const String appName = 'Countries App';
  static const String appVersion = '1.0.0';

  // Timeouts para las peticiones HTTP (desde configuración de entorno)
  static Duration get connectionTimeout =>
      Duration(seconds: EnvironmentConfig.connectionTimeout);
  static Duration get receiveTimeout =>
      Duration(seconds: EnvironmentConfig.receiveTimeout);

  // Configuración de desarrollo vs producción
  static bool get isDebugMode => EnvironmentConfig.isDevelopment;

  // Logging
  static bool get enableHttpLogging => EnvironmentConfig.enableLogging;
}
