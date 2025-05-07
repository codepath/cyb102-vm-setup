#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'
scripts_repo="https://raw.githubusercontent.com/codepath/cyb102-vm-setup/${1:-"main"}/Files/"

echo "[UNIT 5 LAB] Starting script..."

if sudo /opt/splunk/bin/splunk status | grep 'is running'; then
    echo -e "${green}[UNIT 5 LAB]${none} Splunk is already installed."
else
    echo -e "[UNIT 5 LAB] Installing Splunk..."

    # Step 1: Switch to the root user and do the setup
    sudo su - <<EOF

# Step 2: Download the Splunk package
wget -O splunk-9.4.1-e3bdab203ac8-linux-amd64.deb "https://download.splunk.com/products/splunk/releases/9.4.1/linux/splunk-9.4.1-e3bdab203ac8-linux-amd64.deb"

# Step 3: Install the Splunk package
dpkg -i splunk-9.4.1-e3bdab203ac8-linux-amd64.deb

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

    if sudo /opt/splunk/bin/splunk status | grep 'is running'; then
        echo -e "${green}[UNIT 5 LAB]${none} Splunk installed correctly"
    else 
        echo -e "${red}[UNIT 5 LAB]${none} ERROR: Splunk did not install correctly!"
        exit 1
    fi
fi

######## Add data to Splunk

# Ensure the tmp_splunk directory exists
if [ ! -d "$HOME/tmp_splunk" ]; then
    mkdir -p "$HOME/tmp_splunk"
fi

# Initialize a flag to indicate success
all_success=true

# Download the files
wget "${scripts_repo}unit5/netflix_titles.csv" -O "$HOME/tmp_splunk/netflix_titles.csv" || all_success=false
wget "${scripts_repo}unit5/Top Video Game sales.csv" -O "$HOME/tmp_splunk/Top Video Game sales.csv" || all_success=false
wget "${scripts_repo}unit5/webauth.csv" -O "$HOME/tmp_splunk/webauth.csv" || all_success=false

# Verify download was successful
if [ "$all_success" = false ]; then
    echo -e "${red}[UNIT 1 LAB]${none} Error: Could not download Splunk files to $HOME/tmp_splunk folder"
    echo -e "${red}[UNIT 1 LAB]${none} Try downloading manually from ${scripts_repo}unit5 and placing in ~/tmp_splunk."
    rm -rf "$HOME/tmp_splunk"
    exit 1
fi

# Paths of the CSV files you want to add to Splunk for index "main" and their associated hostnames.
declare -A MAIN_DATA
MAIN_DATA=(
  ["$HOME/tmp_splunk/netflix_titles.csv"]="Netflix"
  ["$HOME/tmp_splunk/Top Video Game sales.csv"]="SalesData"
  ["$HOME/tmp_splunk/webauth.csv"]="WebServer01"
)

# Name of the main index you want to add data to.
MAIN_INDEX_NAME="main"

# Add each file in the list to the "main" index
for CSV_FILE_PATH in "${!MAIN_DATA[@]}"; do
    sudo /opt/splunk/bin/splunk add oneshot "$CSV_FILE_PATH" -index "$MAIN_INDEX_NAME" -sourcetype csv -host "${MAIN_DATA[$CSV_FILE_PATH]}" -auth 'codepath:codepath'
done

echo -e "${green}[UNIT 5 LAB]${none} Added data to Splunk."

# Clean up the tmp_splunk directory
rm -rf "$HOME/tmp_splunk"
