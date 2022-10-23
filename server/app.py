import os
from flask import Flask, request, jsonify
from firebase_admin import credentials, firestore, initialize_app

app = Flask(__name__)

cred = credentials.Certificate(
    "georeal-dubhacks-firebase-adminsdk-k6jvz-20e88e2d34.json"
)
default_app = initialize_app(cred)
db = firestore.client()

users_ref = db.collection("users")
regions_ref = db.collection("regions")


@app.route("/live")
def live():
    return {"hello": "world"}


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
    """

    if request.method == "GET":
        return [
            {"lat": 1.02, "lon": 2.02, "radius": 3},
            {"lat": 3.02, "lon": 4.02, "radius": 3},
        ]

    if request.method == "POST":
        region_id = "abc123"

        # TODO: create region with generated region ID

        return {"regionId": region_id}


@app.route("/point", methods=["GET", "POST"])
def point():
    """
    Methods to work with a specific point on the map.

    GET /point?lat=&lon=    - determine if point in any region; return region ID
    """
    lat = request.args.get("lat")
    lon = request.args.get("lon")

    # Determine if lat, lon in any region

    return {"regionId": "abc123", "lat": lat, "lon": lon}


@app.route("/regions/<string:regionId>/photos", methods=["GET", "POST"])
def regionPhotos(regionId: str):
    """
    A photo that belongs to a specific region ID.

    GET /regions/:regionId/photos   - fetch all photos in regionId
    POST /regions/:regionId/photos  - create photo in region
    """

    if request.method == "GET":
        return {
            "photos": [
                "https://via.placeholder.com/150",
                "https://via.placeholder.com/150",
            ]
        }

    if request.method == "POST":
        # Take in image "blob," upload to file storage; get URL

        # Put URL with region ID in Firestore collection

        # Return the image URL
        return {"url": "https://via.placeholder.com/150"}


if __name__ == "__main__":
    app.run(debug=True, port=5001)
