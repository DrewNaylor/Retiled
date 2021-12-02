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
	
	# Load the tilesList as if it were a yaml file.
	jsonifiedTiles = json.dumps(tilesList)
	
	print(jsonifiedTiles)
	
	# Loop through the items in tilesList and add them to TilesListToSave.
	
	

def getTilesList():
	# Gets the list of tiles that should be shown on Start.
	# Currently has the location of the tiles list hardcoded.
	
	# Define list to store the tiles.
	TilesList = []
	
	# Load the file.
	# TODO: Change to using "with" for the .desktop file reader code.
	# "encoding='utf-8'" is necessary or Python will give a UnicodeDecodeError as described here:
	# https://stackoverflow.com/a/42495690
	with open(os.getcwd() + "/libs/libRetiledStartPy/startlayout.yaml", "r", encoding="utf-8") as StartLayoutYamlFile:
	
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




















	