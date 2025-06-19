// lib/presentation/views/pais_detail_page.dart
import 'package:flutter/material.dart';
import '../../domain/entities/pais_entity.dart';
import 'package:intl/intl.dart'; // Para formatear números

class PaisDetailPage extends StatelessWidget {
  final Pais pais;

  const PaisDetailPage({super.key, required this.pais});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat.decimalPattern('es_ES'); // o el locale que prefieras

    return Scaffold(
      appBar: AppBar(
        title: Text(pais.commonName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: pais.flagUrlPng.isNotEmpty
                  ? Image.network(
                      pais.flagUrlPng,
                      height: 150,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(height:150, child: Center(child: CircularProgressIndicator()));
                      },
                    )
                  : const Icon(Icons.flag_circle_outlined, size: 100),
            ),
            if (pais.flagAltText != null && pais.flagAltText!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  pais.flagAltText!,
                  style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 24),
            _buildDetailRow(context, 'Nombre Oficial:', pais.officialName),
            _buildDetailRow(context, 'Capital:', pais.capitalDisplay),
            _buildDetailRow(context, 'Idiomas:', pais.languagesDisplay),
            _buildDetailRow(context, 'Región:', pais.region),
            _buildDetailRow(context, 'Subregión:', pais.subregion),
            _buildDetailRow(context, 'Población:', numberFormat.format(pais.population)),
            _buildDetailRow(context, 'Área:', '${numberFormat.format(pais.area)} km²'),
            _buildDetailRow(context, 'Código (CCA3):', pais.cca3),
            if (pais.nameNative != null && pais.nameNative!.isNotEmpty)
               _buildNativeNames(context, pais.nameNative!),
            if (pais.borders.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Países Fronterizos:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: pais.borders.map((cca3) => Chip(label: Text(cca3))).toList(),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildNativeNames(BuildContext context, Map<String, dynamic> nativeNames) {
    final theme = Theme.of(context);
    List<Widget> nameWidgets = [];

    nativeNames.forEach((langCode, nameData) {
      if (nameData is Map<String, dynamic>) {
        final official = nameData['official'] as String?;
        final common = nameData['common'] as String?;
        if (official != null || common != null) {
          nameWidgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                "$langCode: ${official ?? common} (Oficial) / ${common ?? official} (Común)",
                style: theme.textTheme.bodySmall,
              ),
            )
          );
        }
      }
    });

    if (nameWidgets.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nombres Nativos:", style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          ...nameWidgets,
        ],
      ),
    );
  }
}