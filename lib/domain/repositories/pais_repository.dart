// lib/domain/repositories/pais_repository.dart
import '../entities/pais_entity.dart';

abstract class PaisRepository {
  Future<List<Pais>> getAllPaises();
  Future<List<Pais>> searchPaisesByName(String name);
  // Podrías añadir más métodos como getPaisByCode(String code) si lo necesitas
}