"""
The server for the geofencing app.
"""
from gevent import monkey

monkey.patch_all()

import csv  # noqa: E402
import os  # noqa: E402
from typing import Any  # noqa: E402

from flask import Flask, Response, jsonify, request, send_file  # noqa: E402
from flask_cors import CORS  # noqa: E402
from flask_migrate import Migrate  # noqa: E402
from flask_sqlalchemy import SQLAlchemy  # noqa: E402
from geojson import Feature, Polygon  # noqa: E402
from werkzeug.utils import secure_filename  # noqa: E402

from .logger import logger  # noqa: E402
from .utils import (  # noqa: E402
    DATA_PATH,
    FLASK_ENV,
    GIT_COMMIT_HASH,
    HOST,
    PORT,
    UPLOAD_PATH,
    allowed_file,
)

DATABASE_URI = "sqlite:///geofences.db"

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = DATABASE_URI
app.config["UPLOAD_FOLDER"] = UPLOAD_PATH

db = SQLAlchemy(app)
migrate = Migrate(app, db)

logger.info("Running in %s mode", FLASK_ENV)

if FLASK_ENV == "development":
    logger.info("Enabling CORS for development")
    CORS(app)
else:
    logger.info("Enabling CORS for production")
    CORS(
        app,
        resources={r"/*": {"origins": "https://bereal.michaeldemar.co"}},
        supports_credentials=True,
    )


class Geofence(db.Model):  # type: ignore
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
def bootstrap_table() -> None:
    """
    Insert some sample data into the database.
    """
    geofences_path = os.path.join(DATA_PATH, "geofences.csv")

    with open(geofences_path, "r", encoding="utf-8") as csv_file:
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

    return None


with app.app_context():
    logger.info("Creating database...")
    db.create_all()


@app.route("/status", methods=["GET"])
def status() -> tuple[Response, int]:
    """
    Return the status of the server.
    """
    return jsonify({"status": "ok", "version": GIT_COMMIT_HASH}), 200


@app.route("/geofences", methods=["GET"])
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


@app.route("/geofences", methods=["POST"])
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


@app.route("/geofences/<int:geofence_id>/upload", methods=["POST"])
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


@app.route("/uploads/<filename>", methods=["GET"])
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


if __name__ == "__main__":
    logger.info(
        "Starting BeReal server on %s:%d... in debug=%s mode",
        HOST,
        PORT,
        FLASK_ENV == "development",
    )

    app.run(host=HOST, port=PORT, debug=FLASK_ENV == "development")
