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

// Bring in the custom styles.
import "../../../RetiledStyles" as RetiledStyles


    Item {
		
		
		// We need a small area on the left and an infinitely-expanding area on the right.
		// Wrapping ColumnLayouts inside a RowLayout should work.
		
		RowLayout {
			
			// Not sure if something from this page will help, but I'm trying:
			// https://stackoverflow.com/questions/66216383/why-can-i-not-make-a-qml-rowlayout-fill-a-columnlayouts-width
			anchors.fill: parent
			
			ColumnLayout {
				
				// Make sure the buttons are aligned to the top.
				Layout.alignment: Qt.AlignTop
				
				// Set margins for the ColumnLayout on the left.
				Layout.leftMargin: 10
				Layout.topMargin: 20
				Layout.rightMargin: 10
				
				RetiledStyles.RoundButton {
					// This is for the search button.
					text: qsTr("<b>S</b>")
					pressedTextColor: "black"
					pressedBackgroundColor: "white"
					// Make sure the buttons are aligned to the top.
					Layout.alignment: Qt.AlignTop
				} // End of the search button.
				
			} // End of the ColumnLayout that stores stuff like the Search button.
			
			ColumnLayout { // This stores the flickable for the All Apps list.
				
		Flickable {
			// The Flickable visibleArea group's properties
			// are often used to draw a scrollbar, which
			// will be useful in the All Apps list.
			// https://doc.qt.io/qt-6/qml-qtquick-flickable.html
			
			// Create an empty item above the All Apps list that
			// looks like a margin but isn't and allows scrolling
			// within it.
			// TODO: Figure out how to have the statusbar cover up
			// items in the All Apps list when you're scrolling, but
			// be transparent when in the tiles list.
			// This may require some way for apps to tell the window
			// manager/Wayland compositor that I'm probably going to
			// have to develop that the statusbar should look a certain way.
			// Actually, maybe it would be useful to just bake in a margin
			// and have the statusbar be transparent. Maybe there should
			// be a way to ensure it'll be opaque when running certain
			// apps though, mostly the ones that weren't built with it
			// in mind. Not sure how to do that.
			
			Column {
				
				// Trying to use the ListView:
				// https://doc.qt.io/qt-6/qml-qtquick-listview.html
				
			
			Item {
				// Spacer item above the All Apps list. Doesn't
				// seem to do anything with just a label here.
				height: 15
				width: 250
			} // End of the spacer item above the All Apps list.
			
			
			RetiledStyles.ButtonBase {
				text: qsTr("All Apps list")
				// For some reason, this only works
				// after resizing the window.
				// It needs to fill the rest of the area
				// inside the ColumnLayout that directly contains it.
				
				
			}
			} // End of the ColumnLayout that holds the app entries for the All Apps list.
			
		} // End of the All Apps list flickable.
		
			} // End of the All Apps list ColumnLayout, not to be confused with the one inside the Flickable.
		
		} // End of the RowLayout that holds both ColumnLayouts.
		
	} // End of the Item that's used to hold the All Apps page.
