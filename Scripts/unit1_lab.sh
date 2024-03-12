#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'
scripts_repo="https://raw.githubusercontent.com/codepath/cyb102-vm-setup/main/Files/"

echo "[UNIT 1 LAB] Starting script..."

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

# Ensure the lab_1 directory exists
if [ ! -d "$HOME/lab_1" ]; then
    mkdir -p "$HOME/lab_1"
fi

# Download the required files into the lab_1 directory
if [ -e "$HOME/lab_1/SMTP.pcap" ]; then
    echo -e "${green}[UNIT 1 LAB]${none} Files already found at ~/lab_1."
else
    # Download the files
    wget "${scripts_repo}unit1/DHCP.txt" -O "$HOME/lab_1/DHCP.txt"
    wget "${scripts_repo}unit1/Security_log.rtf" -O "$HOME/lab_1/Security_log.rtf"
    wget "${scripts_repo}unit1/SMTP.pcap" -O "$HOME/lab_1/SMTP.pcap"

    # Verify download was successful
    if ! [ "$HOME/lab_1/SMTP.pcap" ]; then
        echo -e "${red}[UNIT 1 LAB]${none} Error: Could not download files to $HOME/lab_1 folder"
        echo -e "${red}[UNIT 1 LAB]${none} Try downloading manually from ${scripts_repo}unit1 and placing in ~/lab_1."
        exit 1
    else
        echo -e "${green}[UNIT 1 LAB]${none} Files downloaded successfully."
    fi
fi