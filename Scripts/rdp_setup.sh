#!/bin/bash

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