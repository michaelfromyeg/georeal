from flask import Blueprint, jsonify, request

from georeal.models import FriendRequest, User, db, friends

users = Blueprint('users', __name__)

# @users.route('/users', methods=['GET'])
# def get_users():
#     users = User.query.all()
#     users_list = []
#     for user in users:
#         user_data = {
#             'id': user.id,
#             'username': user.username,
#         }
#         users_list.append(user_data)

#     return jsonify(users_list), 200

@users.route('/user', methods=['GET'])
def get_user_details():

    search_username = request.args.get('username')
    if not search_username:
        return jsonify({'error': 'Missing username parameter'}), 400

    user = User.query.filter_by(username=search_username).first()
    if not user:
        return jsonify({'error': 'User not found'}), 404

    user_details = {
        'user_id': user.id,
        'username': user.username,
        'num_places': user.num_places,
        'num_posts': user.num_posts,
        'num_friends': user.num_friends
    }

    return jsonify(user_details), 200



# @users.route('/user', methods=['GET'])
# def get_user():
#     # Extract usernames from query parameters
#     sender_username = request.args.get('sender_username')
#     receiver_username = request.args.get('receiver_username')

#     if not sender_username or not receiver_username:
#         return jsonify({'error': 'Missing sender or receiver username'}), 400

#     # Retrieve both users from the database
#     sender = User.query.filter_by(username=sender_username).first()
#     receiver = User.query.filter_by(username=receiver_username).first()

#     if not sender or not receiver:
#         return jsonify({'error': 'Sender or receiver not found'}), 404

#     isFriend = User.query(friends).filter(
#         db.or_(
#             db.and_(friends.c.friend_id == user_id1, friends.c.friended_id == user_id2),
#             db.and_(friends.c.friend_id == user_id2, friends.c.friended_id == user_id1)
#         )
#     ).first() is not None

#     user_data = {
#         'sender_id': sender.id,
#         'sender_username': sender.username,
#         'receiver_id': receiver.id,
#         'receiver_username': receiver.username,
#         'isFriend': isFriend,
#     }
#     return jsonify(user_data), 200

@users.route('/users/send_request', methods=['POST'])
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


