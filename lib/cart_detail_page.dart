import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'payment_methods.dart'; // Ensure this is the correct path to the PaymentMethodsPage
import 'cart_class.dart'; // Ensure this is the correct path to the Cart class file

class CartDetailPage extends StatefulWidget {
  final List<Cart> cartItems;

  CartDetailPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartDetailPageState createState() => _CartDetailPageState();
}

class _CartDetailPageState extends State<CartDetailPage> {
  double totalPrice = 0.0;
  late String cartId;

  @override
  void initState() {
    super.initState();
    cartId = _generateCartId();
    _calculateTotalPrice();
  }

  // Generate a unique cart ID
  String _generateCartId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // Calculate the total price based on item price and quantity
  void _calculateTotalPrice() {
    totalPrice = widget.cartItems.fold(0, (sum, item) => sum + (item.plant.price * item.quantity));
    setState(() {});
  }

  // Remove an item from the cart
  void _removeItem(int index) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final cartItem = widget.cartItems[index];
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(cartItem.id) // Ensure `id` exists in your Cart class to reference the document
            .delete();
        setState(() {
          totalPrice -= cartItem.plant.price * cartItem.quantity;
          widget.cartItems.removeAt(index);
        });
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error removing item: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  // Edit the quantity of an item
  void _editQuantity(int index, int newQuantity) {
    if (newQuantity > 0) {
      setState(() {
        widget.cartItems[index].quantity = newQuantity;
        _calculateTotalPrice();
      });
    } else {
      _removeItem(index); // Automatically remove if quantity is 0 or less
    }
  }

  // Save cart details to Firestore
  Future<void> _saveCartDetailsToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final cartCollection = FirebaseFirestore.instance.collection('carts').doc(cartId);

      await cartCollection.set({
        'userId': user.uid,
        'totalPrice': totalPrice,
        'createdAt': FieldValue.serverTimestamp(),
        // Save items as an array
        'items': widget.cartItems.map((item) {
          return {
            'plantName': item.plant.name,
            'plantScientificName': item.plant.scientificName,
            'plantCategory': item.plant.category,
            'plantDescription': item.plant.description,
            'plantImageUrl': item.plant.imageUrl,
            'price': item.plant.price,
            'quantity': item.quantity,
          };
        }).toList(),
      });
    }
  }

  // Proceed to the payment methods page
  void _proceedToPayment() async {
    await _saveCartDetailsToFirestore();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodsPage(
          totalPrice: totalPrice,
          cartId: cartId,
        ),
      ),
    );
  }

  // Show a dialog to edit the quantity of an item
  void _showEditQuantityDialog(int index) {
    int currentQuantity = widget.cartItems[index].quantity;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Quantity'),
          content: TextFormField(
            initialValue: currentQuantity.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              try {
                currentQuantity = int.parse(value);
              } catch (e) {
                // Handle invalid input
              }
            },
            decoration: InputDecoration(labelText: 'Quantity'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (currentQuantity > 0) {
                  _editQuantity(index, currentQuantity);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Quantity must be greater than zero.'),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: Text('Update'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[800],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Details'),
        backgroundColor: Colors.teal[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.yellow[100]!, Colors.green[300]!, Colors.teal[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget.cartItems.isEmpty
              ? Center(child: Text('Your cart is empty!'))
              : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = widget.cartItems[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Image.network(cartItem.plant.imageUrl, width: 50, height: 50),
                        title: Text(cartItem.plant.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Scientific Name: ${cartItem.plant.scientificName}'),
                            Text('Category: ${cartItem.plant.category}'),
                            Text('Description: ${cartItem.plant.description}'),
                            Text('Price: \$${cartItem.plant.price.toStringAsFixed(2)} | Quantity: ${cartItem.quantity}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _showEditQuantityDialog(index),
                              color: Colors.blue,
                            ),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _removeItem(index),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Text(
                'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _proceedToPayment,
                child: Text('Proceed to Payment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
