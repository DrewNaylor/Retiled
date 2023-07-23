# RetiledSettings - Windows Phone 8.0-like Settings app for the
#                   Retiled project.
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
import webbrowser

# Settings file loader.
# TODO: Switch to a script that can just run the Python 
# file as a script so that the library doesn't have to
# be copied into each program and waste space and make
# updating more confusing.
# Or actually, maybe I should figure out how to install
# my own libraries into the system-wide Python installation
# instead of putting them in each folder.
from libs.libRetiledSettings import settingsReader as settingsReader

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot

# Trying to figure out buttons with this:
# https://stackoverflow.com/questions/57619227/connect-qml-signal-to-pyside2-slot
class SearchCommands(QObject):
	@Slot(str)
	def openUrl(self, searchTerm):
        # Send the user to Bing based on this SO answer:
		# https://stackoverflow.com/a/31715355
		# TODO: Only do the search if the searchTerm's length is more than 0.
		# Maybe it would be cool to hide the search button if there's nothing
		# in the search box, too.
		# TODO 2: Have the code to do a search be async so it doesn't look
		# choppy when the user presses the button.
		# Not sure how much memory it'll save, but using "".join()
		# instead of "+" for concatenation does prevent creating new strings
		# constantly.
		webbrowser.open("".join(["https://bing.com/search?q=", searchTerm]), new = 2)
		
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
		SettingsFilePath = "".join([os.getcwd(), "/../RetiledSettings/configs/", SettingType, ".config"])
		
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

class ThemeLoader(QObject):
	# Slots still need to exist when using PySide.
	@Slot(str, str, str, str, result=str)
	def getValueFromTheme(self, ThemeName, ThemeSection, RequestedValue, DefaultValue):
		# Get the settings.
		# TODO: Switch to a script that can just run the Python 
		# file as a script so that the library doesn't have to
		# be copied into each program and waste space and make
		# updating more confusing.
		# Set main file path for the config file to get it from the repo, or an install.
		# The two backslashes at the beginning are required on Windows, or it won't go up.
		# (I think I changed this at some point, as there are no backslashes anymore.)
		ThemeFilePath = "".join([os.getcwd(), "/../RetiledThemes/", ThemeName, ".ini"])
		
		# We'll have to look for themes in other places, but not yet.
		#if not sys.platform.startswith("win32"):
			# If not on Windows, check if the config file is in the user's home directory,
			# and update the path accordingly.
		#	if os.path.exists("".join([os.path.expanduser("~"), "/.config/Retiled/RetiledSettings/configs/", ThemeName, ".ini"])):
		#		SettingsFilePath = "".join([os.path.expanduser("~"), "/.config/Retiled/RetiledSettings/configs/", ThemeName, ".ini"])
		
		#print(SettingsFilePath)
		
		# Return the requested value.
		# Remove the quotes, though (Qt doesn't like them):
		# https://stackoverflow.com/a/40950987
		return settingsReader.getSetting(ThemeFilePath, RequestedValue, DefaultValue, sectionName=ThemeSection).strip('\"')

class AppRootPath(QObject):
	# We need to store the app's root directory
	# to refer to the pages so we can properly
	# navigate from the appbar and appbar drawer.
	@Slot(result=str)
	def getAppRootPath(self):
		# TODO: Change this to something more specific
		# so it doesn't break when the working directory
		# changes.
		return os.getcwd()

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
	
	# Bind the settings loader to access it from QML.
	settingsLoader = SettingsLoader()

	# Bind the theme loader to access it from QML.
	ThemeLoader = ThemeLoader()
	
	# Hook up some stuff so I can access the searchClass from QML.
	searchClass = SearchCommands()

	# We need to get the app's root path so the appbar and
	# appbar drawer can navigate.
	AppRootPath = AppRootPath()
	
	engine = QQmlApplicationEngine()
	# Theme settings loader binding.
	engine.rootContext().setContextProperty("settingsLoader", settingsLoader)
	engine.rootContext().setContextProperty("ThemeLoader", ThemeLoader)
	engine.rootContext().setContextProperty("searchClass", searchClass)
	engine.rootContext().setContextProperty("AppRootPath", AppRootPath)
	engine.load("MainWindow.qml")
	if not engine.rootObjects():
		sys.exit(-1)
	sys.exit(app.exec())
