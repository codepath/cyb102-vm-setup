#!/bin/bash
none='\033[0m'
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[33m'
course="CYB101"

branch=${1:-"main"}
scripts_repo="https://raw.githubusercontent.com/codepath/cyb102-vm-setup/${branch}/Scripts/"

# Welcome message
echo -e "Welcome to ${green}CodePath Cybersecurity${none}!"
echo -e "This tool will help you set up your environment for the ${course} course."

if [ "$branch" != "main" ]; then
    echo -e "${yellow}WARNING: You are using the a non-default branch ${branch}.${none}"
    echo -e "${yellow}This is intended for development purposes only.${none}"
fi

# Check if user is running Ubuntu
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "ubuntu" ]; then
        echo -e "${red}WARNING: You are not running Ubuntu. This script is intended for use on Ubuntu.${none}"
        read -p "Do you want to continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Exiting the program. Goodbye!"
            exit 1
        fi
    fi
else
    echo -e "${yellow}WARNING: Unable to determine Linux distribution. This script is intended for use on Ubuntu.${none}"
    read -p "Do you want to continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting the program. Goodbye!"
        exit 1
    fi
fi

# Check if wget is installed
if ! command -v wget &> /dev/null; then
    echo -e "${red}ERROR: wget is not installed.${none}"
    read -p "Do you want to install wget? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt install -y wget
    else
        echo "Exiting the program. Goodbye!"
        exit 1
    fi
fi

# Function to install all scripts
install_all_scripts() {
    echo -e "Installing all ${course} scripts..."
    for i in {1..7} ; do
        install_specific_unit "$i"
    done
}

# Function to install a specific script
install_specific_unit() {
    unit=$1
    dirname="tmp_$course_${unit}"

    # Move to a temporary directory to download the script
    mkdir -p $dirname
    cd $dirname

    # Download and run Lab script
    install_specific_script $unit lab
    # Download and run Project script
    install_specific_script $unit project

    # Move back to the original directory and remove the temporary directory
    cd ..
    rm -rf $dirname
}

# Function to install a specific script
install_specific_script() {
    unit=$1
    type=$2
    script_name="unit${unit}_${type}.sh"

    # Set the script name to rdp_setup.sh if unit is 0
    if [ "$unit" == "0" ]; then
        script_name="rdp_setup.sh"
    fi

    # Download and run script
    wget "${scripts_repo}${script_name}"
    chmod +x ${script_name}
    ./${script_name} ${branch}

    # Check the exit status of the script
    status=$?
    if [ $status -ne 0 ] ; then
        echo -e "${red}Error:${none} ${script_name} exited with status $status"
        read -p "Do you want to continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Exiting the program. Goodbye!"
            cd ..
            rm -rf "tmp_$course_${unit}"
            exit 1
        fi       
    fi
}

# Function to show the menu and process user input
show_menu() {
    echo "Please choose an option:"
    echo "1. Install all units"
    echo "2. Install a specific unit"
    echo "3. Install RDP (Remote Desktop Protocol)"
    echo "4. Exit"

    read -p "Enter your choice (1-4): " choice

    case $choice in
        1)
            install_all_scripts
            ;;
        2)
            read -p "Enter the number of the unit to install (1-7): " unit_number
            install_specific_unit "$unit_number"
            ;;
        3)
            install_specific_script 0 "rdp"
            ;;
        4)
            echo "Exiting the program. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice, please try again."
            show_menu
            ;;
    esac
}

# Main program loop
while true; do
    show_menu
done
