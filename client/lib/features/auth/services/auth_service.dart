import 'dart:convert';
import 'dart:developer';

import 'package:georeal/constants/env_variables.dart';
import 'package:georeal/models/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<User?> login(String email, String password) async {
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
        final userJson = json.decode(response.body);
        log('User fetched: $userJson');
        return User.fromMap(userJson); // Return the user object (or token
      } else {
        throw Exception(
            'Failed to login. Please check your credentials and try again.');
      }
    } catch (e) {
      throw Exception('Error occurred during login: $e');
    }
  }

  static Future<User?> register(
      String name, String username, String email, String password) async {
    try {
      log('Registering user...', name: 'AuthService');
      var uri = Uri.parse('${EnvVariables.uri}/register');
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final userJson = json.decode(response.body);
        log('User fetched: $userJson');
        return User.fromMap(userJson);
      } else {
        throw Exception('Failed to register. Please try again');
      }
    } catch (e) {
      throw Exception('Error occurred during registration: $e');
    }
  }
}
