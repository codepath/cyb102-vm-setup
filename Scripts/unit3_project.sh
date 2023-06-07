#!/bin/bash

# Install Node.js and npm
sudo apt-get install -y nodejs npm

# Install the hftp library globally
sudo npm install -g hftp

# Move everything in ../Files/ftp-3 to ~ and rename it to ftp_folder
sudo mv ../Files/ftp-3 ~/ftp_folder