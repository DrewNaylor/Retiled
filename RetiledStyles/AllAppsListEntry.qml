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
	fontSize: RetiledStyles.FontStyles.normalFontSize
	
	// Remove the border.
	// You can comment this out if you need to debug the area around it.
	borderWidth: 0
	
	// Set the background color when pressing the button to transparent
	// to get rid of it, if the theme says to.
	pressedBackgroundColor: ThemeLoader.getValueFromTheme(themePath, "AllAppsListEntry", "PressedBackgroundColor", "transparent")
	
	// Add a property to store text because I
	// can't just put any property I want into
	// the button style.
	property string entryText: ""
	
	// Put something in setting text color.
	// Usually under the dark theme it'll be
	// white.
	property string textColor: ThemeLoader.getValueFromTheme(themePath, "AllAppsListEntry", "TextColor", "white")
	
	// Have a property for the icon background color.
	property string iconBackgroundColor: ThemeLoader.getValueFromTheme(themePath, "AllAppsListEntry", "UseAccentForIconBackground", "true") === "true" ? accentColor : ThemeLoader.getValueFromTheme(themePath, "AllAppsListEntry", "AlternateIconBackgroundColor", "transparent")
	
	// Signal for moving other apps into the background.
	// Commented out for now because I can't figure it out.
	//signal moveOtherAppsIntoBackground();
	
	// Open the context menu and move other apps into the background.
	onPressAndHold: {
		//moveOtherAppsIntoBackground();
		allappscontextmenu.open();
	}
	
	// Turning off tilting by default because it can be an issue
	// due to it not being constrained to not be way too much yet,
	// as moving to the edge causes it to flicker.
	// This is an issue on the edges of the control.
	// TODO: Figure out how to make tilting smooth.
	// Now we're trying to bring it back, but it's a bit jittery with
	// the pause animation. Maybe it should be removed?
	//tilt: allowTilt
	
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
		// TODO: Add the animation of the context menu "drawing"
		// into reality and smoothly opening downward.
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
		// Now the context menu stays onscreen even if it'd
		// be below the window, but if it's too small it kinda
		// gets squished in the top. Shouldn't be an issue, though.
		y: parent.parent.y + 100 > window.height - 100 ? parent.y - 150 : parent.y + 60
		// TODO: Ensure the context menu doesn't get its
		// background pushed away from the button,
		// which can happen when the user long-presses
		// on an app at the top of the list. Note that
		// this only sometimes happens and it varies
		// depending on how close to the top of the
		// All Apps list that a given item is, so it won't
		// necessarily get messed up, only sometimes.
		// TODO 2: Prevent the user from scrolling the
		// All Apps list if they continue to touch
		// the screen after the context menu opens,
		// unless that's part of WP. I'll have to check.
		// We're using the column layout.
		Column {
			anchors.fill: parent
			
			// Another spacer item above.
			Item {
				height: 17
				width: window.width
			}
			
			ContextMenuButton {
				width: window.width
				textColor: ThemeLoader.getValueFromTheme(themePath, "ContextMenuButton", "TextColor", "black")
				borderColor: ThemeLoader.getValueFromTheme(themePath, "ContextMenuButton", "BorderColor", "transparent")
				// Hide the border if it's set to 0 in the theme.
				borderWidth: ThemeLoader.getValueFromTheme(themePath, "ContextMenuButton", "BorderWidth", "0")
				pressedBackgroundColor: ThemeLoader.getValueFromTheme(themePath, "ContextMenuButton", "PressedBackgroundColor", "transparent")
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

		Image {
			// Temporarily grabbing icons directly from the hicolor
			// theme based on this AskUbuntu answer, notably the "appending
			// a name to a hardcoded path" thing:
			// https://askubuntu.com/a/351924
			// Update: now we're grabbing them via pyxdg.
			// TODO: Properly get the icon size we need here rather
			// than just doing the 96x96 version that's hardcoded in
			// main.py.
			id: appIcon
			source: getAppIcon.getIcon(dotDesktopFilePath, iconTheme)
			anchors.fill: parent
			// Just pad out the image; got the Image.Pad
			// thing from the QtQuick Image link below.
			fillMode: Image.Pad
			// Set image to be async so the UI loads faster:
			// https://doc.qt.io/qt-6/qml-qtquick-image.html#asynchronous-prop
			asynchronous: true
			// Set the image source size to 44 for now,
			// until there's a way to actually get the
			// nearest correct icon size.
			// Modified from here:
			// https://doc.qt.io/qt-6/qml-qtquick-image.html#sourceSize-prop
			// The division by 1.6 value here is from this SO answer:
			// https://stackoverflow.com/a/12958512
			// It honestly looks pretty good for medium tiles,
			// but the wide ones are a bit strange.
			// Of course, that's just for testing images. Only issue
			// is I'll have to figure out how to handle wide icons
			// when they're not intended to be wide in the wide
			// tiles if a program doesn't have a wide icon available.
			// NOTE: This was copied from Tile.qml, and there may need
			// to be changes to accommodate the All Apps list specifically.
			// Actually we're setting the source width and height,
			// and image element width and height to 44 because I read
			// that's what Windows Phone did. I'll have to add where I
			// read that.
			// Now I'm testing at 48.
			// Actually, I'm using 42 now, as the distance between the Kate
			// icon and the edge of the rectangle is 7 pixels that way,
			// which is the same as for the Cortana logo in a screenshot
			// I have from the emulator. I chose those two icons because
			// they're both circular.
			// TODO: Figure out why the Firefox icon and a few others like Koko
			// are blurry when they shouldn't be (Firefox in particular has
			// a 96x96 icon).
			sourceSize.width: 42
			sourceSize.height: 42
			height: 42
			width: 42
		}
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
				font.family: RetiledStyles.FontStyles.regularFont
				font.weight: RetiledStyles.FontStyles.regularFontWeight
            }
			
	
	} // End of the row for the button and text.
	
} // End of the ButtonBase containing the All Apps list button item.











