# libRetiledActionCenter - Utility library for RetiledActionCenter that allows me to
#                          keep the main code out of the UI code, like MVVM.
# Copyright (C) 2021-2022 Drew Naylor
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
import sys
import json
import subprocess

def runCommand(commandName):
	# Run a command based on its name.
	# Flashlight commands were taken from this page:
	# https://xnux.eu/devices/feature/flash-pp.html#toc-pinephone-flash-led
	if commandName == "flashlight_on":
		if sys.platform.startswith("win32"):
			print("running on Windows; this won't work.")
		else:
			# Turn the flashlight on.
			# We have to use os.system instead:
			# https://stackabuse.com/executing-shell-commands-with-python
			os.system("echo 1 > /sys/class/leds/white:flash/brightness")
		print("commandName: " + commandName)
	if commandName == "flashlight_off":
		if sys.platform.startswith("win32"):
			print("running on Windows; this won't work.")
		else:
			# Turn the flashlight off.
			os.system("echo 0 > /sys/class/leds/white:flash/brightness")
		print("commandName: " + commandName)
