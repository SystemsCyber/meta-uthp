#!/bin/bash

# Define the symlink path and target
SYMLINK="/usr/lib/python3.12/site-packages/rpds/rpds.so"
TARGET="/usr/lib/python3.12/site-packages/rpds/rpds.cpython-312-armv7l-linux-gnueabihf.so"

# Check if the symlink exists
if [ -L "$SYMLINK" ]; then
    echo "Symlink $SYMLINK already exists. No action taken."
else
    # Create the symlink if it doesn't exist
    ln -s "$TARGET" "$SYMLINK"
    echo "Created symlink $SYMLINK -> $TARGET"
fi