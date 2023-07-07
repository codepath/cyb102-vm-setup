#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[33m'
none='\033[0m'

warn () {
  echo -e "${yellow}[UNIT 7 LAB]${none} MANUAL INSTALL STEPS NEEDED:"
  echo -e "    Login to 127.0.0.1 on the local machine (No port needed)"
  echo -e "    Change the password from admin@admin.test/admin to admin@admin.test/Codepath123!"
  echo -e "    Click on 'Sync Actions' > 'Feeds' > 'Load Default Feed Metadata' > 'Fetch and Store all feed data'"
  echo -e "    Check all the options and select 'Cache All Feeds'"
  echo -e "      (Note: This is NOT the blue button that says 'Fetch and store all feed Data'!)"
}
echo "[UNIT 7 LAB] Starting script..."

# Make sure we are not root
if [ "$EUID" -eq 0 ]
  then echo "Please do not run as root"
  exit
fi

if systemctl is-active --quiet misp-modules; then
    echo -e "${green}[UNIT 7 LAB]${none} MISP is already installed."
    warn
    exit 0
fi

# Create a new user 'misp'
sudo adduser --disabled-password --gecos "" misp

# Download the MISP installation script
wget --no-cache -O /tmp/INSTALL.sh https://raw.githubusercontent.com/MISP/MISP/2.4/INSTALL/INSTALL.sh

# Run the MISP installation script
bash /tmp/INSTALL.sh -c -M

if systemctl is-active --quiet misp-modules; then
    echo -e "${green}[UNIT 7 LAB]${none} MISP installed correctly"
else 
    echo -e "${red}[UNIT 7 LAB]${none} ERROR: MISP did not install correctly!"
    exit 1
fi
warn
