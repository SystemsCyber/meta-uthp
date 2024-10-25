#!/bin/bash

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Attempt to sync hardware clock to system clock
log_message "Attempting to sync hardware clock to system clock..."
if hwclock --hctosys; then
    log_message "Successfully synced hardware clock to system clock."
else
    log_message "Error syncing hardware clock to system clock. Trying system to hardware sync instead."

    # If hwclock --hctosys fails, try syncing system clock to hardware clock
    if hwclock --systohc; then
        log_message "Successfully synced system clock to hardware clock."
    else
        log_message "Error syncing system clock to hardware clock. Please check system time and hardware clock settings."
    fi
fi