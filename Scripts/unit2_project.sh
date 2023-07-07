#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'

safe_move() {
    if [ -e $2/$1 ]; then
        echo -e "[UNIT 2 PROJECT] File $1 already found at $2."
    else
        if [ -e "$HOME/Files/wazuh-2/$1" ]; then
            sudo mv ~/Files/wazuh-2/"$1" $2/$1 && echo "[UNIT 2 PROJECT] Moved $1 to $2/$1"
        else
            echo -e "${red}[UNIT 2 PROJECT]${none} Error: File ~/Files/wazuh-2/$1 does not exist."
            exit 1
        fi
        # Verify move was successful
        if ! [ -e $2/$1 ]; then
            echo -e "${red}[UNIT 2 PROJECT]${none} Error: Could not move file $1 to $2/$1"
            exit 1
        fi
    fi
}

echo "[UNIT 2 PROJECT] Starting script..."

sudo mkdir -p /etc/wazuh
safe_move attack-part1 ~
safe_move attack-part2 ~
chmod u+x ~/attack-part1
chmod u+x ~/attack-part2
safe_move thisisit.txt /etc/wazuh
safe_move static.txt /etc/wazuh

echo -e "${green}[UNIT 2 PROJECT]${none} All files moved successfully."