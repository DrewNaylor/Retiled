#!/bin/sh

# Run the build scripts.
sh ./build-retiledsearch.sh
sh ./build-retiledstart.sh

# Copy the files to a test directory so we can check this works:
# https://stackoverflow.com/a/12376647
# We have to do this recursively:
# https://www.decodingdevops.com/copy-directory-in-linux-recursive-copy-in-linux/
cd ..
# Make directories first.
# We have to use "-p" to make missing intermediate dirs:
# https://unix.stackexchange.com/a/588680
# TODO: Make sure they don't exist before creating them.
# Make styles dir.
sudo mkdir -p /opt/Retiled/RetiledStyles
# Make fonts dir.
sudo mkdir -p /opt/Retiled/fonts
# Make icons dir.
sudo mkdir -p /opt/Retiled/icons
# Make dirs for the programs themselves.
sudo mkdir -p /opt/Retiled/RetiledSearch
sudo mkdir -p /opt/Retiled/RetiledStart
# Now we can copy stuff.
# Copy styles dir.
sudo cp -rv ./RetiledStyles/* /opt/Retiled/RetiledStyles
# Copy fonts dir.
sudo cp -rv ./fonts/* /opt/Retiled/fonts
# Copy icons.
sudo cp -rv ./icons/* /opt/Retiled/icons
# Now copy the programs.
sudo cp -rv ./RetiledSearch/* /opt/Retiled/RetiledSearch
sudo cp -rv ./RetiledStart/* /opt/Retiled/RetiledStart

# Copy the .desktop files.
sudo cp -v ./Scripts/retiledsearch.desktop /usr/share/applications
sudo cp -v ./Scripts/retiledstart.desktop /usr/share/applications

# Copy the scripts to run everything.
sudo cp -v ./Scripts/run-retiledsearch.sh /opt/Retiled
sudo cp -v ./Scripts/run-retiledstart.sh /opt/Retiled

# Exit with code 0.
exit 0