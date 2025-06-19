// lib/presentation/views/pais_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pais_entity.dart';
import '../providers/pais_providers.dart';
import '../widgets/loading_indicator_widget.dart';
import '../widgets/error_display_widget.dart';
import 'pais_detail_page.dart'; // Crearemos esta pantalla después

class PaisListPage extends ConsumerWidget {
  const PaisListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paisesAsyncValue = ref.watch(paisesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Países del Mundo'),
        actions: [
          IconButton(
            icon: Icon(ref.watch(themeNotifierProvider).value == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              ref.read(themeNotifierProvider.notifier).toggleTheme();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar país por nombre...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: (value) {
                // Actualiza el query, el paisesProvider se reconstruirá
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: paisesAsyncValue.when(
              data: (paises) {
                if (paises.isEmpty) {
                  return Center(
                    child: Text(
                      ref.watch(searchQueryProvider).isEmpty
                          ? 'No se encontraron países.'
                          : 'No hay resultados para "${ref.watch(searchQueryProvider)}"',
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: paises.length,
                  itemBuilder: (context, index) {
                    final pais = paises[index];
                    return PaisListItemWidget(pais: pais);
                  },
                );
              },
              loading: () => const LoadingIndicatorWidget(),
              error: (error, stackTrace) {
                // Evitar mostrar error de "Search query changed" al usuario
                if (error.toString().contains("Search query changed")) {
                   return const LoadingIndicatorWidget(); // Muestra cargando mientras se actualiza
                }
                return ErrorDisplayWidget(
                  message: error.toString(),
                  onRetry: () => ref.refresh(paisesProvider),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PaisListItemWidget extends StatelessWidget {
  final Pais pais;
  const PaisListItemWidget({super.key, required this.pais});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 40,
          child: pais.flagUrlPng.isNotEmpty
              ? Image.network(
                  pais.flagUrlPng,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.flag_circle_outlined, size: 30),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2,)));
                  },
                )
              : const Icon(Icons.flag_circle_outlined, size: 30),
        ),
        title: Text(pais.commonName, style: theme.textTheme.titleMedium),
        subtitle: Text(pais.capitalDisplay, style: theme.textTheme.bodySmall),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaisDetailPage(pais: pais),
            ),
          );
        },
      ),
    );
  }
}