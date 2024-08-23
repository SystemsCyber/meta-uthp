#!/bin/bash
### BEGIN INIT INFO
# Provides:          change_home_permissions
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3
# Default-Stop:      0 1
# Short-Description: Change /home/uthp ownership to uthp
# Description:       Ensures /home/uthp directory has correct permissions
### END INIT INFO

# Path to the home directory
HOME_DIR="/home/uthp"

# Change ownership of the home directory
chown -R uthp:uthp "$HOME_DIR"

echo "Changed ownership of $HOME_DIR to uthp:uthp"