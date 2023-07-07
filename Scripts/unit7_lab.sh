#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[33m'
none='\033[0m'

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

echo -e "${yellow}[UNIT 7 LAB]${none} MANUAL INSTALL STEPS NEEDED:"
echo -e "    Login to 127.0.0.1 on the local machine (No port needed)"
echo -e "    Change the password from admin@admin.test/admin to admin@admin.test/Codepath123!"
echo -e "    Click on 'Sync Actions' > 'Load Default Feed Metadata' > 'Fetch and Store all feed data'"
echo -e "    Check all the options and select 'Cache All Feeds'"
echo -e "      (Note: This is NOT the blue button that says 'Fetch and store all feed Data'!)"