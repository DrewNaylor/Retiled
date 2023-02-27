#!/bin/sh

# install-retiled.sh - Install script for Retiled, 
#                      a Windows Phone 8.x-like "desktop" environment
#                      for (mainly) Linux phones. Will transition to being
#                      either a Plasma Mobile fork or an alternate layout
#                      for Plasma Mobile.
# Copyright (C) 2021, 2023 Drew Naylor
# (Note that the copyright years include the years left out by the hyphen.)
# Windows Phone and all other related copyrights and trademarks are property
# of Microsoft Corporation. All rights reserved.
#
# This file is a part of the Retiled project.
# Neither Retiled nor Drew Naylor are associated with Microsoft
# and Microsoft does not endorse Retiled.
# Any other copyrights and trademarks belong to their
# respective people and companies/organizations.
#
#
#   Licensed under the MIT License (the "License");
#   you may not use this file except in compliance with the License.
#
#       The MIT License (MIT)
#       Copyright (C) 2021, 2023 Drew Naylor
#
#       Permission is hereby granted, free of charge,
#       to any person obtaining a copy of this
#       software and associated documentation files
#       (the “Software”), to deal in the Software
#       without restriction, including without
#       limitation the rights to use, copy, modify,
#       merge, publish, distribute, sublicense,
#       and/or sell copies of the Software, and to
#       permit persons to whom the Software is
#       furnished to do so, subject to the following
#       conditions:
#
#       The above copyright notice and this permission
#       notice shall be included in all copies or
#       substantial portions of the Software.
#
#       THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT 
#       WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
#       INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#       OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
#       PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
#       THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
#       FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#       WHETHER IN AN ACTION OF CONTRACT, TORT OR
#       OTHERWISE, ARISING FROM, OUT OF OR IN
#       CONNECTION WITH THE SOFTWARE OR THE USE OR
#       OTHER DEALINGS IN THE SOFTWARE.

# CD into ./Scripts.
# I think it would be easier to require a manual cd into Scripts, so this is
# uncommented until I find out an easy way to check if we're in here or not.
#cd ./Scripts

# Run the build scripts.
sh ./build-retiledsearch.sh
sh ./build-retiledstart.sh

# We have to copy dirs recursively:
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

# Mark the scripts as executable.
chmod +x ./Scripts/run-retiledsearch.sh
chmod +x ./Scripts/run-retiledstart.sh

# Copy the scripts to run everything.
sudo cp -v ./Scripts/run-retiledsearch.sh /usr/bin/retiledsearch
sudo cp -v ./Scripts/run-retiledstart.sh /usr/bin/retiledstart

# Exit with code 0.
exit 0
