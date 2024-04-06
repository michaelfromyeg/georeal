import 'dart:convert';
import 'dart:developer';

import 'package:georeal/constants/env_variables.dart';
import 'package:georeal/models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<List<User>> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse('${EnvVariables.uri}/users'));

      if (response.statusCode == 200) {
        log('Users fetched: ${response.body}');
        final List<dynamic> usersJson = json.decode(response.body);
        log('Users fetched2: $usersJson');
        for (var user in usersJson) {
          log('User: $user');
        }
        List<User> users = usersJson.map((user) => User.fromMap(user)).toList();
        log('Users fetched3: $users');
        return users;
      } else {
        throw Exception(
            'Failed to load users with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load users: $e');
    }
  }
}
