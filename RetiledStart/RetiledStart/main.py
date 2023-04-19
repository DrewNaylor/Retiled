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
from xdg import IconTheme

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
		
class SettingsLoader(QObject):
	# Slots still need to exist when using PySide.
	@Slot(str, str, str, result=str)
	def getSetting(self, SettingType, RequestedSetting, DefaultValue):
		# Get the settings.
		# TODO: Switch to a script that can just run the Python 
		# file as a script so that the library doesn't have to
		# be copied into each program and waste space and make
		# updating more confusing.
		# Set main file path for the config file to get it from the repo, or an install.
		# The two backslashes at the beginning are required on Windows, or it won't go up.
		# (I think I changed this at some point, as there are no backslashes anymore.)
		SettingsFilePath = "".join([os.getcwd(), "/../../RetiledSettings/configs/", SettingType, ".config"])
		
		if not sys.platform.startswith("win32"):
			# If not on Windows, check if the config file is in the user's home directory,
			# and update the path accordingly.
			if os.path.exists("".join([os.path.expanduser("~"), "/.config/Retiled/RetiledSettings/configs/", SettingType, ".config"])):
				SettingsFilePath = "".join([os.path.expanduser("~"), "/.config/Retiled/RetiledSettings/configs/", SettingType, ".config"])
		
		#print(SettingsFilePath)
		
		# Return the requested setting.
		return settingsReader.getSetting(SettingsFilePath, RequestedSetting, DefaultValue)
	
	# We need to sometimes convert strings to bools for settings
	# loading in QML.
	# Please note: this only covers when the string
	# is "true"; "1", "on", and "yes" are not
	# yet covered.
	# I kinda got this idea from this SO post,
	# since just returning bool(StringToConvert)
	# didn't work:
	# https://stackoverflow.com/a/18472142
	@Slot(str, result=bool)
	def convertSettingToBool(self, StringToConvert):
		if StringToConvert.lower() == "true":
			return True
		else:
			return False


