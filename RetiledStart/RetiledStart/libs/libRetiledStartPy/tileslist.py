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



import os
import sys
import json
import yaml
from yaml.loader import SafeLoader
# We need a few things from the appslist file,
# mainly the code for launching apps.
# I don't want to duplicate it, but maybe
# it could be moved to retiledstartcommon.py,
# or something.
from . import appslist as AppsList


def saveTilesList(tilesList):
	# Saves the list of tiles to the config file.
	# I don't know how to delete sections from the file yet,
	# so I'm just writing it all back. This might delete comments
	# unless there's a way to preserve them.
	# First ensure there are differences between the new tiles
	# list and the one that's currently saved, so that
	# unnecessary writes are avoided to prevent damaging
	# the eMMC on users' phones.
	# Need to turn off sorting with "sort_keys=False":
	# https://github.com/yaml/pyyaml/issues/110#issuecomment-500921155
	
	# Define a list we'll use to store the dictionary in.
	TilesListToSave = []
	
	# Loop through the list of dictionaries and append to
	# the list using what's in each dictionary.
	# Context for how we're getting the items appended:
	# https://stackoverflow.com/q/37758665
	# Perhaps this will work better:
	# https://stackoverflow.com/a/10856270
	for i in tilesList:
		# tile = StartScreenTileEntry(i["DotDesktopFilePath"], i["TileWidth"], i["TileHeight"], i["TileColor"])
		# print(tile.DotDesktopFilePath)
		# Add to the TilesListToSave.
		# NOTE: QML won't give us integers for tile widths and heights,
		# so we need to make them into integers in Python.
		TilesListToSave.append({"DotDesktopFilePath": i["DotDesktopFilePath"], "TileSize": i["TileSize"]})
		# print(i["DotDesktopFilePath"])
		
	#print(TilesListToSave)
	
	# Now we can check if the list is the same as getTilesList().
	if not json.dumps(TilesListToSave) == getTilesList():
	
		# Append the start layout schema version.
		# We need to create a new list first, one that
		# has both the "Tiles:" thing, too.
		StartLayoutConfigFile = {"Tiles": TilesListToSave, "StartLayoutSchemaVersion": 0.2}
	
		# Load the tilesList as if it were a yaml file.
		# Be sure to not have it sort the keys:
		# https://stackoverflow.com/a/55171433
		yamlifiedTiles = yaml.dump(StartLayoutConfigFile, sort_keys=False)
	
		# print(yamlifiedTiles)
		
		# We can now save the file:
		# https://www.w3schools.com/python/python_file_write.asp
		# We need "w+" to create the file if it doesn't exist:
		# https://stackoverflow.com/a/2967249
		# First check which OS we're running on, and set
		# the storage location appropriately.
		# Expand the user's home directory:
		# https://www.tutorialspoint.com/How-to-find-the-real-user-home-directory-using-Python
		# Using "".join to reduce memory usage, as string concatenation with "+" creates new
		# strings each time.
		ModifiedStartLayoutYamlBaseFilePath = "".join([os.path.expanduser("~"), "/.config/Retiled/RetiledStart/"])
		if sys.platform.startswith("win32"):
			# Set it to the same directory as the library
			# if we're running on Windows, because this
			# makes it easier for development.
			ModifiedStartLayoutYamlBaseFilePath = "".join([os.getcwd(), "/libs/libRetiledStartPy/"])
			
		# Create the directory if it doesn't exist:
		# https://www.tutorialspoint.com/How-can-I-create-a-directory-if-it-does-not-exist-using-Python
		if not os.path.exists(ModifiedStartLayoutYamlBaseFilePath):
			os.makedirs(ModifiedStartLayoutYamlBaseFilePath)
		
		with open("".join([ModifiedStartLayoutYamlBaseFilePath, "startlayout-modified.yaml"]), "w+", encoding="utf-8") as ModifiedStartLayoutYamlFile:
			ModifiedStartLayoutYamlFile.write(yamlifiedTiles)
	

