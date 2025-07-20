#!/bin/bash

# Update and install dependencies
sudo apt update -y
sudo apt install -y python3 python3-pip

# Install Flask
pip3 install flask

# Create the Flask app
cat <<EOF > /home/ubuntu/app.py
from flask import Flask
app = Flask(__name__)
@app.route("/")
def hello():
    return "Hello from Backend Flask!"
app.run(host='0.0.0.0', port=80)
EOF

# Make sure no other service is using port 80 and run the app
sudo fuser -k 80/tcp || true
nohup python3 /home/ubuntu/app.py > /home/ubuntu/flask.log 2>&1 &
