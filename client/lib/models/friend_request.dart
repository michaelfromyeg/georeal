class FriendRequest {
  final int id;
  final int senderId;
  final String senderUsername;
  final int receiverId;

  FriendRequest({
    required this.id,
    required this.senderId,
    required this.senderUsername,
    required this.receiverId,
  });

  factory FriendRequest.fromMap(Map<String, dynamic> json) => FriendRequest(
        id: json['request_id'],
        senderId: json['sender_id'],
        senderUsername: json['sender_username'],
        receiverId: json['receiver_id'],
      );

  Map<String, dynamic> toMap() => {
        'request_id': id,
        'sender_id': senderId,
        'sender_username': senderUsername,
        'receiver_id': receiverId,
      };
}
