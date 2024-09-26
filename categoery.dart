import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled37/electronic.dart';
import 'package:untitled37/jewelery.dart';
import 'package:untitled37/men_clothing.dart';
import 'package:untitled37/women_clothing.dart';
import 'model.dart';
import 'end_point.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  Future<List<Category>> fetchCategory() async {
    final response = await http.get(Uri.parse(EndPoints.beseurl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  IconData getIconForCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'electronics':
        return Icons.electrical_services;
      case 'jewelery':
        return Icons.diamond;
      case "men's clothing":
        return Icons.male;
      case "women's clothing":
        return Icons.female;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: fetchCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal, // Set the scroll direction to horizontal
            padding: const EdgeInsets.all(10),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Widget targetScreen;
                    switch (category.name.toLowerCase()) {
                      case 'electronics':
                        targetScreen = ElectronicsScreen(electronic: category.name);
                        break;
                      case 'jewelery':
                        targetScreen = const JeweleryScreen(jewelery: '',); // No need to pass category.name if it's not needed
                        break;
                      case "men's clothing":
                        targetScreen = const MenScreen(men: '',); // No need to pass category.name if it's not needed
                        break;
                      case "women's clothing":
                        targetScreen = const WomenScreen(women: '',); // No need to pass category.name if it's not needed
                        break;
                      default:
                        targetScreen = ElectronicsScreen(electronic: category.name); // Default behavior
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => targetScreen),
                    );
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          getIconForCategory(category.name), // Icon for category
                          size: 40,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          category.name, // Display the category name
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
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
