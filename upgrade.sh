#!/usr/bin/env bash
# Author: Joshua Ross
# Github: https://github.com/ColoredBytes
# Purpose: Semaphore install script.

# script functions,Commands & Variables

# variables -----------------------------------------------------------------------------------------------
HOST_IP=$(hostname -I | cut -d' ' -f1) # Get the IP address of the host machine
TMP=$(mktemp -d) # Create TMP directory
LOG_FILE="$TMP/errors.log"
LATEST=$(curl -s "https://api.github.com/repos/semaphoreui/semaphore/releases/latest" | jq -r '.assets[] | select(.name | endswith("_linux_amd64.deb")) | .browser_download_url')
RPM_LATEST=$(curl -s "https://api.github.com/repos/semaphoreui/semaphore/releases/latest" | jq -r '.assets[] | select(.name | endswith("_linux_amd64.rpm")) | .browser_download_url')

# Commands ----------------------------------------------------------------------------------------------- 
exec > >(tee -a "${LOG_FILE}")
exec 2> >(tee -a "${LOG_FILE}" >&2)

# functions -----------------------------------------------------------------------------------------------
error_exit() {
    echo "$1" 1>&2
    echo "An error occurred. Please check the log file at ${LOG_FILE} for more details."
    exit 1
}

deb() {
sudo apt update
wget -O "${TMP}/semaphore.deb" "${LATEST}" || error_exit "Failed to download the latest semaphore .deb package"
if [ ! -f "${TMP}/semaphore.deb" ]; then
  error_exit "Could not download latest .deb package!"
fi

# Install/update semaphore deb package
echo "Installing Semaphore & Friend..."
sudo apt install -y ansible || error_exit "Failed to install Ansible"
sudo apt install -y "${TMP}/semaphore.deb" || error_exit "Failed to install Semaphore .deb package"
}

rpm() {
sudo dnf makecache
wget -O "${TMP}/semaphore.rpm" "${RPM_LATEST}" || error_exit "Failed to download the latest semaphore .rpm package"
if [ ! -f "${TMP}/semaphore.rpm" ]; then
  error_exit "Could not download latest .rpm package!"
fi

# Install/update semaphore rpm package
echo "Installing Semaphore & Friend..."
sudo dnf install -y epel-release || error_exit "Failed to install EPEL Repo"
sudo dnf install -y ansible || error_exit "Failed to install Ansible"
sudo dnf install -y "${TMP}/semaphore.rpm" || error_exit "Failed to install Semaphore .rpm package"
}

# script -----------------------------------------------------------------------------------------------

# Case Statment to call function depending on the OS.
case "$1" in
  deb)
    deb
    ;;
  rpm)
    rpm
    ;;
  *)
    echo "Usage: $0 {deb|rpm}"
    exit 1
    ;;
esac


# Job's Done
echo "Semaphore has been successfully installed. It should be accessible at http://${HOST_IP}:3000"
