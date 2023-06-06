#!/bin/bash

# Step 1: Switch to the root user and do the setup
sudo su - <<EOF

# Step 2: Download the Splunk package
wget -O splunk-9.0.4.1-419ad9369127-linux-2.6-amd64.deb "https://download.splunk.com/products/splunk/releases/9.0.4.1/linux/splunk-9.0.4.1-419ad9369127-linux-2.6-amd64.deb"

# Step 3: Install the Splunk package
dpkg -i splunk-9.0.4.1-419ad9369127-linux-2.6-amd64.deb

# Create user-seed.conf file to set up the initial admin username and password
echo -e "[user_info]\nUSERNAME = codepath\nPASSWORD = codepath" > /opt/splunk/etc/system/local/user-seed.conf

# Step 4: Change to the Splunk installation directory
cd /opt/splunk/bin

# Step 5: Start Splunk with --accept-license and --answer-yes to skip the first time run wizard's prompts
./splunk start --accept-license --answer-yes --no-prompt

# Step 6: Enable Splunk to start automatically on system boot
sudo ./splunk enable boot-start

# Create the second index
./splunk add index pathcode -auth 'codepath:codepath'

EOF

# Add data to Splunk

# Paths of the CSV files you want to add to Splunk for index "main" and their associated hostnames.
declare -A MAIN_DATA
MAIN_DATA=(
  [".././Files/Splunk-5-6-7/netflix_titles.csv"]="Netflix"
  [".././Files/Splunk-5-6-7/Top Video Game sales.csv"]="SalesData"
  [".././Files/Splunk-5-6-7/webauth.csv"]="WebServer01"
)

# Name of the main index you want to add data to.
MAIN_INDEX_NAME="main"

# Add each file in the list to the "main" index
for CSV_FILE_PATH in "${!MAIN_DATA[@]}"; do
    sudo /opt/splunk/bin/splunk add oneshot "$CSV_FILE_PATH" -index "$MAIN_INDEX_NAME" -sourcetype csv -host "${MAIN_DATA[$CSV_FILE_PATH]}" -auth 'codepath:codepath'
done

# Paths of the CSV files you want to add to Splunk for index "pathcode".
PATHCODE_CSV_FILE_PATHS=(".././Files/Splunk-5-6-7/webserver02.csv" ".././Files/Splunk-5-6-7/uploadedhashes.csv" ".././Files/Splunk-5-6-7/failedlogins64.csv" ".././Files/Splunk-5-6-7/BlueCoatProxy01.csv") 

# Name of the second index you want to add data to.
PATHCODE_INDEX_NAME="pathcode"

# Add each file in the list to the "pathcode" index
for CSV_FILE_PATH in "${PATHCODE_CSV_FILE_PATHS[@]}"; do
    FILE_BASENAME=$(basename "$CSV_FILE_PATH" .csv)
    sudo /opt/splunk/bin/splunk add oneshot "$CSV_FILE_PATH" -index "$PATHCODE_INDEX_NAME" -sourcetype csv -host "$FILE_BASENAME" -auth 'codepath:codepath'
done
