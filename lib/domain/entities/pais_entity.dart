// lib/domain/entities/pais_entity.dart
class Pais {
  final String officialName;
  final String commonName;
  final String flagUrlPng;
  final String? flagAltText; // Added, as 'alt' field exists in API for flags
  final List<String> capital; // Capital can be a list or null
  final Map<String, String> languages; // Map of langCode: langName
  final double area;
  final int population; // Population is an integer
  final List<String> borders; // List of cca3 codes of bordering countries
  final String region;
  final String subregion;
  final String cca3; // Country Code Alpha 3, useful for borders
  final Map<String, dynamic>? nameNative; // For native names

  Pais({
    required this.officialName,
    required this.commonName,
    required this.flagUrlPng,
    this.flagAltText,
    required this.capital,
    required this.languages,
    required this.area,
    required this.population,
    required this.borders,
    required this.region,
    required this.subregion,
    required this.cca3,
    this.nameNative,
  });

  factory Pais.fromJson(Map<String, dynamic> json) {
    // Helper to safely extract list of strings
    List<String> _getListStrings(dynamic data) {
      if (data is List) {
        return data.map((item) => item.toString()).toList();
      }
      return [];
    }

    // Helper to safely extract map of strings
    Map<String, String> _getMapStrings(dynamic data) {
      if (data is Map) {
        return data.map((key, value) => MapEntry(key.toString(), value.toString()));
      }
      return {};
    }

    return Pais(
      officialName: json['name']?['official'] as String? ?? 'N/A',
      commonName: json['name']?['common'] as String? ?? 'N/A',
      flagUrlPng: json['flags']?['png'] as String? ?? '',
      flagAltText: json['flags']?['alt'] as String?,
      capital: _getListStrings(json['capital']),
      languages: _getMapStrings(json['languages']),
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
      population: (json['population'] as num?)?.toInt() ?? 0,
      borders: _getListStrings(json['borders']),
      region: json['region'] as String? ?? 'N/A',
      subregion: json['subregion'] as String? ?? 'N/A',
      cca3: json['cca3'] as String? ?? 'N/A',
      nameNative: json['name']?['nativeName'] as Map<String, dynamic>?,
    );
  }

  // Convenience getter for a display-friendly capital string
  String get capitalDisplay => capital.isNotEmpty ? capital.join(', ') : 'N/A';

  // Convenience getter for a display-friendly languages string
  String get languagesDisplay => languages.values.isNotEmpty ? languages.values.join(', ') : 'N/A';
}