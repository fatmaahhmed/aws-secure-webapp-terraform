#!/bin/bash
sudo apt update -y
sudo apt install -y python3 python3-pip
pip3 install flask
cat <<EOF > /home/ubuntu/app.py
from flask import Flask
app = Flask(__name__)
@app.route("/")
def hello():
    return "Hello from Flask"
EOF
nohup python3 /home/ubuntu/app.py &
