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

// Tried to do import ButtonBase but QML said
// the style wasn't installed, so I'm just
// importing everything in this folder
// until I can figure out a better solution.
import "."
import QtQuick
import QtQuick.Controls
// We also need QtQuick.Layouts for the simple tiles grid.
import QtQuick.Layouts

ButtonBase {
	// We need to change things to make it into a tile.
	id: control
	
	// Add properties.
	property string tileText: "tile"
	// A fontSize of 12 is pretty close to the real sizing.
	// Update: now that we're using Inter Display, the sizing
	// is slightly off, but I guess it's fine since we realistically
	// can't get to the exact same thing.
	// Actually, the extra small font size I'm using is the same
	// width in pixels for the "Calc" part of KCalc as it is
	// for WP's Calculator when combined with semibold Inter Display.
	// Looks very nice.
	// TODO: Allow some way to make it larger for accessibility.
	// Perhaps there should be font size settings for each font size
	// so that users can change all of them to whatever they want,
	// so maybe the extra small font size could be set to 16 if needed?
	property real fontSize: FontStyles.extrasmallFontSize
	property string textColor: ThemeLoader.getValueFromTheme(themePath, "Tiles", "TextColor", "white")
	// Fun fact: if you change the color value here
	// to #990050ef (or anything else with numbers in front of "0050ef"),
	// you'll get transparent tile backgrounds, with different values
	// depending on the first two numbers (replacing "99").
	// This may be useful for customization, if people want W10M-style
	// semi-transparent tiles.
	// TODO: Figure out how to allow this to be changed in themes if possible,
	// or at least hook it up to tile .desktop files and stuff when I get around
	// to doing that.
	property string tileBackgroundColor: accentColor
	// We have to add a property for the button's exec key
	// so that we can add an event handler:
	// https://stackoverflow.com/a/22605752
	property string execKey;
	signal tileClicked(string execKey);

	// Property for storing the tile's icon path.
	property string tileIconPath: ""

	// Store the tile's columnSpan and rowSpan.
	property int rowSpan: 2
	property int columnSpan: 2
	// Properties for tile's column and row.
	property int row: 0
	property int column: 0
	
	// Add signals for the context menu.
	property string dotDesktopFilePath;
	property bool showContextMenu: false
	// Signal for opening the context menu.
	// signal pressAndHold(bool showContextMenu);
	// Signal for decrementing the pinned tiles count.
	// This is used to check whether the tiles page should be hidden.
	signal decrementPinnedTilesCount(int amountToDecrement);
	
	// Signal for turning on or off global edit mode.
	signal toggleGlobalEditMode(bool enable, bool showAllAppsButtonAndAllowGoingBetweenPages);
	
	// Signal for hiding the editing controls on the previously-active tile.
	signal hideEditModeControlsOnPreviousTile(int previousTileInEditingModeIndex);
	
	// Signal to set tile opacity when in edit mode or not.
	signal setTileOpacity();
	
	// Set padding values.
	// These values and the fontSize may be incorrect, at least with WP7:
	// https://stackoverflow.com/a/8430030
	// Or maybe it's right, and it's just a font issue.
	// I looked at Avalonia's default font size for buttons, and
	// it's 14:
	// https://github.com/AvaloniaUI/Avalonia/blob/master/src/Avalonia.Themes.Fluent/Controls/Button.xaml#L24
	// That line references "ControlContentThemeFontSize", which is defined to be "14" here:
	// https://github.com/AvaloniaUI/Avalonia/blob/master/src/Avalonia.Themes.Fluent/Accents/Base.xaml#L17
	// Changing leftPadding to 7 makes the second "l" in the test string
	// ("WP8.1 app with a really long name for testing", though I didn't keep the full thing) be in half properly.
	// I would prefer to use 8, but Open Sans isn't close enough together.
	// Forking it could improve that.
	// Actually, Segoe WP's spacing can be emulated by setting the pixel spacing to -8.
	// It would still be best to fork Open Sans, though, as that's how it can be fixed
	// properly, along with fixing the J and Q.
	// TODO: Allow this to be changed?
	leftPadding: 8
	topPadding: 0
	rightPadding: 0
	bottomPadding: 6
	
	// Create a boolean that says whether we're in edit mode or not.
	// This'll allow people to exit edit mode by tapping the tile.
	property bool editMode: false
	
	// Set tile index for use with global edit mode.
	// This isn't the tile ID, which is used in the config file.
	property int tileIndex;
	
	// Guess we still need this because we're
	// accessing "tilt" in the code where we're
	// clicking on a tile and leaving edit mode.
	property bool tilt: allowTilt

	// Specify whether we should be using
	// a tile background wallpaper.
	// If not, we just use the standard Accent
	// color background.
	// This can be set per-tile, so there can
	// also be tiles that just opt out, whether
	// by the user or by a developer, as well as
	// if the user says not to use a tile wallpaper.
	property bool useTileBackgroundWallpaper;

	// Tile size (small, medium, or wide).
	// Won't be fully used until moving to TilesGrid.
	property string tileSize;

	// Tile icon size.
	// Used in a HACK to get tile icons to not be blurry.
	property bool isTileIconSizeReset: false

	// Properties for unpin button icons.
	// Stored here so they're out of the way.
	property string unpinIconPressed: ThemeLoader.getValueFromTheme(themePath, "Tiles", "UnpinButtonIconPressed", "unpin")
	property string unpinIconUnpressed: ThemeLoader.getValueFromTheme(themePath, "Tiles", "UnpinButtonIconUnpressed", "unpin_white")
	
	function unpinCanDefragTiles() {
	// 		// Put tiles back together when unpinning them.
	// TODO: Figure out how to make this work for the case where no tiles are in a row
	// and we can move them up toward the rest of them.
	// This would fix the issue where you can't scroll the whole page.
		for (var i = 0; i < tilesContainer.children.length; i++) {
			// Move the tiles below ours down a row according to our rowSpan.
			// console.log("looking at column: " + tilesContainer.children[i].Layout.column);
			// console.log("control column plus columnSpan: " + control.Layout.column + control.Layout.columnSpan);
			// We need an if/else here so tiles go back up if possible, but I can't figure out what I need.
			// TODO: figure out a good if/else here. I genuinely don't know what
			// should be used for this, sadly. I had some other code I tried that can be found in the git diffs,
			// but it never ended up working.
			// if (tilesContainer.children[i].Layout.row - 1 != tilesContainer.children[i].Layout.row - 2) {
			// 	tilesContainer.children[i].Layout.row -= control.Layout.rowSpan;
			// }

			// Loop through all the columns so we can check horizontally.
			for (var j = 0; j < tilesContainer.columns; j++) {
				// console.log("column: " + j);
				// Loop through all the rows at the unpinned tile's row until and including the row its rowSpan covers.
				for (var k = control.Layout.row; k < control.Layout.row + control.Layout.rowSpan; k++) {
					//console.log(k);
					// Check to see if there's a tile within the same rows the tile covers and in all the columns.
					// If we don't find anything (that code would work for medium and wide tiles), then
					// check if the tile is not the same columnSpan as the amount of columns in the tilesContainer and
					// make sure it's a small tile in height (should work for custom sizes), then check if the tile we're
					// looking at is on the row above us, then make sure its column is less than the number of
					// columns in the tilesContainer (not sure if the last one is required).
					if (((tilesContainer.children[i].Layout.row == k) && (tilesContainer.children[i].Layout.column == j)) ||
						((control.Layout.columnSpan != tilesContainer.columns) && (control.Layout.rowSpan == 1) && ((tilesContainer.children[i].Layout.row == k - 1) && (tilesContainer.children[i].Layout.column < tilesContainer.columns)))) {
						// console.log("control.tileIndex: " + control.tileIndex);
						//console.log("tilesContainer.children[i].tileIndex: " + tilesContainer.children[i].tileIndex);
						// Make sure we only look at tiles that aren't the one we unpinned and are still visible.
						if ((tilesContainer.children[i].tileIndex != control.tileIndex) && (tilesContainer.children[i].visible == true)) {
							console.log("tile detected in same row and column: " + tilesContainer.children[i].dotDesktopFilePath);
							// Return false since we can't move tiles.
							return false
						} // End of if statement checking if there is a visible tile and making sure it's not an unpinned tile.
					} // End of complicated if statement checking for tiles nearby.
				} // End of for loop looking through all the rows between and including the unpinned tile's row and its rowSpan.
			} // End of for loop looking through all the columns.
		} // End of for loop looking through all the tiles in the tilesContainer.
	} // End of function checking if we can defrag the tiles.

	function unpinDefragTiles() {
		// We can defrag the tiles, so do so.
		// This isn't perfect as it doesn't take into account space where there are only two tiles
		// and a medium tile is unpinned before the smaller ones.
		for (var i = control.tileIndex; i < tilesContainer.children.length; i++) {
			if (tilesContainer.children[i].Layout.row > control.Layout.row) {
				tilesContainer.children[i].Layout.row -= control.Layout.rowSpan;
			}
		}

		// Commit the new sizes to the thing.
		tilesContainer.updatePreferredSizes();
	}
		

	RoundButton {
		id: unpinButton
		visible: editMode
		Image {
			// It's "pressed", not "down", to change images:
			// https://stackoverflow.com/a/30092412
			source: parent.pressed ? "../icons/actions/" + unpinIconPressed + ".svg" : "../icons/actions/" + unpinIconUnpressed + ".svg"
			anchors.fill: parent
			fillMode: Image.Stretch
			// Mipmapping makes it look pretty good.
			mipmap: true
		}
		rotation: 45
		// Anchor the horizontal and vertical
		// center to the right and top
		// respectively so that the unpin
		// button is in the top-right.
		anchors.horizontalCenter: control.right
		anchors.verticalCenter: control.top
		// Set z value to above the tile so that
		// tapping the button works even if
		// it's done in the tile area.
		z: control.z + 1
		// Remove the border since the image itself has one.
		borderWidth: 2
		// Change the pressed background color.
		// TODO: Check if it's the same under the light theme.
		pressedBackgroundColor: ThemeLoader.getValueFromTheme(themePath, "Tiles", "TileRoundButtonPressedBackgroundColor", "white")
		// Forgot to set the unpressedBackgroundColor
		// property and that these buttons are opaque
		// on WP. Thought something looked slightly off.
		// TODO: Check if this is also black under the light theme.
		unpressedBackgroundColor: ThemeLoader.getValueFromTheme(themePath, "Tiles", "TileRoundButtonUnpressedBackgroundColor", "black")
		// Also set pressedBorderColor.
		pressedBorderColor: ThemeLoader.getValueFromTheme(themePath, "Tiles", "TileRoundButtonPressedBorderColor", "black")
		// Set accessibility stuff:
		// https://doc.qt.io/qt-6/qml-qtquick-accessible.html
		// Didn't know this was a thing, but I learned about it
		// from a Mastodon post.
		// Partially copying from that page.
		Accessible.role: Accessible.Button
		Accessible.name: "Unpin tile button"
		Accessible.description: "Unpins the current tile."
		Accessible.onPressAction: {
			// Click the button with the accessibility press feature:
			// https://stackoverflow.com/a/34332489
			// I really hope this works, because I don't really
			// have any way to test it as far as I know.
			clicked()
		}
		onClicked: {
			// Reset the z-index for the tile and hide the buttons.
			// NOTE: Unpinning a tile removes the buttons, so this
			// is ok, unlike when resizing the tile.
			control.z = control.z - 1;
			// Turn off local edit mode.
			editMode = false;
			// Decrement the pinned tiles count.
			// Unpin the tile.
			decrementPinnedTilesCount(-1);
			// Temporary placeholder code that just
			// sets the tile to be invisible.
			// TODO: Figure out how to properly remove the tile
			// since it's dynamically-created.
			control.visible = false;
			// Put the tiles back together.
			// This doesn't work right, sadly.
			// Tiles will end up going inside each other.
			// TODO: Have it work.
			if (unpinCanDefragTiles() != false) {
				unpinDefragTiles();
			}
		}
	}
	
	RoundButton {
		id: resizeButton
		visible: editMode
		text: "<b>\ue021</b>"
		fontFamily: metroFont.name
		// Anchor the horizontal and vertical
		// center to the right and bottom
		// respectively so that the resize
		// button is in the bottom-right.
		anchors.horizontalCenter: control.right
		anchors.verticalCenter: control.bottom
		// Set z value to above the tile so that
		// tapping the button works even if
		// it's done in the tile area.
		z: control.z + 1
		// Change the pressed background color.
		// TODO: Check if it's the same under the light theme.
		pressedBackgroundColor: ThemeLoader.getValueFromTheme(themePath, "Tiles", "TileRoundButtonPressedBackgroundColor", "white")
		// Forgot to set the unpressedBackgroundColor
		// property and that these buttons are opaque
		// on WP. Thought something looked slightly off.
		// TODO: Check if this is also black under the light theme.
		unpressedBackgroundColor: ThemeLoader.getValueFromTheme(themePath, "Tiles", "TileRoundButtonUnpressedBackgroundColor", "black")
		// Change pressed text color.
		// TODO: Check if this is also the same under the light theme.
		pressedTextColor: ThemeLoader.getValueFromTheme(themePath, "Tiles", "TileRoundButtonPressedTextColor", "black")
		// Set accessibility stuff:
				// https://doc.qt.io/qt-6/qml-qtquick-accessible.html
				// Didn't know this was a thing, but I learned about it
				// from a Mastodon post.
				// Partially copying from that page.
				Accessible.role: Accessible.Button
				Accessible.name: "Resize tile button"
				// TODO: Include the next size the tile will be when clicked.
    			Accessible.description: "Resizes the current tile."
    			Accessible.onPressAction: {
        			// Click the button with the accessibility press feature:
					// https://stackoverflow.com/a/34332489
					// I really hope this works, because I don't really
					// have any way to test it as far as I know.
					clicked()
    			}

		function overlappingTileRepositioning() {
			// Subtract 1 from the column because it's zero-indexed.
			if ((control.Layout.columnSpan + control.Layout.column - 1 > tilesContainer.columns - 1)) {
				// Move the tile to fit.
				console.log(control.Layout.columnSpan + control.Layout.column);
				control.Layout.column = 0;
				control.Layout.row += 1;
				// NOTE: We need to check the row above us here so we're spaced correctly. (TODO)
				for (var i = 0; i < tilesContainer.children.length; i++) {
					if ((tilesContainer.children[i].Layout.row === control.Layout.row - 1) &&
					tilesContainer.children[i].Layout.rowSpan > 1) {
					// Increase our new tile's row accordingly.
					// Seems to mostly work, sometimes breaks for some reason, though.
					// If it breaks, it will put the new tile one space down and one
					// space to the right. Not sure why, but at least it doesn't overlap
					// when there's a medium tile to the left of a small tile.
					// TODO: Check if it's supposed to have the next tile go underneath
					// the small tile or column 0.
					control.Layout.row += 1;
					} // End of If statement checking if we're looking at the row above us.
				}
				// We still need to have code for moving our tile around, so this is commented out for now.
				//tilesContainer.children[control.tileIndex].Layout.row += 1;
				// Go through all the pinned tiles after the one we're resizing and check
				// if they would overlap our tile (still have to see if they'd overlap).
				for (var i = control.tileIndex + 1; i < tilesContainer.children.length; i++) {
					// Move the tiles below ours down a row according to our rowSpan.
					// console.log("looking at column: " + tilesContainer.children[i].Layout.column);
					// console.log("control column plus columnSpan: " + control.Layout.column + control.Layout.columnSpan);
					// We need an if/else here so tiles go back up if possible, but I can't figure out what I need.
					// TODO: figure out a good if/else here. I genuinely don't know what
					// should be used for this, sadly. I had some other code I tried that can be found in the git diffs,
					// but it never ended up working.
					tilesContainer.children[i].Layout.row += tilesContainer.children[i - 1].Layout.rowSpan;
				} // End of for loop ensuring we don't overlap any tiles near us.	
				} // End of if statement checking if we'd overlap tiles.
			
			// Commit the new sizes to the thing.
			tilesContainer.updatePreferredSizes();
		}
		onClicked: {
			// Reset the z-index for the tile and hide the buttons.
			// TODO: Figure out how to make it so that tapping any other
			// tile or area on the start screen will hide the
			// resize button so that the user can
			// resize multiple times at once.
			// control.z = control.z - 1;
			// resizeButton.visible = false;
			// unpinButton.visible = false;
			// Actually, we have an edit mode boolean now,
			// so the buttons can stay on here.
			// Resize the tile based on its current width.
			// Using an if statement to determine what to
			// change the button rotation to:
			// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/if...else
			// Use "&&" for "and":
			// https://stackoverflow.com/a/12364825
			// Use behaviors for resize button rotation and tile size.
			rotationBehavior.enabled = true;
			tileResizeHeightBehavior.enabled = true;
			tileResizeWidthBehavior.enabled = true;
			// TODO/HACK: Ensure tiles pop in and out of spaces if they have or don't
			// have enough room when resizing them. Right now what I'm doing
			// should work, but it's reliant on tilesContainer existing and
			// currently only works to move tiles after ours.
			if (tileSize == "medium") {
				// If button is medium, resize to small.
				control.width = 70;
				control.height = 70;
				control.Layout.columnSpan = 1;
				control.Layout.rowSpan = 1;
				tileSize = "small";
				// Change the resize button's rotation for the small tile.
				// 45 points down-right.
				resizeButton.rotation = 45;
			} else if (tileSize == "small") {
				// If button is small, resize to wide.
				control.width = 310;
				control.height = 150;
				control.Layout.columnSpan = 4;
				control.Layout.rowSpan = 2;
				tileSize = "wide";
				// Change the resize button's rotation for the wide tile.
				// -180 points the arrow backward.
				resizeButton.rotation = -180;
			} else if (tileSize == "wide") {
				// If button is wide, resize to medium.
				control.width = 150;
				control.height = 150;
				control.Layout.columnSpan = 2;
				control.Layout.rowSpan = 2;
				tileSize = "medium";
				// Change the resize button's rotation to match
				// the medium tile's expected resize button rotation.
				// We're changing it to -135 so it points in the top-left.
				resizeButton.rotation = -135;
			} else {
				// If nothing matches, resize to medium, just
				// in case.
				control.width = 150;
				control.height = 150;
				
				control.Layout.columnSpan = 2;
				control.Layout.rowSpan = 2;
				tileSize = "medium";
				// Change the resize button's rotation to match
				// the medium tile's expected resize button rotation.
				// We're changing it to -135 so it points in the top-left.
				resizeButton.rotation = -135;
			}
			overlappingTileRepositioning();
		}
		
		// Add behavior for resize button rotation, at least.
		// Make sure it's off until it needs to run:
		// https://doc.qt.io/qt-6/qml-qtquick-behavior.html#enabled-prop
		Behavior on rotation {
			id: rotationBehavior
			enabled: false
			PropertyAnimation { duration: 100;
							    easing.type: Easing.InOutQuad
						      }
		}
	}
	
	// Add behavior for resizing tiles.
	// Not quite sure what the "jumping-like" ease that resizing
	// tiles uses on WP, but I'd like to eventually have it be more like that.
	// Copied the PropertyAnimation stuff here over from what I put into
	// the ButtonBase file.
	Behavior on width {
		id: tileResizeWidthBehavior
		enabled: false
		PropertyAnimation { duration: 75;
							easing.type: Easing.InOutQuad
						  }
	}
	Behavior on height {
		id: tileResizeHeightBehavior
		enabled: false
		PropertyAnimation { duration: 75;
							easing.type: Easing.InOutQuad
						  }
	}
	
	// Properties for pixel density:
	// https://stackoverflow.com/a/38003760
	// This is what QML told me when I used
	// console.log(Screen.pixelDensity).
	property real mylaptopPixelDensity: 4.4709001084468
	// This is just whatever the device that's running will use.
	property real scaleFactor: Screen.pixelDensity / mylaptopPixelDensity
	
	// We're clicking on the tile.
		onClicked: {
			// Only run the app if edit mode is off.
			if ((editMode == false) && (globalEditMode == false)) {
				tileClicked(execKey);
				// Reset the scale to 1.0.
				// This, along with setting the scale
				// in various events below, probably
				// isn't the best way to do this, but
				// it's approximately the same thing
				// as before the MouseArea was used.
				// I'd prefer to just use
				// control.scale: control.down ? 0.98 : 1.0
				// but I can't seem to get that to work
				// with a MouseArea.
				// TODO: Make this less janky.
				scale = 1.0;
			} else if (editMode == true) {
				// Turn off edit mode if it's on.
				editMode = false;
				// Also turn off global edit mode, because
				// the current tile has focus and that's how
				// global edit mode is turned off.
				toggleGlobalEditMode(false, true);
				// Set tile opacity, too.
				setTileOpacity();
				// Hide the edit mode buttons and reset the tile's
				// z-index.
				z = z - 1;
				// Turn back on tilting.
				// TODO: Figure out how to turn off tilting when
				// clicking a tile that's currently in local edit mode
				// so it goes directly "down", as well as figuring it out for
				// not tilting the unpin and resize buttons when pressing the tile.
				tilt = allowTilt;
				// console.log(previousTileInEditingModeIndex);
			} else if ((editMode == false) && (globalEditMode == true)) {
				// If local edit mode is off but global edit mode
				// is on, turn on edit mode for this tile and show
				// the edit controls.
				// TODO: Turn off local edit mode for the tile
				// previously in edit mode.
				// For some reason, local edit mode isn't being
				// turned on properly.
				editMode = true;
				// Forgot to show the controls, oops.
				z = z + 1;
				// Hide the controls on the previously-active tile.
				hideEditModeControlsOnPreviousTile(previousTileInEditingModeIndex);
				// Set tile opacity, too.
				setTileOpacity();
				// Now set the previous tile index.
				previousTileInEditingModeIndex = tileIndex;
					if (tileSize == "medium") {
				// Change the resize button's rotation for the medium tile.
				// -135 points the arrow in the top-left corner.
						resizeButton.rotation = -135;
					} else if (tileSize == "small") {
				// Change the resize button's rotation for the small tile.
				// 45 points the arrow down-right.
						resizeButton.rotation = 45;
					} else if (tileSize == "wide") {
				// Change the resize button's rotation to match
				// the wide tile's expected resize button rotation.
				// -180 points to the left.
						resizeButton.rotation = -180;
					} else {
				// Change the resize button's rotation to -135 to match
				// the wide tile if we don't know what the tile's size is.
				// We're changing it to -135 so it points in the top-left.
						resizeButton.rotation = -135;
					}
			}
			
		}
		// Scaling the buttons down then back up
		// is done by setting scale values for both
		// onPressed and onReleased.
		// If only one is set, the button won't come
		// back up and will stay depressed, like me
		// during most of 2020.
		// See the comment block above for how we're
		// setting it back to 1.0 after the clicked
		// signal is processed.
		// Also, please fix this. It's really janky,
		// but at least it's not as janky as it was
		// before adding onCanceled and resetting
		// the scale in the click handler.
		// TODO: make sure there's some way to have
		// the tilt reset on releasing and canceling
		// without affecting other controls that don't have editMode.
		// At least for tiles, they can sometimes get stuck tilted.
		onPressed: {
			// Only change the scale if edit mode is off.
			if ((editMode == false) && (globalEditMode == false)) {
				scale = 0.98
			}
		}
		
		onReleased: {
			// Make sure global edit mode isn't on first.
			if (globalEditMode == false) {
				scale = 1.0
			}
		}
		onCanceled: {
			// Make sure global edit mode isn't on first.
			if (globalEditMode == false) {
				scale = 1.0
			}
		}
		
		// Trying to do a press and hold for edit mode.
		onPressAndHold: {
			// TODO: Figure out how to have it enter a
			// "tile modification" mode so that users can
			// scroll and tap on different tiles to modify
			// them instead of having to long-press on each
			// tile.
			// This would also allow moving tiles around
			// if I can figure out how to initiate a grab
			// and let the user scroll up and down by dragging
			// the tile.
			// Pressing a tile, using the back button, or tapping
			// anywhere outside the resize and unpin buttons
			// on the start screen will also exit the modification
			// mode.
			// Note that you can also just have no tile selected so
			// they're all in the "background", smaller, and less
			// visible (darker/dimmer?).
			// Update: There's an edit mode now, but it only applies
			// to each tile rather than the entire tile list, so
			// it's still possible to open an app with tile A while the menu
			// for tile B is open.
			z = z + 1;
			// If global edit mode is already on, hide the edit controls on the previous tile.
			// Also make sure we're not editing this tile at the moment.
			// There may be more stuff to change so that this works more reliably,
			// but it gets rid of the issue for now.
			if ((globalEditMode == true) && (editMode == false)) {
				hideEditModeControlsOnPreviousTile(previousTileInEditingModeIndex);
			}
			// Turn on edit mode.
			editMode = true;
			// Turn on global edit mode.
			toggleGlobalEditMode(true, false);
			// Set tile opacity, too.
			setTileOpacity();
			// Now set the previous tile index.
			previousTileInEditingModeIndex = tileIndex;
			//console.log("tileIndex on long-pressing a tile: " + tileIndex);
			// Rotate the resize button as well.
			// TODO: Make the rotation into its own function.
			// NOTE: These values are different from the ones
			// used when pressing the resize button.
			if (tileSize == "medium") {
				// Change the resize button's rotation for the medium tile.
				// -135 points the arrow in the top-left corner.
				resizeButton.rotation = -135;
			} else if (tileSize == "small") {
				// Change the resize button's rotation for the small tile.
				// 45 points the arrow down-right.
				resizeButton.rotation = 45;
			} else if (tileSize == "wide") {
				// Change the resize button's rotation to match
				// the wide tile's expected resize button rotation.
				// -180 points to the left.
				resizeButton.rotation = -180;
			} else {
				// Change the resize button's rotation to -135 to match
				// the wide tile if we don't know what the tile's size is.
				// We're changing it to -135 so it points in the top-left.
				resizeButton.rotation = -135;
			}
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
				// pixelSize isn't device-independent.
                font.pointSize: fontSize
				// Set the font weight:
				// https://doc.qt.io/qt-5/qml-font.html
				// Windows Phone 7 used SemiBold, but I hope
				// DemiBold is close enough:
				// https://stackoverflow.com/a/8430030
				// Funny enough, DemiBold is 63, which was
				// my favorite number in 6th grade due to
				// Super Mario 63.
				// I did find a link to Microsoft's documentation
				// showing what various measurements for Windows Phone 8
				// are:
				// https://docs.microsoft.com/en-us/previous-versions/windows/apps/ff769552(v=vs.105)
				// Something else interesting is that Microsoft has a page with the names and
				// hex values for each of the accent colors. One thing on this page says
				// you can get the styles from C:\Program Files (x86)\Microsoft SDKs\Windows Phone\v8.0\Design
				// Here's the link:
				// https://docs.microsoft.com/en-us/previous-versions/windows/apps/ff402557(v=vs.105)
				//font.weight: Font.DemiBold
				// Font weight changes don't look that good.
				// Hide text on small tiles.
				// This is not ideal and is basically a temporary hack until a proper solution of
				// checking to see if the tile is "medium" or "wide" rather than "small" is implemented.
				// TODO: Replace this with a proper implementation.
                text: parent.width >= 150 && parent.height >= 150 ? tileText : ""
                color: textColor
				// Turn off ellipsis.
				elide: Text.ElideNone
				// Ensure that text doesn't just go out of
				// the tiles.
				clip: true
				// Set font.
				font.family: FontStyles.semiboldFont
				font.weight: FontStyles.semiboldFontWeight
				// A letter spacing of -0.8 emulates
				// Segoe WP's letter spacing.
				// However, it's not perfect as I can't
				// get the second "l" in "really" to be
				// in half in a medium tile at the same time
				// as the entirety of the "o" in "Calculator"
				// is showing on a small tile.
				// For some reason, the font spacing is slightly
				// off on the phone.
				// I think they're different because this is
				// based on pixels.
				// Preferably this would multiply against
				// the DPI to determine what number should be used.
				// I think -1.25 is close enough for the PinePhone.
				// This SO answer shows how to multiply against
				// pixel density: https://stackoverflow.com/a/38003760
				// This doesn't help that much, but I think
				// I'll keep it for now to make sure things
				// don't get too out of control.
				//font.letterSpacing: -0.8 * scaleFactor
				// You know what, I'm just not going to do this
				// because it'll introduce difficult-to-fix bugs
				// and inconsistencies.
				// I wasn't going to do it, but then I went back
				// and I really don't like how Open Sans looks by default.
				// Now that we're using Inter Display, we don't need it
				// to make things look better.
            }
			
			Image {
		// Temporarily grabbing icons directly from the hicolor
		// theme based on this AskUbuntu answer, notably the "appending
		// a name to a hardcoded path" thing:
		// https://askubuntu.com/a/351924
		// Update: now we're grabbing them via pyxdg.
		// TODO: Properly get the icon size we need here rather
		// than just doing the 96x96 version that's hardcoded in
		// main.py. In this case, wide tiles make icons stretched
		// out. But now I'm just doing a hack to force the icon's
		// source width to be based off it's height, so it's
		// not as bad as it could be.
		//source: "../icons/actions/unpin_white"
		source: tileIconPath
		anchors.fill: parent
		// Allow the icon to be hidden while it's resized.
		visible: isTileIconSizeReset
		// Just pad out the image; got the Image.Pad
		// thing from the QtQuick Image link below.
		fillMode: Image.Pad
		// Set image to be async so the UI loads faster:
		// https://doc.qt.io/qt-6/qml-qtquick-image.html#asynchronous-prop
		asynchronous: true
		// Set the images to the tile size for now,
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
		// TODO: Figure out a better way to not have SVG files
		// get stretched than forcing the source width to be
		// based off the tile's height, because it could
		// probably be a problem eventually. At least this looks
		// pretty good for now. This is a hack.
		// TODO 2: Figure out why the Firefox icon and a few others like Koko
		// are blurry when they shouldn't be (Firefox in particular has
		// a 96x96 icon).
		sourceSize.width: isTileIconSizeReset ? control.height/1.6 : 256
		sourceSize.height: isTileIconSizeReset ? control.height/1.6 : 256
		height: isTileIconSizeReset ? control.height/1.6 : 256
		width: isTileIconSizeReset ? control.height/1.6 : 256

		// Make sure the icons are antialiased.
		antialiasing: true
	}
	
	
	
	background: Loader {
		// Ensure we only give tiles that are the same as the Accent color
		// the tile background wallpaper.
		// We also check to ensure the user actually wants to use
		// a tile background wallpaper.
		// TODO: Remember that we need to allow just using a plain
		// background wallpaper for devices that can't
		// handle the in-tile image as well as anyone that just doesn't
		// want it.
		source: tileBackgroundColor == accentColor && useTileBackgroundWallpaper == true && displayBackgroundWallpaper == true ? "./TileBackgroundShaderEffectSource.qml" : "./TileBackgroundSolidColorRectangle.qml"
	}
	
	//background: 
	
}
