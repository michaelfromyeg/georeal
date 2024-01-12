"""
Utility functions and constants.
"""
import configparser
import os
import subprocess

from dotenv import load_dotenv

from .logger import logger

load_dotenv()

CWD = os.getcwd()

FLASK_ENV = os.getenv("FLASK_ENV") or "production"

HOST: str | None = os.getenv("HOST")
PORT_STR: str | None = os.getenv("PORT")

PORT = int(PORT_STR) if PORT_STR is not None else None

if not HOST or not PORT:
    logger.error("HOST and PORT environment variables must be set")

config = configparser.ConfigParser()

config.read("config.ini")

UPLOAD_FOLDER = config.get("georeal", "upload_folder", fallback="uploads")
UPLOAD_PATH = os.path.join(CWD, UPLOAD_FOLDER)

os.makedirs(UPLOAD_PATH, exist_ok=True)

DATA_PATH = os.path.join(CWD, "data")

ALLOWED_EXTENSIONS = {"jpg", "jpeg", "png", "gif"}


def get_git_commit_hash() -> str:
    try:
        if not os.path.isdir(".git"):
            return "unknown"

        commit_hash = subprocess.check_output(
            ["git", "rev-parse", "--short", "HEAD"]
        ).strip()
        return commit_hash.decode("utf-8")
    except subprocess.CalledProcessError:
        return "unknown"
    except Exception:
        return "unknown"


GIT_COMMIT_HASH = get_git_commit_hash()


def allowed_file(filename: str) -> bool:
    """
    Determine if a file name is allowed.
    """
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS
