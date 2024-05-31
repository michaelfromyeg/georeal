"""
The server for the geofencing app.
"""
from gevent import monkey

monkey.patch_all()

import csv  # noqa: E402
from typing import Any  # noqa: E402

from flask import Flask
from flask_cors import CORS  # noqa: E402
from flask_migrate import Migrate  # noqa: E402

from .extensions import bcrypt
from .logger import logger  # noqa: E402
from .models import db
from .utils import (DATA_PATH, FLASK_ENV, GIT_COMMIT_HASH, HOST,  # noqa: E402
                    PORT, UPLOAD_PATH, allowed_file)

 # noqa: E402



DATABASE_URI = "sqlite:///geofences.db"

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = DATABASE_URI
app.config["UPLOAD_FOLDER"] = UPLOAD_PATH

db.init_app(app)

migrate = Migrate(app, db)
bcrypt.init_app(app)

logger.info("Running in %s mode", FLASK_ENV)

if FLASK_ENV == "development":
    logger.info("Enabling CORS for development")
    CORS(app)
else:
    logger.info("CORS not yet setup for production; would enable")

    CORS(app)

    # TODO(michaelfromyeg): add cors settings for production environment
    # CORS(
    #     app,
    #     resources={r"/*": {"origins": "https://bereal.michaeldemar.co"}},
    #     supports_credentials=True,
    # )


from .routes.auth import auth
from .routes.geofences import geofences
from .routes.routes import api
from .routes.users import users

app.register_blueprint(api)
app.register_blueprint(users)
app.register_blueprint(auth)
app.register_blueprint(geofences)

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
    # db.drop_all()
    db.create_all()


if __name__ == "__main__":
    logger.info(
        "Starting GeoReal server on %s:%d... in debug=%s mode",
        HOST,
        PORT,
        FLASK_ENV,
    )

    app.run(host=HOST, port=PORT, debug=FLASK_ENV != "production")
