# '/root/aws-secure-webapp/scripts/install-nginx.tpl'
#!/bin/bash
sudo apt update -y
sudo apt install -y nginx -y
echo "<h1>Hello from NGINX</h1>" | sudo tee /var/www/html/index.html
cat <<EOF | sudo tee /etc/nginx/sites-available/default
server {
    listen 80;
    location / {
        proxy_pass http://${backend_alb_dns};
    }
}
EOF

sudo systemctl restart nginx
cat /root/.ssh/id_rsa | sudo tee /root/.ssh/id_rsa > /dev/null
sudo chmod 600 /root/.ssh/id_rsa