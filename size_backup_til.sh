#!/bin/bash

BACKUP_FOLDER=/root/backup

# The script checks if a valid 4-digit year was provided as an argument; if not, it shows an error and exits. 
# Then it lists files older than that year and calculates their total disk usage.

# Check if year argument is provided
if [[ -z "$1" ]]; then
  echo "❌ Error: You must provide a year as the first argument."
  echo "Usage: $0 <year>"
  exit 1
fi

# Optional: Validate that $1 is a 4-digit year
if ! [[ "$1" =~ ^[0-9]{4}$ ]]; then
  echo "❌ Error: '$1' is not a valid 4-digit year."
  exit 1
fi

# Proceed with disk usage calculation
cd $BACKUP_FOLDER || { echo "❌ Failed to change directory to $BACKUP_FOLDER"; exit 1; }

echo "Total size of all files up to 01/01/$1:"
find . -type f ! -newermt "$1-01-01" -print0 | du --files0-from=- -ch | tail -n 1
