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


// Importing everything in this folder
// until I can figure out a better solution.
import "." as RetiledStyles
import QtQuick
import QtQuick.Controls



RetiledStyles.AppBarDrawerBase {
    // TODO: Figure out a way to allow the drawer to be closed from any
    // page and not just from clicking inside the main page or clicking
    // on any of the items in the drawer.
    // TODO 2: Figure out how to let the user drag the app bar back down
    // on both the right and the left side to close the
    // drawer, like on Windows Phone.
	// TODO 3: Move the customizations to AppBarDrawer.qml so that
	// more apps can use this customized appbar drawer.
	// TODO 4: Prevent the appbar drawer from being able to be closed
	// by dragging downward on the items in it or by clicking anywhere
	// on the appbar other than the ellipsis/more button or the empty
	// spot on the left side of the appbar.
        id: control
        width: window.width
        // Set height to 165 so that there's enough space for the pages,
        // but allow it to be changed by apps.
        property int appbarDrawerHeight: 165
        height: appbarDrawerHeight
		// Not sure what Interactive means, but I'll guess it determines
		// if you can interact with the app drawer.
        interactive: stackView.depth === 1
        // Setting edge to Qt.BottomEdge makes the menu
        // kinda look like WP's ellipsis menu, except it
        // doesn't yet move the bar up. Maybe a translation
        // thing will help with that.
        // Edge documentation:
        // https://doc.qt.io/qt-5/qml-qtquick-controls2-drawer.html#edge-prop
        edge: Qt.BottomEdge
		
		// Set font.
		font.family: RetiledStyles.FontStyles.semiboldFont
		font.weight: RetiledStyles.FontStyles.semiboldFontWeight
		// TODO: Move letter spacing into the control.
		//font.letterSpacing: -0.8 * scaleFactor

        property ListModel drawerItems;


        // Removing the shadow from the drawer:
        // https://stackoverflow.com/a/63411102
        

       Rectangle {
       // You have to set this rectangle's color
       // or else it'll be white.
            anchors.fill: parent
            color: "transparent"
        

// TODO: Figure out how to have tabbing and arrow keys work correctly in the appbar drawer
// and the appbar itself, once that's implemented.
        ListView {
            id: appbarDrawerListView
            anchors.fill: parent
            clip: true
            focus: true

            delegate: RetiledStyles.AppBarDrawerEntry {
                width: parent.width
                text: model.title
                onClicked: {
					// Only navigate to another page if the item says to.
					// Sometimes you don't want to navigate, so that's why
					// it has to be specified.
					if (model.navigate === "true"){
						stackView.push(model.source)
						// Set the appbar drawer's color to transparent.
						control.backgroundColor = "transparent"
						// Close the appbar drawer.
						control.close()
						// Show the back button to allow navigating back.
						backButtonVisible = true
						// Have the appbar be transparent.
						appBar.backgroundColor = "transparent"
						// Hide the ellipsis button.
						appbarEllipsisButtonVisible = false
					} else {
						// This is just a test for now to allow commands
						// to be used from the appbar.
						// An example would be pinning something to Start.
						console.log(model.command)
						// We should also close the appbar drawer.
						control.close()
					}

                }
            }

			// Note: these pages here will eventually be replaced
			// with items that would be in a settings app's appbar drawer,
			// and not ones that are now in the main list.
            model: drawerItems

			// TODO: Improve the shape of the scrollbar
			// so it's closer to WP.
            ScrollIndicator.vertical: ScrollIndicator { }
            }
        }
    }