// RetiledStart -  Windows Phone 8.x-like Start screen UI for the
//                 Retiled project.
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
		
		// Function for putting other apps into the background when
		// opening the All Apps list context menu.
		function repositionApps(index) {
			// We need to loop through the contentItem:
			// https://stackoverflow.com/a/45988187
			for (var i = 0; i < actualAppsList.contentItem.children.length; i++) {
				console.log(actualAppsList.contentItem.children[i].index);
				// Check the item we're looking at:
				// https://doc.qt.io/qt-6/qml-qtqml-models-listmodel.html#get-method
				if (actualAppsList.contentItem.children[i].index != index) {
					actualAppsList.contentItem.children[i].opacity = 0.5;
					actualAppsList.contentItem.children[i].scale = 0.9;
				} else {
					actualAppsList.contentItem.children[i].opacity = 1;
					actualAppsList.contentItem.children[i].scale = 1;
				}
			}
		}
		
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
				Layout.rightMargin: 5
				
				RetiledStyles.RoundButton {
					// This is for the search button.
					// TODO: implement searching.
					// This could be useful:
					// http://imaginativethinking.ca/use-qt-quicks-delegatemodelgroup/
					text: "<b>\ue031</b>"
					font: metroFont.font
					pressedTextColor: "black"
					pressedBackgroundColor: "white"
					// Make sure the buttons are aligned to the top.
					Layout.alignment: Qt.AlignTop
				} // End of the search button.
				
			} // End of the ColumnLayout that stores stuff like the Search button.
			
			ColumnLayout { // This stores the flickable for the All Apps list.
			// Adding this margin makes the All Apps list look almost
			// exactly like the Avalonia-based one, except there's 
			// a gap between the Search button and the items in the list
			// and I can't figure out what it is. The margin causes empty
			// space to be added permanently, though.
				//Layout.topMargin: 15
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
			
			
			
			ListView {
                id: actualAppsList
				width: window.width
				// Not setting the height results in only one
				// item appearing.
				// I don't know if the height should be window.height.
				// "- 45" is just to have all the items show while there's
				// an appbar.
				height: window.height
				// Clip the ListView or things don't scroll correctly.
				clip: true
				// We're using the ListView:
				// https://doc.qt.io/qt-6/qml-qtquick-listview.html
				// TODO: Add section headers that the user can click/tap on to get a
				// jump list to go to any part of the list with a specific letter.
				// The ListView actually has support for section headers built-in
				// and detailed at the ListView documentation:
				// https://doc.qt.io/qt-6/qml-qtquick-listview.html#section-prop
				//
				// We're currently basing the code for getting the items into the list
				// off the second part of this answer:
				// https://stackoverflow.com/a/59700406
				
				header: Item {
				// Spacer item above the All Apps list.
				// You have to set this as the ListView's header
				// in order for it to work.
				// This is not to be confused with section headers.
				height: 15
				} // End of the spacer item above the All Apps list.
			

			
			model: allAppsListItems.model
			delegate: Column { RetiledStyles.AllAppsListEntry { 
								//entryText: model.display
								entryText: allAppsListViewModel.GetDesktopEntryNameKey(model.display)
								//entryText: allAppsListViewModel.GetDesktopEntryNameKey("/usr/share/applications/" + name)
								// Width of the window - 50 ends up with buttons that fill the width like they're supposed to.
								width: window.width - 50
								onClicked: allAppsListViewModel.RunApp(model.display)
								// Set pin to start stuff.
								dotDesktopFilePath: model.display
								onPinToStart: {
									// Visually pin the tile to start, then save the layout.
									tilesContainer.pinToStart(model.display);
									// allAppsListViewModel.PinToStart(model.display);
								}
								// Setup moveOtherAppsIntoBackground.
								onMoveOtherAppsIntoBackground: {
									// Learned about index from here:
									// https://stackoverflow.com/a/25163706
									repositionApps(index);
								}
								//onClicked: allAppsListViewModel.RunApp("/usr/share/applications/" + dotDesktopFile)
								} // End of the Button delegate item in the listview.
			} // End of the Column that's the ListView's delegate.
			} // End of the ListView that holds the app entries for the All Apps list.
			
			
		} // End of the All Apps list flickable.
		
			} // End of the All Apps list ColumnLayout, not to be confused with the one inside the Flickable.
		
		} // End of the RowLayout that holds both ColumnLayouts.
		
		// Not sure how to make this work correctly.
		Component.onCompleted: allAppsListItems.getDotDesktopFilesInList()
		
	} // End of the Item that's used to hold the All Apps page.
