// RetiledStyles - Windows Phone 8.x-like QML styles for the
//                 Retiled project. Some code was copied from
//                 the official qtdeclarative repo, which you can
//                 access a copy of here:
//                 https://github.com/DrewNaylor/qtdeclarative
// Copyright (C) 2021 Drew Naylor
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

// Tried to do import ButtonBase but QML said
// the style wasn't installed, so I'm just
// importing everything in this folder
// until I can figure out a better solution.
// Also qualify the name to ensure there's
// no clashing with QML.
import "." as RetiledStyles
import QtQuick

RetiledStyles.Button {
	id: control
	
	// TODO: Figure out how to properly center buttons.
	// I may have to change this in ButtonBase.
	
	// Add two properties to change the text color
	// on being pressed down.
	property string pressedTextColor: "white"
	property string defaultTextColor: "white"
	
	// Set button properties.
	borderRadius: 90
	
	// We're defaulting to use cobalt as most round
	// buttons will probably use accent colors.
	// Round buttons as used on the Start screen will
	// have to set this to black or white accordingly.
	pressedBackgroundColor: "#0050ef"
	
	// Some round buttons have to have their background
	// color set too, such as the tile editing ones.
	// unpressedBackgroundColor: "transparent"
	
	// Set the size to be small.
	buttonWidth: 32
	buttonHeight: 32
	
	// Set font size.
	fontSize: 10
	
	// Get rid of padding.
	padding: 0
	verticalPadding: 0
	
	// Change text color on down.
	textColor: control.down ? control.pressedTextColor : control.defaultTextColor
}