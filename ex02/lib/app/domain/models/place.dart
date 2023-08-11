class Place {
  final String name;
  final String? region;
  final String? country;
  final Map<String, String> coordinates;

  Place({
    required this.name,
    required this.region,
    required this.country,
    required this.coordinates,
  });
}
