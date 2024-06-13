#!/usr/bin/env bash
# Author: Joshua Ross
# Github: https://github.com/ColoredBytes
# Purpose: semaphore update script.

# Variables 
TMP=$(mktemp -d) # Create TMP directory
LOG_FILE="$TMP/errors.log"
LATEST=$(curl -s "https://api.github.com/repos/semaphoreui/semaphore/releases/latest" | jq -r '.assets[] | select(.name | endswith("_linux_amd64.deb")) | .browser_download_url')

# Commands
exec > >(tee -a ${LOG_FILE})
exec 2> >(tee -a ${LOG_FILE} >&2)

error_exit() {
    echo "$1" 1>&2
    echo "An error occurred. Please check the log file at ${LOG_FILE} for more details."
    exit 1
}

# stop semaphore
systemctl stop semaphore.service

# Download semaphore deb package to TMP
wget -O $TMP/semaphore.deb $LATEST || error_exit "Failed to download the latest semaphore .deb package"
if [ ! -f "$TMP/semaphore.deb" ]; then
  error_exit "Could not download latest .deb package!"
fi

# Install/update semaphore deb package
echo "Installing Ansible & Semaphore..."
sudo apt install -y ansible || error_exit "Failed to install Ansible"
sudo apt install -y $TMP/semaphore.deb || error_exit "Failed to install Semaphore .deb package"

# start semaphore
systemctl start semaphore.service

# Clean up
echo "Cleaning up the mess you made..."
rm -rf $TMP
> $LOG_FILE