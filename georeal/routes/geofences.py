import os
from typing import Any

from flask import Blueprint, Response
from flask import current_app as app
from flask import jsonify, request, send_from_directory
from werkzeug.utils import secure_filename

from georeal.models import Geofence, Post, db
from georeal.utils import allowed_file

geofences = Blueprint('geofences', __name__)

@geofences.route("/geofences", methods=["GET"])
def get_geofences() -> tuple[Response, int]:
    """
    Get all regions that are geofenced.
    """
    geofences = Geofence.query.all()
    return jsonify([{
        'id': g.id,
        'name': g.name,
        'latitude': g.latitude,
        'longitude': g.longitude,
        'radius': g.radius,
        'creator_id': g.creator_id,
    } for g in geofences]), 200

@geofences.route("/geofences/<int:user_id>", methods=["GET"])
def get_geofences_by_user(user_id: int) -> tuple[Response, int]:
    """
    Get all regions that are geofenced by a specific user.
    """
    geofences = Geofence.query.filter_by(creator_id=user_id).all()
    return jsonify([{
        'id': g.id,
        'name': g.name,
        'latitude': g.latitude,
        'longitude': g.longitude,
        'radius': g.radius,
        'creator_id': g.creator_id,
    } for g in geofences]), 200

        
@geofences.route("/geofences", methods=["POST"])
def create_geofence():
    data = request.get_json()
    new_geofence = Geofence(
        name=data['name'],
        latitude=data['latitude'],
        longitude=data['longitude'],
        radius=data['radius'],
        creator_id=data['creator_id']
    )

    db.session.add(new_geofence)
    db.session.commit()
    return jsonify({'id': new_geofence.id}), 201

@geofences.route('/uploads/<filename>')
def uploaded_file(filename):
    if allowed_file(filename):
        return send_from_directory(app.config['UPLOAD_FOLDER'], filename)
    else:
        return jsonify({"error": "File not allowed"}), 403

@geofences.route('/geofences/<int:geofence_id>/upload_photo', methods=['POST'])
def upload_photo(geofence_id):
    geofence = Geofence.query.get(geofence_id)
    if not geofence:
        return jsonify({"error": "Geofence not found"}), 404

    photo_file = request.files['photo']
    if photo_file and allowed_file(photo_file.filename):
        filename = secure_filename(photo_file.filename)
        local_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        photo_file.save(local_path)

        photo_url = f"/uploads/{filename}"  
        new_post = Post(photo_url=photo_url, author_id=request.form['author_id'], geofence_id=geofence_id)
        db.session.add(new_post)
        db.session.commit()
        return jsonify({'message': 'Photo uploaded successfully', 'photo_url': photo_url}), 200

    return jsonify({"error": "No valid files were uploaded"}), 400


@geofences.route('/geofences/<int:geofence_id>/posts', methods=['GET'])
def get_posts_by_geofence(geofence_id):
    print("Test")
    print(Geofence.query.all())
    geofence = Geofence.query.get(geofence_id)
    if not geofence:
        return jsonify({'message': 'Geofence not found'}), 404

    posts = [{
        'id': post.id,
        'photo_url': post.photo_url,
        'created_at': post.created_at.isoformat(),
        'author_id': post.author_id
    } for post in geofence.posts]
    return jsonify(posts), 200

@geofences.route('/geofences/delete/<int:geofence_id>', methods=['DELETE'])
def delete_geofence(geofence_id):
    geofence = Geofence.query.get(geofence_id)
    if not geofence:
        return jsonify({'message': 'Geofence not found'}), 404

    db.session.delete(geofence)
    db.session.commit()
    return jsonify({'message': 'Geofence deleted successfully'}), 200

