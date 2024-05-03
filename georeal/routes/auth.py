from flask import Blueprint, jsonify, request

from ..extensions import bcrypt
from ..models import User, db

auth = Blueprint('auth', __name__)


@auth.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    email = data.get('email')
    plain_password = data.get('password')
    print(username, email, plain_password)
    # Hash password
    pw_hash = bcrypt.generate_password_hash(plain_password).decode('utf-8')
    print("ok")
    # Check if the user already exists by email or username
    user = User.query.filter((User.username == username) | (User.email == email)).first()
    if user:
        print("User already exists")
        return jsonify({'message': 'User already exists'}), 400
    
    new_user = User(username=username, email=email, password_hash=pw_hash)
    db.session.add(new_user)
    db.session.commit()
    
    return jsonify({'message': 'User created successfully'}), 201

@auth.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')  
    plain_password = data.get('password')
    
    user = User.query.filter_by(email=email).first()  
    if user and bcrypt.check_password_hash(user.password_hash, plain_password):
        # Success
        return jsonify({
            'message': 'Login successful',
            'username': user.username, 
        }), 200
    else:
        return jsonify({'message': 'Invalid email or password'}), 401