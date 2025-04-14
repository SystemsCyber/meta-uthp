#!/bin/bash
## This script generates a hashed password for the pre-production image of the UTHP based on the YOCTO project's expected password input
read -p "Please enter the password: " password
hashed_password=$(openssl passwd -6 $password)
# escape the $ characters
escaped_password=$(echo $hashed_password | sed 's/\$/\\$/g')
# output the escaped hashed password
echo "Copy this to meta-uthp/recipes-core/images/core-image*.bb: "
echo $escaped_password
