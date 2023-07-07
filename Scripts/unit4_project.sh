#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'

# Are pip3 and Slowloris already installed?
if command -v pip3 &> /dev/null; then
    if pip3 freeze | grep -iq "Slowloris" ; then
        echo -e "${green}[UNIT 4 PROJECT]${none} Slowloris already installed."
        exit 0
    fi
fi

echo "The slowloris library is installed."

# Install curl, gnupg2, ca-certificates, lsb-release, and ubuntu-keyring
sudo apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring

# Import NGINX signing key
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# Add NGINX to sources list
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list

# Pin NGINX packages
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx

# Update package lists
sudo apt update

# Install NGINX
sudo apt install -y nginx

# Install Python
sudo apt install -y python3-pip

# Install Slowloris
sudo pip3 install slowloris

# Did pip3 and Slowloris install?
if command -v pip3 &> /dev/null; then
    if pip3 freeze | grep -i "Slowloris" ; then
        echo -e "${green}[UNIT 4 PROJECT]${none} Slowloris successfully installed."
        exit 0
    fi
fi
echo -e "${red}[UNIT 4 PROJECT]${none} ERROR: Slowloris did not install correctly!"
exit 1