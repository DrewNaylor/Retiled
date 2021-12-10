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
mkdir -p ./test/RetiledStyles
mkdir -p ./test/RetiledSearch
mkdir -p ./test/RetiledStart
# Now we can copy stuff.
cp -rv ./RetiledStyles/* ./test/RetiledStyles
cp -rv ./RetiledSearch/* ./test/RetiledSearch
cp -rv ./RetiledStart/* ./test/RetiledStart

# Exit with code 0.
exit 0