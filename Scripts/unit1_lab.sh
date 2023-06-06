#!/bin/bash

# Pre-set the answer for the wireshark-common package
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

# Add the Wireshark PPA
sudo add-apt-repository -y ppa:wireshark-dev/stable

# Update the package list
sudo apt-get update

# Install Wireshark in non-interactive mode
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y wireshark
