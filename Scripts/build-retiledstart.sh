#!/bin/sh

# CD into the directory with the project.
cd ../RetiledStart/RetiledStart

# Start using compileall to build the Python scripts:
# https://docs.python.org/3/library/compileall.html
# https://stackoverflow.com/a/32686745
python3 -m compileall -l .

# CD into the libs folder.
cd ./libs

# Compile the stuff in here.
python3 -m compileall .

# Go back to the original dir.
cd ../../../Scripts

# Exit with code 0.
exit 0
