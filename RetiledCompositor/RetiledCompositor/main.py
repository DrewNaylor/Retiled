# RetiledCompositor - Windows Phone 8.x-like compositor for the Retiled project.
#                     Some code was copied from
#                     the official qtwayland repo, which you can
#                     access a copy of here:
#                     https://github.com/DrewNaylor/qtwayland
#                     You can also use that link to access the code for qtwayland
#                     as required by the GPL.
# Copyright (C) 2022 Drew Naylor
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
class RunAppFromNavbarButton(QObject):
	@Slot(str)
	def runApp(self, appName):
        # We need to run the app if the user taps the Start or Search buttons.
		# Split the app name from what it needs to be run with.
		# Kinda copied this from libdotdesktop_py.
		args = shlex.split(appName)
		# Copied this from libRetiledStart.
		proc = subprocess.Popen(args)
		
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
	
	# Hook up some stuff so I can access the runAppFromNavbarButton class from QML.
	runAppFromNavbarButton = RunAppFromNavbarButton()
	
	# Bind the theme settings loader to access it from QML.
	themeSettingsLoader = ThemeSettingsLoader()
	
	engine = QQmlApplicationEngine()
	# Bind theme settings loader.
	engine.rootContext().setContextProperty("themeSettingsLoader", themeSettingsLoader)
	# Bind run app from navbar button.
	engine.rootContext().setContextProperty("runAppFromNavbarButton", runAppFromNavbarButton)
	engine.load("MainWindow.qml")
	if not engine.rootObjects():
		sys.exit(-1)
	sys.exit(app.exec())
