#!/bin/bash

# List of common US time zones
timezones=(
  "America/New_York"    # Eastern Time
  "America/Chicago"     # Central Time
  "America/Denver"      # Mountain Time
  "America/Phoenix"     # Mountain Time (no DST)
  "America/Los_Angeles" # Pacific Time
  "America/Anchorage"   # Alaska Time
  "America/Adak"        # Hawaii-Aleutian Time
  "Pacific/Honolulu"    # Hawaii Time
)

# Function to check internet connection
check_internet() {
    wget -q --spider http://google.com
    return $?
}

# Function to prompt the user for timezone selection
select_timezone() {
    echo "Select a time zone for the system:"
    for i in "${!timezones[@]}"; do
        echo "$((i+1)). ${timezones[$i]}"
    done

    read -p "Enter the number corresponding to your time zone: " selection
    if [[ $selection -gt 0 && $selection -le ${#timezones[@]} ]]; then
        selected_timezone="${timezones[$((selection-1))]}"
        echo "Setting time zone to $selected_timezone..."
        timedatectl set-timezone "$selected_timezone"
    else
        echo "Invalid selection. Please run the script again and select a valid number."
        exit 1
    fi
}

# Main script logic
echo "Checking internet connection..."

if check_internet; then
    echo "Internet connection detected. Syncing date and time..."

    # Prompt the user to select a timezone
    select_timezone

    # Sync system time from internet
    timedatectl set-ntp true
    timedatectl status | grep "NTP synchronized: yes" > /dev/null

    if [ $? -eq 0 ]; then
        echo "System time synchronized with internet."
    else
        echo "Failed to sync time from the internet."
    fi

    # Sync the hardware clock with system time
    sudo hwclock --systohc
    echo "Hardware clock updated to match system time."
else
    echo "No internet connection detected. Manual time entry required."

    # Prompt the user to enter the date and time manually
    read -p "Enter the date and time (YYYY-MM-DD HH:MM:SS): " user_entered_time

    # Set the system time manually
    sudo date -s "$user_entered_time"

    # Prompt the user to select a timezone
    select_timezone

    # Sync the hardware clock with the manually set system time
    sudo hwclock --systohc
    echo "System time and hardware clock set manually."
fi

# Exit successfully
exit 0