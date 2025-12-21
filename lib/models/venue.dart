class Venue {
  final int id;
  final String name;
  final String location;
  final int capacity;
  final String status;
  final List<String> images;

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.status,
    required this.images,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      capacity: json['capacity'],
      status: json['status'] ?? 'pending',
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'capacity': capacity,
      'status': status,
      'images': images,
    };
  }
}
