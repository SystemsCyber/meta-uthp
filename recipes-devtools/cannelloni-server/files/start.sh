#!/bin/bash

# Configuration file (sourced)
CONFIG_FILE="/opt/scripts/cannelloni-server/cannelloni-server.conf"

if [[ -f "$CONFIG_FILE" ]]; then
    source $CONFIG_FILE
fi

if [[ -z "$REMOTE_IP" ]]; then
    REMOTE_IP="127.0.0.1"
fi
if [[ -z "$REMOTE_PORT" ]]; then
    REMOTE_PORT="20000"
fi
if [[ -z "$CAN_INTERFACE" ]]; then
    CAN_INTERFACE="vcan0"
fi

/usr/bin/cannelloni -R $REMOTE_IP -r $REMOTE_PORT -I $CAN_INTERFACE