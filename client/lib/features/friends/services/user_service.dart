import 'dart:convert';
import 'dart:developer';

import 'package:georeal/constants/env_variables.dart';
import 'package:georeal/models/friend_request.dart';
import 'package:georeal/models/other_user.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<List<OtherUser>> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse('${EnvVariables.uri}/users'));

      if (response.statusCode == 200) {
        log('Users fetched: ${response.body}');
        final List<dynamic> usersJson = json.decode(response.body);
        log('Users fetched2: $usersJson');

        List<OtherUser> users =
            usersJson.map((user) => OtherUser.fromMap(user)).toList();

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

  static Future<OtherUser> getUserByUsername(
      String username, int userId) async {
    try {
      log('Fetching user with username: $username');
      final response = await http.get(
        Uri.parse(
            '${EnvVariables.uri}/user?username=${Uri.encodeComponent(username)}&user_id=${Uri.encodeComponent(userId.toString())}'),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final userJson = json.decode(response.body);
        return OtherUser.fromMap(userJson);
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

  static Future<List<FriendRequest>> getAllFriendRequests(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${EnvVariables.uri}/users/$userId/friend_requests'),
      );

      if (response.statusCode == 200) {
        List<dynamic> requestsJson = json.decode(response.body);
        return requestsJson.map((data) => FriendRequest.fromMap(data)).toList();
      } else {
        throw Exception(
            'Failed to load friend requests with status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load friend requests: $e');
    }
  }

  static Future<bool> acceptFriendRequest(int requestId) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
            '${EnvVariables.uri}/users/friend_requests/$requestId/accept'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        log('Friend request accepted: ${response.body}');
        return true;
      } else {
        log('Failed to accept friend request with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to accept friend request: $e');
    }
  }
}
