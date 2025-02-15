import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeliveryInformationForm extends StatefulWidget {
  @override
  _DeliveryInformationFormState createState() => _DeliveryInformationFormState();
}

class _DeliveryInformationFormState extends State<DeliveryInformationForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _midNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  String? selectedDetailId;

  String _generateDetailsId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> _submitDeliveryInfo() async {
    if (_formKey.currentState!.validate()) {
      try {
        String userId = user!.uid;
        String detailsId = _generateDetailsId();

        Map<String, dynamic> deliveryData = {
          'detailsId': detailsId,
          'userId': userId,
          'firstName': _firstNameController.text,
          'midName': _midNameController.text,
          'lastName': _lastNameController.text,
          'address': _addressController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'pincode': _pincodeController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneNumberController.text,
          'isSelected': false,
        };

        await FirebaseFirestore.instance.collection('details').doc(detailsId).set(deliveryData);
        _showSuccessDialog();
        Navigator.pop(context);
      } catch (e) {
        _showErrorDialog(e.toString());
      }
    }
  }

  Future<void> _submitSelectedInfo() async {
    if (selectedDetailId != null) {
      await FirebaseFirestore.instance.collection('details').where('userId', isEqualTo: user?.uid).get().then((snapshot) {
        for (var doc in snapshot.docs) {
          if (doc['detailsId'] != selectedDetailId) {
            doc.reference.update({'isSelected': false});
          }
        }
      });

      await FirebaseFirestore.instance.collection('details').doc(selectedDetailId).update({'isSelected': true});

      DocumentSnapshot selectedDetailSnapshot = await FirebaseFirestore.instance.collection('details').doc(selectedDetailId).get();
      Map<String, dynamic> selectedDetail = selectedDetailSnapshot.data() as Map<String, dynamic>;

      Navigator.pop(context, selectedDetail);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Your delivery information has been saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeliveryForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add your delivery information'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField('First Name', _firstNameController, false),
                  _buildTextField('Mid Name', _midNameController, false),
                  _buildTextField('Last Name', _lastNameController, false),
                  _buildTextField('Address', _addressController, false),
                  _buildTextField('City', _cityController, false),
                  _buildTextField('State', _stateController, false),
                  _buildTextField('Pincode', _pincodeController, false),
                  _buildTextField('Email', _emailController, true),
                  _buildTextField('Phone Number', _phoneNumberController, false),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _submitDeliveryInfo,
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isEmail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  void _toggleSelection(String detailsId) {
    setState(() {
      selectedDetailId = selectedDetailId == detailsId ? null : detailsId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Information'),
        backgroundColor: Colors.teal[800],
        actions: [
          TextButton(
            onPressed: _submitSelectedInfo,
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: _showDeliveryForm,
            child: Text(
              'Add delivery information',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('details')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No delivery information found.'));
          }

          var details = snapshot.data!.docs;

          return ListView.builder(
            itemCount: details.length,
            itemBuilder: (context, index) {
              var detail = details[index].data() as Map<String, dynamic>;
              var detailId = detail['detailsId'];

              return GestureDetector(
                onTap: () => _toggleSelection(detailId),
                child: Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  color: selectedDetailId == detailId ? Colors.teal[100] : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${detail['firstName']} ${detail['midName']} ${detail['lastName']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Address: ${detail['address']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'City: ${detail['city']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'State: ${detail['state']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Pincode: ${detail['pincode']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Phone: ${detail['phoneNumber']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
