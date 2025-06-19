// lib/application/usecases/search_paises_by_name_usecase.dart
import '../../domain/entities/pais_entity.dart';
import '../../domain/repositories/pais_repository.dart';

class SearchPaisesByNameUsecase {
  final PaisRepository repository;

  SearchPaisesByNameUsecase(this.repository);

  Future<List<Pais>> call(String name) async {
    return await repository.searchPaisesByName(name);
  }
}