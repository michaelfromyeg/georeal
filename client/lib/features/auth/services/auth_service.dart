import 'dart:convert';

import 'package:georeal/constants/env_variables.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<dynamic> login(String email, String password) async {
    try {
      var uri = Uri.parse('${EnvVariables.uri}/login');
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Return the user object (or token
      } else {
        throw Exception(
            'Failed to login. Please check your credentials and try again.');
      }
    } catch (e) {
      throw Exception('Error occurred during login: $e');
    }
  }

  static Future<void> register(
      String name, String email, String password) async {
    try {
      var uri = Uri.parse('${EnvVariables.uri}/register');
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Return the user object (or token
      } else {
        throw Exception('Failed to register. Please try again');
      }
    } catch (e) {
      throw Exception('Error occurred during registration: $e');
    }
  }
}
