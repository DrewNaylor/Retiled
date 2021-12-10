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
mkdir -p ./test/opt/Retiled/RetiledStyles
# Make fonts dir.
mkdir -p ./test/opt/Retiled/fonts
# Make icons dir.
mkdir -p ./test/opt/Retiled/icons
# Make dirs for the programs themselves.
mkdir -p ./test/opt/Retiled/RetiledSearch
mkdir -p ./test/opt/Retiled/RetiledStart
# Make the directory for the .desktop files.
# This is only necessary during testing.
mkdir -p ./test/usr/share/applications
# Now we can copy stuff.
# Copy styles dir.
cp -rv ./RetiledStyles/* ./test/opt/Retiled/RetiledStyles
# Copy fonts dir.
cp -rv ./fonts/* ./test/opt/Retiled/fonts
# Copy icons.
cp -rv ./icons/* ./test/opt/Retiled/icons
# Now copy the programs.
cp -rv ./RetiledSearch/* ./test/opt/Retiled/RetiledSearch
cp -rv ./RetiledStart/* ./test/opt/Retiled/RetiledStart

# Copy the .desktop files.
cp -v .retiledsearch.desktop ./test/usr/share/applications
cp -v .retiledstart.desktop ./test/usr/share/applications

# Exit with code 0.
exit 0