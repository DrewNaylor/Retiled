# libdotdesktop_py - Get info from .desktop files for the DotDesktop4Win
# partial implementation of Freedesktop.org's Desktop Entry spec.
# This is a limited port of libdotdesktop_standard to Python.
# Copyright (C) 2021 Drew Naylor
# (Note that the copyright years include the years left out by the hyphen.)
#
# This file is a part of the DotDesktop4Win project.
# Neither DotDesktop4Win nor Drew Naylor are associated with Freedesktop.org.
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



import configparser

def getInfo(inputFile, keyToGet, fileName = "", IsCustomKey = False):
	# fileName and IsCustomKey are both optional.
	
	# Create a configparser to read the .desktop files.
	# We have to change some of the options to work with
	# only valid .desktop files by using options described
	# in the Python docs here:
	# https://docs.python.org/3/library/configparser.html#customizing-parser-behaviour
	# Turn off interpolation, too, since that interferes with fields.
	dotDesktopFileReader = configparser.ConfigParser(delimiters=('='), comment_prefixes=('#'), empty_lines_in_values=False, interpolation=None)
	
	# Now read the file into the dotDesktopFileReader.
	# Basing this off this page here:
	# https://www.tutorialspoint.com/how-to-read-a-text-file-in-python
	# I had a TODO here about escaping backslashes, but it just does that.
	# However, I do have to add one about removing extra quotes around
	# the file path:
	# TODO: Remove extra quotes around file paths if that's a problem,
	# such as when a user pastes in a file that was copied with
	# "Copy file as path" on Windows.
	# Actually, configparser has a read_file function:
	# https://docs.python.org/3/library/configparser.html#configparser.ConfigParser.read_file
	dotDesktopFile = open(inputFile, "r")
	dotDesktopFileReader.read_file(dotDesktopFile)
	# We can now close the file since it's in the configparser.
	dotDesktopFile.close()
	
	# Now print the sections for debugging.
	#print(dotDesktopFileReader.sections())
	
	# We need to specify that we'll use the Desktop Entry section.
	# Currently I don't know how to check if it exists or not.
	# Actually, this'll be done in the return part.
	
	# Python 3.10 has its own version of Select Case,
	# but it's not stable yet, though it will be on October 4, 2021,
	# which is the day after I'm writing this so I'll just
	# use if statements for now. More info here:
	# https://stackoverflow.com/a/66877137
	# For now I'm just using an if statement as detailed here:
	# https://stackoverflow.com/a/66886730
	if IsCustomKey == True:
		# Return the value of the key specified in keyToGet.
		# This works, I just have to remember to set IsCustomKey = True
		# for anything I haven't implemented yet.
		return dotDesktopFileReader.get('Desktop Entry', keyToGet)
		