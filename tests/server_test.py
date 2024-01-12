"""
Basic tests for the core endpoints.
"""
from io import BytesIO
from typing import Any, Generator

import pytest
from geojson import Point

from georeal.server import Geofence, app, db


@pytest.fixture
def client() -> Generator[Any, Any, None]:
    """
    Setup the app.
    """
    # use an in-memory SQLite database for testing
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///:memory:"
    app.config["TESTING"] = True

    client = app.test_client()

    with app.app_context():
        db.create_all()

    yield client

    with app.app_context():
        db.drop_all()


def test_status_endpoint(client: Any) -> None:
    """
    Test the /status endpoint.
    """
    response = client.get("/status")

    assert response.status_code == 200
    assert "status" in response.json
    assert "version" in response.json


def test_get_geofences(client: Any) -> None:
    """
    Test the /geofences endpoint.
    """
    with app.app_context():
        geofence = Geofence(
            name="Test Zone", geojson={"type": "Point", "coordinates": [-115.81, 37.24]}
        )
        db.session.add(geofence)
        db.session.commit()

        response = client.get("/geofences")

        assert response.status_code == 200
        assert len(response.json) == 1
        assert response.json[0]["name"] == "Test Zone"


def test_create_geofence(client):
    """
    Create a geofence.
    """
    geojson_data = {"type": "Point", "coordinates": [-115.81, 37.24]}
    data = {
        "name": "New Zone",
        "geojson": geojson_data,
    }

    response = client.post("/geofences", json=data)

    assert response.status_code == 201
    assert "Geofence created successfully" in response.json["message"]


def test_create_geofence_missing_data(client: Any) -> None:
    """
    Try creating a geofence without data.
    """
    with app.app_context():
        response = client.post("/geofences", json={})

        assert response.status_code == 400
        assert "Name and GeoJSON are required" in response.json["error"]


def test_upload_photos(client: Any) -> None:
    """
    Upload a photo.
    """
    with app.app_context():
        geofence = Geofence(
            name="Test Zone", geojson=Point((-115.81, 37.24)).__geo_interface__
        )
        db.session.add(geofence)
        db.session.commit()

        data = {"photo": (BytesIO(b"test data"), "test.jpg")}
        response = client.post(
            f"/geofences/{geofence.geofence_id}/upload",
            content_type="multipart/form-data",
            data=data,
        )

        assert response.status_code == 200
        assert "Photos uploaded successfully" in response.json["message"]


def test_upload_photos_no_file(client: Any) -> None:
    """
    Upload a photo but forget to include the file.
    """
    with app.app_context():
        response = client.post("/geofences/1/upload")

        assert response.status_code == 400
        assert "No file part" in response.json["error"]


def test_upload_photos_geofence_not_found(client):
    """
    Upload to a non-existent geofence.
    """
    with app.app_context():
        data = {"photo": (BytesIO(b"test data"), "test.jpg")}
        response = client.post("/geofences/9999/upload", data=data)

        assert response.status_code == 404
        assert "Geofence not found" in response.json["error"]


def test_get_image(client: Any) -> None:
    """
    Try to get a test image.
    """
    with app.app_context():
        response = client.get("/uploads/test.jpg")

        assert response.status_code == 200
        assert response.content_type == "image/jpeg"


def test_get_image_file_not_found(client: Any) -> None:
    """
    Get a non-existent image.
    """
    with app.app_context():
        response = client.get("/uploads/nonexistent.jpg")

        assert response.status_code == 404
        assert "File not found" in response.json["error"]


def test_get_image_invalid_file_type(client: Any) -> None:
    """
    Get a bad file type.
    """
    with app.app_context():
        response = client.get("/uploads/invalid_file.exe")

        assert response.status_code == 400
        assert "Invalid file type" in response.json["error"]
