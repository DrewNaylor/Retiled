# RetiledActionCenter - Windows Phone 8.1-like Action Center UI for the
#                       Retiled project.
# Copyright (C) 2021-2023 Drew Naylor
# (Note that the copyright years include the years left out by the hyphen.)
# (This file is based off RetiledStart, hence the copyright including 2021.)
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
# from libs.libRetiledStartPy import appslist as AppsList
# from libs.libRetiledStartPy import tileslist as TilesList
from libs.libRetiledActionCenter import actioncentercommands as ActionCenterCommands

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
# class AllAppsListViewModel(QObject):
	# @Slot(str)
	# def RunApp(self, ViewModelExecFilename):
		# # Pass the app's command to the code to actually
		# # figure out how to run it.
		# # This is different on Windows for debugging purposes.
		# # Example code for sys.platform:
		# # https://docs.python.org/3/library/sys.html#sys.platform
		# if sys.platform.startswith("win32"):
			# AppsList.RunApp("".join(["C:\\Users\\drewn\\Desktop\\", ViewModelExecFilename]))
		# else:
			# AppsList.RunApp("".join(["/usr/share/applications/", ViewModelExecFilename]))
		
	# # Slots still need to exist when using PySide.
	# @Slot(result=str)
	# def getDotDesktopFiles(self):
		# # Get the .desktop files list.
		# # I'm trying to get the list split into each
		# # All Apps list item.
		# return AppsList.getDotDesktopFiles()
		
	# @Slot(str, result=str)
	# # Add the result=str to get the return thing to work:
	# # https://stackoverflow.com/a/36210838
	# def GetDesktopEntryNameKey(self, DotDesktopFile):
		# # Get and return the .desktop file's Name key value.
		# # We're no longer specifying the path here so to
		# # reduce code duplication, as this is also used when
		# # loading the tiles list.
		# return AppsList.GetAppName(DotDesktopFile)
	
	# # Pin the app to Start.
	# @Slot(str)
	# def PinToStart(self, dotDesktopFilePath):
		# print(dotDesktopFilePath)
		
# # This class is for the items in the All Apps list as described in
# # the second half of this answer:
# # https://stackoverflow.com/a/59700406
# class AllAppsListItems(QObject):
	# def __init__(self, parent=None):
		# super().__init__(parent)
		# self._model = QStringListModel()
	
	# # Just guessing that it's Property instead of pyqtProperty.
	# @Property(QObject, constant=True)
	# def model(self):
		# return self._model
	
	# # I'm not passing anything to the code, so
	# # this has to be a "Slot()" instead of "Slot(str)".
	# @Slot()
	# def getDotDesktopFilesInList(self):
		# #self._model.setStringList(['Firefox Launcher.desktop', 'top-exec.desktop'])
		# self._model.setStringList(AppsList.getDotDesktopFiles())
	# # TODO: Make sure the items are properly cleaned up so QML doesn't say
	# # that there are null items after closing.
	
# class TilesListViewModel(QObject):
	# # Save the tile layout after exiting global exit mode.
	# # This involves reading JSON as a dictionary and
	# # modifying the startlayout.yaml file after copying
	# # it to the user's home folder if necessary.
	# # The slot has to be a list, otherwise we'll just
	# # get [object, Object] a bunch of times.
	# @Slot(list)
	# def SaveTileLayout(self, tilesList):
		# # Send the tiles list to the JSON processing code.
		# TilesList.saveTilesList(tilesList)
		
	# # Slots still need to exist when using PySide.
	# @Slot(result=str)
	# def getTilesList(self):
		# # Get the tiles list.
		# # I'm trying to get a list of dictionaries
		# # in JSON for dynamic object creation
		# # and destruction.
		# return TilesList.getTilesList()
		
class ActionCenterActionButtonsViewModel(QObject):
	# Currently only offers functionality to run commands.
	# TODO: Load the list of buttons from a config file.
	@Slot(str)
	def runCommand(self, command):
		# Pass the command to the library so it runs.
		ActionCenterCommands.runCommand(command)

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

if __name__ == "__main__":
	# Set the Universal style.
	sys.argv += ['--style', 'Universal']
	app = QGuiApplication(sys.argv)
	
	# # Define the AllAppsListItems class so I can use it.
	# allAppsListItems = AllAppsListItems()
	
	# Bind the theme settings loader to access it from QML.
	themeSettingsLoader = ThemeSettingsLoader()
	
	# Hook up some stuff so I can access the ActionCenterActionButtonsViewModel from QML.
	actionCenterActionButtonsViewModel = ActionCenterActionButtonsViewModel()
	
	engine = QQmlApplicationEngine()
	# engine.rootContext().setContextProperty("allAppsListItems", allAppsListItems)
	# Theme settings loader binding.
	engine.rootContext().setContextProperty("themeSettingsLoader", themeSettingsLoader)
	# Action buttons for the Action Center.
	engine.rootContext().setContextProperty("actionCenterActionButtonsViewModel", actionCenterActionButtonsViewModel)
	engine.load("pages/ActionCenterWindow.qml")
	if not engine.rootObjects():
		sys.exit(-1)
	sys.exit(app.exec())
