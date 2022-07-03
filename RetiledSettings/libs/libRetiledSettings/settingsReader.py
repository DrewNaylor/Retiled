# libRetiledSettings - Utility library for Retiled that works with settings.
#                      This file is used for reading settings from config files.
# Copyright (C) 2022 Drew Naylor
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




# configparser is used as the .config file reader.
import configparser
from os.path import exists

def getInfo(inputFile, keyToGet, defaultValue, fileName = "", IsCustomKey = False):
	# fileName and IsCustomKey are both optional.

	# Check if the path exists first to prevent using
	# extra memory to create the config parser if we don't have to:
	# https://stackoverflow.com/a/8933290
	if not exists(inputFile):
		# Return the default value if the file doesn't exist.
		# This should prevent issues at runtime.
		return defaultValue
	else:
	
	# Create a configparser to read the .config files.
	# We have to change some of the options to work with
	# only valid .config files by using options described
	# in the Python docs here:
	# https://docs.python.org/3/library/configparser.html#customizing-parser-behaviour
	# Turn off interpolation, too, since that interferes with fields.
	# "Strict" is on because these files shouldn't have multiple keys.
		settingsFileReader = configparser.ConfigParser(delimiters=('='), comment_prefixes=('#'), empty_lines_in_values=False, interpolation=None)
	
	# Now read the file into the settingsFileReader.
	# Basing this off this page here:
	# https://www.tutorialspoint.com/how-to-read-a-text-file-in-python
	# I had a TODO here about escaping backslashes, but it just does that.
	# Actually, configparser has a read_file function:
	# https://docs.python.org/3/library/configparser.html#configparser.ConfigParser.read_file
	# For some reason, I had to start specifying the encoding as UTF-8
	# as of July 2, 2022, at least for Python on Windows. Not sure about
	# any other platforms. I don't know why it broke suddenly.
	# More info here:
	# https://stackoverflow.com/a/42070962
		settingsFile = open(inputFile, "r", encoding='utf-8')
		settingsFileReader.read_file(settingsFile)
	# We can now close the file since it's in the configparser.
		settingsFile.close()
	
	# Now print the sections for debugging.
	#print(settingsFileReader.sections())
	
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
	# TODO: Change to using Python's Select Case statements, it's almost been
	# a year.
		if IsCustomKey == True:
		# Return the value of the key specified in keyToGet.
		# This works, I just have to remember to set IsCustomKey = True
		# for anything I haven't implemented yet.
		# Make sure the key is in the file and return the default
		# if it's not:
		# https://stackoverflow.com/a/21057828
			if settingsFileReader.has_option('ThemeSettings', keyToGet):		
				return settingsFileReader.get('ThemeSettings', keyToGet)
			else:
				return defaultValue
			