#!/bin/sh

# build-retiledsearch.sh - Build script for RetiledSearch, an app meant as part of Retiled and will be like the Bing Search app on Windows Phone. 
#                          Retiled is a Windows Phone 8.x-like "desktop" environment
#                          for (mainly) Linux phones. Will transition to being
#                          either a Plasma Mobile fork or an alternate layout
#                          for Plasma Mobile.
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
