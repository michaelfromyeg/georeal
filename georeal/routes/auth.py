from flask import Blueprint, jsonify, request

from ..extensions import bcrypt
from ..models import User, db

auth = Blueprint('auth', __name__)


@auth.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    email = data.get('email')
    name = data.get('name')
    plain_password = data.get('password')
    
    # Hash password
    pw_hash = bcrypt.generate_password_hash(plain_password).decode('utf-8')
    
    # Check if the user already exists by email or username
    user = User.query.filter((User.username == username) | (User.email == email)).first()
    if user:
        print("User already exists")
        return jsonify({'message': 'User already exists'}), 400
    
    new_user = User(username=username, email=email, password_hash=pw_hash, name=name)
    
    db.session.add(new_user)
    db.session.commit()
    
    return jsonify({
        'id': new_user.id,
        'username': new_user.username,
        'name': new_user.name,
        'email': new_user.email,
        'num_places': new_user.num_places,
        'num_posts': new_user.num_posts,
        'num_friends': new_user.num_friends,
        'profile_photo': new_user.profile_photo,
    }), 200

@auth.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')  
    plain_password = data.get('password')
    
    user = User.query.filter_by(email=email).first()  
    if user and bcrypt.check_password_hash(user.password_hash, plain_password):
        # Success
        return jsonify({
            'id': user.id,
            'name': user.name,
            'username': user.username,
            'email': user.email,
            'num_places': user.num_places,
            'num_posts': user.num_posts,
            'num_friends': user.num_friends, 
            'profile_photo': user.profile_photo,
        }), 200
    else:
        return jsonify({'message': 'Invalid email or password'}), 401
