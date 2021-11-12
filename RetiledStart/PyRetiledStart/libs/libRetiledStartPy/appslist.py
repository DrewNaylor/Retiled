# libRetiledStartPy - Utility library for RetiledStart that allows me to
#                     keep the main code out of the UI code, like MVVM.
#                     This is a port of the VB.NET version to Python.
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
from ..libdotdesktop_py import desktopEntryStuff
# Stuff for getting the files from /usr/share/applications.
import os
from os.path import isfile, join

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
        # Get the ExecFilename split using shlex.split.
	args = desktopEntryStuff.getInfo(DotDesktopFilePath, "Exec", "", "", True)
	splitargs = shlex.split(args)
		# Now run the command.
		# TODO: Ensure the command is wrapped in quotes
		# if I already do that in my VB.NET library.
		# Actually, I'm not sure if I am, but that version
		# seems to do just fine when an Exec key lacks quotes
		# around the first part of the command, unlike this one
		# which says it can't find the file.
	proc = subprocess.Popen(splitargs)

def GetAppName(DotDesktopFilePath):
	# Gets the app's name using the libdotdesktop_py library.
	return desktopEntryStuff.getInfo(DotDesktopFilePath, "Name", DotDesktopFilePath, "", True)
	
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
	
	
	# Get the list of files from /usr/share/applications:
	# https://stackoverflow.com/a/3207973
	#DotDesktopFilesList = [file for file in listdir("C:\\Users\\drewn\Desktop") if isfile(join("C:\\Users\\drewn\Desktop", file))]
	#DotDesktopFilesList = [file for file in listdir("/usr/share/applications") if isfile(join("/usr/share/applications", file))]
	# Only put apps in the list if they're supposed to be shown.
	# Using the example from this answer:
	# https://stackoverflow.com/a/51850082
	
	# Specify root path.
	#DotDesktopRootPath = "C:\\Users\\drewn\Desktop"
	DotDesktopRootPath = "/usr/share/applications"
	
	# Specify the type of slash.
	slash = "/"
	#slash = "\\"
	
	# Use the filesystem encode thing to get the folder.
	FSEncodedFolder = os.fsencode(DotDesktopRootPath)
	
	# Create empty list that will be written to later.
	DotDesktopFilesList = []
	
	# Somehow I need to use a dictionary for this, and this answer seems reasonable:
	# https://stackoverflow.com/a/31182009
	
	# Loop through the files and add them to the list.
	for DotDesktopFile in os.listdir(FSEncodedFolder):
		DotDesktopFilename = os.fsdecode(DotDesktopFile)
		# Ensure only .desktop files are picked up.
		if DotDesktopFilename.endswith( (".desktop") ):
			# Make sure the .desktop file doesn't have NoDisplay = true.
			if not desktopEntryStuff.getInfo(DotDesktopRootPath + slash + DotDesktopFilename, "NoDisplay", "false", "", True) == "true":
				DotDesktopFilesList.append(DotDesktopFilename)
	
	# Not sure if splitting this is how to get things into the list.
	# Wait, no it can't be split because it's a list.
	# TODO: Make sure that .desktop files are supposed to be shown in the list
	# before adding them.
	#print(DotDesktopFilesList)
	
	# Now we make the .desktop file thing into a dictionary:
	# https://stackoverflow.com/a/31182009
	# There has to be a more efficient way to do this.
	# Define the dictionary.
	DotDesktopDictionary = []
	for DotDesktopFileEntry in DotDesktopFilesList:
		DotDesktopDictionaryEntry = {"FileNameProperty": DotDesktopFileEntry, "NameKeyValueProperty": desktopEntryStuff.getInfo(DotDesktopRootPath + slash + DotDesktopFilename, "Name", DotDesktopFileEntry, "", True)}
		DotDesktopDictionary.append(DotDesktopDictionaryEntry)
	
	# Sort the filenames.
	# TODO: I need to figure out how to sort the filenames based on the file's "Name" key.
	DotDesktopFilesList.sort()
	
	return DotDesktopFilesList
	
	
	
	
	
	