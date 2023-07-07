#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'

if systemctl is-active --quiet xrdp; then
     echo -e "${green}[RDP SETUP]${none} XRDP is already installed."
     exit 0
fi
echo "[RDP SETUP] Installing XRDP..."

# Run an update before making changes
sudo apt-get update

# Install xfce
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install xfce4
sudo apt install xfce4-session

# Install xrdp
sudo apt-get -y install xrdp
sudo systemctl enable xrdp

# On Ubuntu 20, you need to give certificate access to an xrdp user:
sudo adduser xrdp ssl-cert

# Tell xrdp what desktop environment to use:
echo xfce4-session >~/.xsession

# Restart the xrdp service for the changes to take effect:
sudo service xrdp restart

if systemctl is-active --quiet xrdp; then
    echo -e "${green}[RDP SETUP]${none} XRDP installed successfully."
else
    echo -e "${red}[RDP SETUP]${none} ERROR: XRDP did not install correctly."
    exit 1
fi