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
//    it under the terms of the GNU Lesser General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU Lesser General Public License for more details.
//
//    You should have received a copy of the GNU Lesser General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

// Just import everything in this folder so QML doesn't complain
// about missing stuff.
import "." as RetiledStyles
import QtQuick


// Change the button to be like the All Apps list buttons on WP.
RetiledStyles.Button {
	
	// Set button height.
	buttonHeight: 60
	
	// Set text size.
	fontSize: 20
	
	// Add a property to store text because I
	// can't just put any property I want into
	// the button style.
	property string entryText: ""
	
	// Put something in setting text color.
	// Usually under the dark theme it'll be
	// white.
	property string textColor: "white"
	
	// Have a property for the icon background color.
	property string iconBackgroundColor: "#0050ef"
	
	Row {
		
		// Add an icon to the item.
	Rectangle {
		// For now, just use a rectangle filled with the user's
		// accent color, cobalt by default.
		// Some stuff from here may help a bit, and I'm trying to figure this out from some answers here:
		// https://stackoverflow.com/questions/27324318/how-to-make-image-to-fill-qml-controls-button
		width: 50
		height: 50
		color: iconBackgroundColor
	}
	
	Text {
		// Put the text back in the center according to this:
		// https://stackoverflow.com/a/35800196
		anchors.verticalCenter: parent.verticalCenter
				// Make the font bigger.
                font.pixelSize: fontSize
                text: entryText
                color: textColor
            }
			
	
	} // End of the row for the button and text.
	
} // End of the ButtonBase containing the All Apps list button item.