def getTilesList():
	# Gets the list of tiles that should be shown on Start.
	
	# Check whether the modified tiles list exists, and use
	# the built-in one if it doesn't.
	# First set the built-in path.
	StartLayoutFilePath = "".join([os.getcwd(), "/libs/libRetiledStartPy/startlayout.yaml"])
	# Didn't know how to check if a file existed off the top of my head:
	# https://www.pythontutorial.net/python-basics/python-check-if-file-exists/
	# We can now check if we're running on Windows.
	if sys.platform.startswith("win32"):
		if os.path.exists("".join([os.getcwd(), "/libs/libRetiledStartPy/startlayout-modified.yaml"])):
			StartLayoutFilePath = "".join([os.getcwd(), "/libs/libRetiledStartPy/startlayout-modified.yaml"])
	else:
		if os.path.exists("".join([os.path.expanduser("~"), "/.config/Retiled/RetiledStart/startlayout-modified.yaml"])):
			StartLayoutFilePath = "".join([os.path.expanduser("~"), "/.config/Retiled/RetiledStart/startlayout-modified.yaml"])
	
	# Define list to store the tiles.
	TilesList = []
	
	# Load the file.
	# TODO: Change to using "with" for the .desktop file reader code.
	# "encoding='utf-8'" is necessary or Python will give a UnicodeDecodeError as described here:
	# https://stackoverflow.com/a/42495690
	with open(StartLayoutFilePath, "r", encoding="utf-8") as StartLayoutYamlFile:
	
		# Output the file.
		#print(StartLayoutYamlFile.read())
		#print(yaml.safe_load(StartLayoutYamlFile))
	
		# Here's some stuff on using PyYAML. It's partially being used here:
		# https://pynative.com/python-yaml/
	
		# Load the file into a YAML reader.
		#YamlFile = StartScreenLayoutRoot(yaml.safe_load(StartLayoutYamlFile))
		YamlFile = yaml.safe_load(StartLayoutYamlFile)
		
		# Now we can refer to the items in the file by their names!
		#print(YamlFile.StartLayoutSchemaVersion)
		# You can now know their names.
		#print(YamlFile.Tiles[0].DotDesktopFilePath)

		# Create a variable for TileSize to access in the loop.
		#tempTileSize = "medium"
		
		# Loop through the Tiles items and add them to the TilesList.
		# We'll use the looping through index numbers example here:
		# https://www.w3schools.com/python/python_lists_loop.asp
		#for i in range(len(YamlFile.Tiles)):
		#print(YamlFile)

		for i in YamlFile["Tiles"]:
			#print(YamlFile.Tiles[i].TileColor)
			# We need to know if the config file has the deprecated
			# raw values of width and height.
			# This is used when saving the config file, so that we'll
			# manually save it and ignore the eMMC safety thing,
			# otherwise we won't know if we're supposed to save or not,
			# and that would be bad once we remove this feature.
			hasDeprecatedRawWidthAndHeight = False
			# Only add the tile to the list if the .desktop file path
			# key is longer than 0, which will break everything.
			# First assign the variable so we don't have to read it multiple times.
			tempDotDesktopFilePath = i.get("DotDesktopFilePath")
			if ((not tempDotDesktopFilePath == None) and (len(tempDotDesktopFilePath) > 0)):
				if ((not i.get("TileWidth") == None) or (not i.get("TileHeight") == None)) and (i.get("TileSize") == None):
					print("RetiledStart: Specifying TileWidth or TileHeight is deprecated in v0.1-DP2. It's replaced by TileSize and will be removed in v0.1-DP3.")
					print("RetiledStart: For now we'll still load TileWidth and TileHeight, but they'll be converted to TileSize at runtime and when saving tile layout.")
					print("RetiledStart: Valid values for TileSize include: small, medium, and wide.")
					print("RetiledStart: A future version will add back in custom sizes via columns and rows when TilesGrid is integrated.")
					print("RetiledStart: Affected tile's .desktop file: " + tempDotDesktopFilePath)
					print("\r")
					# The config file is manually setting height and width,
					# and we need to know that.
					hasDeprecatedRawWidthAndHeight = True
				# Temporary value for tempFileSize so we can grab it later.
				tempTileSize = "medium"
				# We have to use .get:
				# https://stackoverflow.com/a/9285135
				if (i.get("TileSize")) == None:
					if (i.get("TileWidth") == int(310) and i.get("TileHeight") == int(150)):
						tempTileSize = "wide"
					elif (i.get("TileWidth") == int(70) and i.get("TileHeight") == int(70)):
						tempTileSize = "small"
					else:
						tempTileSize = "medium"
				else:
					tempTileSize = i["TileSize"]
				#print(tempTileSize)
				if (hasDeprecatedRawWidthAndHeight == True):
					TilesList.append({"DotDesktopFilePath": tempDotDesktopFilePath, "TileSize": tempTileSize, "hasDeprecatedRawWidthAndHeight" : "True"})
				else:
					TilesList.append({"DotDesktopFilePath": tempDotDesktopFilePath, "TileSize": tempTileSize})
		
		# Get the stuff under Tiles.
	
	
	# Hard-code the tiles for now to make sure this'll work
	# without having to do everything first.
	# Adding dictionaries to list from here:
	# https://codeigo.com/python/add-dictionary-to-a-list
	# TilesList.append({"DotDesktopPath": "/usr/share/applications/firefox.desktop", "TileAppNameAreaText": "Firefox", "TileWidth": 150, "TileHeight": 150, "TileColor": "#0050ef"})
	# TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.angelfish.desktop", "TileAppNameAreaText": "Angelfish", "TileWidth": 150, "TileHeight": 150, "TileColor": "#0050ef"})
	# TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.index.desktop", "TileAppNameAreaText": "Index", "TileWidth": 310, "TileHeight": 150, "TileColor": "#0050ef"})
	# TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.discover.desktop", "TileAppNameAreaText": "Discover", "TileWidth": 150, "TileHeight": 150, "TileColor": "#0050ef"})
	# TilesList.append({"DotDesktopPath": "/usr/share/applications/htop.desktop", "TileAppNameAreaText": "Htop", "TileWidth": 70, "TileHeight": 70, "TileColor": "#0050ef"})
	# TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.kalk.desktop", "TileAppNameAreaText": "Calculator", "TileWidth": 70, "TileHeight": 70, "TileColor": "#0050ef"})
	# TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.nota.desktop",  "TileAppNameAreaText": "Nota", "TileWidth": 70, "TileHeight": 70, "TileColor": "#0050ef"})
	# TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.phone.dialer.desktop",  "TileAppNameAreaText": "Phone", "TileWidth": 70, "TileHeight": 70, "TileColor": "Red"})
	# TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.okular.desktop",  "TileAppNameAreaText": "Okular", "TileWidth": 150, "TileHeight": 150, "TileColor": "#0050ef"})
	
	# Turn the tiles list into JSON.
	# Example #2 here:
	# https://pythonexamples.org/python-list-to-json/
	# Looks the same, but I'm going to do it anyway
	# just in case it's different later.
	jsonTiles = json.dumps(TilesList)
	
	#print(jsonTiles)
	
	return jsonTiles