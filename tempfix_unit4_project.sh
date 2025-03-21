#!/bin/bash
set -e  # Exit on any error

red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'

echo "[UNIT 4 PROJECT] Starting script..."

# Check if Slowloris is already installed
if command -v pip3 &> /dev/null; then
    if pip3 show slowloris &> /dev/null; then
        echo -e "${green}[UNIT 4 PROJECT]${none} Slowloris is already installed."
        exit 0
    fi
fi

# Update package lists
echo "[UNIT 4 PROJECT] Updating package lists..."
sudo apt update

# Install dependencies
echo "[UNIT 4 PROJECT] Installing required dependencies..."
sudo apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring python3-pip

# Install NGINX
echo "[UNIT 4 PROJECT] Installing NGINX..."
curl -fsSL https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx
sudo apt update
sudo apt install -y nginx

# Install Slowloris
echo "[UNIT 4 PROJECT] Installing Slowloris..."
sudo pip3 install --break-system-packages slowloris

# Verify installation
if pip3 show slowloris &> /dev/null; then
    echo -e "${green}[UNIT 4 PROJECT]${none} Slowloris successfully installed."
    exit 0
else
    echo -e "${red}[UNIT 4 PROJECT]${none} ERROR: Slowloris did not install correctly!"
    exit 1
fi
