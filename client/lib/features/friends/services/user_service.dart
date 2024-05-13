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
        final List<dynamic> usersJson = json.decode(response.body);
        log(usersJson.toString());
        List<OtherUser> users =
            usersJson.map((user) => OtherUser.fromMap(user)).toList();

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

  static Future<String> sendFriendRequest(int senderId, int receiverId) async {
    try {
      log('Sending friend request from $senderId to $receiverId');
      http.Response response = await http.post(
        Uri.parse(
            '${EnvVariables.uri}/users/friend_request?sender_id=${Uri.encodeComponent(senderId.toString())}&receiver_id=${Uri.encodeComponent(receiverId.toString())}'),
        headers: {'Content-Type': 'application/json'},
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

  static Future<bool> rejectFriendRequest(int requestId) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
            '${EnvVariables.uri}/users/friend_requests/$requestId/reject'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        log('Friend request rejected: ${response.body}');
        return true;
      } else {
        log('Failed to reject friend request with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to reject friend request: $e');
    }
  }

  static Future<List<OtherUser>> searchUsers(String query) async {
    try {
      http.Response response = await http.get(
        Uri.parse(
            '${EnvVariables.uri}/users/search?query=${Uri.encodeComponent(query)}'),
      );
      List<OtherUser> users = [];
      log('Searching users: ${response.body}');
      for (var user in json.decode(response.body)) {
        users.add(OtherUser.fromMap(user));
      }
      return users;
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to search users: $e');
    }
  }
}
