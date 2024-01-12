#!/bin/sh

echo "Running database migrations"
flask db upgrade

if [ $? -ne 0 ]; then
    echo "Failed to apply database migrations"
    exit 1
fi

echo "Starting the main application"
exec gunicorn -b :5000 -k gevent -w 4 -t 600 "georeal.server:app"
