// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/providers/pais_providers.dart'; // Para el theme provider
import 'presentation/views/pais_list_page.dart';
import 'theme/app_themes.dart'; // Importa tus temas

void main() {
  // Opcional: puedes configurar aquí cosas globales antes de runApp
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // Para que los providers de Riverpod estén disponibles globalmente
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el provider del tema
    final themeMode = ref.watch(themeNotifierProvider).value;

    return MaterialApp(
      title: 'REST Countries App',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode, // Usa el themeMode del provider
      theme: AppThemes.lightTheme, // Tu tema claro
      darkTheme: AppThemes.darkTheme, // Tu tema oscuro
      home: const PaisListPage(), // Tu pantalla inicial
    );
  }
}