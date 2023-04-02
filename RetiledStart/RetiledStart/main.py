# RetiledStart - Windows Phone 8.x-like Start screen UI for the
#                Retiled project.
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
from pathlib import Path
import sys
from libs.libRetiledStartPy import appslist as AppsList
from libs.libRetiledStartPy import tileslist as TilesList
# Importing the icon theme library to make getting icons easier.
from libs.pyxdg.xdg import IconTheme

# I need to directly import libdotdesktop as well, for icons.
from libs.libdotdesktop_py import desktopEntryStuff

# Settings file loader.
# TODO: Switch to a script that can just run the Python 
# file as a script so that the library doesn't have to
# be copied into each program and waste space and make
# updating more confusing.
from libs.libRetiledSettings import settingsReader as settingsReader

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Property, QStringListModel

# Trying to figure out buttons with this:
# https://stackoverflow.com/questions/57619227/connect-qml-signal-to-pyside2-slot
class AllAppsListViewModel(QObject):
	@Slot(str)
	def RunApp(self, ViewModelExecFilename):
		# Pass the app's command to the code to actually
		# figure out how to run it.
		# This is different on Windows for debugging purposes.
		# Example code for sys.platform:
		# https://docs.python.org/3/library/sys.html#sys.platform
		if sys.platform.startswith("win32"):
			#AppsList.RunApp("".join(["C:\\Users\\drewn\\Desktop\\", ViewModelExecFilename]))
			AppsList.RunApp("".join(["C:\\Users\\Drew\\Desktop\\", ViewModelExecFilename]))
		else:
			AppsList.RunApp("".join(["/usr/share/applications/", ViewModelExecFilename]))
		
	# Slots still need to exist when using PySide.
	@Slot(result=str)
	def getDotDesktopFiles(self):
		# Get the .desktop files list.
		# I'm trying to get the list split into each
		# All Apps list item.
		return AppsList.getDotDesktopFiles()
		
	@Slot(str, result=str)
	# Add the result=str to get the return thing to work:
	# https://stackoverflow.com/a/36210838
	def GetDesktopEntryNameKey(self, DotDesktopFile):
		# Get and return the .desktop file's Name key value.
		# We're no longer specifying the path here so to
		# reduce code duplication, as this is also used when
		# loading the tiles list.
		return AppsList.GetAppName(DotDesktopFile)
	
	# Pin the app to Start.
	@Slot(str)
	def PinToStart(self, dotDesktopFilePath):
		print(dotDesktopFilePath)
		
# This class is for the items in the All Apps list as described in
# the second half of this answer:
# https://stackoverflow.com/a/59700406
class AllAppsListItems(QObject):
	def __init__(self, parent=None):
		super().__init__(parent)
		self._model = QStringListModel()
	
	# Just guessing that it's Property instead of pyqtProperty.
	@Property(QObject, constant=True)
	def model(self):
		return self._model
	
	# I'm not passing anything to the code, so
	# this has to be a "Slot()" instead of "Slot(str)".
	@Slot()
	def getDotDesktopFilesInList(self):
		#self._model.setStringList(['Firefox Launcher.desktop', 'top-exec.desktop'])
		self._model.setStringList(AppsList.getDotDesktopFiles())
	# TODO: Make sure the items are properly cleaned up so QML doesn't say
	# that there are null items after closing.
	
class TilesListViewModel(QObject):
	# Save the tile layout after exiting global exit mode.
	# This involves reading JSON as a dictionary and
	# modifying the startlayout.yaml file after copying
	# it to the user's home folder if necessary.
	# The slot has to be a list, otherwise we'll just
	# get [object, Object] a bunch of times.
	@Slot(list)
	def SaveTileLayout(self, tilesList):
		# Send the tiles list to the JSON processing code.
		TilesList.saveTilesList(tilesList)
		
	# Slots still need to exist when using PySide.
	@Slot(result=str)
	def getTilesList(self):
		# Get the tiles list.
		# I'm trying to get a list of dictionaries
		# in JSON for dynamic object creation
		# and destruction.
		return TilesList.getTilesList()
		
