class OtherUser {
  final int id;
  final String username;
  final int numPlaces;
  final int numPosts;
  final int numFriends;
  final bool isFriend;
  final String? friendRequestStatus;

  OtherUser({
    required this.id,
    required this.username,
    required this.numPlaces,
    required this.numPosts,
    required this.numFriends,
    required this.isFriend,
    this.friendRequestStatus,
  });

  factory OtherUser.fromMap(Map<String, dynamic> json) {
    return OtherUser(
      id: json['user_id'] as int,
      username: json['username'] as String,
      numPlaces: json['num_places'] as int,
      numPosts: json['num_posts'] as int,
      numFriends: json['num_friends'] as int,
      isFriend: json['is_friend'] as bool,
      friendRequestStatus: json['friend_request_status'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': id,
      'username': username,
      'num_places': numPlaces,
      'numPosts': numPosts,
      'num_friends': numFriends,
      'is_friend': isFriend,
      'friend_request_status': friendRequestStatus,
    };
  }
}
