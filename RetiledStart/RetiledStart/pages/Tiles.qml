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
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Universal
// Message box for the deprecated startlayout format.
import QtQuick.Dialogs

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

	// Store the theme family and theme name for easy access.
	// TODO: Hook this up to D-Bus along with the rest of the settings
	// so that it can update when the user changes it in the Settings app.
	property string themeFamily: settingsLoader.getSetting("themes", "ThemeFamily", "Retiled-Metro")
	property string themeName: settingsLoader.getSetting("themes", "ThemeName", "MetroDark")
	// Also construct a theme path so it's less to figure out each time
	// I need to have something read from a theme file.
	// Each theme is in a subfolder starting with the theme family name
	// followed by the theme name as a folder then the name again
	// but as a file.
	property string themePath: themeFamily + "/" + themeName + "/" + themeName

    Universal.theme: {
		// Get Universal theme.
		// TODO: Split this if statement out so it's easier to reuse.
		if (ThemeLoader.getValueFromTheme(themePath, "ThemeDetails", "ThemeType", "dark") === "light") {
			return Universal.Light;
		} else {
			return Universal.Dark;
		}
	} // End of the Universal theme loader.
    // Property for setting Accent colors so that Universal.accent
	// can in turn be set easily at runtime.
	property string accentColor: settingsLoader.getSetting("themes", "AccentColor", "#0050ef")
    Universal.accent: accentColor
	Universal.foreground: ThemeLoader.getValueFromTheme(themePath, "UniversalStyle", "UniversalForegroundColor", "white")
	// Fun fact: QML supports setting the background to transparent,
	// which shows all the other windows behind the app's window as you'd expect.
	// This will probably be useful when working on stuff like the volume controls and Action Center.
	Universal.background: ThemeLoader.getValueFromTheme(themePath, "UniversalStyle", "UniversalBackgroundColor", "black")
	
	// Decide whether to display a background image or not.
	// This (displayBackgroundWallpaper) is used in conjunction with
	// useTileBackgroundWallpaper to determine if we should use
	// a tile background (in-tile, like 8.1),
	// or if it should be displayed behind the tiles like 10
	// if useTileBackgroundWallpaper is false.
	// Having both be false will just do the solid-color tiles
	// like 7.x-8.0.
	property bool displayBackgroundWallpaper: settingsLoader.convertSettingToBool(settingsLoader.getSetting("themes", "DisplayBackgroundWallpaper", "false"))
	property bool useTileBackgroundWallpaper: settingsLoader.convertSettingToBool(settingsLoader.getSetting("themes", "UseTileBackgroundWallpaper", "false"))
	// Set the path for background wallpapers.
	property string wallpaperPath: settingsLoader.getSetting("themes", "WallpaperPath", "wallpaper.jpg")
	// Turning off parallax is for accessibility.
	// See also "TileBackgroundShaderEffectSource.qml"
	// for more details, for both this and
	// useTileBackgroundWallpaper above.
	property bool allowParallax: settingsLoader.convertSettingToBool(settingsLoader.getSetting("accessibility", "AllowParallax", "true"))
	// Turning off tilt for accessibility if desired.
	property bool allowTilt: settingsLoader.convertSettingToBool(settingsLoader.getSetting("accessibility", "AllowTilt", "true"))

	// Grab the wallpaper overlay rectangle properties.
	property string wallpaperOverlayLayerColor: settingsLoader.getSetting("themes", "WallpaperOverlayLayerColor", "black")
	property string wallpaperOverlayLayerOpacity: settingsLoader.getSetting("themes", "WallpaperOverlayLayerOpacity", "0.20")

	// Set icon theme.
	property string iconTheme: settingsLoader.getSetting("themes", "IconTheme", "breeze-dark")
	
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
	//FontLoader {
			//id: opensansRegular
			// This is using the Open Sans font, which you can
			// find here:
			// https://fonts.google.com/specimen/Open+Sans
			// This font was designed by Steve Matteson and is under the Apache License, Version 2.0:
			// http://www.apache.org/licenses/LICENSE-2.0
			//source: "../../../fonts/open_sans/static/OpenSans/OpenSans-Regular.ttf"
		//}

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
	
	
	Shortcut {
		id: backButtonShortcut
		sequences: ["Esc", "Back"]
        onActivated: {
			
			if (globalEditMode == true) {
				// Turn off global edit mode.
				toggleGlobalEditMode(false, true);
				// Hide editMode controls for each tile.
				// This also resets z-index values for each tile.
				hideEditModeControlsOnAllTiles();
				// Reset opacity for each tile.
				setTileOpacity();
				// TODO: This doesn't properly remove editMode controls from
				// the active tile, for some reason.
			} else {
				// Go back to the tiles list.
				startScreenView.currentIndex = 0
				// Also set the flickable's contentY property to 0
				// so it goes back to the top, like on WP:
				// https://stackoverflow.com/a/7564705
				tilesFlickable.contentY = 0
			}
			// TODO: Figure out how to make this
			// not conflict with the keyboard shortcut
			// in the main window's file that goes back.
			
			// TODO 2: Figure out how to let this be sent
			// at any time so that the user can, for example,
			// swipe over to the All Apps list and immediately
			// press the Back button so it goes back right away.
			// I did that sometimes because it was fun, and I want
			// other people to have that experience available to them.
			
        }
    }
	
	// Turn on or off global edit mode.
	function toggleGlobalEditMode(enable, showAllAppsButtonAndAllowGoingBetweenPages) {
		// If enable is false, global edit mode will be
		// turned off. Likewise, if it's true, it'll be
		// turned on.
		globalEditMode = enable;
		
		// Hide the All Apps button and don't let the user
		// open the All Apps list based on showAllAppsButtonAndAllowGoingBetweenPages.
		allAppsButton.visible = showAllAppsButtonAndAllowGoingBetweenPages;
		startScreenView.interactive = showAllAppsButtonAndAllowGoingBetweenPages;
		
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
					tile['TileSize'] = tilesContainer.children[i].tileSize;
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
		// Use the previous tile index to hide the buttons on the previous tile
		// that was in editMode.
		// The moderator's answer here should work for looping through items:
		// https://forum.qt.io/post/234640
		// Now hide the buttons and turn edit mode off for that tile.
		// The visibility of the edit mode buttons is tied to editMode.
		// As it turns out, just directly accessing the previous tile index
		// doesn't work if you're trying to remove the edit mode controls
		// from a newly-pinned tile. Unfortunately, this means that
		// we have to loop over the tiles.
		// TODO: Figure out something more efficient.
		for (var i = 0; i < tilesContainer.children.length; i++) {
			if (tilesContainer.children[i].tileIndex == previousTileInEditingModeIndex) {
				tilesContainer.children[i].editMode = false;
				tilesContainer.children[i].z = tilesContainer.children[i].z - 1;
			}
		}
		//console.log("tilesContainer.children.length: " + tilesContainer.children.length);
		//console.log("pinnedTilesCount: " + pinnedTilesCount);
		//console.log("previousTileInEditingModeIndex: " + previousTileInEditingModeIndex);
	} // End of the function that hides edit mode controls on the previous tile.
	
	// Hides editMode controls on all tiles.
	// Function only to be used with the Back button, as it's not optimized
	// to be run when switching which tile is currently in editMode.
	// I really don't think this function can be easily combined
	// with the non-loop one that hides editMode controls on the
	// previously-active tile because they're now too different for it
	// to make sense.
	function hideEditModeControlsOnAllTiles() {
		// Loop through tiles and hide editMode controls on all of them.
		// The moderator's answer here should work for looping through items:
		// https://forum.qt.io/post/234640
		for (var i = 0; i < tilesContainer.children.length; i++) {
			// Loop through the children of the tilesContainer flow.
			// Now hide the buttons and turn edit mode off for that tile.
			// The visibility of the edit mode buttons is tied to editMode.
			tilesContainer.children[i].editMode = false;
			// We have to set their z-index to 0,
			// otherwise everything starts getting messed up.
			tilesContainer.children[i].z = 0;
		}
	}
	
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

	// Trip a boolean for the deprecated tile raw heights and widths thing.
	// This is only used to show a messagebox informing the user that they
	// need to force a save to the config file by entering edit mode
	// then leaving edit mode any way they usually would so that their
	// startlayout-modified.yaml file can be switched to use TileSize
	// instead of TileWidth and TileHeight.
	// This will be removed in v0.1-DP3.
	function tripDeprecatedTileRawWidthAndHeightValuesBoolean() {
		deprecatedRawTileHeightsAndWidthsBoolean = true;
		// Open the popup:
		// https://stackoverflow.com/a/39348167
		deprecatedRawTileHeightsAndWidthsMessageDialog.open();
	}

	property bool deprecatedRawTileHeightsAndWidthsBoolean: false

	// The popup for the deprecated heights and widths thing.
	// TODO: Move this into RetiledStyles so it can be reused
	// for messageboxes in general.
	// TODO 2: Figure out how to make it so the text can be
	// scrolled. Adding a Flickable into the ColumnLayout
	// didn't work out too well in my tests.
	Popup {
		id: deprecatedRawTileHeightsAndWidthsMessageDialog
		// Set width:
		width: window.width
		// We're using a Popup directly to cover everything we need:
		// https://doc.qt.io/qt-6/qml-qtquick-controls2-popup.html
		closePolicy: Popup.CloseOnEscape | Popup.NoAutoClose
		focus: true
		modal: true
		// Set the dimming area to be a semi-opaque black rectangle:
		// https://stackoverflow.com/a/67307006
		Overlay.modal: Rectangle {
			// We can't use opacity, for some reason.
			// This value seems pretty good, though.
			// It's meant to be black with an alpha channel.
			color: "#aa000000"
		}
		// Set the popup background color to the same
		// as the dark appbar's color.
		// I'm pretty sure this would be correct.
		// Turns out it's not the right color for popups.
		// I may need to change the appbar color as well.
		// I got this from the "Allow search to access
		// and use your location?" popup background.
		background: Rectangle {
			color: "#1F1F1F"
		}
		contentItem: ColumnLayout {
			width: parent.width
			//anchors.fill: parent
		Text {
			// This is the header text.
			text: "Deprecated config file keys"
			Layout.fillWidth: true
			wrapMode: Text.Wrap
			color: "white"
			// My guess for the font was wrong.
			// I checked the "Allow search to use your location..."
			// messagebox just to be sure.
			font.family: RetiledStyles.FontStyles.semiboldFont
			font.pointSize: RetiledStyles.FontStyles.mediumFontSize
			font.weight: RetiledStyles.FontStyles.semiboldFontWeight
		}
		Flickable {
			// Properly have the text wrap in a flickable:
			// https://forum.qt.io/topic/104565/wrapping-text-in-a-vertical-flickable/4?_=1681868713839&lang=en-US
			Layout.fillWidth: true
			contentHeight: popupText.height
			// Don't specify contentWidth to prevent horizontal scrolling.
			// TODO: Bring this change over to RetiledSearch's about page
			// to prevent the horizontal scrolling here when the window
			// is resized.
			//ontentWidth: popupText.width
			Layout.preferredHeight: 250
			Layout.preferredWidth: parent.width
			//Layout.maximumWidth: window.width
			// Clip the flickable to keep the text in the area it should be in.
			clip: true
			Text { 
		id: popupText
		// We can't use just plain width in a ColumnLayout:
		// https://stackoverflow.com/a/44713811
		// Layout.fillWidth looks nice.
		Layout.fillWidth: true
		// Strangely we need to set width, even though usually you're
		// not supposed to in a Layout:
		// https://stackoverflow.com/a/44713904
		// Can't have the text too wide, or it will require horizontal scrolling.
		width: window.width - 30
		Layout.preferredWidth: window.width - 30
		//Layout.fillHeight: true

		font.family: RetiledStyles.FontStyles.regularFont
		font.pointSize: RetiledStyles.FontStyles.smallFontSize
		text: "One or more tiles in your Start layout config file are setting their size via raw height and width values.\n" +
		"This is deprecated and will be removed in Retiled v0.1-DP3, and has been replaced by a TileSize key.\n" +
		"Valid values for TileSize include: small, medium, and wide. Any height and width combinations that don't equal these values were set to medium.\n" +
		"To convert your config file to the newest format, please force a save by entering edit mode on a tile then leaving edit mode. This " +
		"situation doesn't require manually changing tile size or unpinning anything, as it's already accounted for.\n" +
		"For now we'll still load TileWidth and TileHeight from the config file, but it'll be converted to TileSize at runtime.\n" +
		"A future version will add back in custom sizes via columns and rows when TilesGrid is integrated."
		color: "white"
		// Word wrap:
		// https://doc.qt.io/qt-6/qml-qtquick-text.html#wrapMode-prop
		wrapMode: Text.Wrap
			}
		}
		RetiledStyles.Button {
			id: popupOkButton
			// Set margins:
			// https://doc.qt.io/qt-6/qtquick-positioning-anchors.html#anchor-margins-and-offsets
			//anchors.top: popupText.bottom
			text: "ok"
			// We have to align left since it's one button and
			// that's what the guidelines say:
			// https://learn.microsoft.com/en-us/archive/blogs/africaapps/uxui-guidelines-for-windows-phone-8
			Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
			// The button was a little too wide, I think.
			Layout.preferredWidth: window.width / 2.25
			// The "Allow search to use your location..."
			// popup, and I think all the rest of them,
			// are 36 pixels tall based on my calculations.
			// TODO: Update the RetiledStyles.Button style
			// so it defaults to this height, as I think that's
			// generally the right size.
			// TODO 2: Add an invisible area above and below
			// the buttons so they can be easily pressed.
			Layout.preferredHeight: 36
			onClicked: {
				// This'll close the popup.
				// TODO: Add the animations in for opening and closing it.
				// They were "barn door sweeps" from the top.
				// TODO 2: Allow using the Enter key to activate buttons,
				// and not just spacebar.
				deprecatedRawTileHeightsAndWidthsMessageDialog.close();
			}
		}
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

		//Flickable {
				//// This is an example of a tile page
				//// background wallpaper as taken from the
				//// parallax-background-test branch.
				//// It has some problems with ensuring the image
				//// is always visible rather than displaying empty
				//// areas, so it's not fully available yet.
				//// The example wallpaper that's available is
				//// of my cat Mitty, and it was taken with
				//// a Nokia Lumia 822 on September 28, 2013.
				//// This is the same image I liked using on
				//// Windows Phone 8.1 as a tile background,
				//// so I'm using it for testing.
				//// Please be respectful in how you use this image.
				
				//// In case it's not clear, Windows Phone 8.1 had
				//// parallax scrolling tile backgrounds, so I'd like
				//// to implement the same thing so that no one misses it,
				//// because it looks really cool. That's also where I got
				//// the idea for the feature, just to be completely clear
				//// on this.
				
				//// Source for the original code that I tried to learn
				//// from on how to do parallax scrolling in QML,
				//// including the original text I wrote when trying
				//// to figure this out, though it's somewhat different
				//// the way I implemented it. Guess I should say I used
				//// the example under the BSD License as displayed below the text,
				//// and that the example file is Copyright (C) 2017 The Qt Company Ltd..
				//// 	Trying to implement parallax scrolling based on
				//// 	this example:
				//// 	https://doc.qt.io/archives/qt-5.9/qtquick-views-parallax-content-parallaxview-qml.html
				//// 	I did read on the Qt forums that someone suggested
				//// 	using a nested Flickable, so I may have to do that
				//// 	if this doesn't work.
				
					// BSD License begins:
					// "Redistribution and use in source and binary forms, with or without
					// modification, are permitted provided that the following conditions are
					// met:
					//   * Redistributions of source code must retain the above copyright
					//     notice, this list of conditions and the following disclaimer.
					//   * Redistributions in binary form must reproduce the above copyright
					//     notice, this list of conditions and the following disclaimer in
					//     the documentation and/or other materials provided with the
					//     distribution.
					//   * Neither the name of The Qt Company Ltd nor the names of its
					//     contributors may be used to endorse or promote products derived
					//     from this software without specific prior written permission.
					//
					//
					// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
					// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
					// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
					// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
					// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
					// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
					// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
					// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
					// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
					// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
					// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
					// BSD License ends.
				
				//// Experimenting with setting the contentY to
				//// the tilesFlickable current scroll position
				//// multiplied by 0.12 to try to do parallax scrolling.
				//contentY: tilesFlickable.contentY * 0.12
				//// Offset the flickable by tilesContainer.height * -0.1
				//// so it doesn't show the edge of the image.
				//y: tilesContainer.height * -0.1
				
					Image {
						id: tileWallpaper
						fillMode: Image.PreserveAspectCrop
						// Setting the width to tilesContainer's width plus 50
						// ensures empty space on the right is hidden.
						// Actually, we shouldn't do that anymore because then it
						// goes too far outside its intended area.
						width: window.width
						// Setting the height to the window's height multiplied
						// by 1.2 ensures the image is at least as tall as the
						// window, but this introduces a problem if there are enough
						// tiles to make the tilesContainer taller than the window.
						// The solution to this doesn't seem to be to use the tilesContainer's
						// height, because resizing, pinning, and unpinning tiles
						// will change the height of the tilesContainer, and thus the
						// background image.
						height: window.height * 1.2
						// Ensure the image doesn't go into the All Apps list area.
						// This may be desirable for some if they want it like
						// Windows 10 Mobile, but there's no horizontal parallax for the image
						// yet, so it just ends up showing part of itself in the All Apps area.
						// As stated at the bottom of this section, it's important to clip an image if
						// using PreserveAspectCrop, as it can still go outside its intended bounds:
						// https://doc.qt.io/qt-6/qml-qtquick-image.html#fillMode-prop
						// We don't actually need clipping anymore for this, as it stays
						// in the tiles area on its own now.
						//clip: true
						source: wallpaperPath
						visible: displayBackgroundWallpaper
						
						y: allowParallax == true ? -tilesFlickable.contentY * 0.12 : 0
					
					} //// End of the tile area background image item.

					Rectangle {
						// Darken the wallpaper by 20% like WP does,
						// or however much the user decided to set the
						// opacity to, with whichever color they decided
						// to use.
						// Only render it when the opacity is greater
						// than 0 and the option to display
						// a background wallpaper is on to save processing power.
						// Probably shouldn't have this dim if the user wants
						// to use a solid-color background different from their
						// accent color instead of an image.
						visible: opacity > 0 && displayBackgroundWallpaper
						color: wallpaperOverlayLayerColor
						opacity: wallpaperOverlayLayerOpacity
						anchors.fill: tileWallpaper
					}
		//} //// End of the flickable allowing the background image to have some parallax scrolling.
		
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
		
		MouseArea {
			// This MouseArea lets us leave edit mode when clicked inside it.
			// TODO: Move this block and the one in the Shortcut
			// at the top of this file to a separate function to not
			// have to change it in multiple places.
			onClicked: {
				if (globalEditMode == true) {
				// Turn off global edit mode.
				toggleGlobalEditMode(false, true);
				// Hide editMode controls for each tile.
				// This also resets z-index values for each tile.
				hideEditModeControlsOnAllTiles();
				// Reset opacity for each tile.
				setTileOpacity();
				// TODO: Figure out how to ensure we can click
				// anywhere on the tiles page to exit edit mode,
				// because right now there's an area on the right
				// side where it won't work.
				} 
			}
			// Set the width and height manually instead of using
			// anchors to fill the Flickable.
			// This allows the user to tap anywhere inside the tiles
			// area's background to leave edit mode.
			width: window.width
			// HACK: Might be kinda a hack to add the window's height to the tilePageContentHolder's
			// height, but at least it's a more reliable way to ensure the MouseArea
			// to allow exiting edit mode fills the area properly.
			// TODO: figure out a non-hacky way to do this.
			height: window.height + tilePageContentHolder.height
			//Rectangle {
			//  // Rectangle for testing, if you need to uncomment this.
			//	color: "green"
			//	anchors.fill: parent
			//}
		}

		RowLayout {
			
			Item {
				// Empty item that acts as a margin on the left of the
				// tiles so it can be scrolled, as margins don't allow scrolling.
				// 20 gives us more of a centered appearance.
				Layout.preferredWidth: 20
			}
		
		ColumnLayout {
			id: tilePageContentHolder
		
		Item {
			// Create an empty item so the area above
			// the tiles works as a scrollable area.
			id: tilesPageTopSpacer
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
			// We have to do it like this or else the All Apps
			// button will shift around horizontally and resizing
			// the tiles will make them eventually go into one list.
			// Subtracting 33 from the window's width results in the same
			// horizontal position as it had on WP7.8-8.1 Update 1.
			// At least, I assume it was the same position on 7.8 through
			// 8.1 non-Update 1, because that's what it is on 8.1 Update 1.
			// May need to change this when the tiles are more centered.
			Layout.preferredWidth: window.width - 33
			Layout.fillWidth: true
			// Set layout to the center.
			Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
			
			// Add proper transitions when tiles move around based on this example
			// and also basing the details on the tile resize transition I put into the Tile.qml file:
			// https://doc.qt.io/qt-6/qml-qtquick-viewtransition.html#view-transitions-a-simple-example
			// Consult this page for easing options:
			// https://doc.qt.io/qt-6/qml-qtquick-propertyanimation.html
			// Made the duration longer and used InOutQuart to make it feel better.
			move: Transition {
				// TODO: Use a simultaneous animation or whatever it is to have things
				// move at the same time for both.
				PropertyAnimation { property: "x"; duration: 200; easing.type: Easing.InOutQuart }
				PropertyAnimation { property: "y"; duration: 200; easing.type: Easing.InOutQuart }
			}
			
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
				/* RetiledStyles.Tile {
				tileText: qsTr("WP8.1 app with a really long name")
				width: 150
				height: 150
				tileBackgroundColor: "red"
				// You can access code in the main.py file from QML sub-pages.
				onClicked: allAppsListViewModel.getDotDesktopFiles()
				}
				RetiledStyles.Tile {
				tileText: qsTr("WP8.1 app with a really long name")
				width: 310
				height: 150
				tileBackgroundColor: "purple"
				onClicked: tilesListViewModel.getTilesList()
				}
				RetiledStyles.Tile {
				tileText: qsTr("WP8.1 app with a really long name")
				width: 150
				height: 150
				tileBackgroundColor: "orange"
				}
				RetiledStyles.Tile {
				tileText: qsTr("WP8.1 app with a really long name")
				width: 70
				height: 70
				} */
				
				// Set up the tile click signals.
				function tileClicked(execKey) {
					allAppsListViewModel.RunApp(execKey);
					// console.log(execKey);
				}
				
				// Pinning a tile to start.
				function pinToStart(dotDesktopFilePath) {
					// Create a new tile using the .desktop file path.
					// Copied from the other code that adds tiles on
					// startup because this hasn't been separated yet.
					// TODO: Put the code to create tiles into its own
					// function to reduce code duplication.
					var TileComponent = Qt.createComponent("../../../RetiledStyles/Tile.qml");
					
					var NewTileObject = TileComponent.createObject(tilesContainer);
						
						// Set tile properties.
							NewTileObject.tileText = allAppsListViewModel.GetDesktopEntryNameKey(dotDesktopFilePath);
							NewTileObject.tileSize = "medium";
							// 157x157 is what the 720p WP8.1 Update 1 emulator has at 100%
							// for medium tiles after dividing the size by 2.
							// It doesn't line up properly on a PinePhone in horizontal, though.
							// Maybe it needs different values for spacing?
							// Maybe not though, as 150x150 is the official size, so maybe
							// it just needs more spacing on the left side.
							NewTileObject.width = 150;
							NewTileObject.height = 150;
							// Set the boolean to use the tile background wallpaper on this tile,
							// according to the user's choices in the config file.
							NewTileObject.useTileBackgroundWallpaper = useTileBackgroundWallpaper;
							// TODO: Add another property to tiles so they'll default to
							// using accent colors unless the boolean to use accent colors
							// is off, in which case they'll use a specified tile background
							// color according to the layout config file or the .desktop file.
							NewTileObject.tileBackgroundColor = Universal.accent;
						// Doesn't quite work on Windows because the hardcoded tile is trying to read
						// from /usr/share/applications and can't find Firefox.
						// Turns out it was trying to run Firefox. Not sure how to stop that.
						// Actually, I think this involves an event handler:
						// https://stackoverflow.com/a/22605752
						// For some reason, the entire path isn't being set on Windows.
							NewTileObject.execKey = dotDesktopFilePath;
						
						// Set the .desktop file path for unpinning or resizing.
							NewTileObject.dotDesktopFilePath = dotDesktopFilePath;

						// Set the icon path for the new tile.
							NewTileObject.tileIconPath = getAppIcon.getIcon(dotDesktopFilePath, iconTheme)
						
						// Set tile index for the edit mode.
							NewTileObject.tileIndex = pinnedTilesCount + 1;
						//console.log("pinnedTilesCount: " + pinnedTilesCount);
						// Connect clicked signal.
							NewTileObject.tileClicked.connect(tileClicked);
						
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
							
							// Force the layout of the tiles list:
							// https://doc.qt.io/qt-5/qml-qtquick-flow.html#forceLayout-method
							tilesContainer.forceLayout();
							
							// Increment the tile count and go back to the tiles page.
							checkPinnedTileCount(1, true);
							//console.log("pinnedTilesCount: " + pinnedTilesCount);
							// Exit global edit mode so we save the newly-pinned tile
							// to the layout config file.
							toggleGlobalEditMode(false, true);
							
							// Force the layout of the tiles list:
							// https://doc.qt.io/qt-5/qml-qtquick-flow.html#forceLayout-method
							tilesContainer.forceLayout();
							
				}
				
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
						// First make sure we're not in global edit mode.
						if (globalEditMode == false) {
							if (startScreenView.interactive == false) {
							// Allow it to be interactive again and switch to it.
								startScreenView.interactive = true;
								startScreenView.currentIndex = 0;
							// Show the All Apps button again, too.
								allAppsButton.visible = true;
							// Reset the Back button/Escape key shortcut.
								backButtonShortcut.enabled = true;
							} else if ((startScreenView.interactive == true) && (startScreenView.currentIndex == 1)) {
								// Move to the bottom of the tiles list, as we're pinning a tile:
								// https://stackoverflow.com/a/25363306
								// As it turns out, you have to use the flickable's values
								// for both contentHeight and height in order for this to work,
								// or it won't be the right position.
								//Actually, returnToBounds() works great when using the y-value from the All Apps button.
								tilesFlickable.contentY = allAppsButton.y;
								// Ensure we're in bounds:
								// https://doc.qt.io/qt-6/qml-qtquick-flickable.html#returnToBounds-method
								tilesFlickable.returnToBounds();
								startScreenView.currentIndex = 0;
								// Not sure if this code will help when I'm trying to figure out
								// moving to the bottom to pin tiles.
							} // End of if statement seeing if the swipeview is currently interactive.
						} // End of global edit mode check.
					} else {
						// There are either 0 or fewer tiles pinned, so hide the tiles page.
						// It's unlikely that there will be fewer than 0 tiles, but
						// I'm just allowing for the possibility to ensure things don't break.
						// Also check to see if global edit mode is currently on.
						if ((startScreenView.interactive == true) || (globalEditMode == true)) {
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
							// Also don't show the all apps button or let the user go
							// back to the tiles list.
							toggleGlobalEditMode(false, false);
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

						// Set a boolean if this tile is using the deprecated format.
						// TODO: Remove this in v0.1-DP3.
						if (ParsedTilesList[i].hasDeprecatedRawWidthAndHeight == "True") {
							tripDeprecatedTileRawWidthAndHeightValuesBoolean();
						}
						
						// Now create the tile.
						// Make sure it's ready first.
						// TODO: Switch to incubateObject.
						//if (TileComponent.status == Component.Ready) {
							var NewTileObject = TileComponent.createObject(tilesContainer);
						// Increment the tile count.
							checkPinnedTileCount(1, true);
						// Set tile properties.
							NewTileObject.tileText = allAppsListViewModel.GetDesktopEntryNameKey(ParsedTilesList[i].DotDesktopFilePath);
							NewTileObject.tileSize = ParsedTilesList[i].TileSize;
							// Using the tileSize property to set the tile's height and width.
							// Please note: in the future, we're not going to be setting height
							// and width, and instead we'll be setting rows and columns
							// in TilesGrid.
							// These values are ones that I got from a screenshot of the
							// 720p Windows Phone 8.1 Update 1 emulator at 100% scale,
							// then I divided those values by 2 and got these.
							// They're slightly larger than they were before,
							// but it's more accurate.
							// Actually, maybe it's worse because they don't line up
							// properly now.
							// I'm going back to the officially-documented values.
							if (NewTileObject.tileSize == "small") {
								NewTileObject.width = 70;
								NewTileObject.height = 70;
							} else if (NewTileObject.tileSize == "wide") {
								NewTileObject.width = 310;
								NewTileObject.height = 150;
							} else {
								NewTileObject.width = 150;
								NewTileObject.height = 150;
							}
							NewTileObject.tileBackgroundColor = accentColor;
							// Set the boolean to use the tile background wallpaper on this tile,
							// according to the user's choices in the config file.
							NewTileObject.useTileBackgroundWallpaper = useTileBackgroundWallpaper;
						// Doesn't quite work on Windows because the hardcoded tile is trying to read
						// from /usr/share/applications and can't find Firefox.
						// Turns out it was trying to run Firefox. Not sure how to stop that.
						// Actually, I think this involves an event handler:
						// https://stackoverflow.com/a/22605752
							NewTileObject.execKey = ParsedTilesList[i].DotDesktopFilePath;
						
						// Set the .desktop file path for unpinning or resizing.
							NewTileObject.dotDesktopFilePath = ParsedTilesList[i].DotDesktopFilePath;
						
						// Set the icon path for the new tile.
							NewTileObject.tileIconPath = getAppIcon.getIcon(NewTileObject.dotDesktopFilePath, iconTheme)

						// HACK: Say that we're done loading the icon to
						// force QtQuick to go to the expected icon size.
						// This doesn't work to reload the icon, maybe I need to
						// unset the path to the icon and put it back?
						NewTileObject.tileIconLoadingComplete = true

						// Set tile index for the edit mode.
							NewTileObject.tileIndex = i
						
						// Connect clicked signal.
							NewTileObject.tileClicked.connect(tileClicked);
						
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
	
		
		
		Item {
			// Empty item above All Apps button for spacing.
			// Wasn't quite tall enough.
			Layout.preferredHeight: 8
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
			// Ok, I don't think I can just use the font directly
			// from the repo, and instead it'll need to be installed
			// into the fonts directory, usually "/usr/share/fonts",
			// but can also be "~/.local/share/fonts/".
			// This will be replaced with SVG files soon, anyway.
			text: "<b>\ue021</b>"
			// I guess it'll work for now, but we need to use ".name"
			// instead of ".font" for some reason.
			// Got this idea from here:
			// https://stackoverflow.com/a/57219406
			fontFamily: metroFont.name
			
			// Set background color for when pressed.
			// By default this is white.
			// This would probably be black in light themes.
			pressedBackgroundColor: ThemeLoader.getValueFromTheme(themePath, "Tiles", "TileRoundButtonPressedBackgroundColor", "white")
			// Set text color for when the button is pressed.
			// This is white by default, as most round buttons
			// don't change their text color.
			// I think this would also have to be white when
			// using the light theme.
			pressedTextColor: ThemeLoader.getValueFromTheme(themePath, "Tiles", "TileRoundButtonPressedTextColor", "black")
			// If necessary, you can also set the default text color.
			// This is the color that the text color returns to after
			// un-pressing the button.
			// Light themes would have the default text color be black
			// I think.
			// defaultTextColor: "white"
			// Set accessibility stuff:
				// https://doc.qt.io/qt-6/qml-qtquick-accessible.html
				// Didn't know this was a thing, but I learned about it
				// from a Mastodon post.
				// Partially copying from that page.
				Accessible.role: Accessible.Button
				Accessible.name: "All Apps button"
    			Accessible.description: "Goes to the All Apps list."
    			Accessible.onPressAction: {
        			// Click the button with the accessibility press feature:
					// https://stackoverflow.com/a/34332489
					// I really hope this works, because I don't really
					// have any way to test it as far as I know.
					clicked()
    			}
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
				// TODO: have the All Apps button be pushed over so that it lines up
				// below the bottom-right corner of the tiles. Right now it's not quite
				// in the right spot.
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
