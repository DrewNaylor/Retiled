// RetiledStart -  Windows Phone 8.x-like Start screen UI for the
//                 Retiled project.
// Copyright (C) 2021-2023 Drew Naylor
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
			// Important note: Don't do "anchors.fill: parent"
			// in RowLayouts similar to what we're doing here in Qt 6.4, because it'll break and your
			// stuff will be way off the screen.
			// See also: https://github.com/DrewNaylor/Retiled/issues/155
			//anchors.fill: parent
			
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
					fontFamily: metroFont.name
					pressedTextColor: ThemeLoader.getValueFromTheme(themePath, "Tiles", "TileRoundButtonPressedTextColor", "black")
					pressedBackgroundColor: ThemeLoader.getValueFromTheme(themePath, "Tiles", "TileRoundButtonPressedBackgroundColor", "white")
					// Make sure the buttons are aligned to the top.
					Layout.alignment: Qt.AlignTop
					// Set accessibility stuff:
					// https://doc.qt.io/qt-6/qml-qtquick-accessible.html
					// Didn't know this was a thing, but I learned about it
					// from a Mastodon post.
					// Partially copying from that page.
					Accessible.role: Accessible.Button
					Accessible.name: "Search button"
    				Accessible.description: "Opens a search box to search your All Apps list (not yet implemented)."
    				Accessible.onPressAction: {
        				// Click the button with the accessibility press feature:
						// https://stackoverflow.com/a/34332489
						// I really hope this works, because I don't really
						// have any way to test it as far as I know.
						clicked()
    				}
				} // End of the search button.
				
			} // End of the ColumnLayout that stores stuff like the Search button.
			
			ColumnLayout { // This stores the flickable for the All Apps list.
			// Adding this margin makes the All Apps list look almost
			// exactly like the Avalonia-based one, except there's 
			// a gap between the Search button and the items in the list
			// and I can't figure out what it is. The margin causes empty
			// space to be added permanently, though.
				//Layout.topMargin: 15
				// Ensure we're aligned to the top of the thing, as otherwise there'll be
				// an empty area at the top and we won't be able to have stuff go cleanly off the top of the window
				// (of course, there will be a small rectangle added eventually for the statusbar
				// background, but that'll be intentional so we'll know what's going on).
				// This also seems to be related to Qt 6.4, similar to not being able
				// to use "anchors.fill: parent" in the RowLayout above.
				Layout.alignment: Qt.AlignTop
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

				// We have to set the ListView's width to the window minus 50
				// so that the scrollbar shows up properly.
				width: window.width - 50
				// Not setting the height results in only one
				// item appearing.
				// I don't know if the height should be window.height.
				// "- 45" is just to have all the items show while there's
				// an appbar.
				height: window.height
				// Reuse items for less memory usage.
				// TODO: Figure out a way to allow reuseItems to be on
				// while also not having icons get replaced with other icons
				// in the list if an app doesn't have an icon specified.
				//reuseItems: true
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

				// Add a ScrollBar:
				// https://doc.qt.io/qt-6/qml-qtquick-controls2-scrollbar.html
				// TODO: Make it fade out more quickly like on WP.
				// Customize scrollbar:
				// https://doc.qt.io/qt-6/qtquickcontrols-customize.html#customizing-scrollbar
				ScrollBar.vertical: ScrollBar {
					// We're doing our own choices for the customizations.
					// TODO: Move it away from the edge a little.
					// TODO 2: Make it wider when putting the mouse over it for usability
					// like on Windows 10.
					width: 6
					opacity: 0.50
					contentItem: Rectangle {
						radius: 90
					}
				}
				
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
								// Make sure to set the height for the items:
								// https://forum.qt.io/topic/68757/qml-listview-memory-performance
								height: 60
								onClicked: allAppsListViewModel.RunApp(model.display)
								// Set pin to start stuff.
								dotDesktopFilePath: model.display
								onPinToStart: {
									// Visually pin the tile to start, then save the layout.
									tilesContainer.pinToStart(model.display);
									// allAppsListViewModel.PinToStart(model.display);
								}
								// Setup moveOtherAppsIntoBackground.
								//onMoveOtherAppsIntoBackground: {
									// Maybe something like this could work?
									// https://stackoverflow.com/a/64434328
									//repositionApps(index);
								//}
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
