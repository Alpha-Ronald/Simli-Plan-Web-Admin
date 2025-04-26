class VenueModel {
  final String id;
  final String name;
  final String faculty;
  final int capacity;
  final String locationDescription;

  VenueModel({
    required this.id,
    required this.name,
    required this.faculty,
    required this.capacity,
    required this.locationDescription,
  });

  factory VenueModel.fromMap(Map<String, dynamic> map, String docId) {
    return VenueModel(
      id: docId,
      name: map['name'] ?? '',
      faculty: map['faculty'] ?? '',
      capacity: map['capacity'] ?? 0,
      locationDescription: map['location_description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'faculty': faculty,
      'capacity': capacity,
      'location_description': locationDescription,
    };
  }
}
