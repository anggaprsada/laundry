import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerService {
  static const String baseUrl = 'http://localhost:3000/customers';

  static Future<List<dynamic>?> getAllCustomers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          return jsonResponse['data'];
        } else {
          print('Error: response status not success or data null');
          return null;
        }
      } else {
        print('Failed to load customers. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception while fetching customers: $e');
      return null;
    }
  }

  static Future<List<dynamic>?> getCustomers() => getAllCustomers();
  
  // Tambah customer
  static Future<Map<String, dynamic>?> addCustomer(String name, String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'phone': phone}),
      );

      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 201 && jsonResponse['status'] == 'success') {
        return jsonResponse['data']; // biasanya berisi id customer baru
      } else {
        print('Failed to add customer: ${jsonResponse['message']}');
        return null;
      }
    } catch (e) {
      print('Exception while adding customer: $e');
      return null;
    }
  }
  static Future<bool> updateCustomer(int id, String name, String phone) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'phone': phone}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Exception while updating customer: $e');
      return false;
    }
  }

  static Future<bool> deleteCustomer(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Exception while deleting customer: $e');
      return false;
    }
  }
}
