# Paths of the CSV files you want to add to Splunk for index "pathcode".
PATHCODE_CSV_FILE_PATHS=("Files/Splunk-5-6-7/webserver02.csv" "Files/Splunk-5-6-7/uploadedhashes.csv" "Files/Splunk-5-6-7/failedlogins64.csv" "Files/Splunk-5-6-7/BlueCoatProxy01.csv") 

# Name of the second index you want to add data to.
PATHCODE_INDEX_NAME="pathcode"

# Add each file in the list to the "pathcode" index
for CSV_FILE_PATH in "${PATHCODE_CSV_FILE_PATHS[@]}"; do
    FILE_BASENAME=$(basename "$CSV_FILE_PATH" .csv)
    sudo /opt/splunk/bin/splunk add oneshot "$CSV_FILE_PATH" -index "$PATHCODE_INDEX_NAME" -sourcetype csv -host "$FILE_BASENAME" -auth 'codepath:codepath'
done

echo -e "${green}[UNIT 5 Project]${none} Added data to Splunk."