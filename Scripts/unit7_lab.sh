#!/bin/bash

# Make sure we are not root
if [ "$EUID" -eq 0 ]
  then echo "Please do not run as root"
  exit
fi

# Create a new user 'misp'
sudo adduser --disabled-password --gecos "" misp

# Download the MISP installation script
wget --no-cache -O /tmp/INSTALL.sh https://raw.githubusercontent.com/MISP/MISP/2.4/INSTALL/INSTALL.sh

# Run the MISP installation script
bash /tmp/INSTALL.sh -c -M
