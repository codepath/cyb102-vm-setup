#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'

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

# Move everything in ../Files/ftp-3 to ~ and rename it to ftp_folder
if [ -e ~/ftp_folder ]; then
    echo -e "${green}[UNIT 3 PROJECT]${none} ftp_folder already exists."
else
    if [ -e ~/Files/ftp-3 ]; then
        sudo mv ~/Files/ftp-3 ~/ftp_folder && echo -e "${green}[UNIT 3 PROJECT]${none} Moved ftp-3 files to ~/ftp_folder"
    else
        echo -e "${red}[UNIT 3 PROJECT]${none} Error: File ~/Files/ftp-3 does not exist."
        exit 1
    fi
fi
