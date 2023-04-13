# libdotdesktop_py - Get info from .desktop files for the DotDesktop4Win
# partial implementation of Freedesktop.org's Desktop Entry spec.
# This is a limited port of libdotdesktop_standard to Python.
# Copyright (C) 2021-2023 Drew Naylor
# (Note that the copyright years include the years left out by the hyphen.)
#
# This file is a part of the DotDesktop4Win project.
# Neither DotDesktop4Win nor Drew Naylor are associated with Freedesktop.org.
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



# configparser is used as the .desktop file reader.
import configparser
# Regex.
# Commented out because I couldn't get it to work,
# so I just used string replacement instead.
#import re
import shlex
from os.path import exists

def getInfo(inputFile, keyToGet, defaultValue, fileName = "", IsCustomKey = False):
	# fileName and IsCustomKey are both optional.

	# Check if the path exists first to prevent using
	# extra memory to create the config parser if we don't have to:
	# https://stackoverflow.com/a/8933290
	if not exists(inputFile):
		# Return the path if it doesn't exist, mostly
		# in the case of getting the name.
		# TODO: Change this to return different defaults
		# other than the one for the name.
		return inputFile
	else:
	
	# Create a configparser to read the .desktop files.
	# We have to change some of the options to work with
	# only valid .desktop files by using options described
	# in the Python docs here:
	# https://docs.python.org/3/library/configparser.html#customizing-parser-behaviour
	# Turn off interpolation, too, since that interferes with fields.
	# "Strict" has to be off as some .desktop files have duplicate keys,
	# most notably GNOME/Phosh Settings has several "X-Purism-FormFactor"
	# keys, all with the same values.
		dotDesktopFileReader = configparser.ConfigParser(delimiters=('='), comment_prefixes=('#'), empty_lines_in_values=False, interpolation=None, strict=False)
	
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
	# For some reason, I had to start specifying the encoding as UTF-8
	# as of July 2, 2022, at least for Python on Windows. Not sure about
	# any other platforms. I don't know why it broke suddenly.
	# More info here:
	# https://stackoverflow.com/a/42070962
		dotDesktopFile = open(inputFile, "r", encoding='utf-8')
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
	# TODO: Change to using Python's Select Case statements, it's almost been
	# a year.
		if IsCustomKey == True:
		# Return the value of the key specified in keyToGet.
		# This works, I just have to remember to set IsCustomKey = True
		# for anything I haven't implemented yet.
		# Make sure the key is in the file and return the default
		# if it's not:
		# https://stackoverflow.com/a/21057828
			if dotDesktopFileReader.has_option('Desktop Entry', keyToGet):		
				return dotDesktopFileReader.get('Desktop Entry', keyToGet)
			else:
				return defaultValue
			
			
			
def cleanExecKey(inputFile):
	# Clean up the exec key by removing flags.
	# Currently assuming everything is an app,
	# but support for links and urls will be added,
	# as will checking to ensure the file is a valid
	# .desktop file.
	
	# Load exec key.
	cleanedExecKey = getInfo(inputFile, "Exec", "", "", True)
	
	#print(cleanedExecKey)
	
	# Begin cleaning the key.
	# %d is deprecated.
	cleanedExecKey = regexReplaceFlags(cleanedExecKey, "%d", "")
	# %D is deprecated.
	cleanedExecKey = regexReplaceFlags(cleanedExecKey, "%D", "")
	# %n is deprecated.
	cleanedExecKey = regexReplaceFlags(cleanedExecKey, "%n", "")
	# %N is deprecated.
	cleanedExecKey = regexReplaceFlags(cleanedExecKey, "%N", "")
	# %v is deprecated.
	cleanedExecKey = regexReplaceFlags(cleanedExecKey, "%v", "")
	# %m is deprecated.
	cleanedExecKey = regexReplaceFlags(cleanedExecKey, "%m", "")
	
	# Clean up other flags that aren't supported by the Python port.
	cleanedExecKey = regexReplaceFlags(cleanedExecKey, "%u", "")
	cleanedExecKey = regexReplaceFlags(cleanedExecKey, "%U", "")
	cleanedExecKey = regexReplaceFlags(cleanedExecKey, "%f", "")
	cleanedExecKey = regexReplaceFlags(cleanedExecKey, "%F", "")
	
	# Other flags that aren't implemented yet.
	# TODO: Implement passing the localized Name key value, if it exists (%c)
	cleanedExecKey = regexReplaceFlags(cleanedExecKey, "%c", "")
	# TODO: Implement passing the Icon key value, if it exists (%i, expanded to "--icon icon-key-value-here")
	cleanedExecKey = regexReplaceFlags(cleanedExecKey, "%i", "")
	# TODO: Implement passing %k for "The location of the desktop file as either a URI (if for example
	#       gotten from the vfolder system) or a local filename or empty if no location is known." - Desktop Entry Spec Exec key page
	cleanedExecKey = regexReplaceFlags(cleanedExecKey, "%k", "")

	# Now back to a list.
	
	cleanedExecKeyList = shlex.split(cleanedExecKey)
	
	# TODO: Expand environment variables.
	#print(cleanedExecKeyList)
	# Return the cleaned key.
	return cleanedExecKeyList



def regexReplaceFlags(input, flag, desiredReplacement, caseSensitive = True):
	# Code for replacing flags using regex.
	# Python docs page:
	# https://docs.python.org/3/howto/regex.html
	# This is used when launching apps to clean their Exec keys.
	# Ported from the VB.NET version.
	# Couldn't get regex to work, so I just used string replacement
	# instead.
	# Original comment:
		# Replaces flags in the style of %u with a string using regex.
		# First we need to create a regular expression to match what'll
		# be replaced.
		# \s+ is for whitespace before the flag.
		# \b is for the word border at the end.
		# This can be used with flags/environment variables
		# that end with a percent sign.
		# The case-sensitive if statement may need to be cleaned up a bit.
			
	# Hold the regex in a string for now:
	if input.__contains__(flag):
		#tempRegex = r"\s+" + flag + "\b"
	
		#if flag.endswith("%"):
		# Check if the flag ends with a percent sign and change
		# the regex if necessary so it matches the flag later.
		# Maybe I should keep the "\s+" part in there.
		# Noticed that it wasn't in the original code.
			#tempRegex = flag.rstrip("%") + "\b%"
	
		if caseSensitive == False:
		# If case-insensitivity is fine for this
		# flag, have the regex thing ignore case.
			#regexThing = re.compile(tempRegex, re.IGNORECASE)
		# Replace the flag.
		# IMPORTANT: You must remember to add the target string so
		# the replacement works.
		# Info from this page:
		# https://pynative.com/python-regex-replace-re-sub/
			#regexedString = regexThing.sub(desiredReplacement, input)
			regexedString = input.replace(flag, desiredReplacement)
			#print(regexedString)
			return regexedString
		else:
		# Otherwise, don't ignore case.
			#regexThing = re.compile(tempRegex)
		# Now for the replacement.
		# IMPORTANT: You must remember to add the target string so
		# the replacement works.
			#regexedString = regexThing.sub(desiredReplacement, input)
			regexedString = input.replace(flag, desiredReplacement)
			#print(regexedString)
			return regexedString
	else:
		return input
			
			
