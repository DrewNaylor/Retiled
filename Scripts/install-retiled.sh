#!/bin/sh

# Run the build scripts.
sh ./build-retiledsearch.sh
sh ./build-retiledstart.sh

# Copy the files to a test directory so we can check this works:
# https://stackoverflow.com/a/12376647
# We have to do this recursively:
# https://www.decodingdevops.com/copy-directory-in-linux-recursive-copy-in-linux/
cd ..
cp -rv ./RetiledSearch/* ./test/RetiledSearch
cp -rv ./RetiledStyles/* ./test/RetiledStyles
cp -rv ./RetiledStart/* ./test/RetiledStart

# Exit with code 0.
exit 0