import 'plant_class_file.dart'; // Import the Plant class
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class Cart {
  final String id;
  final Plant plant;
  int quantity;

  Cart({
    required this.id,
    required this.plant,
    required this.quantity,
  });

  // Convert Cart item to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plant': plant.toMap(),
      'quantity': quantity,
    };
  }

  // Create Cart object from Map (Firestore document or other sources)
  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'] ?? '', // Provide a default empty string if id is null
      plant: Plant.fromMap(map['plant'] ?? {}), // Initialize with an empty Plant if missing
      quantity: map['quantity'] ?? 1, // Default quantity if missing
    );
  }

  // Create Cart object from Firestore document snapshot
  factory Cart.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Safely handle null data
    if (data == null) {
      throw Exception('Document data is null');
    }
    return Cart(
      id: doc.id, // Use the document ID from Firestore
      plant: Plant.fromMap(data['plant'] ?? {}), // Initialize with an empty Plant if missing
      quantity: data['quantity'] ?? 1, // Default quantity if missing
    );
  }
}
