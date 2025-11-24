#!/bin/bash

set -e

APP_DIR="/var/www/ecomm"

echo "🔹 Creating virtual environment if not exists..."
python3 -m venv $APP_DIR/venv

echo "🔹 Activating environment..."
source $APP_DIR/venv/bin/activate

echo "🔹 Installing requirements..."
pip install -r $APP_DIR/requirements.txt

echo "🔹 Restarting Gunicorn service..."
sudo systemctl restart ecomm

echo "🚀 Deployment completed successfully!"
