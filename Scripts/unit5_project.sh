#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'
scripts_repo="https://raw.githubusercontent.com/codepath/cyb102-vm-setup/main/Files/"

echo "[UNIT 5 PROJECT] Starting script..."

# Ensure the tmp_splunk directory exists
if [ ! -d "$HOME/tmp_splunk" ]; then
    mkdir -p "$HOME/tmp_splunk"
fi

# Download the files
wget "${scripts_repo}unit5/webserver02.csv" -O "$HOME/tmp_splunk/webserver02.csv"
wget "${scripts_repo}unit5/uploadedhashes.csv" -O "$HOME/tmp_splunk/uploadedhashes.csv"
wget "${scripts_repo}unit5/failedlogins64.csv" -O "$HOME/tmp_splunk/failedlogins64.csv"
wget "${scripts_repo}unit5/BlueCoatProxy01.csv" -O "$HOME/tmp_splunk/BlueCoatProxy01.csv"

# Verify download was successful
if ! [ "$HOME/tmp_splunk/BlueCoatProxy01.csv" ]; then
    echo -e "${red}[UNIT 1 LAB]${none} Error: Could not download Splunk files to $HOME/tmp_splunk folder"
    echo -e "${red}[UNIT 1 LAB]${none} Try downloading manually from ${scripts_repo}unit5 and placing in ~/tmp_splunk."
    exit 1
fi

# Paths of the CSV files you want to add to Splunk for index "pathcode".
PATHCODE_CSV_FILE_PATHS=("$HOME/tmp_splunk/webserver02.csv" "$HOME/tmp_splunk/uploadedhashes.csv" "$HOME/tmp_splunk/failedlogins64.csv" "$HOME/tmp_splunk/BlueCoatProxy01.csv") 

# Name of the second index you want to add data to.
PATHCODE_INDEX_NAME="pathcode"

# Add each file in the list to the "pathcode" index
for CSV_FILE_PATH in "${PATHCODE_CSV_FILE_PATHS[@]}"; do
    FILE_BASENAME=$(basename "$CSV_FILE_PATH" .csv)
    sudo /opt/splunk/bin/splunk add oneshot "$CSV_FILE_PATH" -index "$PATHCODE_INDEX_NAME" -sourcetype csv -host "$FILE_BASENAME" -auth 'codepath:codepath'
done

echo -e "${green}[UNIT 5 Project]${none} Added data to Splunk."