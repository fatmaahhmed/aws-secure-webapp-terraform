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
    return "Hello from Flask"

app.run(host='0.0.0.0', port=80)
EOF

# Run the app in background
sudo fuser -k 80/tcp || true
sudo nohup python3 /home/ubuntu/app.py &
