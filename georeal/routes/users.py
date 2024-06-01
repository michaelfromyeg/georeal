import os

from flask import Blueprint
from flask import current_app as app
from flask import jsonify, request
from werkzeug.utils import secure_filename

from georeal.models import FriendRequest, User, db
from georeal.utils import allowed_file

users = Blueprint('users', __name__)

# Get all users
@users.route('/users', methods=['GET'])
def get_all_users():
    users = User.query.all()
    users_list = []
    for user in users:
        user_data = {
            'user_id': user.id,
            'name': user.name,
            'email': user.email,
            'username': user.username,
            'num_places': user.num_places,
            'num_posts': user.num_posts,
            'num_friends': user.num_friends,
            'profile_photo': user.profile_photo,
            'friends_ids': user.get_friends_ids(),
        }
        
        users_list.append(user_data)

    return jsonify(users_list), 200

# Get user details for a specific user
@users.route('/user', methods=['GET'])
def get_user_details():
    search_username = request.args.get('username')
    querying_user_id = request.args.get('user_id', type=int)

    if not search_username:
        return jsonify({'error': 'Missing username parameter'}), 400
    if not querying_user_id:
        return jsonify({'error': 'Missing user ID parameter'}), 400

    user = User.query.filter_by(username=search_username).first()
    if not user:
        return jsonify({'error': 'User not found'}), 404

    # Check friendship and friend request status
    is_friend = False
    friend_request_sent = None
    if querying_user_id:
        if user in User.query.get(querying_user_id).friends:
            is_friend = True
        else:
            # Check for existing friend request in either direction
            friend_request = FriendRequest.query.filter(
                db.or_(
                    db.and_(FriendRequest.sender_id == querying_user_id, FriendRequest.receiver_id == user.id),
                    db.and_(FriendRequest.receiver_id == querying_user_id, FriendRequest.sender_id == user.id)
                )
            ).first()
            friend_request_sent = 'sent' if friend_request and friend_request.sender_id == querying_user_id else 'received'

    user_details = {
        'user_id': user.id,
            'name': user.name,
            'email': user.email,
            'username': user.username,
            'num_places': user.num_places,
            'num_posts': user.num_posts,
            'num_friends': user.num_friends,
            'profile_photo': user.profile_photo,
            'friends_ids': user.get_friends_ids(),
    }

    return jsonify(user_details), 200

# Creates a friend request from sender to receiver
@users.route('/users/friend_request', methods=['POST'])
def create_friend_request():
    sender_id = request.args.get('sender_id')
    receiver_id = request.args.get('receiver_id')
    
    if not sender_id or not receiver_id:
        return jsonify({'error': 'Missing sender_id or receiver_id'}), 400
    
    if sender_id == receiver_id:
        return jsonify({'error': 'Cannot send a friend request to oneself'}), 400
    
    sender = User.query.get(sender_id)
    receiver = User.query.get(receiver_id)
    if not sender or not receiver:
        return jsonify({'error': 'Sender or receiver not found'}), 404

    existing_request = FriendRequest.query.filter(
        ((FriendRequest.sender_id == sender_id) & (FriendRequest.receiver_id == receiver_id)) |
        ((FriendRequest.sender_id == receiver_id) & (FriendRequest.receiver_id == sender_id))
    ).first()

    if existing_request:
        return jsonify({'error': 'Friend request already exists'}), 409

    new_request = FriendRequest(sender_id=sender_id, receiver_id=receiver_id)
    db.session.add(new_request)
    db.session.commit()

    return jsonify({'message': f'Friend request sent from {sender_id} to {receiver_id}'}), 200

@users.route('/users/<int:user_id>/friend_requests', methods=['GET'])
def get_all_friend_requests(user_id):
    
    friend_requests = FriendRequest.query \
        .join(User, User.id == FriendRequest.sender_id) \
        .add_columns(
            FriendRequest.id,
            FriendRequest.sender_id,
            User.username.label('sender_username'),
            FriendRequest.receiver_id,
        ) \
        .filter(FriendRequest.receiver_id == user_id).all()

    result = [{
        'request_id': fr.id,
        'sender_id': fr.sender_id,
        'sender_username': fr.sender_username,  
        'receiver_id': fr.receiver_id,
    } for fr in friend_requests]

    return jsonify(result), 200

@users.route('/users/friend_requests/<int:request_id>/accept', methods=['POST'])
def accept_friend_request(request_id):
    friend_request = FriendRequest.query.get(request_id)

    if not friend_request:
        return jsonify({'error': 'Friend request not found'}), 404

    # Manually increment the num_friends counter for both users and delete the friend request 
    sender = User.query.get(friend_request.sender_id)
    receiver = User.query.get(friend_request.receiver_id)
    if sender and receiver:

        sender.num_friends += 1
        receiver.num_friends += 1

        sender.friends.append(receiver)
        receiver.friends.append(sender)

        db.session.delete(friend_request)
        db.session.commit()

        return jsonify({'message': 'Friend request accepted, users are now friends'}), 200
    else:
        db.session.rollback()
        return jsonify({'error': 'Sender or receiver not found'}), 404

@users.route('/users/friend_requests/<int:request_id>/reject', methods=['POST'])
def reject_friend_request(request_id):
    friend_request = FriendRequest.query.get(request_id)

    if not friend_request:
        return jsonify({'error': 'Friend request not found'}), 404

    db.session.delete(friend_request)
    db.session.commit()

    return jsonify({'message': 'Friend request rejected'}), 200


@users.route('/users/search', methods=['GET'])
def search_users():
    search_query = request.args.get('query')
    if not search_query:
        return jsonify({'error': 'Missing query parameter'}), 400

    users = User.query.filter(User.username.ilike(f'%{search_query}%')).all()
    users_list = []
    for user in users:
        user_data = {
            'user_id': user.id,
            'name': user.name,
            'email': user.email,
            'username': user.username,
            'num_places': user.num_places,
            'num_posts': user.num_posts,
            'num_friends': user.num_friends,
            'profile_photo': user.profile_photo,
            'friends_ids': user.get_friends_ids(),
        }
        users_list.append(user_data)

    return jsonify(users_list), 200

@users.route('/user/<int:user_id>/profile_photo/upload', methods=['POST'])
def upload_profile_photo(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    photo_file = request.files['photo']

    if photo_file and allowed_file(photo_file.filename):
        filename = secure_filename(photo_file.filename)
        local_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        photo_file.save(local_path)

        user.profile_photo = f"/uploads/{filename}"
        db.session.commit()

        return jsonify({'message': 'Profile photo uploaded successfully', 'photo_url': user.profile_photo}), 200
    return jsonify({'error': 'No valid files were uploaded'}), 400

@users.route('/user/<int:user_id>/profile_photo', methods=['GET'])
def get_profile_photo(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({'error': 'User not found'}), 404

    return jsonify({'photo_url': user.profile_photo}), 200
