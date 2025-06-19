// lib/presentation/providers/pais_providers.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/usecases/get_all_paises_usecase.dart';
import '../../application/usecases/search_paises_by_name_usecase.dart';
import '../../core/config/app_config.dart';
import '../../data/datasources/pais_remote_data_source.dart';
import '../../data/repositories/pais_repository_impl.dart';
import '../../domain/entities/pais_entity.dart';
import '../../domain/repositories/pais_repository.dart';
import '../../theme/app_themes.dart';

// 1. Provider para Dio
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl, // Ya está en AppConfig
      connectTimeout: AppConfig.connectionTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
    ),
  );
  // Aquí podrías añadir interceptores si los necesitas (logging, auth, etc.)
  if (AppConfig.enableHttpLogging) {
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }
  return dio;
});

// 2. Provider para PaisRemoteDataSource
final paisRemoteDataSourceProvider = Provider<PaisRemoteDataSource>((ref) {
  return PaisRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

// 3. Provider para PaisRepository
final paisRepositoryProvider = Provider<PaisRepository>((ref) {
  return PaisRepositoryImpl(
    remoteDataSource: ref.watch(paisRemoteDataSourceProvider),
  );
});

// 4. Provider para GetAllPaisesUsecase
final getAllPaisesUsecaseProvider = Provider<GetAllPaisesUsecase>((ref) {
  return GetAllPaisesUsecase(ref.watch(paisRepositoryProvider));
});

// 5. Provider para SearchPaisesByNameUsecase
final searchPaisesByNameUsecaseProvider = Provider<SearchPaisesByNameUsecase>((
  ref,
) {
  return SearchPaisesByNameUsecase(ref.watch(paisRepositoryProvider));
});

// 6. StateProvider para el query de búsqueda
final searchQueryProvider = StateProvider<String>((ref) => '');

// 7. FutureProvider para obtener los países (se re-ejecuta si searchQueryProvider cambia)
// Este provider manejará la lógica de si buscar o traer todos.
final paisesProvider = FutureProvider<List<Pais>>((ref) async {
  final searchQuery = ref.watch(searchQueryProvider);
  final getAllUsecase = ref.watch(getAllPaisesUsecaseProvider);
  final searchUsecase = ref.watch(searchPaisesByNameUsecaseProvider);

  if (searchQuery.isEmpty) {
    return getAllUsecase.call();
  } else {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simula un debounce simple
    if (ref.read(searchQueryProvider) != searchQuery) {
      throw Exception("Search query changed");
    }
    return searchUsecase.call(searchQuery);
  }
});

final themeNotifierProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
  return ThemeNotifier(ThemeMode.system); // O el modo inicial que prefieras
});
