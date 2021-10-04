// PyRetiledStart -  Windows Phone 8.x-like Start screen UI for the
//                   Retiled project. Once this version reaches
//                   feature-parity with the Avalonia version, "Py"
//                   will be removed from the name and the original
//                   will be archived.
// Copyright (C) 2021 Drew Naylor
// (Note that the copyright years include the years left out by the hyphen.)
// Windows Phone and all other related copyrights and trademarks are property
// of Microsoft Corporation. All rights reserved.
//
// This file is a part of the Retiled project.
// Neither Retiled nor Drew Naylor are associated with Microsoft
// and Microsoft does not endorse Retiled.
// Any other copyrights and trademarks belong to their
// respective people and companies/organizations.
//
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
	
	
	Shortcut {
		sequences: ["Esc", "Back"]
        onActivated: {
			
			// Go back to the tiles list.
            startScreenView.currentIndex = 0
			// Also set the flickable's contentY property to 0
			// so it goes back to the top, like on WP:
			// https://stackoverflow.com/a/7564705
			tilesFlickable.contentY = 0
			
        }
    }
	
	SwipeView {
		id: startScreenView
		currentIndex: 0
		anchors.fill: parent

	// Note: You have to use "Item" for each
	// of the pages in the SwipeView, or it
	// gets into an endless loop.
    Item {
	Flickable {
		// Gotta set a bunch of properties so the Flickable looks right.
		// TODO: Change the scrolling so it's more loose and doesn't feel like
		// it's dragging as much.
		// TODO 2: Fix "QML Flickable: Binding loop detected for property "contentWidth""
		// error that shows up on the PinePhone.
		anchors.fill: parent
		anchors.margins: 10
		anchors.topMargin: 37
		id: tilesFlickable
		// Trying to go from this:
		// https://stackoverflow.com/a/8902014
		contentWidth: tilePageContentHolder.width
		contentHeight: tilePageContentHolder.height
		// Very important: Lock the flickable to vertical.
		// I noticed this when I was just trying to find
		// a way to disengage the flickable if the user
		// is flicking horizontally in the docs.
		flickableDirection: Flickable.VerticalFlick
		width: parent.width
		height: parent.height
		// I mostly copied this from my modified version of the Qml.Net example app.
		// Code for the About.qml file here:
		// https://github.com/DrewNaylor/wp-like_qmlnet-examples/blob/master/src/Features/pages/About.qml
		
		ColumnLayout {
			id: tilePageContentHolder
		
		
		
		// We'll use Flow to get the buttons to wrap
		// to each line. This may not be what I'll
		// always use, though.
		// Docs:
		// https://doc.qt.io/qt-6/qml-qtquick-flow.html
		// SO example:
		// https://stackoverflow.com/a/38532138
		Flow {
			spacing: 10
			// Make sure the buttons stay in the tiles area.
			width: window.width
			// Set layout to the center.
			Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
			// Note: None of the tiles are properly colored
			// or styled yet. I need to make a style to
			// apply to them so that a whole bunch of space
			// doesn't get taken up.
			Button {
				text: qsTr("cobalt-colored tile")
				width: 150
				height: 150
				// Scale down the button when pressed.
				scale: down ? 0.98 : 1.0
				// TapHandler seemed to interfere with how
				// the button looked when using it, but
				// there's an onPressAndHold event we can
				// use instead:
				// https://stackoverflow.com/a/62000844
				onPressAndHold: console.log("We can definitely do this!")
				onClicked: console.log("The future doesn't belong to you!")
				}
				Button {
				text: qsTr("cobalt-colored tile")
				width: 150
				height: 150
				}
				Button {
				text: qsTr("cobalt-colored tile")
				width: 310
				height: 150
				}
				Button {
				text: qsTr("cobalt-colored tile")
				width: 150
				height: 150
				}
				Button {
				text: qsTr("cobalt-colored tile")
				width: 70
				height: 70
				}
				Button {
				text: qsTr("cobalt-colored tile")
				width: 70
				height: 70
				}
				Button {
				text: qsTr("cobalt-colored tile")
				width: 70
				height: 70
				}
				Button {
				text: qsTr("cobalt-colored tile")
				width: 70
				height: 70
				}
				Button {
				text: qsTr("cobalt-colored tile")
				width: 150
				height: 150
				}
				Button {
				text: qsTr("cobalt-colored tile")
				width: 150
				height: 150
				}
			}
	
		Button {
			id: allAppsButton
			text: qsTr("->")
			// Layout.alignment only works in QML's
			// "Layout" types, like ColumnLayout,
			// RowLayout, and GridLayout.
			Layout.alignment: Qt.AlignRight | Qt.AlignBottom
			// Open the All Apps list.
			// I'll use a SwipeView:
			// https://doc.qt.io/qt-6/qml-qtquick-controls2-swipeview.html
			onClicked: {
				startScreenView.currentIndex = 1
						}
				}	

	
		}
	}
	}
	
	Item {
		
		Flickable {
			// The Flickable visibleArea group's properties
			// are often used to draw a scrollbar, which
			// will be useful in the All Apps list.
			// https://doc.qt.io/qt-6/qml-qtquick-flickable.html
			
			Label {
				text: qsTr("All Apps list")
				
			}
			
		}
		
	}
	
}
}