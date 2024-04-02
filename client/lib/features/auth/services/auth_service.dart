import 'dart:convert';

import 'package:georeal/constants/env_variables.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<void> login(String email, String password) async {
    var uri = Uri.parse('${EnvVariables.uri}/login');
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json', // Specify content type as JSON
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // TODO: Handle successful login
    } else {
      // TODO: Handle unsuccessful login
    }
  }

  static Future<void> register(
      String name, String email, String password) async {
    var uri = Uri.parse('${EnvVariables.uri}/register');
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json', // Specify content type as JSON
      },
      body: json.encode({
        'username':
            name, // Make sure to use 'username' as the key if that's what your Flask route expects
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // TODO: Handle successful registration
    } else {
      // TODO: Handle unsuccessful registration
    }
  }
}
