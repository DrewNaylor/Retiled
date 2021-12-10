#!/bin/sh

# Run the build scripts.
sh ./build-retiledsearch.sh
sh ./build-retiledstart.sh

# Copy the files to a test directory so we can check this works:
# https://stackoverflow.com/a/12376647
cd ..
cp ./RetiledSearch ./test/RetiledSearch
cp ./RetiledStyles ./test/RetiledStyles
cp ./RetiledStart ./test/RetiledStart

# Exit with code 0.
exit 0