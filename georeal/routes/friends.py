from flask import Blueprint, jsonify, request

from georeal.models import FriendRequest, User, db

friends = Blueprint('friends', __name__)

@friends.route('/friend_request', methods=['POST'])
def send_friend_request():
    data = request.get_json()
    username = data.get('username')
    friend_username = data.get('friend_username')
    
    if not username or not friend_username:
        return jsonify({'message': 'Missing username or friend_username'}), 400

    if username == friend_username:
        return jsonify({'message': 'Cannot send a friend request to yourself'}), 400
    
    user = User.query.filter_by(username=username).first()
    friend = User.query.filter_by(username=friend_username).first()
    
    if not user or not friend:
        return jsonify({'message': 'User not found'}), 404

    # Check if a friend request already exists
    existing_request = FriendRequest.query.filter(
        ((FriendRequest.sender == user) & (FriendRequest.receiver == friend)) |
        ((FriendRequest.sender == friend) & (FriendRequest.receiver == user))
    ).first()

    if existing_request:
        return jsonify({'message': 'Friend request already sent or received'}), 409

    # Create a new friend request
    new_request = FriendRequest(sender=user, receiver=friend)
    db.session.add(new_request)
    db.session.commit()

    return jsonify({'message': f'Friend request sent from {username} to {friend_username}'}), 200


