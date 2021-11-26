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
import "."
import QtQuick

ButtonBase {
	// We need to change things to make it into a tile.
	id: control
	
	// Add properties.
	property string tileText: "tile"
	property int fontSize: 14
	property string textColor: "white"
	property string tileBackgroundColor: "#0050ef"
	// We have to add a property for the button's exec key
	// so that we can add an event handler:
	// https://stackoverflow.com/a/22605752
	property string execKey;
	signal clicked(string execKey);
	
	// Set padding values.
	// These values and the fontSize may be incorrect, at least with WP7:
	// https://stackoverflow.com/a/8430030
	leftPadding: 10
	topPadding: 0
	rightPadding: 0
	bottomPadding: 6
	
	// Add a mousearea to allow for clicking it.
	MouseArea {
		anchors.fill: parent
		onClicked: parent.clicked(parent.execKey)
		// Scaling the buttons down then back up
		// is done by setting scale values for both
		// onPressed and onReleased.
		// If only one is set, the button won't come
		// back up and will stay depressed, like me
		// during most of 2020.
		onPressed: control.scale = 0.98
		onReleased: control.scale = 1.0
	}
	
	// Override the contentItem using the one from Button.
	contentItem: Text {
		// I couldn't figure out why things weren't
		// working, but it turns out that you can't
		// have another contentItem in the button in
		// the window or it'll override this style's
		// contentItem.
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
				// Make the font bigger.
                font.pixelSize: control.fontSize
                text: control.tileText
                color: control.textColor
				// Turn off ellipsis.
				elide: Text.ElideNone
				// Ensure that text doesn't just go out of
				// the tiles.
				clip: true
            }
	
	background: Rectangle {
		// Change tile color and stuff.
				color: control.tileBackgroundColor
                border.width: 0
                radius: 0
	}
	
}