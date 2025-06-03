import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:3000/users';

  static final storage = FlutterSecureStorage();

  // LOGIN
  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'pass': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody['status'] == 'OK!') {
          String token = responseBody['message'];
          String userId = responseBody['idUser'].toString();

          await storage.write(key: 'access_token', value: token);
          await storage.write(key: 'user_id', value: userId);

          return {
            'status': 'OK!',
            'token': token,
            'userId': userId,
          };
        } else {
          // Response error dengan tipe error
          return {
            'status': 'error',
            'errorType': responseBody['errorType'] ?? 'unknown',
            'message': responseBody['message'] ?? 'Login gagal',
          };
        }
      } else {
        return {
          'status': 'error',
          'errorType': 'server_error',
          'message': 'Server error ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'errorType': 'exception',
        'message': e.toString(),
      };
    }
  }

  // REGISTER
  static Future<bool> register(String name, String email, String pass) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'pass': pass,
      }),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }

  // GET USER dengan token
  static Future<Map<String, dynamic>?> getUser(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('getUser status: ${response.statusCode}');
    print('getUser body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // Pastikan responsenya sesuai struktur {status: 'success', data: user}
      if (json['status'] == 'success' && json['data'] != null) {
        return json['data'];
      } else {
        print('getUser error: status not success or data null');
        return null;
      }
    } else {
      print("Get user error: ${response.body}");
      return null;
    }
  }

  // DELETE
  static Future<bool> deleteUser(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }

  // EDIT
  static Future<bool> updateUser(
      String id, String name, String email, String pass, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'pass': pass,
      }),
    );

    print('updateUser status: ${response.statusCode}');
    print('updateUser body: ${response.body}');

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      return res['status'] == 'success';
    }

    return false;
  }
}
