#!/bin/bash

# Creates a comma-separated String of open applications and assign it to the APPS variable.
APPS=$(osascript -e 'tell application "System Events" to get name of (processes where background only is false)')

IFS=',' read -r -a myAppsArray <<< "$APPS"

# Loop through each item in the 'myAppsArray' Array.
for myApp in "${myAppsArray[@]}"
do
  # Remove space character from the start of the Array item
  appName=$(echo "$myApp" | sed 's/^ *//g')
  #Avoid closing the "Finder" and your CLI tool.
  #Note: you may need to change "iTerm" to "Terminal"
  if [[ ! "$appName" == "Finder" && ! "$appName" == "iTerm" ]]; then
    # quit the application
    osascript -e 'quit app "'"$appName"'"'
  fi
done