// RetiledStyles - Windows Phone 8.x-like QML styles for the
//                 Retiled project. Some code was copied from
//                 the official qtdeclarative repo, which you can
//                 access a copy of here:
//                 https://github.com/DrewNaylor/qtdeclarative
// Copyright (C) 2021-2022 Drew Naylor
// (Note that the copyright years include the years left out by the hyphen.)
// Windows Phone and all other related copyrights and trademarks are property
// of Microsoft Corporation. All rights reserved.
//
// This file is a part of the RetiledStyles project, which is used by Retiled.
// Neither Retiled nor Drew Naylor are associated with Microsoft
// and Microsoft does not endorse Retiled.
// Any other copyrights and trademarks belong to their
// respective people and companies/organizations.
//
//
//    RetiledStyles is free software: you can redistribute it and/or modify
//    it under the terms of the GNU Lesser General Public License
//    version 3 as published by the Free Software Foundation.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU Lesser General Public License for more details.
//
//    You should have received a copy of the GNU Lesser General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

// This is one of the buttons at the top of the Action Center.
import "." as RetiledStyles
import QtQuick
import QtQuick.Controls

RetiledStyles.Button {
	// Set borderWidth to 0.
	borderWidth: 0
	// Add property for button color when it's toggled on.
	// This is the accent color, cobalt by default.
	property string toggledOnColor: "#0050ef"
	// Unpressed background color will use the toggledOnColor
	// to ensure things don't break.
	unpressedBackgroundColor: isToggled ? toggledOnColor : toggledOffColor
	pressedBackgroundColor: isToggled ? toggledOnColor : toggledOffColor
	// Add property for toggled-off button color.
	// This is the same as displayed in the emulator.
	property string toggledOffColor: "#1F1F1F"
	
	// Specify whether this button can be toggled.
	// By default it's a toggle button for testing.
	property bool canToggle: true
	// Specify whether the button is currently toggled.
	property bool isToggled: false
	
	// Switch the button between toggled on and off states.
	onClicked: {
		if ((canToggle == true) && (isToggled == false)) {
			// Toggle the button on.
			isToggled = true;
		} else if ((canToggle == true) && (isToggled == true)) {
			// Toggle the button off.
			isToggled = false;
		}
	}
}