class GetAppIcon(QObject):
	# Arguments:
	#     First "str" is the name of the application (we need to fall back to the .desktop
	# file's name just in case there's no "Icon=" key in it. I don't
	# know if this is allowed by the Icon theme spec, though).
	#     (when implemented) The "int" is for the icon size (we'll have to diverge from the Icon theme spec
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
	#     The second "str" is for the current icon theme.
	# We're passing this from QML, which may not be ideal but
	# it's quick to add for now.
	#     TODO: extend the ThemeSettingsLoader class above to allow
	# specifying whatever value we want to grab from the theme file
	# so that we can store the icon theme in there (ideally we should try to
	# grab settings from KDE and Gnome if we're running on them, but the main
	# focus is to mostly do our own thing for now and add compatibility
	# via options to default to the current desktop's settings [kinda not
	# going to be making my own compositor probably due to touch input
	# issues at HiDPI and instead going with a custom LookAndFeel package
	# for Plasma Mobile] or use our own settings instead of the desktop's
	# settings; not sure how that would be implemented in a user-friendly way,
	# maybe in a "compatibility" Settings page? I'm already going to have to
	# do a compatibility layer for Plasma Mobile to put my stuff as a custom
	# homescreen, and if I replace the KDE settings app in a custom image
	# that otherwise uses some pieces of Plasma Mobile, I'll still have to
	# have a way for users to set the Plasma Accent color in the kdeglobals
	# file so all their KDE apps still look ok and they can easily change
	# their colors; maybe an option on the "start+theme" page to inherit from
	# the KDE Accent color, and it can be changed to an option to change
	# our own color with a checkbox to "update KDE Accent color when changing
	# it for Retiled"? That sounds pretty good, but I think maybe all the
	# settings like this should be in the "compatibility" page, or maybe
	# "advanced compatibility", to not confuse anyone; this would have to
	# be added in there specifically, because a hypothetical RetiledTweaks
	# app might not be the most efficient way to do this, as it may be
	# a bit error-prone, or maybe it would be fine if there's like a thing
	# in there to update the KDE Accent color upon the D-Bus message
	# about the Retiled Accent color being sent out, but even then it would
	# require code to be always running to keep the Accent colors in sync;
	# alternatively, there could be a thing that updates the Retiled Accent
	# color when the KDE one changes and vice-versa, but then that shouldn't
	# be a default setting as it may confuse people, so maybe it would be best
	# to have it be a separate app for advanced users, and keep the main Retiled
	# Settings app simple enough for average users to use without getting too confused
	# or overwhelmed. Yeah, that actually sounds like a good idea, then I can put
	# the RetiledTweaks settings into the Settings app like in the KDE Settings
	# app and the Windows Control Panel so it's easy to get to it from there,
	# but a separate .desktop file will be needed at minimum to make it easy to
	# launch from any app launcher and make it obvious on how it can be pinned;
	# there will still need to be a way to change advanced settings that aren't
	# really as complicated as Accent color syncing, so those will stay in the
	# Settings app by default. I do still need to have something like kde-gtk-config so that stuff for GTK apps can be configured in my Settings app, and setting KDE Accent colors and stuff from my Settings app will probably be in there as well, just at least as its own page linked from `start+theme`, and the syncing back and forth wouldn't be a default thing, rather, there would be a page that lets KDE-specific stuff be configured that doesn't directly impact my own apps, but desktop stuff that does will be where it makes sense; maybe a checkbox to "sync KDE Accent color to Retiled Accent color" would be in fact a good thing to have on "start+theme".).
	#     NOTE: Make sure you use "RequestedIconTheme" instead of
	# "IconTheme", because the second one is part of pyxdg and will
	# conflict.
	@Slot(str, str, result=str)
	def getIcon(self, DotDesktopFile, RequestedIconTheme):
		# Gets and returns the icon for a given .desktop file
		# based on the icon size and current user theme.
		# See the "Arguments" block above for what the args do.
		# TODO: Allow using different icon
		# sizes depending on where the icon is being shown
		# and the user's DPI scaling (on 200% scaling, 96px
		# icons might be a good idea in the All Apps list and
		# maybe small tiles, but wide tiles have the icons
		# stretched horizontally and medium tiles might be a little large
		# to display the icon so they may be a little blurry).
		# We're only returning a value if the DotDesktopFile has something
		# in it, otherwise this would return nothing which results
		# in trying to assign /usr/share/applications as an image,
		# and that's not what we want.
		# TODO 2: Also look in the other places that .desktop files can be
		# instead of just /usr/share/applications.
		if len(DotDesktopFile) > 0:
			iconPath = IconTheme.getIconPath(desktopEntryStuff.getInfo("".join(["/usr/share/applications/", DotDesktopFile]), "Icon", DotDesktopFile, "", True), 96, RequestedIconTheme)
			# Don't return anything if the icon path doesn't exist.
			# Make sure we check to make sure the path isn't None.
			# If we don't do this, then we get an error in the terminal
			# saying it can't be NoneType or something.
			# This doesn't seem to improve the choppiness/slowness
			# in scrolling on the PinePhone. Probably would help
			# to cache the "Icon=" value from .desktop files so
			# we're not going through two layers every time.
			if (not iconPath == None) and (os.path.exists(iconPath)):
				return iconPath
			else:
				# Returning None if the path doesn't exist or it is None
				# apparently is fine for Qt.
				return None

def shutdown():
	# This is the cleanup code as described in the link.
	engine.rootObjects()[0].deleteLater()

if __name__ == "__main__":
	# Set the Universal style.
	sys.argv += ['--style', 'Universal']
	app = QGuiApplication(sys.argv)
	# Clean up the engine stuff before closing:
	# https://bugreports.qt.io/browse/QTBUG-81247?focusedCommentId=512347&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-512347
	# But we're actually taking the one from September 17, 2021, also from Benjamin Green.
	app.aboutToQuit.connect(shutdown)
	
	# Define the AllAppsListItems class so I can use it.
	allAppsListItems = AllAppsListItems()
	
	# Hook up some stuff so I can access the allAppsListViewModel from QML.
	allAppsListViewModel = AllAppsListViewModel()
	
	# Hook up the tiles list stuff.
	tilesListViewModel = TilesListViewModel()
	
	# Bind the settings loader to access it from QML.
	settingsLoader = SettingsLoader()

	# Grab the GetAppIcon class so we can put it into QML later.
	getAppIcon = GetAppIcon()
	
	engine = QQmlApplicationEngine()
	# Theme settings loader binding.
	engine.rootContext().setContextProperty("settingsLoader", settingsLoader)
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
