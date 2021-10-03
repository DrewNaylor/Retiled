# libRetiledStart - Utility library for RetiledStart that allows me to
#                   keep the main code out of the UI code, like MVVM.
# Copyright (C) 2021 Drew Naylor
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
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

import shlex
import subprocess

# Trying to create a class and library similar to this one:
# https://codeigo.com/python/import-class-from-another-file-and-directory
# I'm also trying to make a thing that'll run apps based on the Python docs:
# https://docs.python.org/3/library/subprocess.html#popen-constructor
#class AppsList(object):
    # We have to do an __init__ thing:
	# https://careerkarma.com/blog/python-missing-required-positional-argument-self/
    #def init(self, ExecFilename):
        #self.ExecFilename = ExecFilename

# At least this works at all.
# TODO: Figure out how to use this with a class so that
# the code can be cleaner.
def RunApp(ExecFilename):
        # Get the ExecFilename split using shlex.split.
    args = ExecFilename
    splitargs = shlex.split(args)
		# Now run the command.
		# TODO: Ensure the command is wrapped in quotes
		# if I already do that in my VB.NET library.
    proc = subprocess.Popen(splitargs)