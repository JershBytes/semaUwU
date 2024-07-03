#!/usr/bin/env bash
# Author: Joshua Ross
# Github: https://github.com/ColoredBytes
# Purpose: Semaphore install script.

# Variables
HOST_IP=$(hostname -I | cut -d' ' -f1) # Get the IP address of the host machine
TMP=$(mktemp -d) # Create TMP directory
LOG_FILE="$TMP/errors.log"
LATEST=$(curl -s "https://api.github.com/repos/semaphoreui/semaphore/releases/latest" | jq -r '.assets[] | select(.name | endswith("_linux_amd64.deb")) | .browser_download_url')
RPM_LATEST=$(curl -s "https://api.github.com/repos/semaphoreui/semaphore/releases/latest" | jq -r '.assets[] | select(.name | endswith("_linux_amd64.rpm")) | .browser_download_url')
CURDIR=$(pwd)

# Define the source and destination paths for systemd service
SERVICE_FILE_PATH="$CURDIR/conf"
DEST_DIR="/etc/systemd/system"
SERVICE_FILE="semaphore.service"

# Commands
exec > >(tee -a "${LOG_FILE}")
exec 2> >(tee -a "${LOG_FILE}" >&2)

# script functions
error_exit() {
    echo "$1" 1>&2
    echo "An error occurred. Please check the log file at ${LOG_FILE} for more details."
    exit 1
}

systemd_config() {
    sudo systemctl daemon-reload || error_exit "Failed to reload systemd daemon"
    sudo systemctl enable "$SERVICE_FILE" || error_exit "Failed to enable semaphore service"
    sudo systemctl start "$SERVICE_FILE" || error_exit "Failed to start semaphore service"
    sudo systemctl status "$SERVICE_FILE" || error_exit "Failed to get semaphore service status"
}

# Copy the service file to the destination directory
copy_service_file() {
    sudo cp "$SERVICE_FILE_PATH/$SERVICE_FILE" "$DEST_DIR/$SERVICE_FILE" || error_exit "Failed to copy systemd service file"
    echo "Service file copied successfully."
}

# -----------------------------------------------------------------------------------------------

# MariaDB Install Functions
deb_mariadb_install() {
    sudo apt install -y mariadb-server || error_exit "Failed to install MariaDB"
    sudo mysql_secure_installation || error_exit "Failed to secure MariaDB installation"
}
rpm_mariadb_install() {
    sudo dnf install -y mariadb-server mariadb || error_exit "Failed to install MariaDB"
    sudo mysql_secure_installation || error_exit "Failed to secure MariaDB installation"
}

# -----------------------------------------------------------------------------------------------

# Semaphore install functions
deb_install() {
    # Create User
sudo adduser --system --group --home /home/semaphore semaphore || error_exit "Failed to create semaphore user"

# Setup and configure MariaDB
deb_mariadb_install || error_exit "Failed to install MariaDB"
sudo mysql -u root < "${CURDIR}/conf/mariadb.conf" || error_exit "Failed to import MariaDB config"

# Quick nap
sleep 5

# Download semaphore deb package to TMP
wget -O "${TMP}/semaphore.deb" "${LATEST}" || error_exit "Failed to download the latest semaphore .deb package"
if [ ! -f "${TMP}/semaphore.deb" ]; then
  error_exit "Could not download latest .deb package!"
fi

# Install/update semaphore deb package
echo "Installing Semaphore & Friend..."
sudo apt install -y ansible || error_exit "Failed to install Ansible"
sudo apt install -y "${TMP}/semaphore.deb" || error_exit "Failed to install Semaphore .deb package"
}

rpm_install() {
# Create group
sudo groupadd semaphore || error_exit "Failed to create semaphore group"

# Create user and assign to group
sudo useradd --system --create-home --home /home/semaphore --shell /bin/false --gid semaphore semaphore || error_exit "Failed to create semaphore user"

# Setup and configure MariaDB
rpm_mariadb_install || error_exit "Failed to install MariaDB"
sudo mysql -u root < "${CURDIR}/conf/mariadb.conf" || error_exit "Failed to import MariaDB config"

# Quick nap
sleep 5

# Download semaphore rpm package to TMP
wget -O "${TMP}/semaphore.rpm" "${RPM_LATEST}" || error_exit "Failed to download the latest semaphore .rpm package"
if [ ! -f "${TMP}/semaphore.rpm" ]; then
  error_exit "Could not download latest .rpm package!"
fi

# Install/update semaphore rpm package
echo "Installing Semaphore & Friend..."
sudo dnf install -y ansible || error_exit "Failed to install Ansible"
sudo dnf install -y "${TMP}/semaphore.rpm" || error_exit "Failed to install Semaphore .rpm package"
}

# -----------------------------------------------------------------------------------------------

case "$1" in
  deb)
    deb_install
    ;;
  rpm)
    rpm_install
    ;;
  *)
    echo "Usage: $0 {deb|rpm}"
    exit 1
    ;;
esac

# Setup Semaphore
semaphore setup || error_exit "Failed to setup Semaphore"

# Make semaphore a home
sudo mkdir /etc/semaphore || error_exit "Failed to create /etc/semaphore directory"
sudo mv config.json /etc/semaphore/ || error_exit "Failed to move config.json to /etc/semaphore"
sudo chown -R semaphore:semaphore /etc/semaphore || error_exit "Failed to set permissions for /etc/semaphore"

# Copy over service file and ask about Terraform and OpenTofu
copy_service_file

# Do the needful to enable it correctly 
systemd_config

# Job's Done
echo "Semaphore has been successfully installed. It should be accessible at http://${HOST_IP}:3000"