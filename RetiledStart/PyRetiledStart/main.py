# PyRetiledStart - Windows Phone 8.x-like Start screen UI for the
#                  Retiled project. Once this app reaches
#                  feature-parity with the older Avalonia-based
#                  version, this version will be renamed back to
#                  "RetiledStart".
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
from pathlib import Path
import sys
from libs.libRetiledStartPy import appslist as AppsList
from libs.libRetiledStartPy import tileslist as TilesList

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
			AppsList.RunApp("C:\\Users\\drewn\\Desktop\\" + ViewModelExecFilename)
		else:
			AppsList.RunApp("/usr/share/applications/" + ViewModelExecFilename)
		
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
		# This is different on Windows for debugging purposes.
		# Example code for sys.platform:
		# https://docs.python.org/3/library/sys.html#sys.platform
		if sys.platform.startswith("win32"):
			return AppsList.GetAppName("C:\\Users\\drewn\\Desktop\\" + DotDesktopFile)
		else:
			return AppsList.GetAppName("/usr/share/applications/" + DotDesktopFile)
	
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
	@Slot(str)
	def RunApp(self, ViewModelExecFilename):
		# Pass the app's command to the code to actually
		# figure out how to run it.
		# This is different on Windows for debugging purposes.
		# Example code for sys.platform:
		# https://docs.python.org/3/library/sys.html#sys.platform
		# if sys.platform.startswith("win32"):
			# Not sure if this code here is a good idea, as any tiles on Windows
			# are just going to have the path of the .desktop file, which is how
			# it works on Linux.
			# TODO: Figure out how to use the user's own copy of a .desktop
			# file if it exists instead of the one from /usr/share/applications/,
			# as this will allow the user to override the .desktop file by
			# putting one in their home directory.
			# This needs to be done for both the All Apps list as well as the Tiles.
			#AppsList.RunApp("C:\\Users\\drewn\\Desktop\\" + ViewModelExecFilename)
			# As it turns out, I guess I did need the path on Windows after all, or maybe I didn't.
		AppsList.RunApp(ViewModelExecFilename)
		# else:
			#AppsList.RunApp("/usr/share/applications/" + ViewModelExecFilename)
		# AppsList.RunApp(ViewModelExecFilename)
		# I got rid of the if statement because it's basically redundant.
		# Don't have both of the lines calling the running code uncommented
		# at the same time like I did, or you'll be confused why it opens
		# a GUI app twice but not, say, htop or nano.
		
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


#class TilesViewModel(QObject):
	#@Slot(str)
	#def RunApp(self, ExecFilename):
		## Maybe I should figure out how to combine this
		## function with the AllAppsListViewModel one
		## so that there's more code reused. Probably should just
		## have it be in a GenericAppCode class or something.
		#args = shlex.split(ExecFilename)
		## Now run the command.
		#proc = subprocess.Popen(args)


if __name__ == "__main__":
	# Set the Universal style.
	sys.argv += ['--style', 'Universal']
	app = QGuiApplication(sys.argv)
	
	# Define the AllAppsListItems class so I can use it.
	allAppsListItems = AllAppsListItems()
	#allAppsListItems = ['Firefox Launcher.desktop', 'top-exec.desktop']
	
	# Hook up some stuff so I can access the allAppsListViewModel from QML.
	allAppsListViewModel = AllAppsListViewModel()
	
	# Hook up the tiles list stuff.
	tilesListViewModel = TilesListViewModel()
	
	engine = QQmlApplicationEngine()
	engine.rootContext().setContextProperty("allAppsListItems", allAppsListItems)
	engine.rootContext().setContextProperty("allAppsListViewModel", allAppsListViewModel)
	engine.rootContext().setContextProperty("tilesListViewModel", tilesListViewModel)
	#engine.load("MainWindow.qml")
	engine.load("pages/Tiles.qml")
	if not engine.rootObjects():
		sys.exit(-1)
	sys.exit(app.exec())
