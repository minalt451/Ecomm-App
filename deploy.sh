#!/bin/bash

# Navigate to app directory
cd /var/www/ecomm || exit 1

# Activate virtual environment
source venv/bin/activate

# Install Python dependencies
pip install --upgrade pip
if [ -f requirements.txt ]; then
    pip install -r requirements.txt
fi

# Restart Gunicorn service
sudo systemctl daemon-reload
sudo systemctl restart ecomm

# Reload Nginx to make sure it picks up changes
sudo systemctl reload nginx

echo "Deployment completed successfully."

