#!/bin/bash

brew install python@3.11 docker

python3.11 -m venv env

source env/bin/activate

pip install --upgrade pip
pip install -r requirements/dev.txt
