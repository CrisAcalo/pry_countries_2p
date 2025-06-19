// lib/application/usecases/get_all_paises_usecase.dart
import '../../domain/entities/pais_entity.dart';
import '../../domain/repositories/pais_repository.dart';

class GetAllPaisesUsecase {
  final PaisRepository repository;

  GetAllPaisesUsecase(this.repository);

  Future<List<Pais>> call() async {
    return await repository.getAllPaises();
  }
}