import 'package:georeal/constants/env_variables.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String name;
  final int numPlaces;
  final int numPosts;
  final int numFriends;
  String?
      profilePhotoUrl; // Assuming profile photo is managed separately or not directly included in this model
  // Assuming lastLocation, places, posts, and friends are managed separately or not directly included in this model

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.profilePhotoUrl,
    this.numPlaces = 0,
    this.numPosts = 0,
    this.numFriends = 0,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    String? profilePhotoPath = data['profile_photo'];
    String? fullProfilePhotoUrl = profilePhotoPath != null
        ? '${EnvVariables.uri}$profilePhotoPath'
        : null;
    return User(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      name: data['name'],
      numPlaces: data['num_places'] ?? 0,
      numPosts: data['num_posts'] ?? 0,
      numFriends: data['num_friends'] ?? 0,
      profilePhotoUrl: fullProfilePhotoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'num_places': numPlaces,
      'num_posts': numPosts,
      'num_friends': numFriends,
      'profile_photo': profilePhotoUrl,
    };
  }
}
