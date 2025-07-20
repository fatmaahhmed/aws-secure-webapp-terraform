#!/bin/bash
sudo apt update -y
sudo apt install -y nginx

# Use hardcoded internal ALB DNS from your setup
cat <<EOF | sudo tee /etc/nginx/sites-available/default
server {
    listen 80;
    location / {
        proxy_pass http://internal-backend-alb-2037941868.us-east-2.elb.amazonaws.com;
    }
}
EOF

sudo systemctl restart nginx
