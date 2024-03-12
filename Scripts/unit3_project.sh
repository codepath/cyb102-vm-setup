#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'
scripts_repo="https://raw.githubusercontent.com/codepath/cyb102-vm-setup/${1:-"main"}/Files/"

echo "[UNIT 3 PROJECT] Starting script..."

# Are npm and hftp already installed?
if command -v npm &> /dev/null ; then
    if npm list -g | grep -q "hftp" ; then
        echo -e "${green}[UNIT 3 PROJECT]${none} NPM and hftp already installed."
    fi
else
    # Install Node.js and npm
    sudo apt-get install -y nodejs npm
    # Install the hftp library globally
    sudo npm install -g hftp

    # Did npm and hftp install correctly?
    if command -v npm &> /dev/null ; then
        if npm list -g | grep -q "hftp" ; then
            echo -e "${green}[UNIT 3 PROJECT]${none} NPM and hftp installed correctly"
        else
            echo -e "${red}[UNIT 3 PROJECT]${none} ERROR: hftp did not install correctly."
            exit 1
        fi
    else
        echo -e "${red}[UNIT 3 PROJECT]${none} ERROR: NPM did not install correctly."
        exit 1
    fi
fi

# Download the required files into the lab_1 directory
if [ -e ~/ftp_folder ]; then
    echo -e "${green}[UNIT 3 PROJECT]${none} ftp_folder already exists."
else
    # Download the files
    wget "${scripts_repo}unit3/ftp_folder.zip" -O "$HOME/ftp_folder.zip"
    unzip ~/ftp_folder.zip -d ~/

    # Verify download was successful
    if ! [ "$HOME/ftp_folder" ]; then
        echo -e "${red}[UNIT 3 PROJECT]${none} Error: Could not download files to $HOME/ftp_folder"
        echo -e "${red}[UNIT 3 PROJECT]${none} Try downloading manually from ${scripts_repo}unit3/ftp_folder.zip and placing in $HOME."
        exit 1
    else
        echo -e "${green}[UNIT 3 PROJECT]${none} Files downloaded successfully."
    fi
fi