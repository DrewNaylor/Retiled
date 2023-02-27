# libRetiledActionCenter - Utility library for RetiledActionCenter that allows me to
#                          keep the main code out of the UI code, like MVVM.
# Copyright (C) 2022-2023 Drew Naylor
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
#   Licensed under the MIT License (the "License");
#   you may not use this file except in compliance with the License.
#
#       The MIT License (MIT)
#       Copyright (C) 2022-2023 Drew Naylor
#
#       Permission is hereby granted, free of charge,
#       to any person obtaining a copy of this
#       software and associated documentation files
#       (the “Software”), to deal in the Software
#       without restriction, including without
#       limitation the rights to use, copy, modify,
#       merge, publish, distribute, sublicense,
#       and/or sell copies of the Software, and to
#       permit persons to whom the Software is
#       furnished to do so, subject to the following
#       conditions:
#
#       The above copyright notice and this permission
#       notice shall be included in all copies or
#       substantial portions of the Software.
#
#       THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT 
#       WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
#       INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#       OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
#       PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
#       THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
#       FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#       WHETHER IN AN ACTION OF CONTRACT, TORT OR
#       OTHERWISE, ARISING FROM, OUT OF OR IN
#       CONNECTION WITH THE SOFTWARE OR THE USE OR
#       OTHER DEALINGS IN THE SOFTWARE.



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
