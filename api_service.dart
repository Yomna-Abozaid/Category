import 'dart:convert';
import 'package:http/http.dart' as http;
import 'end_point.dart'; // Adjust import based on your project structure
import 'model.dart'; // Adjust import based on your project structure

class ApiService {
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(EndPoints.beseurl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
