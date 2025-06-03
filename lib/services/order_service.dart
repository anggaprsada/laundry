import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  static const String baseUrl = 'http://localhost:3000/orders';

  static Future<List<dynamic>?> getOrders() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }

  static Future<bool> addOrder(Map<String, dynamic> orderData) async {
    if (orderData.containsKey('productName')) {
      orderData['productName'] = _capitalize(orderData['productName']);
    }
    if (orderData.containsKey('status')) {
      orderData['status'] = _capitalize(orderData['status']);
    }

    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );

    print('Response code: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response.statusCode == 201;
  }

  static Future<bool> updateOrder(
      int id, Map<String, dynamic> orderData) async {
    if (orderData.containsKey('productName')) {
      orderData['productName'] = _capitalize(orderData['productName']);
    }
    if (orderData.containsKey('status')) {
      orderData['status'] = _capitalize(orderData['status']);
    }

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteOrder(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}
