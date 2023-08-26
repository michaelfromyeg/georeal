"""
The server for the geofencing app.
"""
import csv
import os
import subprocess

from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from geojson import Feature, Polygon, loads
from werkzeug.utils import secure_filename

DATABASE_URI = "sqlite:///geofences.db"
UPLOAD_FOLDER = "uploads"
ALLOWED_EXTENSIONS = {"jpg", "jpeg", "png", "gif"}

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = DATABASE_URI
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

db = SQLAlchemy(app)


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


@app.cli.command("bootstrap")
def bootstrap_table():
    """
    Insert some sample data into the database.
    """
    with open("data/geofences.csv", "r", encoding="utf-8") as csv_file:
        csv_reader = csv.DictReader(csv_file)
        for row in csv_reader:
            geofence = Geofence(
                geofence_id=row["geofence_id"],
                name=row["name"],
                geojson=row["geojson"],
                photo_filenames=row["photo_filenames"],
            )
            db.session.add(geofence)
        db.session.commit()


with app.app_context():
    print("Creating missing tables...")
    db.create_all()


def allowed_file(filename):
    """
    Determine if a file name is allowed.
    """
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


def get_git_revision_short_hash() -> str:
    """
    Get the version of the server.
    """
    return (
        subprocess.check_output(["git", "rev-parse", "--short", "HEAD"])
        .decode("ascii")
        .strip()
    )


@app.route("/", methods=["GET"])
def index():
    """
    Get the status of the server.
    """
    return jsonify({"message": "up", "version": get_git_revision_short_hash()})


@app.route("/geofences", methods=["GET"])
def get_geofences():
    """
    Get all regions that are geofenced.
    """
    geofences = Geofence.query.all()
    geofences_data = []

    for geofence in geofences:
        geofences_data.append(
            {
                "geofence_id": geofence.geofence_id,
                "name": geofence.name,
                "geojson": loads(geofence.geojson),
                "photo_filenames": geofence.photo_filenames.split(",")
                if geofence.photo_filenames
                else [],
            }
        )

    return jsonify(geofences_data)


@app.route("/geofences", methods=["POST"])
def create_geofence():
    """
    Create a new geofenced region.
    """
    data = request.get_json()
    name = data.get("name")
    geojson_str = data.get("geojson")

    if not name or not geojson_str:
        return jsonify({"error": "Name and GeoJSON are required"}), 400

    geojson = loads(geojson_str)
    geofence = Geofence(name=name, geojson=geojson)
    db.session.add(geofence)
    db.session.commit()

    return jsonify({"message": "Geofence created successfully"}), 201


@app.route("/geofences/<int:geofence_id>/upload", methods=["POST"])
def upload_photos(geofence_id):
    """
    Upload a new photo or photos to a geofence
    """
    if "photo" not in request.files:
        return jsonify({"error": "No file part"}), 400

    files = request.files.getlist("photo")

    geofence = Geofence.query.get(geofence_id)
    if not geofence:
        return jsonify({"error": "Geofence not found"}), 404

    filenames = geofence.photo_filenames or []

    for photo_file in files:
        if photo_file and allowed_file(photo_file.filename):
            filename = secure_filename(photo_file.filename)
            photo_file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))
            filenames.append(filename)

    if filenames:
        geofence.photo_filenames = filenames
        db.session.commit()
        return jsonify({"message": "Photos uploaded successfully"}), 200
    else:
        return jsonify({"error": "No valid files were uploaded"}), 400


if __name__ == "__main__":
    app.run(debug=True)
