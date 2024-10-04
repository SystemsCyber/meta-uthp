#!/bin/bash
# Install PRU common files
if ! id | grep -q root; then
        echo "must be run as root"
        exit
fi
# Link to support package
TI=/usr/lib/ti
SUP=pru-software-support-package
if [ ! -d "$TI/$SUP" ]; then
        echo "Installing $TI/$SUP"
        SRC=`pwd`
        cd $TI
        ln -s $TI/${SUP}-v6.0 $TI/$SUP
        cd $SRC
fi
