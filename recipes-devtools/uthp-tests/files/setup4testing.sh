#!/bin/bash

# This script is used to setup the environment for testing the UTHP on real hardware.

read -p "Are you connected to the Cascadia CAN bus and the Brake Board? (y/n) " -n 1 -r

if [[ $REPLY =~ ^[Nn]$ ]]
then
    echo "Please connect to the Cascadia CAN bus and the Brake Board before running the tests."
    exit 1
else
    echo "Setting up the environment for testing the UTHP..."
    echo "Setting up the CAN interface..."
    sudo ip link set can0 down
    sudo ip link set can0 type can bitrate 500000
    sudo ip link set up can0
    echo "Setting up the Brake Board..."
    sudo systemctl start j17084truckduck.service
    echo "Environment setup complete."
fi