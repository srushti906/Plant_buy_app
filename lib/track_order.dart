import 'package:flutter/material.dart';
import 'cart_class.dart'; // Ensure this import is correct for your Cart class
import 'plant_class_file.dart'; // Ensure this import is correct for your Plant class
import 'homepage.dart'; // Ensure this import is correct for your HomePage class

class TrackOrderPage extends StatelessWidget {
  final String cartId;
  final String paymentId;
  final Map<String, dynamic> deliveryInfo;
  final double totalPrice;
  final List<Cart> cartItems; // Using Cart class for items
  final String paymentMethod;
  final String? upiId;

  const TrackOrderPage({
    Key? key,
    required this.cartId,
    required this.paymentId,
    required this.deliveryInfo,
    required this.totalPrice,
    required this.cartItems,
    required this.paymentMethod,
    this.upiId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Your Order'),
        backgroundColor: Colors.teal[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Cart ID: $cartId'),
            Text('Payment ID: $paymentId'),
            Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
            Text('Payment Method: $paymentMethod'),
            if (paymentMethod == 'UPI Transaction' && upiId != null)
              Text('UPI ID: $upiId'),
            SizedBox(height: 20),
            Text(
              'Delivery Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Name: ${deliveryInfo['firstName'] ?? 'N/A'} ${deliveryInfo['midName'] ?? ''} ${deliveryInfo['lastName'] ?? ''}'),
            Text('Address: ${deliveryInfo['address'] ?? 'N/A'}, ${deliveryInfo['city'] ?? 'N/A'}, ${deliveryInfo['state'] ?? 'N/A'}, ${deliveryInfo['pincode'] ?? 'N/A'}'),
            Text('Phone: ${deliveryInfo['phoneNumber'] ?? 'N/A'}'),
            Text('Email: ${deliveryInfo['email'] ?? 'N/A'}'),
            Text('User ID: ${deliveryInfo['userId'] ?? 'N/A'}'),
            Text('Details ID: ${deliveryInfo['detailsId'] ?? 'N/A'}'),
            Text('Is Selected: ${deliveryInfo['isSelected'] ?? false ? 'Yes' : 'No'}'),
            SizedBox(height: 20),
            Text(
              'Items Ordered:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  final plantItem = cartItem.plant; // Assuming Cart class has a reference to Plant

                  return Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          plantItem.imageUrl, // Accessing Plant's image URL
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(plantItem.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text(plantItem.description, style: TextStyle(fontSize: 12)),
                              SizedBox(height: 4),
                              Text('Quantity: ${cartItem.quantity}', style: TextStyle(fontSize: 12)), // Displaying quantity here
                              SizedBox(height: 4),
                              Text('Price: \$${plantItem.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the home page, removing TrackOrderPage from the stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Ensure HomePage is accessible
                      (route) => false, // This clears all previous routes
                );
              },
              child: Text('Back to Home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
