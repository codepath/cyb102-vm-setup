#!/bin/bash

# Call the rdp_setup.sh script
./Scripts/rdp_setup.sh

# Check the exit status of the script
status=$?
if [ $status -ne 0 ] ; then
  echo "Error: rdp_setup.sh exited with status $status"
  exit $status
fi
read -p "Press any key to continue"

for i in {1..7} ; do
  # Call the unit*_lab.sh script
  ./Scripts/unit${i}_lab.sh
  
  # Check the exit status of the script
  status=$?
  if [ $status -ne 0 ] ; then
    echo "Error: unit${i}_lab.sh exited with status $status"
    exit $status
  fi
  read -p "Press any key to continue"
  
  # Call the unit*_project.sh script
  ./Scripts/unit${i}_project.sh
  
  # Check the exit status of the script
  status=$?
  if [ $status -ne 0 ] ; then
    echo "Error: unit${i}_project.sh exited with status $status"
    exit $status
  fi
  read -p "Press any key to continue"
done

echo "All scripts executed successfully."