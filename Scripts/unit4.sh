#!/bin/bash

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

# Install Slowloris
sudo pip3 install slowloris