class ThemeSettingsLoader(QObject):
	# Slots still need to exist when using PySide.
	@Slot(result=str)
	def getThemeSettings(self):
		# Get the theme settings.
		# Currently just Accent colors.
		# TODO: Switch to a script that can just run the Python 
		# file as a script so that the library doesn't have to
		# be copied into each program and waste space and make
		# updating more confusing.
		# Set main file path for the config file to get it from the repo, or an install.
		# The two backslashes at the beginning are required on Windows, or it won't go up.
		ThemeSettingsFilePath = "".join([os.getcwd(), "/../../RetiledSettings/configs/themes.config"])
		
		if not sys.platform.startswith("win32"):
			# If not on Windows, check if the config file is in the user's home directory,
			# and update the path accordingly.
			if os.path.exists("".join([os.path.expanduser("~"), "/.config/Retiled/RetiledSettings/configs/themes.config"])):
				ThemeSettingsFilePath = "".join([os.path.expanduser("~"), "/.config/Retiled/RetiledSettings/configs/themes.config"])
		
		#print(ThemeSettingsFilePath)
		
		# Return the Accent color.
		return settingsReader.getSetting(ThemeSettingsFilePath, "AccentColor", "#0050ef")

class GetAppIcon(QObject):
	# Arguments:
	# First "str" is the name of the application (for now the .desktop file without
	# ".desktop", but will use the "Icon=" value in that file once it's integrated,
	# but we'll still fall back to the .desktop file's name just in case. I don't
	# know if this is allowed by the Icon theme spec, thoug).
	# The "int" is for the icon size (we'll have to diverge from the Icon theme spec
	# a little because for tiles, they probably will have different-sized
	# icons both per size, and per tile type, with some tiles not displaying
	# an icon at all if they're not using the "Iconic"-style template
	# template when medium or wide, in which case we'll have to have a different method
	# to get each Live Tile the images and content they need. I expect
	# most small tiles to just display an icon, so they'll still sometimes
	# need to get an icon. The calendar app though would display the current
	# date on the small tile, so that needs to be taken care of, and
	# Weatherbug would display current weather on the small tile even
	# though that wasn't according to the spec, so I'll just outright allow
	# it in my Live Tile implementation because it's useful. Users
	# will still need to be able to turn them off, though.)
	# The second "str" is for the current icon theme (we'll default to
	# "breeze" for now until implementing reading from the user's config.)
	@Slot(str, result=str)
	def getIcon(self, DotDesktopFile):
		# Gets and returns the icon for a given .desktop file
		# based on the icon size and current user theme.
		# See the "Arguments" block above for what the args do.
		# TODO: Use the user's current icon theme instead
		# of hardcoding Breeze, and allow using different icon
		# sizes depending on where the icon is being shown
		# and the user's DPI scaling (on 200% scaling, 96px
		# icons might be a good idea in the All Apps list and
		# maybe small tiles, but wide tiles have the icons
		# stretched horizontally and medium tiles might be a little large
		# to display the icon so they may be a little blurry).
		return IconTheme.getIconPath(desktopEntryStuff.getInfo("".join(["/usr/share/applications/", DotDesktopFile]), "Icon", DotDesktopFile, "", True), 96, "breeze")

if __name__ == "__main__":
	# Set the Universal style.
	sys.argv += ['--style', 'Universal']
	app = QGuiApplication(sys.argv)
	
	# Define the AllAppsListItems class so I can use it.
	allAppsListItems = AllAppsListItems()
	
	# Hook up some stuff so I can access the allAppsListViewModel from QML.
	allAppsListViewModel = AllAppsListViewModel()
	
	# Hook up the tiles list stuff.
	tilesListViewModel = TilesListViewModel()
	
	# Bind the theme settings loader to access it from QML.
	themeSettingsLoader = ThemeSettingsLoader()

	# Grab the GetAppIcon class so we can put it into QML later.
	getAppIcon = GetAppIcon()
	
	engine = QQmlApplicationEngine()
	# Theme settings loader binding.
	engine.rootContext().setContextProperty("themeSettingsLoader", themeSettingsLoader)
	# All Apps list items and view model.
	engine.rootContext().setContextProperty("allAppsListItems", allAppsListItems)
	engine.rootContext().setContextProperty("allAppsListViewModel", allAppsListViewModel)
	# Tiles list view model.
	engine.rootContext().setContextProperty("tilesListViewModel", tilesListViewModel)
	# Icon-getter class to use in QML.
	engine.rootContext().setContextProperty("getAppIcon", getAppIcon)
	# Load the Tiles.qml page, which acts as the main window.
	engine.load("pages/Tiles.qml")
	if not engine.rootObjects():
		sys.exit(-1)
	sys.exit(app.exec())
