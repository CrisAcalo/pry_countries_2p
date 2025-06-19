// lib/data/repositories/pais_repository_impl.dart
import '../../domain/entities/pais_entity.dart';
import '../../domain/repositories/pais_repository.dart';
import '../datasources/pais_remote_data_source.dart';
import 'package:dio/dio.dart'; // Para DioException

class PaisRepositoryImpl implements PaisRepository {
  final PaisRemoteDataSource remoteDataSource;

  PaisRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Pais>> getAllPaises() async {
    try {
      final List<Map<String, dynamic>> paisesJson = await remoteDataSource.fetchAllPaises();
      return paisesJson.map((json) => Pais.fromJson(json)).toList();
    } on DioException catch (e) {
      // Aquí puedes mapear DioException a un error de dominio más específico si quieres
      // Por ahora, solo lo relanzamos como una excepción genérica de app.
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }

  @override
  Future<List<Pais>> searchPaisesByName(String name) async {
    try {
      final List<Map<String, dynamic>> paisesJson = await remoteDataSource.searchPaisesByName(name);
      return paisesJson.map((json) => Pais.fromJson(json)).toList();
    } on DioException catch (e) {
       if (e.response?.statusCode == 404) {
        return []; // Devuelve lista vacía si es un 404 (no encontrado)
      }
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to search countries: $e');
    }
  }
}