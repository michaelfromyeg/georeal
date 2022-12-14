import os
import uuid
import string
import random
from flask import Flask, request, jsonify
from firebase_admin import credentials, firestore, initialize_app, storage
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = "tmp"
ALLOWED_EXTENSIONS = set(["png", "jpg", "jpeg"])

app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

cred = credentials.Certificate(
    "georeal-dubhacks-firebase-adminsdk-k6jvz-20e88e2d34.json"
)
default_app = initialize_app(cred)
db = firestore.client()

users_ref = db.collection("users")
regions_ref = db.collection("regions")
photos_ref = db.collection("photos")

bucket = storage.bucket("georeal-dubhacks")


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route("/")
def hello():
    return {"hello": "world"}


@app.route("/status")
def status():
    return {"status": "up"}


@app.route("/users/<string:username>", methods=["GET", "POST"])
def users(username: str):
    """
    Method for accessing and creating users.

    GET /users/:username    - get user information
    POST /users/:username   - create empty user account with username
    """
    if request.method == "GET":
        try:
            user = users_ref.document(username).get()
            if not user.to_dict():
                return jsonify({"message": f"User {username} does not exist"}), 404

            return jsonify(user.to_dict()), 200
        except Exception as e:
            return f"An error occurred: {e}"

    if request.method == "POST":
        try:
            default_user = {
                # TODO: add fields for user
                "username": username
            }
            users_ref.document(username).set(default_user)
            return jsonify({"success": True}), 200
        except Exception as e:
            return f"An error occurred: {e}"


@app.route("/regions", methods=["GET", "POST"])
def regions():
    """
    A circular region on the map.

    GET /regions    - fetch all regions
    POST /regions   - create a single region (with lat, lon, radius); return region ID

    e.g., an array of regions
    [
        { "regionId: "abc", "lat": 1.02, "lon": 2.02, "radius": 3 },
        { "regionId: "abc", "lat": 3.02, "lon": 4.02, "radius": 3 },
    ]
    """

    if request.method == "GET":
        try:
            all_regions = [region.to_dict() for region in regions_ref.stream()]
            return jsonify(all_regions), 200
        except Exception as e:
            return f"An error occurred: {e}"

    if request.method == "POST":
        try:
            # region_id = uuid.uuid4()
            N = 3
            region_id = "".join(
                random.choices(string.ascii_lowercase + string.digits, k=N)
            )

            # ASSUME: request.json contains lat, lon, radius only
            region_body = request.json
            region_body["regionId"] = region_id

            regions_ref.document(region_id).set(region_body)
            return jsonify({"success": True}), 200
        except Exception as e:
            return f"An Error Occurred: {e}"


@app.route("/regions/<string:region_id>/photos", methods=["GET", "POST"])
def regionPhotos(region_id: str):
    """
    A photo that belongs to a specific region ID.

    GET /regions/:region_id/photos   - fetch all photos in regionId
    POST /regions/:region_id/photos  - create photo in region

    e.g., example photos

    "photos": [
        "https://via.placeholder.com/150",
        "https://via.placeholder.com/150",
    ]
    """

    if request.method == "GET":
        all_photos = [photo.to_dict() for photo in photos_ref.stream()]
        region_photos = list(
            filter(lambda photo: photo["regionId"] == region_id, all_photos)
        )

        return jsonify(region_photos), 200

    # TODO: handle case where filename already exists in bucket, photos collection
    if request.method == "POST":
        # Take in image "blob," upload to file storage; get URL
        if "file" not in request.files:
            return jsonify({"message": "Missing file part"}), 400

        public_url = ""
        filename = ""

        file = request.files["file"]
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            # Save to tmp/ directly, for now
            path = os.path.join(app.config["UPLOAD_FOLDER"], filename)
            file.save(path)

            # Upload the file
            blob = bucket.blob(filename)
            blob.upload_from_filename(path)

            public_url = blob.public_url

            # Remove the now unnecessary file
            os.remove(path)

        # Put URL with region ID in Firestore collection
        if public_url:
            # Save entry in Firestore
            photo_entry = {
                "filename": filename,
                "publicUrl": public_url,
                "regionId": region_id,
            }
            photos_ref.document(filename).set(photo_entry)

            # Return the image URL
            return jsonify(photo_entry), 200

        return jsonify({"message": "An unexpected error occurred"}), 500


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))
