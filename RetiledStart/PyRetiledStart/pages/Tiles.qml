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
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Universal

// Bring in the custom styles.
import "../../../RetiledStyles" as RetiledStyles

// Bring in the All Apps page.
import "." as RetiledStartPages

ApplicationWindow {
	
	id: window
    width: 360
    height: 720
    visible: true
    title: qsTr("RetiledStart")

    Universal.theme: Universal.Dark
    Universal.accent: '#0050ef'
	Universal.foreground: 'white'
	// Fun fact: QML supports setting the background to transparent,
	// which shows all the other windows behind the app's window as you'd expect.
	// This will probably be useful when working on stuff like the volume controls and Action Center.
	Universal.background: 'black'
	
	// Global edit mode property so we can check to see if
	// edit mode is turned on globally when tapping a tile.
	// If it is, we'll turn local edit mode on for that tile
	// and turn off edit mode for the previous tile.
	// Note that global edit mode is exited when either
	// a tile is tapped again in edit mode, or by tapping
	// anywhere outside the tiles.
	// This requires looking at the tile that previously had edit mode
	// in order to remove local edit mode from that tile.
	// I'll have to use integers for it.
	// Turning on and off global edit mode will probably use
	// signals, as it's turned on when long-pressing on
	// a tile and turned off when tapping a tile.
	property bool globalEditMode: false
	
	// This is the index for the tile that was previously
	// in editing mode so we can remove the buttons from it.
	// Set this after turning local edit mode on for a tile.
	// Also set this to the first tile long-pressed if
	// global edit mode is off.
	property int previousTileInEditingModeIndex;
	
	// We're using this to keep track of how many tiles
	// are on Start. Adding a tile increases this number
	// by 1, and unpinning a tile decreases it by 1.
	// This is checked every time a tile is pinned or unpinned
	// to see whether the tiles page should be shown or hidden.
	property int pinnedTilesCount: 0
	
	// Save the default animation time for the swipeview.
	property int defaultSwipeViewMoveAnimationDuration: startScreenView.contentItem.highlightMoveDuration
	
	// Load Open Sans ~~SemiBold~~ Regular (see below) for the tile text:
	// https://stackoverflow.com/a/8430030
	// It's possible that Windows Phone switched to
	// a different style of Segoe for its tiles
	// in WP8, so perhaps the WindowsPhoneToolkit
	// repo can help:
	// https://github.com/microsoftarchive/WindowsPhoneToolkit
	// My fork, in case that one goes down:
	// https://github.com/DrewNaylor/WindowsPhoneToolkit
	// Actually, turns out the HubTileSample uses the regular
	// font style:
	// https://github.com/microsoftarchive/WindowsPhoneToolkit/blob/master/PhoneToolkitSample/Samples/HubTileSample.xaml#L19
	// Note: Context menus use SemiLight, which isn't available in Open Sans,
	// so I'll probably just use Regular for them.
	FontLoader {
			id: opensansRegular
			// This is using the Open Sans font, which you can
			// find here:
			// https://fonts.google.com/specimen/Open+Sans
			// This font was designed by Steve Matteson and is under the Apache License, Version 2.0:
			// http://www.apache.org/licenses/LICENSE-2.0
			source: "../../../fonts/open_sans/static/OpenSans/OpenSans-Regular.ttf"
		}
	
	
	Shortcut {
		id: backButtonShortcut
		sequences: ["Esc", "Back"]
        onActivated: {
			
			// Go back to the tiles list.
            startScreenView.currentIndex = 0
			// Also set the flickable's contentY property to 0
			// so it goes back to the top, like on WP:
			// https://stackoverflow.com/a/7564705
			tilesFlickable.contentY = 0
			
			// TODO: Figure out how to make this
			// not conflict with the keyboard shortcut
			// in the main window's file that goes back.
			
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
		
		RowLayout {
			
			Item {
				// Empty item that acts as a margin on the left of the
				// tiles so it can be scrolled, as margins don't allow scrolling.
				width: 10
			}
		
		ColumnLayout {
			id: tilePageContentHolder
		
		Item {
			// Create an empty item so the area above
			// the tiles works as a scrollable area.
			height: 37
			
		}
		
		// We'll use Flow to get the buttons to wrap
		// to each line. This may not be what I'll
		// always use, though.
		// Docs:
		// https://doc.qt.io/qt-6/qml-qtquick-flow.html
		// SO example:
		// https://stackoverflow.com/a/38532138
		Flow {
			id: tilesContainer
			spacing: 10
			// Make sure the buttons stay in the tiles area.
			width: window.width
			// Set layout to the center.
			Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
			// Might use this example since it includes adding and removing stuff if I can figure out how to make
			// a different one work for the All Apps list:
			// https://code.qt.io/cgit/pyside/pyside-setup.git/tree/examples/declarative/editingmodel
				//RetiledStyles.Tile {
				//tileText: qsTr("cobalt-colored tile")
				//width: 150
				//height: 150
				//// TapHandler seemed to interfere with how
				//// the button looked when using it, but
				//// there's an onPressAndHold event we can
				//// use instead:
				//// https://stackoverflow.com/a/62000844
				//onPressAndHold: console.log("We can definitely do this!")
				//onClicked: console.log("The future doesn't belong to you!")
				//}
				//RetiledStyles.Tile {
				//tileText: qsTr("WP8.1 app with a really long name")
				//width: 150
				//height: 150
				//// You can access code in the main.py file from QML sub-pages.
				//onClicked: allAppsListViewModel.getDotDesktopFiles()
				//}
				//RetiledStyles.Tile {
				//tileText: qsTr("WP8.1 app with a really long name")
				//width: 310
				//height: 150
				//onClicked: tilesListViewModel.getTilesList()
				//}
				//RetiledStyles.Tile {
				//tileText: qsTr("WP8.1 app with a really long name")
				//width: 150
				//height: 150
				//}
				//RetiledStyles.Tile {
				//tileText: qsTr("WP8.1 app with a really long name")
				//width: 70
				//height: 70
				//}
				
				// Set up the tile click signals.
				function tileClicked(execKey) {
					tilesListViewModel.RunApp(execKey);
				}
				
				// Set up the signals for the tile context menu.
				// Unpin tiles.
				function unpinTile(dotDesktopFilePath) {
					tilesListViewModel.UnpinTile(dotDesktopFilePath);
				}
				// Resize tiles.
				function resizeTile(dotDesktopFilePath, newTileWidth, newTileHeight) {
					tilesListViewModel.ResizeTile(dotDesktopFilePath, newTileWidth, newTileHeight);
				}
				
				// Turn on or off global edit mode.
				function toggleGlobalEditMode(enable) {
					// If enable is false, global edit mode will be
					// turned off. Likewise, if it's true, it'll be
					// turned on.
					globalEditMode = enable;
					
					// Set the visibility of the All Apps list button
					// and the ability to use the swipeview to the
					// "enable" boolean, too.
					// We have to use the opposite of enable, actually.
					allAppsButton.visible = !enable;
					startScreenView.interactive = !enable;
					
					// Now if global edit mode gets turned off, we
					// need to save the tile layout.
					if (globalEditMode == false) {
						// Create a list of the tiles to send to Python:
						// https://stackoverflow.com/a/24747608
						var tilesList = [];
						// Loop through the tiles and add them to the list
						// if their visible property is set to "true".
						for (var i = 0; i < tilesContainer.children.length; i++) {
							if (tilesContainer.children[i].visible == true) {
								// Get the properties from the tiles
								// and add them to the list.
								var tile = {};
								tile['DotDesktopFilePath'] = tilesContainer.children[i].dotDesktopFilePath;
								tile['TileWidth'] = tilesContainer.children[i].width;
								tile['TileHeight'] = tilesContainer.children[i].height;
								tile['TileColor'] = tilesContainer.children[i].tileBackgroundColor;
								// Push the tile to the list.
								// TODO: Prevent sorting.
								tilesList.push(tile);
							} // End of If statement checking if the tile is visible.
						} // End of loop that goes through the tiles to save.
						// Send the list of tiles to Python so it can save
						// changes to the config file and remove any unpinned tiles.
						tilesListViewModel.SaveTileLayout(tilesList);
					} // End of the check to see if we're in global edit mode.
				} // End of the global edit mode toggle function.
				
				// Hide the local edit mode controls on the previously-active tile.
				function hideEditModeControlsOnPreviousTile(previousTileInEditingModeIndex) {
					// Use the previous tile index to hide the buttons on the previous tile.
					// The moderator's answer here should work:
					// https://forum.qt.io/post/234640
					for (var i = 0; i < tilesContainer.children.length; i++) {
						// Loop through the children of the tilesContainer flow
						// and find the tile that has the same tileIndex as the tile
						// that was previously in editing mode.
						if (tilesContainer.children[i].tileIndex == previousTileInEditingModeIndex) {
							// Now hide the buttons and turn edit mode off for that tile.
							// The visibility of the edit mode buttons is tied to editMode.
							tilesContainer.children[i].editMode = false;
							tilesContainer.children[i].z = tilesContainer.children[i].z - 1;
						}
					}
				} // End of the function that hides edit mode controls on the previous tile.
				
				// Set opacity to 0.5 for tiles not in edit mode.
				function setTileOpacity() {
					// We need to see if the tile is currently in edit mode.
					for (var i = 0; i < tilesContainer.children.length; i++) {
						// Make sure tiles are set back to 1.0 opacity
						// when leaving global edit mode, too.
						if ((tilesContainer.children[i].editMode == true) || (globalEditMode == false)) {
							tilesContainer.children[i].opacity = 1.0;
							// Set scale back to 1.0.
							tilesContainer.children[i].scale = 1.0;
						} else {
							// When in global edit mode, we have to set all
							// tiles that aren't in local edit mode to 50% opacity.
							tilesContainer.children[i].opacity = 0.5;
							// Change scale to 0.9 for all the other tiles
							// so they look like they're in the background.
							tilesContainer.children[i].scale = 0.9;
						}
					}
				} // End of the tile-opacity function.
				
				// Hide or show tiles page based on the current number of tiles.
				function checkPinnedTileCount(numberToChangePinnedTilesCountBy, showAnimation) {
					// Add the number to change the pinned tiles count by.
					// This can be positive or negative, as we're using addition.
					pinnedTilesCount = pinnedTilesCount + numberToChangePinnedTilesCountBy;
					
					// TODO: Include this when pinning tiles. Actually, I think what
					// can be done is that we can get the All Apps button's y-value
					// and scroll to it to show the newly-added tile. Hopefully that
					// works.
					
					// Check whether the pinnedTilesCount is above 0, and show the pinned
					// tiles list if it's currently not showing.
					if (pinnedTilesCount > 0) {
						// Set the interactivity of the SwipeView back to True
						// if it's currently false:
						// https://doc.qt.io/qt-6/qml-qtquick-controls2-swipeview.html#interactive-prop
						if (startScreenView.interactive == false) {
							// Allow it to be interactive again and switch to it.
							startScreenView.interactive = true;
							startScreenView.currentIndex = 0;
							// Show the All Apps button again, too.
							allAppsButton.visible = true;
							// Reset the Back button/Escape key shortcut.
							backButtonShortcut.enabled = true;
						} // End of if statement seeing if the swipeview is currently interactive.
					} else {
						// There are either 0 or fewer tiles pinned, so hide the tiles page.
						// It's unlikely that there will be fewer than 0 tiles, but
						// I'm just allowing for the possibility to ensure things don't break.
						if (startScreenView.interactive == true) {
							// Prevent interaction with the swipeview,
							// lock the user to the All Apps list, and
							// hide the All Apps button.
							startScreenView.interactive = false;
							// Turn off the animation so the All Apps list is right there:
							// https://forum.qt.io/topic/81535/swipeview-page-change-without-animation
							// Set the animation to 0 if the calling code wants it.
							// This is the case if no tiles are pinned on startup,
							// but if they're unpinned at runtime, we need to have
							// an animation.
							if (showAnimation == false) {
								startScreenView.contentItem.highlightMoveDuration = 0
							}
							startScreenView.currentIndex = 1;
							allAppsButton.visible = false;
							// Turn off the back button shortcut.
							backButtonShortcut.enabled = false;
							// Loop through the tiles list and make sure they're
							// all hidden, because I was having an issue where
							// one would remain for some reason.
							for (var i = 0; i < tilesContainer.children.length; i++) {
								if (tilesContainer.children[i].visible == true) {
								// Get the properties from the tiles
								// and add them to the list.
								tilesContainer.children[i].visible = false;
								} // End of If statement checking if the tile is visible.
							} // End of for loop checking if any tiles are visible when they shouldn't be.
							// Exit global edit mode.
							toggleGlobalEditMode(false);
							// Set the animation duration back to the default, since we're
							// probably already in the all apps list.
							// Didn't know this is what the original post actually did
							// until I read it again.
							// NOTE: You have to wait a little while, or it won't be instant.
							startScreenView.contentItem.highlightMoveDuration = defaultSwipeViewMoveAnimationDuration
						} // End of if statement seeing if the swipeview is currently interactive.
					} // End of if statement checking if the number of pinned tiles is above 0.
				} // End of function checking the pinned tile count.
				
				Component.onCompleted: {
					
					// Start looping through the list provided by Python
					// so it can be parsed as JSON.
					
					// We're using the last example here, with the books:
					// https://www.microverse.org/blog/how-to-loop-through-the-array-of-json-objects-in-javascript
					// Most of that example was used in the for loop below, but I changed some stuff.
					var TilesList = tilesListViewModel.getTilesList();
					//console.log(TilesList)
					
					// Remember to parse the JSON.
					// I forgot to do this and couldn't
					// figure out why it wouldn't work.
					var ParsedTilesList = JSON.parse(TilesList);
					
					// Make sure the tiles list isn't just an empty list
					// before we create the tiles list. This allows the user
					// to just not have tiles if they don't want to.
					if (ParsedTilesList.length > 0) {
					
					// Create the tiles dynamically according to this page:
					// https://doc.qt.io/qt-6/qtqml-javascript-dynamicobjectcreation.html
					// We're doing this outside the loop, because that's what the docs
					// did and it's probably faster/less memory-intensive.
					// TODO: Check if this can be changed to RetiledStyles.Tile.
						var TileComponent = Qt.createComponent("../../../RetiledStyles/Tile.qml");
					
						for (var i = 0; i < ParsedTilesList.length; i++){
						//console.log(ParsedTilesList[i].DotDesktopPath);
						//console.log(ParsedTilesList[i].TileAppNameAreaText);
						//console.log(ParsedTilesList[i].TileWidth);
						//console.log(ParsedTilesList[i].TileHeight);
						//console.log(ParsedTilesList[i].TileColor);
						//console.log("------------------------");
						
						// Now create the tile.
						// Make sure it's ready first.
						// TODO: Switch to incubateObject.
						//if (TileComponent.status == Component.Ready) {
							var NewTileObject = TileComponent.createObject(tilesContainer);
						// Increment the tile count.
							checkPinnedTileCount(1, true);
						// Set tile properties.
							NewTileObject.tileText = ParsedTilesList[i].TileAppNameAreaText;
							NewTileObject.width = ParsedTilesList[i].TileWidth;
							NewTileObject.height = ParsedTilesList[i].TileHeight;
							NewTileObject.tileBackgroundColor = ParsedTilesList[i].TileColor;
						// Doesn't quite work on Windows because the hardcoded tile is trying to read
						// from /usr/share/applications and can't find Firefox.
						// Turns out it was trying to run Firefox. Not sure how to stop that.
						// Actually, I think this involves an event handler:
						// https://stackoverflow.com/a/22605752
							NewTileObject.execKey = ParsedTilesList[i].DotDesktopFilePath;
						
						// Set the .desktop file path for unpinning or resizing.
							NewTileObject.dotDesktopFilePath = ParsedTilesList[i].DotDesktopFilePath;
						
						// Set tile index for the edit mode.
							NewTileObject.tileIndex = i
						
						// Connect clicked signal.
							NewTileObject.clicked.connect(tileClicked);
						
						// Connect global edit mode toggle.
							NewTileObject.toggleGlobalEditMode.connect(toggleGlobalEditMode);
						
						// Connect hideEditModeControlsOnPreviousTile signal.
							NewTileObject.hideEditModeControlsOnPreviousTile.connect(hideEditModeControlsOnPreviousTile);
						
						// Connect the opacity-setter function.
							NewTileObject.setTileOpacity.connect(setTileOpacity);
						
						// Connect long-press signal.
						// NewTileObject.pressAndHold.connect(tileLongPressed);
						
						// Connect decrementing the pinned tiles count signal.
							NewTileObject.decrementPinnedTilesCount.connect(checkPinnedTileCount);
						
						//} // End of If statement to ensure things are ready.
						
						} // End of For loop that loads the tiles.
					} else {
						// We have to add 0 to 0 if there are no tiles to add
						// so that the whole thing where the tiles list is hidden
						// happens.
						// There's an animation that occurs where the page slides over
						// to the All Apps list, and I'd prefer to turn that off on
						// startup if possible, but allow it to be used later.
						checkPinnedTileCount(0, false);
					} // End of If statement checking to ensure there are tiles to add.
					
				} // Component.onCompleted for the Tiles Flow area.
				
			} // End of the Flow that contains the tiles.
	
		// Use a FontLoader to get the arrow button font:
		// https://doc.qt.io/qt-6/qml-qtquick-fontloader.html
		FontLoader {
			id: metroFont
			// This is using the wp-metro font, which you can
			// find here:
			// https://github.com/ajtroxell/wp-metro
			// In case that repo goes down, here's my fork:
			// https://github.com/DrewNaylor/wp-metro
			// This font was made by AJ Troxell and is under the SIL OFL 1.1:
			// http://scripts.sil.org/OFL
			source: "../../../fonts/wp-metro/WP-Metro.ttf"
		}
		
		Item {
			// Empty item above All Apps button for spacing.
			height: 5
		}
		
		RetiledStyles.RoundButton {
			id: allAppsButton
			// We have to say this is a Unicode font:
			// https://stackoverflow.com/a/47790127
			// It's loading a Chinese character, for some reason.
			// Actually, I think that's because it's using the
			// wrong font, "8514oem" to be exact.
			// Seems to work fine on Linux, for some reason.
			// This is really weird.
			text: "<b>\ue021</b>"
			font: metroFont.font
			
			// Set background color for when pressed.
			// By default this is cobalt (#0050ef).
			// This would probably be black in light themes.
			pressedBackgroundColor: "white"
			// Set text color for when the button is pressed.
			// This is white by default, as most round buttons
			// don't change their text color.
			// I think this would also have to be white when
			// using the light theme.
			pressedTextColor: "black"
			// If necessary, you can also set the default text color.
			// This is the color that the text color returns to after
			// un-pressing the button.
			// Light themes would have the default text color be black
			// I think.
			// defaultTextColor: "white"
			
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
				} // End of the All Apps button.

		Item {
			// Empty item below the All Apps button
			// for spacing, as margins don't allow you
			// to scroll in them.
			height: 20
			
		}

	
		} // End of ColumnLayout for the tiles and All Apps button.
		
		Item {
				// Empty item that acts as a margin on the right of the
				// tiles so it can be scrolled, as margins don't allow scrolling.
				width: 10
			}
		
		} // End of RowLayout for storing empty items that form the margins on the left and right.
		
	} // End of the flickable for the tiles area, which includes the margins.
	} // End of the item containing the tiles area.
	
	RetiledStartPages.AllApps {
		// The All Apps page has been moved to its own file.
	}
	
} // End of the swipeview for the Start screen.
}// End of the window.