// lib/data/datasources/pais_remote_data_source.dart
import 'package:dio/dio.dart';
import '../../core/config/app_config.dart'; // Para baseUrl
// Si usas tu entidad directamente para el parsing aquí, impórtala
// import '../../domain/entities/pais_entity.dart';

abstract class PaisRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchAllPaises();
  Future<List<Map<String, dynamic>>> searchPaisesByName(String name);
}

class PaisRemoteDataSourceImpl implements PaisRemoteDataSource {
  final Dio dio;

  PaisRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<Map<String, dynamic>>> fetchAllPaises() async {
    try {
      final response = await dio.get(AppConfig.allCountriesUrl);
      if (response.statusCode == 200 && response.data is List) {
        // Aseguramos que la lista contiene Maps
        return List<Map<String, dynamic>>.from(
          (response.data as List).whereType<Map<String, dynamic>>(),
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Invalid response format or status code: ${response.statusCode}',
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException {
      // Re-throw para que el repositorio lo maneje o lo pase
      rethrow;
    } catch (e) {
      // Para errores inesperados
      throw Exception('Failed to fetch all countries: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchPaisesByName(String name) async {
    if (name.trim().isEmpty) {
      return fetchAllPaises(); // Si la búsqueda está vacía, devuelve todos
    }
    try {
      final response = await dio.get(AppConfig.searchCountriesByNameUrl(name));
      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(
          (response.data as List).whereType<Map<String, dynamic>>(),
        );
      } else if (response.statusCode == 404) {
        return []; // País no encontrado, devuelve lista vacía
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Invalid response format or status code: ${response.statusCode}',
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return []; // País no encontrado
      }
      rethrow;
    } catch (e) {
      throw Exception('Failed to search countries by name: $e');
    }
  }
}
