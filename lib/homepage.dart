import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'plant_class_file.dart';
import 'plant_detail_page.dart';
import 'cart_detail_page.dart';
import 'cart_class.dart';
import 'sign_up_page.dart';
import 'sign_in_page.dart';
import 'delivery_information_form.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Plant> plants = [
    Plant(
      name: 'Snake Plant',
      scientificName: 'Sansevieria trifasciata',
      category: 'Succulent',
      description: 'A hardy plant that is easy to care for.',
      imageUrl: 'assets/images/snakeplant.jfif',
      price: 25.00,
    ),
    Plant(
      name: 'Monstera',
      scientificName: 'Monstera deliciosa',
      category: 'Indoor',
      description: 'A popular plant with unique leaves.',
      imageUrl: 'assets/images/monstera.webp',
      price: 45.00,
    ),
  ];

  List<Plant> filteredPlants = [];
  List<Cart> cartItems = [];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    filteredPlants = plants;
  }

  void _filterPlants(String query) {
    setState(() {
      filteredPlants = plants.where((plant) {
        final lowerQuery = query.toLowerCase();
        return (plant.name.toLowerCase().contains(lowerQuery) ||
            plant.scientificName.toLowerCase().contains(lowerQuery) ||
            plant.description.toLowerCase().contains(lowerQuery) ||
            plant.price.toString().contains(lowerQuery)) &&
            (selectedCategory == 'All' || plant.category.toLowerCase() == selectedCategory.toLowerCase());
      }).toList();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredPlants = plants.where((plant) {
        return selectedCategory == 'All' || plant.category.toLowerCase() == selectedCategory.toLowerCase();
      }).toList();
      _filterPlants(''); // Reset search query
    });
  }

  void _navigateToPlantDetail(Plant plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantDetailPage(
          plant: plant,
          onAddToCart: (quantity) {
            if (quantity > 0) {
              setState(() {
                cartItems.add(Cart(id: UniqueKey().toString(), plant: plant, quantity: quantity));
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${plant.name} added to cart!'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _navigateToCartDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartDetailPage(cartItems: cartItems),
      ),
    );
  }

  void _navigateToInformationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryInformationForm(),
      ),
    );
  }

  Future<void> _logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');

    Navigator.pushReplacementNamed(context, '/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/icons/logo.png', // Path to your logo image
              height: 100, // Adjust the height as necessary
              width: 80,
            ),
            SizedBox(width: 8), // Space between logo and title
            Text(
              'Green Square',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD7F1DE), Color(0xFF9FEFA2), Color(0xFF62E867), Color(0xFF07EF9E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _navigateToCartDetail,
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _navigateToInformationPage,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 300,
              child: TextField(
                onChanged: _filterPlants,
                decoration: InputDecoration(
                  hintText: 'Search Plants...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Icon(Icons.search, color: Colors.green[400]),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          TextButton(
            onPressed: _logOut,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red[700],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            ).copyWith(
              overlayColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.red[800]!;
                } else if (states.contains(MaterialState.pressed)) {
                  return Colors.red[900]!;
                }
                return Colors.transparent;
              }),
            ),
            child: Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryButton('All'),
                  _buildCategoryButton('Indoor'),
                  _buildCategoryButton('Succulent'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: filteredPlants.length,
        itemBuilder: (context, index) {
          final plant = filteredPlants[index];
          return GestureDetector(
            onTap: () => _navigateToPlantDetail(plant),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
              elevation: 10.0,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white24.withOpacity(1), Colors.green.withOpacity(1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(0.0),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 10.0, offset: Offset(10, 5))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
                        child: Image.asset(plant.imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(plant.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(plant.scientificName, style: TextStyle(fontSize: 14, color: Colors.white70)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Text(
                        '${plant.description}\n\$${plant.price.toStringAsFixed(2)}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return TextButton(
      onPressed: () => _filterByCategory(category),
      style: TextButton.styleFrom(
        foregroundColor: selectedCategory == category ? Colors.white : Colors.green,
        backgroundColor: selectedCategory == category ? Colors.green : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      child: Text(
        category,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
