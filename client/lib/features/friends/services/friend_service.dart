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

  static Future<User> getUserByUsername(String username) async {
    try {
      final response = await http.get(
        Uri.parse('${EnvVariables.uri}/users/$username'),
      );

      if (response.statusCode == 200) {
        log('User fetched: ${response.body}');
        final userJson = json.decode(response.body);
        return User.fromMap(userJson);
      } else {
        throw Exception(
            'Failed to load user with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load user: $e');
    }
  }

  static Future<String> sendFriendRequest(
      String senderUsername, String receiverUsername) async {
    try {
      var body = json.encode(
          {'username': senderUsername, 'friend_username': receiverUsername});
      log('Sending friend request with body: $body');
      http.Response response = await http.post(
        Uri.parse('${EnvVariables.uri}/friend_request'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        log('Friend request sent: ${response.body}');
        return 'Friend request sent successfully';
      } else {
        log('Failed to send friend request with status code: ${response.statusCode}');
        return 'Failed to send friend request';
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to send friend request: $e');
    }
  }
}
