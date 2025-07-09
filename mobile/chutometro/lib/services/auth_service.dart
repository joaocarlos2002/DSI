import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/response_dto.dart';
import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {

  Future<void> updateProfileName(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');
    if (token == null || userId == null) throw Exception('Usuário não autenticado');
    final response = await http.put(
      Uri.parse('$baseUrl/user/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"name": newName}),
    );
    if (response.statusCode == 200) {
      await prefs.setString('name', newName);
      notifyListeners();
    } else {
      throw Exception('Erro ao atualizar nome');
    }
  }

  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');
    if (token == null || userId == null) throw Exception('Usuário não autenticado');
    final response = await http.delete(
      Uri.parse('$baseUrl/user/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      await logout();
    } else {
      throw Exception('Erro ao excluir conta');
    }
  }
  static const String baseUrl = "http://localhost:6969/api";

  Future<ResponseDTO> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonResp = jsonDecode(response.body);
      final data = ResponseDTO.fromJson(jsonResp);
      await _saveUserData(data);
      return data;
    } else {
      throw Exception(
        response.statusCode == 400
            ? 'Usuário não encontrado ou senha incorreta'
            : 'Erro no login',
      );
    }
  }

  Future<ResponseDTO> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = ResponseDTO.fromJson(jsonDecode(response.body));
      await _saveUserData(data);
      return data;
    } else {
      throw Exception(
        response.statusCode == 400
            ? 'Email já está em uso'
            : 'Erro no registro',
      );
    }
  }

  Future<void> _saveUserData(ResponseDTO data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', data.token);
    await prefs.setString('name', data.name);
    await prefs.setString('userId', data.id);
  }

  Future<Map<String, String>> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final name = prefs.getString('name');
    final userId = prefs.getString('userId');

    if (token != null && name != null && userId != null) {
      return {'name': name, 'token': token, 'userId': userId};
    } else if (token != null && name != null) {
      return {'name': name, 'token': token};
    }
    return {};
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('name');
  }
}
