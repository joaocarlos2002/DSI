import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://localhost:6969/api";

  Future<http.Response> authenticatedGet(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> authenticatedPost(String endpoint, dynamic body) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }
}
