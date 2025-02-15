class Plant {
  final String name;
  final String scientificName;
  final String category;
  final String description;
  final String imageUrl;
  final double price;

  Plant({
    required this.name,
    required this.scientificName,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  // Convert a Plant instance to a Map for storage or serialization
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'scientificName': scientificName,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  // Create a Plant instance from a Map
  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      name: map['name'],
      scientificName: map['scientificName'],
      category: map['category'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      price: map['price'],
    );
  }
}
