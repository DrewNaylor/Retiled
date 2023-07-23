# RetiledCompositor - Windows Phone 8.x-like compositor for the Retiled project.
#                     Some code was copied from
#                     the official qtwayland repo, which you can
#                     access a copy of here:
#                     https://github.com/DrewNaylor/qtwayland
#                     You can also use that link to access the code for qtwayland
#                     as required by the GPL.
# Copyright (C) 2022-2023 Drew Naylor
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
#    RetiledCompositor is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License
#    version 3 as published by the Free Software Foundation.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.




import os
import subprocess
import shlex
from pathlib import Path
import sys

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
class RunAppFromNavbarButton(QObject):
	@Slot(str)
	def runApp(self, appName):
        # We need to run the app if the user taps the Start or Search buttons.
		# Split the app name from what it needs to be run with.
		# Kinda copied this from libdotdesktop_py.
		args = shlex.split(appName)
		# Copied this from libRetiledStart.
		proc = subprocess.Popen(args)
		
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
		ThemeFilePath = "".join([os.getcwd(), "/../../RetiledThemes/", ThemeName, ".ini"])
		
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
	
	# Hook up some stuff so I can access the runAppFromNavbarButton class from QML.
	runAppFromNavbarButton = RunAppFromNavbarButton()
	
	# Bind the theme settings loader to access it from QML.
	settingsLoader = SettingsLoader()

	# Bind the theme loader to access it from QML.
	ThemeLoader = ThemeLoader()
	
	engine = QQmlApplicationEngine()
	# Bind theme settings loader.
	engine.rootContext().setContextProperty("settingsLoader", settingsLoader)
	engine.rootContext().setContextProperty("ThemeLoader", ThemeLoader)
	# Bind run app from navbar button.
	engine.rootContext().setContextProperty("runAppFromNavbarButton", runAppFromNavbarButton)
	engine.load("MainWindow.qml")
	if not engine.rootObjects():
		sys.exit(-1)
	sys.exit(app.exec())
