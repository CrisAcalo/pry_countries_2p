class Pais {
  final String nameOficial;
  final String nameCommon;
  final String flags;
  final String capital;
  final String languages;
  final double area;
  final double population;
  final List<String> borders;

  Pais({
    required this.nameOficial,
    required this.nameCommon,
    required this.flags,
    required this.capital,
    required this.languages,
    required this.area,
    required this.population,
    required this.borders,
  });
  factory Pais.fromJson(Map<String, dynamic> json) {
    return Pais(
      nameOficial: json['name']['official'] ?? '',
      nameCommon: json['name']['common'] ?? '',
      flags: json['flags']['png'] ?? '',
      capital: (json['capital'] as List).isNotEmpty ? json['capital'][0] : '',
      languages: (json['languages'] as Map<String, dynamic>).values.join(', '),
      area: json['area']?.toDouble() ?? 0.0,
      population: json['population']?.toDouble() ?? 0.0,
      borders: (json['borders'] as List<dynamic>?)
              ?.map((border) => border.toString())
              .toList() ??
          [],
    );
  }


}
