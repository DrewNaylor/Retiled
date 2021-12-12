#!/bin/sh

# Just delete the /opt/Retiled dir for now.
# TODO: Properly uninstall and don't delete anything I didn't add.
sudo rm -rf /opt/Retiled

# Delete the .desktop files we installed.
sudo rm -f /usr/share/applications/retiledsearch.desktop
sudo rm -f /usr/share/applications/retiledstart.desktop

# Delete the scripts.
sudo rm -f /usr/bin/retiledsearch
sudo rm -f /usr/bin/retiledstart

# Exit with code 0.
exit 0