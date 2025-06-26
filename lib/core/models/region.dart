class Region {
  final String id;
  final String name;
  final String displayName;
  final int eventCount;
  final RegionCoordinates coordinates;
  final String description;

  const Region({
    required this.id,
    required this.name,
    required this.displayName,
    required this.eventCount,
    required this.coordinates,
    required this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Region && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class RegionCoordinates {
  final double latitude;
  final double longitude;
  final double radius;

  const RegionCoordinates({
    required this.latitude,
    required this.longitude,
    required this.radius,
  });
}
