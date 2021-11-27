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
from yaml.loader import SafeLoader

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
		print(yaml.safe_load(StartLayoutYamlFile))
	
		# Here's some stuff on using PyYAML. It's partially being used here:
		# https://pynative.com/python-yaml/
	
		# Load the file into a YAML reader.
		YamlFile = StartScreenLayout.load(StartLayoutYamlFile.read())
		
		print(YamlFile.StartLayoutSchemaVersion)
		
		# Get the stuff under Tiles.
	
	
	# Hard-code the tiles for now to make sure this'll work
	# without having to do everything first.
	# Adding dictionaries to list from here:
	# https://codeigo.com/python/add-dictionary-to-a-list
	TilesList.append({"DotDesktopPath": "/usr/share/applications/firefox.desktop", "TileAppNameAreaText": "Firefox", "TileWidth": 150, "TileHeight": 150, "TileColor": "#0050ef"})
	TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.angelfish.desktop", "TileAppNameAreaText": "Angelfish", "TileWidth": 150, "TileHeight": 150, "TileColor": "#0050ef"})
	TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.index.desktop", "TileAppNameAreaText": "Index", "TileWidth": 310, "TileHeight": 150, "TileColor": "#0050ef"})
	TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.discover.desktop", "TileAppNameAreaText": "Discover", "TileWidth": 150, "TileHeight": 150, "TileColor": "#0050ef"})
	TilesList.append({"DotDesktopPath": "/usr/share/applications/htop.desktop", "TileAppNameAreaText": "Htop", "TileWidth": 70, "TileHeight": 70, "TileColor": "#0050ef"})
	TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.kalk.desktop", "TileAppNameAreaText": "Calculator", "TileWidth": 70, "TileHeight": 70, "TileColor": "#0050ef"})
	TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.nota.desktop",  "TileAppNameAreaText": "Nota", "TileWidth": 70, "TileHeight": 70, "TileColor": "#0050ef"})
	TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.phone.dialer.desktop",  "TileAppNameAreaText": "Phone", "TileWidth": 70, "TileHeight": 70, "TileColor": "Red"})
	TilesList.append({"DotDesktopPath": "/usr/share/applications/org.kde.okular.desktop",  "TileAppNameAreaText": "Okular", "TileWidth": 150, "TileHeight": 150, "TileColor": "#0050ef"})
	
	# Turn the tiles list into JSON.
	# Example #2 here:
	# https://pythonexamples.org/python-list-to-json/
	# Looks the same, but I'm going to do it anyway
	# just in case it's different later.
	jsonTiles = json.dumps(TilesList)
	
	#print(jsonTiles)
	
	return jsonTiles
	
	

class StartScreenLayout:
	# Trying to get all the tile entries
	# contained into another class so it's
	# easy to read. Also using the SO link in
	# the other class below.
	def __init__(self, Tiles, StartLayoutSchemaVersion):
		self.Tiles = Tiles
		self.StartLayoutSchemaVersion = raw["StartLayoutSchemaVersion"]
		

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
		
	def yaml(self):
		return yaml.dump(self.__dict__)
		
	@staticmethod
	def load(data):
		values = yaml.safe_load(data)
		return StartScreenTileEntry(values["DotDesktopFilePath"], values["TileWidth"], values["TileHeight"], values["TileColor"])




















	