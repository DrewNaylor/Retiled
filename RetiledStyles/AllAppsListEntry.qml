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

// Just import everything in this folder so QML doesn't complain
// about missing stuff.
import "." as RetiledStyles
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal


// Change the button to be like the All Apps list buttons on WP.
RetiledStyles.Button {
	
	// Set button height.
	buttonHeight: 60
	buttonWidth: parent.width
	
	// Set text size.
	fontSize: 16
	
	// Remove the border.
	// You can comment this out if you need to debug the area around it.
	borderWidth: 0
	
	// Set the background color when pressing the button to transparent
	// to get rid of it.
	pressedBackgroundColor: "transparent"
	
	// Add a property to store text because I
	// can't just put any property I want into
	// the button style.
	property string entryText: ""
	
	// Put something in setting text color.
	// Usually under the dark theme it'll be
	// white.
	property string textColor: "white"
	
	// Have a property for the icon background color.
	property string iconBackgroundColor: Universal.accent
	
	// Open the context menu.
	onPressAndHold: allappscontextmenu.open()
	
	// Signal and property for the pin to start button.
	property string dotDesktopFilePath;
	signal pinToStart(string dotDesktopFilePath);
	
	// Adding the context menus:
	// https://doc.qt.io/qt-6/qml-qtquick-controls2-popup.html
	// Here's how to do it dynamically, which might help with
	// the tiles:
	// https://stackoverflow.com/a/45052339
	ContextMenu {
		id: allappscontextmenu
		width: window.width
		contentWidth: window.width
		modal: true
		// Center the popup in the window:
		// https://stackoverflow.com/a/45052225
		// We have to divide by -2 or it goes
		// off the right side of the screen.
		x: (width) / -2
		// Move the y position below the button so
		// it shows what you long-pressed on.
		// TODO: Fade/darken everything but the button we
		// long-pressed on into the background, or
		// whatever WP does.
		// TODO 2: Move the button that was long-pressed
		// into the view if it's partially offscreen.
		y: parent.y + 60
		// TODO: Ensure the context menu doesn't get its
		// background pushed away from the button,
		// which can happen when the user long-presses
		// on an app at the top of the list.
		// TODO 2: Prevent the user from scrolling the
		// All Apps list if they continue to touch
		// the screen after the context menu opens,
		// unless that's part of WP. I'll have to check.
		// We're using the column layout.
		Column {
			anchors.fill: parent
			// ButtonBase {
				// width: parent.width
				// text: qsTr("pin to start")
				// // Set font style to opensans.
				// font.family: "Open Sans"
				// font.weight: Font.Normal
				// onClicked: pinToStart(dotDesktopFilePath)
			// }
			
			// Another spacer item above.
			Item {
				height: 17
				width: window.width
			}
			
			ContextMenuButton {
				width: window.width
				textColor: "black"
				borderColor: "transparent"
				pressedBackgroundColor: "transparent"
				text: qsTr("pin to start")
				// TODO: Figure out why the font
				// on this button looks way more bold
				// than it does in the search app, even
				// though the button template uses the
				// same weight for each.
				onClicked: {
					// Hide the context menu.
					allappscontextmenu.visible = false;
					pinToStart(dotDesktopFilePath);
				}
			}
			
			// Add a spacer item at the bottom.
			// Not sure why it's there in WP, but I guess it looks better.
			Item {
				height: 62
				width: window.width
			}
		}
	}
	
	Row {
		// Fill the button so we can align things properly.
		anchors.fill: parent
		// Add spacing between the icon and the text:
		// https://stackoverflow.com/a/24361104
		spacing: 10
		// Add an icon to the item.
	Rectangle {
		// For now, just use a rectangle filled with the user's
		// accent color, cobalt by default.
		// Some stuff from here may help a bit, and I'm trying to figure this out from some answers here:
		// https://stackoverflow.com/questions/27324318/how-to-make-image-to-fill-qml-controls-button
		width: 50
		height: 50
		color: iconBackgroundColor
		// Align the icon area to the top and bottom so it's stretched.
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		// A margin needs to be added to ensure it's the right size.
		anchors.topMargin: 5
		anchors.bottomMargin: 5
		// Have the rectangle be antialiased.
		antialiasing: true
	}
	
	Text {
		// Put the text back in the center according to this:
		// https://stackoverflow.com/a/35800196
		anchors.verticalCenter: parent.verticalCenter
				// Make the font bigger.
				// pixelSize isn't device-independent.
                font.pointSize: fontSize
                text: entryText
                color: textColor
				// Set font style to opensans.
				font.family: "Open Sans"
				font.weight: Font.Normal
            }
			
	
	} // End of the row for the button and text.
	
} // End of the ButtonBase containing the All Apps list button item.











