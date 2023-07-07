#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'

safe_move() {
    if [ -e $2/$1 ]; then
        echo -e "[UNIT 2 PROJECT] File $1 already found at $2."
    else
        if [ -e $1 ]; then
            sudo mv "~/Files/wazuh-2/$1" $2 && echo "[UNIT 2 PROJECT] Moved $1 to $2/$1"
        else
            echo -e "${red}[UNIT 2 PROJECT]${none} Error: File ~/Files/wazuh-2/$1 does not exist."
            exit 1
        fi
    fi
}

safe_move attack-part1.sh ~
safe_move attack-part2.sh ~
safe_move thisisit.txt /etc/wazuh
safe_move static.txt /etc/wazuh

echo -e "${green}[UNIT 2 PROJECT]${none} All files moved successfully."