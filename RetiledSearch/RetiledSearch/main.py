# RetiledSearch - Windows Phone 8.0-like Search app for the
#                 Retiled project.
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
	
	# Bind the theme settings loader to access it from QML.
	themeSettingsLoader = ThemeSettingsLoader()
	
	# Hook up some stuff so I can access the searchClass from QML.
	searchClass = SearchCommands()
	
	engine = QQmlApplicationEngine()
	# Theme settings loader binding.
	engine.rootContext().setContextProperty("themeSettingsLoader", themeSettingsLoader)
	engine.rootContext().setContextProperty("searchClass", searchClass)
	engine.load("MainWindow.qml")
	if not engine.rootObjects():
		sys.exit(-1)
	sys.exit(app.exec())
