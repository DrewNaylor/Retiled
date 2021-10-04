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

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot

# Trying to figure out buttons with this:
# https://stackoverflow.com/questions/57619227/connect-qml-signal-to-pyside2-slot
class AllAppsListViewModel(QObject):
    @Slot(str)
    def RunApp(self, ViewModelExecFilename):
        # Pass the app's command to the code to actually
        # figure out how to run it.
        #AppsList.RunApp(ViewModelExecFilename)
        AppsList.GetAppName(ViewModelExecFilename)

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
	# Hook up some stuff so I can access the allAppsListViewModel from QML.
    allAppsListViewModel = AllAppsListViewModel()
    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("allAppsListViewModel", allAppsListViewModel)
    engine.load("MainWindow.qml")
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
