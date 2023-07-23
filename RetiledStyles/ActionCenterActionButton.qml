// RetiledStyles - Windows Phone 8.x-like QML styles for the
//                 Retiled project. Some code was copied from
//                 the official qtdeclarative repo, which you can
//                 access a copy of here:
//                 https://github.com/DrewNaylor/qtdeclarative
// Copyright (C) 2021-2023 Drew Naylor
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
//    All files in this repo (Retiled) licensed under the Apache License, 2.0,
//    are using RetiledStyles under the LGPLv3.
//
//    Alternatively, this file may be used under the terms of the GNU
//    General Public License version 2.0 or later as published by the Free
//    Software Foundation and appearing in the file LICENSE.GPL included in
//    the packaging of this file. Please review the following information to
//    ensure the GNU General Public License version 2.0 requirements will be
//    met: http://www.gnu.org/licenses/gpl-2.0.html.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU (Lesser) General Public License for more details.
//
//    You should have received a copy of the GNU (Lesser) General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

// This is one of the buttons at the top of the Action Center.
import "." as RetiledStyles
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal

RetiledStyles.Button {
	// Set borderWidth to 0.
	// TODO: Allow setting border width for these.
	borderWidth: 0
	// TODO: Allow setting radius for Action Center Action Buttons,
	// like ordinary buttons and tiles.
	// Set width and height.
	// These are roughly what the 720p 4.7-inch emulator has at 50% scale.
	// If these don't feel that good on a phone, they can be changed.
	buttonWidth: 86
	buttonHeight: 58
	// Add property for button color when it's toggled on.
	// This is the accent color, cobalt (#0050ef) by default.
	// TODO: Allow this to be overridden by themes so they can
	// use a different color.
	property string toggledOnColor: accentColor
	// Unpressed background color will use the toggledOnColor
	// to ensure things don't break.
	unpressedBackgroundColor: isToggled ? toggledOnColor : toggledOffColor
	pressedBackgroundColor: isToggled ? toggledOnColor : toggledOffColor
	// Add property for toggled-off button color.
	// This is the same as displayed in the emulator.
	property string toggledOffColor: ThemeLoader.getValueFromTheme(themePath, "ActionCenterActionButton", "ToggledOffBackgroundColor", "#1f1f1f")
	
	// Property for button text color.
	property string actionCenterActionButtonTextColor: ThemeLoader.getValueFromTheme(themePath, "ActionCenterActionButton", "ActionButtonTextColor", "white")
	// Specify whether this button can be toggled.
	// TODO: Allow multi-state buttons, such as for display brightness.
	// By default it's a toggle button for testing.
	property bool canToggle: true
	// Specify whether the button is currently toggled.
	property bool isToggled: false
	
	// Property for setting the text on a specific Action Center button.
	property string actionCenterButtonText: "(null)"
	
	// Property for setting whether the text should be all-caps or lowercase.
	// This is for accessibility purposes to help screen readers and should also help anyone that doesn't
	// like stuff in all-caps because it feels like it's yelling at them.
	// Currently unused.
	// NOTE: We'll use the font property to have text render as lowercase,
	// rather than directly using ".toLower" or something.
	// That way it should be fine for screen readers.
	property bool textIsLowercase: false
	
	// Property for storing the command the button can use.
	property string buttonCommand;
	
	// Signal for running the button's command.
	signal runCommand(string buttonCommand);
	
	// Clip the contents of the button so it doesn't go outside its area.
	clip: true
	
	// Switch the button between toggled on and off states.
	// We have to use onReleased because QML doesn't let onClicked
	// events go as quickly as I want to allow.
	onReleased: {
		if ((canToggle == true) && (isToggled == false)) {
			// Toggle the button on.
			isToggled = true;
			//console.log(isToggled);
		} else if ((canToggle == true) && (isToggled == true)) {
			// Toggle the button off.
			isToggled = false;
			//console.log(isToggled);
		}
		// Run the command that's supposed to happen when pressing the button.
		// TODO: Make sure the button has a command, or don't have it run.
		// TODO 2: Block the button from being used if its command can't be used
		// right now, but this will probably be somewhere else.
		runCommand(buttonCommand);
	}
	
	Text {
		font.pointSize: RetiledStyles.FontStyles.extraextrasmallFontSize
		text: actionCenterButtonText
		//text: "FLASHLIGHT"
		//text: "ROTATION LOCK"
		//text: "AIRPLANE\nMODE"
		color: actionCenterActionButtonTextColor
	}
	
}
