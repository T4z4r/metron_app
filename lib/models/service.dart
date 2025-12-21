class Service {
  final int id;
  final String name;
  final String description;
  final double price;
  final String status;
  final List<String> images;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.status,
    required this.images,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      status: json['status'] ?? 'inactive',
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'status': status,
      'images': images,
    };
  }
}
