// RetiledActionCenter -  Windows Phone 8.1-like Action Center UI for the
//                        Retiled project.
// Copyright (C) 2021-2023 Drew Naylor
// (Note that the copyright years include the years left out by the hyphen.)
// (This file is based off RetiledStart, hence the copyright including 2021.)
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
import "../../RetiledStyles" as RetiledStyles

// Bring in the All Apps page.
import "." as RetiledStartPages

ApplicationWindow {
	
	id: window
    width: 360
    height: 720
    visible: true
    title: qsTr("RetiledActionCenter")

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
	// Currently used for the button to test changing the Accent color
	// at runtime if a different color besides Cobalt is desired.
	property string defaultAccentColor: settingsLoader.getSetting("themes", "AccentColor", "#0050ef")
	Universal.foreground: ThemeLoader.getValueFromTheme(themePath, "UniversalStyle", "UniversalForegroundColor", "white")
	// Fun fact: QML supports setting the background to transparent,
	// which shows all the other windows behind the app's window as you'd expect.
	// This will probably be useful when working on stuff like the volume controls and Action Center.
	Universal.background: ThemeLoader.getValueFromTheme(themePath, "UniversalStyle", "UniversalBackgroundColor", "black")

	// Turning off tilt for accessibility if desired.
	property bool allowTilt: settingsLoader.convertSettingToBool(settingsLoader.getSetting("accessibility", "AllowTilt", "true"))
	
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
			//source: "../../fonts/open_sans/static/OpenSans/OpenSans-Regular.ttf"
		//}
	
	
	Shortcut {
		id: backButtonShortcut
		sequences: ["Esc", "Back"]
        onActivated: {
			
			// Go back to the tiles list.
            //startScreenView.currentIndex = 0
			// Also set the flickable's contentY property to 0
			// so it goes back to the top, like on WP:
			// https://stackoverflow.com/a/7564705
			//tilesFlickable.contentY = 0
			
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
	
	
	// Add testing buttons.
	RowLayout {
		RetiledStyles.ActionCenterActionButton {
			// Flashlight toggle.
			actionCenterButtonText: "FLASHLIGHT"
			buttonCommand: isToggled ? "flashlight_on" : "flashlight_off"
			// Can't use the JS functions for this, for some reason.
			onReleased: actionCenterActionButtonsViewModel.runCommand(buttonCommand)
		}
		RetiledStyles.ActionCenterActionButton {
			// Change the Accent color from Cobalt (#0050ef) to Maroon when
			// toggled on.
			// Doesn't quite work correctly if using a different Accent color, so there's
			// something that needs to be figured out later.
			actionCenterButtonText: "CHANGE ACCENT"
			buttonCommand: isToggled ? "maroon" : defaultAccentColor
			onReleased: {
				accentColor = buttonCommand;
				}
		}
	} // End ActionCenter button RowLayout container.
	
}// End of the window.
