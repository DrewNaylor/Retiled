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

def getTilesList():
	# Gets the list of tiles that should be shown on Start.
	# Currently has the location of the tiles list hardcoded.
	
	# Define list to store the tiles.
	TilesList = []
	
	# Load the file.
	StartLayoutYamlFile = open(os.getcwd() + "/libs/libRetiledStartPy/startlayout.yaml", "r")
	
	# Output the file.
	print(StartLayoutYamlFile)
	
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
	
	
	
	