#!/bin/bash

# Navigate to the project directory
cd /home/ubuntu

# Update the system and install necessary dependencies
sudo apt update -y
sudo apt install -y python3 python3-pip python3-venv git

# Clone the project repository
git clone https://github.com/rahulwagh/python-mysql-db-proj-1.git

# Navigate into the project directory
cd python-mysql-db-proj-1

# Create a Python virtual environment
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate

# Install the required Python packages from requirements.txt
pip install -r requirements.txt

# Wait for 30 seconds before running the app
echo 'Waiting for 30 seconds before running the app.py'
sleep 30

# Run the app.py script in the background
setsid python3 -u app.py &

# Deactivate the virtual environment
deactivate

echo 'App is running in the background.'
