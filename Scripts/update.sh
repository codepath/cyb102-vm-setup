#!/bin/bash

# Inform the user about adding the 'universe' repository
echo "Adding the 'universe' repository..."
sudo add-apt-repository universe -y
echo "The 'universe' repository has been added successfully."

# Update the package list
echo "Updating the package list..."
sudo apt update
echo "Package list updated successfully."

# Upgrade all the installed packages
echo "Upgrading all installed packages. This might take a while..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo "All packages have been upgraded successfully."

# Final completion message
echo "Update and upgrade process completed successfully!"
