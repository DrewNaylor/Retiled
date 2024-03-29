# libRetiledStartPy - Utility library for RetiledStart that allows me to
#                     keep the main code out of the UI code, like MVVM.
#                     This is a port of the VB.NET version to Python.
# Copyright (C) 2021-2023 Drew Naylor
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
#       Copyright (C) 2021-2023 Drew Naylor
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

import sys
import subprocess
from ..libdotdesktop_py import desktopEntryStuff
# Stuff for getting the files from /usr/share/applications.
import os

# Python allows relative imports as used above:
# https://stackoverflow.com/a/714647

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
def RunApp(DotDesktopFilePath):
        # Clean the exec key.
	args = desktopEntryStuff.cleanExecKey(DotDesktopFilePath)
	#print("Split: ")
	#print(args)
		# Now run the command.
		# TODO: Ensure the command is wrapped in quotes
		# if I already do that in my VB.NET library.
		# Actually, I'm not sure if I am, but that version
		# seems to do just fine when an Exec key lacks quotes
		# around the first part of the command, unlike this one
		# which says it can't find the file.
	proc = subprocess.Popen(args)

def GetAppName(DotDesktopFilePath):
	# Gets the app's name using the libdotdesktop_py library.
	# This is different on Windows for debugging purposes.
	# Example code for sys.platform:
	# https://docs.python.org/3/library/sys.html#sys.platform
	# You can use "".join() to concatenate strings directly together
	# with nothing between them, just as you would with "+", except
	# there's less memory usage since we're not creating strings
	# constantly.
	if sys.platform.startswith("win32"):
		return desktopEntryStuff.getInfo("".join(["C:\\Users\\Drew\\Desktop\\", DotDesktopFilePath]), "Name", DotDesktopFilePath, "", True)
		#return desktopEntryStuff.getInfo("".join(["C:\\Users\\drewn\\Desktop\\", DotDesktopFilePath]), "Name", DotDesktopFilePath, "", True)
	else:
		return desktopEntryStuff.getInfo("".join(["/usr/share/applications/", DotDesktopFilePath]), "Name", DotDesktopFilePath, "", True)
	
def getDotDesktopFiles():
	# Gets the list of .desktop files and creates a list of objects
	# of type DotDesktopEntryInAllAppsList that can be put into QML
	# after being ordered by name. The DotDesktopEntryInAllAppsList
	# type is a class, and that class has two properties:
	# FileNameProperty, which is the .desktop file path, and
	# NameKeyValueProperty, which stores the "Name" key value
	# to display the app's name in the All Apps list.
	# The FileNameProperty will be used to launch the apps by
	# passing it to desktopEntryStuff.getInfo.
	# Note: This description may be outdated as I'm currently
	# not using properties for the items, and just using a dictionary.
	
	
	# Get the list of files from /usr/share/applications:
	# https://stackoverflow.com/a/3207973
	# Only put apps in the list if they're supposed to be shown.
	# Using the example from this answer:
	# https://stackoverflow.com/a/51850082
	
	# Specify root path and slash.
	# This is different on Windows for debugging purposes.
	# Example code for sys.platform:
	# https://docs.python.org/3/library/sys.html#sys.platform
	if sys.platform.startswith("win32"):
		#DotDesktopRootPath = "C:\\Users\\drewn\\Desktop"
		DotDesktopRootPath = "C:\\Users\\Drew\\Desktop"
		slash = "\\"
	else:
		DotDesktopRootPath = "/usr/share/applications"
		slash = "/"
		
	# Use the filesystem encode thing to get the folder.
	FSEncodedFolder = os.fsencode(DotDesktopRootPath)
	
	# Create empty list that will be written to later.
	DotDesktopFilesList = []
	
	# Loop through the files and add them to the list.
	for DotDesktopFile in os.listdir(FSEncodedFolder):
		DotDesktopFilename = os.fsdecode(DotDesktopFile)
		# Ensure only .desktop files are picked up.
		if DotDesktopFilename.endswith( (".desktop") ):
			# Make sure the .desktop file doesn't have NoDisplay = true.
			# Concatenate using the ".join" method instead of a "+"
			# to save memory, as otherwise a new string would be created
			# every time a string is concatenated with another.
			# As we're in a loop, that would be a lot of extra memory wasted.
			# I do the same thing when sorting the list below.
			if not desktopEntryStuff.getInfo(slash.join([DotDesktopRootPath, DotDesktopFilename]), "NoDisplay", "false", "", True) == "true":
				DotDesktopFilesList.append(DotDesktopFilename)

	# Put it back into a list because I don't know how to
	# use dictionaries with QML listview models yet.
	# Example here:
	# https://pythonexamples.org/python-dictionary-values-to-list/#4
	# This example may work better:
	# https://tutorial.eyehunts.com/python/python-add-to-dict-in-a-loop-adding-item-to-dictionary-within-loop-example/
	SortedDotDesktopFilesList = {}
	# This is going through the items in the DotDesktopFilesList and adding items to a dictionary by getting the
	# name from the .desktop file's "Name" key. If the "Name" key doesn't exist, it just uses the filename.
	for i in range(len(DotDesktopFilesList)):
		SortedDotDesktopFilesList[DotDesktopFilesList[i]] = desktopEntryStuff.getInfo(slash.join([DotDesktopRootPath, DotDesktopFilesList[i]]), "Name", DotDesktopFilesList[i], "", True)
	
	# Now we can sort the dictionary by values.
	# I think the filename sorting above will be
	# unnecessary with this, and it'll be removed.
	# Example from here:
	# https://www.30secondsofcode.org/python/s/sort-dict-by-value
	# This needs case-folding to ensure things are where they're
	# supposed to be:
	# https://stackoverflow.com/a/57923460
	# Note that the ".casefold()" has to be after the x[1] or it won't work.
	# Shorter example: "...key = lambda x: x[1].casefold()..."
	# If it's in the wrong spot, it might say "Error: 'tuple' object has no attribute 'casefold'"
	SortedDotDesktopFilesList = dict(sorted(SortedDotDesktopFilesList.items(), key = lambda x: x[1].casefold()))
	
	# Return a list for now, as using a dictionary may take longer to hook up:
	# https://www.tutorialspoint.com/How-to-get-a-list-of-all-the-keys-from-a-Python-dictionary
	# Maybe I can just re-use the old list instead of creating a new one.
	DotDesktopFilesList = [key for key in SortedDotDesktopFilesList]
	
	return DotDesktopFilesList
