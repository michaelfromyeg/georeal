import os

from flask import Blueprint, Response, jsonify, request, send_file
from geojson import Feature, Polygon
from werkzeug.utils import secure_filename

from .extensions import bcrypt
from .models import User, db
from .utils import GIT_COMMIT_HASH, allowed_file, logger

api = Blueprint('api', __name__)


@api.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    email = data.get('email')
    plain_password = data.get('password')
    
    # Hash password
    pw_hash = bcrypt.generate_password_hash(plain_password).decode('utf-8')
    
    # Check if the user already exists by email or username
    user = User.query.filter((User.username == username) | (User.email == email)).first()
    if user:
        return jsonify({'message': 'User already exists'}), 400

    new_user = User(username=username, email=email, password_hash=pw_hash)
    db.session.add(new_user)
    db.session.commit()
    
    return jsonify({'message': 'User created successfully'}), 201

@api.route('/login', methods=['POST'])
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

@api.route('/users', methods=['GET'])
def get_users():
    users = User.query.all()
    users_list = []
    for user in users:
        user_data = {
            'id': user.id,
            'username': user.username,
            'email': user.email
        }
        users_list.append(user_data)

    return jsonify(users_list), 200

@api.route('/add_friend', methods=['POST'])
def add_friend():
    data = request.get_json()
    username = data.get('username')
    friend_username = data.get('friend_username')
    
    if not username or not friend_username:
        return jsonify({'message': 'Missing username or friend_username'}), 400

    if username == friend_username:
        return jsonify({'message': 'Cannot friend yourself'}), 400
    
    user = User.query.filter_by(username=username).first()
    friend = User.query.filter_by(username=friend_username).first()
    
    if not user or not friend:
        return jsonify({'message': 'User not found'}), 404

    if user.friends.filter_by(username=friend_username).first() is not None:
        return jsonify({'message': 'Already friends'}), 409

    user.friends.append(friend)
    friend.friends.append(user) 

    db.session.commit()

    return jsonify({'message': f'{username} and {friend_username} are now friends'}), 200


class Geofence(db.Model): 
    """
    The model for a region on the map.
    """

    __tablename__ = "geofences"

    geofence_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    geojson = db.Column(db.JSON, nullable=False)
    photo_filenames = db.Column(db.JSON, nullable=True)

    def as_geojson_feature(self):
        """
        Convert raw geojson to a geojson feature.
        """
        return Feature(geometry=Polygon(self.geojson["coordinates"]))


@api.route("/status", methods=["GET"])
def status() -> tuple[Response, int]:
    """
    Return the status of the server.
    """
    return jsonify({"status": "ok", "version": GIT_COMMIT_HASH}), 200


@api.route("/geofences", methods=["GET"])
def get_geofences() -> tuple[Response, int]:
    """
    Get all regions that are geofenced.
    """
    geofences = Geofence.query.all()
    geofences_data: list[dict[str, Any]] = []

    for geofence in geofences:
        photo_filenames: list[str] = (
            geofence.photo_filenames.split(",") if geofence.photo_filenames else []
        )
        geofence_entry = {
            "geofence_id": geofence.geofence_id,
            "name": geofence.name,
            "geojson": geofence.geojson,
            "photo_filenames": photo_filenames,
        }
        geofences_data.append(geofence_entry)

    return jsonify(geofences_data), 200


@api.route("/geofences", methods=["POST"])
def create_geofence() -> tuple[Response, int]:
    """
    Create a new geofenced region.
    """
    data = request.get_json()
    name = data.get("name")
    geojson = data.get("geojson")

    if not name or not geojson:
        return jsonify({"error": "Name and GeoJSON are required"}), 400

    geofence = Geofence(name=name, geojson=geojson)
    db.session.add(geofence)
    db.session.commit()

    return jsonify({"message": "Geofence created successfully"}), 201


@api.route("/geofences/<int:geofence_id>/upload", methods=["POST"])
def upload_photos(geofence_id: int) -> tuple[Response, int]:
    """
    Upload a new photo or photos to a geofence
    """
    if "photo" not in request.files:
        return jsonify({"error": "No file part"}), 400

    files = request.files.getlist("photo")

    geofence = db.session.get(Geofence, geofence_id)
    if not geofence:
        return jsonify({"error": "Geofence not found"}), 404

    filenames = geofence.photo_filenames or []

    for photo_file in files:
        if (
            photo_file is not None
            and photo_file.filename is not None
            and allowed_file(photo_file.filename)
        ):
            filename = secure_filename(photo_file.filename)
            local_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)
            photo_file.save(local_path)
            filenames.append(filename)

    if filenames:
        geofence.photo_filenames = filenames
        db.session.commit()
        return jsonify({"message": "Photos uploaded successfully"}), 200
    else:
        return jsonify({"error": "No valid files were uploaded"}), 400


@api.route("/uploads/<filename>", methods=["GET"])
def get_image(filename: str) -> tuple[Response, int]:
    """
    Return an image.

    TODO(michaelfromyeg): implement some sort of token-based authentication; these photos can only be accessed from the app.
    """
    if not filename:
        return jsonify({"error": "No filename provided"}), 400

    if not allowed_file(filename):
        return jsonify({"error": "Invalid file type"}), 400

    image_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)

    if not os.path.isfile(image_path):
        return jsonify({"error": "File not found"}), 404

    return send_file(image_path, mimetype="image/jpeg"), 200


@api.errorhandler(400)
def bad_request(error) -> tuple[Response, int]:
    logger.error("Got 400 error: %s", error)

    return jsonify(
        {
            "error": "Bad Request",
            "message": "The server could not understand the request due to invalid syntax.",
        }
    ), 400


@api.errorhandler(404)
def not_found(error) -> tuple[Response, int]:
    logger.warning("Got 404 for URL %s: %s", request.url, error)

    return jsonify(
        {"error": "Not Found", "message": "This resource does not exist"}
    ), 404


@api.errorhandler(500)
def internal_error(error) -> tuple[Response, int]:
    logger.error("Got 500 error: %s", error)

    return jsonify(
        {
            "error": "Internal Server Error",
            "message": "An internal server error occurred",
        }
    ), 500
