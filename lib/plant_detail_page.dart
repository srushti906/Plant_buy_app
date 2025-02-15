import 'package:flutter/material.dart';
import 'plant_class_file.dart'; // Adjust this path as needed
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


class PlantDetailPage extends StatelessWidget {
  final Plant plant;
  final void Function(int) onAddToCart; // Callback for adding to cart

  PlantDetailPage({
    required this.plant,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], // Light green background color
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD7F1DE), // Light green
                Color(0xFF9FEFA2), // Medium green
                Color(0xFF62E867), // Bright green
                Color(0xFF07EF9E), // Turquoise green
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          plant.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 4, // Slight shadow for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Subtle shadow
                        blurRadius: 10.0,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      plant.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Subtle shadow
                      blurRadius: 10.0,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800], // Dark green for contrast
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      plant.scientificName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[600], // Medium green
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '\$${plant.price.toStringAsFixed(2)}', // Price
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700], // Slightly darker green for price
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          plant.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Show dialog to enter quantity
                        final quantity = await _showQuantityDialog(context);
                        if (quantity != null && quantity > 0) {
                          onAddToCart(quantity); // Use the callback
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${plant.name} added to cart!'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700], // Green background for the button
                        foregroundColor: Colors.white, // White text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        elevation: 5,
                      ),
                      icon: Icon(Icons.add_shopping_cart, size: 20),
                      label: Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<int?> _showQuantityDialog(BuildContext context) {
    int quantity = 1;
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Quantity'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Quantity'),
            onChanged: (value) {
              quantity = int.tryParse(value) ?? 1;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: Text('Add to Cart'),
              onPressed: () {
                Navigator.of(context).pop(quantity);
              },
            ),
          ],
        );
      },
    );
  }
}
