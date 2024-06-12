#!/usr/bin/env bash
# Author: Joshua Ross
# Github: https://github.com/ColoredBytes
# Purpose: semaphore install script.
# -------------------------------------------

# Variables
TMP=$(mktemp -d) # Create TMP directory
LATEST=$(curl -s "https://api.github.com/repos/semaphoreui/semaphore/releases/latest" | jq '.assets[] | select(.name|match("semaphore_*_linux_amd64.deb$")) | .browser_download_url' | tr -d '"') # Grab Latest deb file
HOST_IP=$(hostname -I | cut -d' ' -f1) # Get the IP address of the host machine
SYSTEMD_FILE=""

mariadb_install() {
  sudo apt install mariadb-server
  sudo mysql_secure_installation
  sudo mariadb
}

# Create User
sudo adduser --system --group --home /home/semaphore semaphore

# Build the Database
mariadb_install

# Download semaphore deb pacakge to TMP
wget -O $TMP/semaphore.deb $LATEST
if [ ! -f "$TMP/semaphore.deb"]; then
  echo "Could not download latest .deb package!"
  exit 1
fi

# Install/update emby server deb package
echo "Installing Ansible & Semaphore..."
sudo apt install -y ansible
sudo apt install -y $TMP/semaphore.deb

# Setup Semaphore
semaphore setup

# Test Semaphore runs correctly 
echo "Testing Semaphore..."
semaphore server --config config.json
echo "Try accessing Semaphore at $(HOST_IP):3000..."

# Make semaphore a home
sudo mkdir /etc/semaphore;sudo mv config.json /etc/semaphore/;sudo chown -R semaphore:semaphore /etc/semaphore

# Make systemd service 

# Do the needful to enable it correctly 
sudo systemctl daemon-reload;sudo systemctl enable semaphore.service;sudo systemctl start semaphore.service

# Job's Done
echo "Semaphore has been Sucessfully Installed it should be accessible at $(HOST_IP):3000..."



