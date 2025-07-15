#!/bin/bash
sudo apt update -y
sudo apt install -y nginx
echo "<h1>Hello from NGINX</h1>" | sudo tee /var/www/html/index.html
sudo systemctl restart nginx
