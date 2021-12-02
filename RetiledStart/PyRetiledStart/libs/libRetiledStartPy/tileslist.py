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



import os
import sys
import json
from ..pyyaml import yaml
# We have to specify the whole path or it won't work.
from ..pyyaml.yaml.loader import SafeLoader
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
	# This involves the ToDict method.
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
		TilesListToSave.append({"DotDesktopFilePath": i["DotDesktopFilePath"], "TileWidth": int(i["TileWidth"]), "TileHeight": int(i["TileHeight"]), "TileColor": i["TileColor"]})
		# print(i["DotDesktopFilePath"])
		
	# print(TilesListToSave)
	
	# Now we can check if the list is the same as getTilesList().
	if not json.dumps(TilesListToSave) == getTilesList(False):
	
		# Append the start layout schema version.
		# We need to create a new list first, one that
		# has both the "Tiles:" thing, too.
		StartLayoutConfigFile = {"Tiles": TilesListToSave, "StartLayoutSchemaVersion": 0.1}
	
		# Load the tilesList as if it were a yaml file.
		# Be sure to not have it sort the keys:
		# https://stackoverflow.com/a/55171433
		yamlifiedTiles = yaml.dump(StartLayoutConfigFile, sort_keys=False)
	
		print(yamlifiedTiles)
		
		# We can now save the file:
		# https://www.w3schools.com/python/python_file_write.asp
		# We need "w+" to create the file if it doesn't exist:
		# https://stackoverflow.com/a/2967249
		# First check which OS we're running on, and set
		# the storage location appropriately.
		# Expand the user's home directory:
		# https://www.tutorialspoint.com/How-to-find-the-real-user-home-directory-using-Python
		ModifiedStartLayoutYamlBaseFilePath = os.path.expanduser("~") + "/.config/Retiled/RetiledStart/"
		if sys.platform.startswith("win32"):
			# Set it to the same directory as the library
			# if we're running on Windows, because this
			# makes it easier for development.
			ModifiedStartLayoutYamlBaseFilePath = os.getcwd() + "/libs/libRetiledStartPy/"
			
		# Create the directory if it doesn't exist:
		# https://www.tutorialspoint.com/How-can-I-create-a-directory-if-it-does-not-exist-using-Python
		if not os.path.exists(ModifiedStartLayoutYamlBaseFilePath):
			os.makedirs(ModifiedStartLayoutYamlBaseFilePath)
		
		with open(ModifiedStartLayoutYamlBaseFilePath + "startlayout-modified.yaml", "w+", encoding="utf-8") as ModifiedStartLayoutYamlFile:
			ModifiedStartLayoutYamlFile.write(yamlifiedTiles)
	

def getTilesList(includeTileAppNameAreaText = True):
	# Gets the list of tiles that should be shown on Start.
	
	# Check whether the modified tiles list exists, and use
	# the built-in one if it doesn't.
	# First set the built-in path.
	StartLayoutFilePath = os.getcwd() + "/libs/libRetiledStartPy/startlayout.yaml"
	# Didn't know how to check if a file existed off the top of my head:
	# https://www.pythontutorial.net/python-basics/python-check-if-file-exists/
	# We can now check if we're running on Windows.
	if sys.platform.startswith("win32"):
		if os.path.exists(os.getcwd() + "/libs/libRetiledStartPy/startlayout-modified.yaml"):
			StartLayoutFilePath = os.getcwd() + "/libs/libRetiledStartPy/startlayout-modified.yaml"
	else:
		if os.path.exists(os.path.expanduser("~") + "/.config/Retiled/RetiledStart/startlayout-modified.yaml"):
			StartLayoutFilePath = os.path.expanduser("~") + "/.config/Retiled/RetiledStart/startlayout-modified.yaml"
	
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
		YamlFile = StartScreenLayoutRoot(yaml.safe_load(StartLayoutYamlFile))
		
		# Now we can refer to the items in the file by their names!
		#print(YamlFile.StartLayoutSchemaVersion)
		# You can now know their names.
		#print(YamlFile.Tiles[0].DotDesktopFilePath)
		
		# Loop through the Tiles items and add them to the TilesList.
		# We'll use the looping through index numbers example here:
		# https://www.w3schools.com/python/python_lists_loop.asp
		for i in range(len(YamlFile.Tiles)):
			#print(YamlFile.Tiles[i].TileColor)
			if (includeTileAppNameAreaText == False):
				TilesList.append({"DotDesktopFilePath": YamlFile.Tiles[i].DotDesktopFilePath, "TileWidth": YamlFile.Tiles[i].TileWidth, "TileHeight": YamlFile.Tiles[i].TileHeight, "TileColor": YamlFile.Tiles[i].TileColor})
			else:
				TilesList.append({"DotDesktopFilePath": YamlFile.Tiles[i].DotDesktopFilePath, "TileAppNameAreaText": AppsList.GetAppName(YamlFile.Tiles[i].DotDesktopFilePath), "TileWidth": YamlFile.Tiles[i].TileWidth, "TileHeight": YamlFile.Tiles[i].TileHeight, "TileColor": YamlFile.Tiles[i].TileColor})
		
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
	
	

class StartScreenLayoutRoot:
	# Trying to get all the tile entries
	# contained into another class so it's
	# easy to read. Also using the SO link in
	# the other class below.
	def __init__(self, root):
		self.Tiles = [StartScreenTileEntry(i["DotDesktopFilePath"], i["TileWidth"], i["TileHeight"], i["TileColor"]) for i in root["Tiles"]]
		self.StartLayoutSchemaVersion = root["StartLayoutSchemaVersion"]



class StartScreenTileEntry:
	# We're creating our own class to use with safe_load:
	# https://stackoverflow.com/a/2627732
	# Not sure if this'll work.
	# The values here are the same as in the VB.NET version.
	# Actually, we're now mostly using this answer:
	# https://stackoverflow.com/a/52581851
	def __init__(self, DotDesktopFilePath, TileWidth, TileHeight, TileColor):
		self.DotDesktopFilePath = DotDesktopFilePath
		self.TileWidth = TileWidth
		self.TileHeight = TileHeight
		self.TileColor = TileColor
		
	# Add a ToDict method to get this as a dict we can add to a list:
	# https://stackoverflow.com/a/37758807
	def ToDict(self):
		tileDict = {}
		tileDict["DotDesktopFilePath"] = self.DotDesktopFilePath
		tileDict["TileWidth"] = self.TileWidth
		tileDict["TileHeight"] = self.TileHeight
		tileDict["TileColor"] = self.TileColor




















	