#!/bin/bash
set -euo pipefail

APP_DIR="/var/www/ecomm"
VENV_DIR="$APP_DIR/venv"
SERVICE_NAME="ecomm"
GUNICORN_BIND="127.0.0.1:8000"
WORKERS=3
USER=ubuntu
GROUP=www-data

# Ensure ownership
sudo mkdir -p "$APP_DIR"
sudo chown -R $USER:$GROUP "$APP_DIR"

echo "Copying app files to $APP_DIR (assumes files already placed by Jenkins)..."

# Create venv if not exists
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi

# Activate and install
source "$VENV_DIR/bin/activate"
pip install --upgrade pip
if [ -f "$APP_DIR/requirements.txt" ]; then
    pip install -r "$APP_DIR/requirements.txt"
fi

# Create systemd service
sudo bash -c "cat >/etc/systemd/system/$SERVICE_NAME.service" <<EOF
[Unit]
Description=Gunicorn instance for Ecomm Flask App
After=network.target

[Service]
User=$USER
Group=$GROUP
WorkingDirectory=$APP_DIR
Environment='PATH=$VENV_DIR/bin'
ExecStart=$VENV_DIR/bin/gunicorn --workers $WORKERS --bind $GUNICORN_BIND app:app

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and restart
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl restart $SERVICE_NAME

# Nginx config
sudo bash -c 'cat >/etc/nginx/sites-available/ecomm' <<'NGINX'
server {
    listen 80;
    server_name _;
    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://127.0.0.1:8000;
    }
}
NGINX

sudo ln -sf /etc/nginx/sites-available/ecomm /etc/nginx/sites-enabled/ecomm
sudo nginx -t
sudo systemctl restart nginx

echo "Deployment complete. Service: $SERVICE_NAME. Check status: sudo systemctl status $SERVICE_NAME"
