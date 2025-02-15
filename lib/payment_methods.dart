import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'track_order.dart'; // Ensure this import is correct
import 'delivery_information_form.dart'; // Import the Delivery Information Form

class PaymentMethodsPage extends StatefulWidget {
  final double totalPrice;
  final String cartId;

  const PaymentMethodsPage({
    Key? key,
    required this.totalPrice,
    required this.cartId,
  }) : super(key: key);

  @override
  _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  String _selectedPaymentMethod = '';
  String? _upiId;
  Map<String, dynamic>? _deliveryInfo; // Store delivery info as a Map
  final TextEditingController _upiController = TextEditingController(); // Controller for UPI ID field
  final _formKey = GlobalKey<FormState>();

  void _submitPayment() {
    if (_deliveryInfo == null || _deliveryInfo!.isEmpty) {
      _showSnackBar('Please add your delivery information!');
      return;
    }

    if (_selectedPaymentMethod.isEmpty) {
      _showSnackBar('Please select a payment method!');
      return;
    }

    _storePaymentData();
  }

  void _storePaymentData() async {
    String paymentId = _generatePaymentId();

    Map<String, dynamic> paymentData = {
      'paymentId': paymentId,
      'cartId': widget.cartId,
      'paymentMethod': _selectedPaymentMethod,
      'deliveryInfo': _deliveryInfo,
      'totalPrice': widget.totalPrice,
      'upiId': _selectedPaymentMethod == 'UPI Transaction' ? _upiController.text : null,
    };

    // Store payment data in Firestore
    await FirebaseFirestore.instance.collection('payments').doc(paymentId).set(paymentData);

    // Navigate to TrackOrderPage and pass the required parameters
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrackOrderPage(
          cartId: widget.cartId,
          paymentId: paymentId,
          deliveryInfo: _deliveryInfo!, // Pass delivery info
          totalPrice: widget.totalPrice, // Pass total price
          cartItems: [], // Replace with your actual cart items list
          paymentMethod: _selectedPaymentMethod,
          upiId: _selectedPaymentMethod == 'UPI Transaction' ? _upiController.text : null, // Pass UPI ID if applicable
        ),
      ),
    );
  }

  String _generatePaymentId() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8); // Generate a unique payment ID
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showPaymentForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildPaymentFormDialog();
      },
    );
  }

  Dialog _buildPaymentFormDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow[100]!, Colors.green[300]!, Colors.teal[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12.0),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedPaymentMethod.isEmpty ? 'Payment Method' : _selectedPaymentMethod,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                  fontFamily: 'PlayfairDisplay',
                ),
              ),
              SizedBox(height: 20),
              _selectedPaymentMethod == 'Cash on Delivery' ? _buildCashOnDeliveryForm() : _buildUPITransactionForm(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPayment,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.yellow[100]!, Colors.green[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.green[700]!.withOpacity(0.3), blurRadius: 12.0),
        ],
      ),
      child: Column(
        children: [
          _buildPaymentOptionTile(
            icon: Icons.money_off,
            title: 'Cash on Delivery',
            method: 'Cash on Delivery',
          ),
          Divider(),
          _buildPaymentOptionTile(
            icon: Icons.payment,
            title: 'UPI Transaction',
            method: 'UPI Transaction',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionTile({
    required IconData icon,
    required String title,
    required String method,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.all(16),
      leading: Icon(
        icon,
        color: _selectedPaymentMethod == method ? Colors.teal[400] : Colors.green[400],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedPaymentMethod == method ? Colors.teal[400] : Colors.green[800],
        ),
      ),
      tileColor: _selectedPaymentMethod == method ? Colors.yellow[100] : Colors.white,
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
        _showPaymentForm();
      },
    );
  }

  Widget _buildCashOnDeliveryForm() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _redirectToDeliveryInformationForm,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text('Add your information'),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Payment Method: Cash on Delivery',
          style: TextStyle(color: Colors.teal[800], fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildUPITransactionForm() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _redirectToDeliveryInformationForm,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text('Add your information'),
            ],
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _upiController,
          decoration: InputDecoration(
            labelText: 'Enter UPI ID (Optional)',
            labelStyle: TextStyle(color: Colors.teal[800]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal),
            ),
          ),
          style: TextStyle(color: Colors.teal[800]),
        ),
        SizedBox(height: 20),
        Image.asset('assets/images/QR.jpeg', height: 150),
        Text('Scan the QR code to make a payment.', style: TextStyle(color: Colors.teal[800])),
      ],
    );
  }

  void _redirectToDeliveryInformationForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeliveryInformationForm()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _deliveryInfo = result; // Set the delivery info from the Delivery Information Form
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Methods'),
        backgroundColor: Colors.teal[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.yellow[100]!, Colors.green[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Select a Payment Method',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildPaymentOptions(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPayment,
              child: Text('Confirm Payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[300],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
