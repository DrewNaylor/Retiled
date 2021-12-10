#!/bin/sh

# Go up one level so we can access the ./test dir.
cd ..

# Just delete the ./test dir for now.
# TODO: Properly uninstall and don't delete anything I didn't add.
sudo rm -rf /opt/Retiled

# Exit with code 0.
exit 0