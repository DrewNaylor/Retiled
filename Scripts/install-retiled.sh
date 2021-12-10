#!/bin/sh

# Mark the build scripts as executable.
chmod +x ./build-retiledsearch.sh
chmod +x ./build-retiledstart.sh

# Run the build scripts.
./build-retiledsearch.sh
./build-retiledstart.sh