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
from pathlib import Path
import sys
import webbrowser

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot

# Trying to figure out buttons with this:
# https://stackoverflow.com/questions/57619227/connect-qml-signal-to-pyside2-slot
class RunAppFromNavbarButton(QObject):
    @Slot(str)
    def runApp(self, appName):
        # We need to run the app if the user taps the Start or Search buttons.
		# TODO: Change this to open stuff.
        webbrowser.open("https://bing.com/search?q=" + appName, new = 2)


if __name__ == "__main__":
    # Set the Universal style.
    sys.argv += ['--style', 'Universal']
    app = QGuiApplication(sys.argv)
	# Hook up some stuff so I can access the searchClass from QML.
    runAppFromNavbarButton = RunAppFromNavbarButton()
    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("runAppFromNavbarButton", runAppFromNavbarButton)
    engine.load("MainWindow.qml")
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
