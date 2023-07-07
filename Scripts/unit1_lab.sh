#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'

# Check if the script needs to run
if command -v wireshark >/dev/null 2>&1 ; then
    echo -e "${green}[UNIT 1 LAB]${none} Wireshark is already installed."
    exit 0
fi
echo "[UNIT 1 LAB] Installing Wireshark..."

# Pre-set the answer for the wireshark-common package
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

# Add the Wireshark PPA
sudo add-apt-repository -y ppa:wireshark-dev/stable

# Update the package list
sudo apt-get update

# Install Wireshark in non-interactive mode
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y wireshark

# Print output based on whether or not Wireshark is installed
if command -v wireshark >/dev/null 2>&1 ; then
    echo -e "${green}[UNIT 1 LAB]${none} Wireshark installed successfully."
else
    echo -e "${red}[UNIT 1 LAB]${none} ERROR: Wireshark was not installed correctly!"
    exit 1
fi