#!/bin/sh

# CD into the directory with the project.
cd ../RetiledSearch/RetiledSearch

# Start using compileall to build the Python scripts:
# https://docs.python.org/3/library/compileall.html
# https://stackoverflow.com/a/32686745
python -m compileall -l .

# Go back to the original dir.
cd ../../Scripts

# Exit with code 0.
exit 0