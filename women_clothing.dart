import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WomenScreen extends StatelessWidget {
  final String women;

  const WomenScreen({super.key, required this.women});

  Future<List<Product>> fetchWomenProducts() async {
    final response = await http.get(Uri.parse("https://fakestoreapi.com/products/category/women's%20clothing"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load women products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Women's Clothing "),
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchWomenProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 2,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          product.image,
                          height: 100, // Adjust height for better UI
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 2, // Limit text to two lines
                                overflow: TextOverflow.ellipsis, // Handle overflow
                              ),
                              Text('\$${product.price.toStringAsFixed(2)}'), // Format price to 2 decimal places
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 8, // Position button at the bottom
                          left: 8,
                          right: 8,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            onPressed: () {
                              // Handle add to cart action
                            },
                            child: const Text('Add to Cart'),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.red),
                        onPressed: () {
                          // Handle favorite action
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Model class for Product
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      image: json['image'],
      category: json['category'],
    );
  }
}
