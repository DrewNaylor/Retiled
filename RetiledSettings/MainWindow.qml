// RetiledSettings - Windows Phone 8.0-like Settings app for the
//                   Retiled project.
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
import "../RetiledStyles" as RetiledStyles


ApplicationWindow {
    id: window
    width: 360
    height: 720
    visible: true
    title: qsTr("RetiledSettings")

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
	Universal.background: ThemeLoader.getValueFromTheme(themePath, "UniversalStyle", "UniversalBackgroundColor", "black")

	// Turning off tilt for accessibility if desired.
	property bool allowTilt: settingsLoader.convertSettingToBool(settingsLoader.getSetting("accessibility", "AllowTilt", "true"))
	
	// Bring in the shortcut code for the app bar.
	// Copied from my modified version of the Qml.Net example app,
	// but modified for this one. Code here:
	// https://github.com/DrewNaylor/wp-like_qmlnet-examples/blob/master/src/Features/Main.qml
	Shortcut {
		sequences: ["Esc", "Back"]
        enabled: stackView.depth > 1
        onActivated: {
			
            stackView.pop()
            
			if (stackView.depth == 1) {
						// TODO: Move this to a function, preferably stackView.pop()
						// if that's defined in this file.
						// Only hide the back button if we can't
						// go back any further.
						// The double-equals is required rather than
						// a single-equals, as otherwise it'll complain
						// that depth is read-only and won't just compare.
						backButton.visible = false
						// Show the ellipsis button again.
						appbarEllipsisButton.visible = true
						// Set the appbar and its drawer background color to the default.
						// TODO: move this to another file so it can just be referenced
						// along with all the other light and dark theme colors.
						// TODO 2: For real though, this needs to be moved for theme support.
						appBar.backgroundColor = ThemeLoader.getValueFromTheme(themePath, "AppBar", "BackgroundColor", "#1f1f1f")
						appbarDrawer.backgroundColor = ThemeLoader.getValueFromTheme(themePath, "AppBarDrawerBase", "BackgroundColor", "#1f1f1f")
					}
			
        }
    }
	
	Shortcut {
    // The Menu key is the context menu key on the keyboard.
    // I've hooked it up to the app bar drawer so that it's
    // easier to open with the keyboard.
        sequence: "Menu"
		// Prevent activation when the About window is open.
		enabled: stackView.depth == 1
        // TODO: It would be useful to have a way to open
        // and close the app bar drawer using the same
        // key. However, this would require a boolean
        // to be set when the drawer is opened and closed,
        // and I don't know enough about QML booleans right
        // now and I need to go to bed.
        onActivated: appbarDrawer.open()
    }
	
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
			source: "../fonts/wp-metro/WP-Metro.ttf"
		}
		
			// Load Open Sans Regular for the textbox and other controls
			// that use Open Sans Regular.
			// Source for the textbox thing:
			// https://github.com/microsoftarchive/WindowsPhoneToolkit/blob/master/Microsoft.Phone.Controls.Toolkit.WP8/Themes/Generic.xaml#L1309
	//FontLoader {
			//id: opensansRegular
			// This is using the Open Sans font, which you can
			// find here:
			// https://fonts.google.com/specimen/Open+Sans
			// This font was designed by Steve Matteson and is under the Apache License, Version 2.0:
			// http://www.apache.org/licenses/LICENSE-2.0
			//source: "../../fonts/open_sans/static/OpenSans/OpenSans-Regular.ttf"
		//}
		
		//FontLoader {
			//id: opensansSemiBold
			// This is using the Open Sans SemiBold font, which you can
			// find here:
			// https://fonts.google.com/specimen/Open+Sans
			// This font was designed by Steve Matteson and is under the Apache License, Version 2.0:
			// http://www.apache.org/licenses/LICENSE-2.0
			//source: "../../fonts/open_sans/static/OpenSans/OpenSans-SemiBold.ttf"
		//}
		
			// Properties for pixel density:
	// https://stackoverflow.com/a/38003760
	// This is what QML told me when I used
	// console.log(Screen.pixelDensity).
	property real mylaptopPixelDensity: 4.4709001084468
	// This is just whatever the device that's running will use.
	property real scaleFactor: Screen.pixelDensity / mylaptopPixelDensity
	
	footer: RetiledStyles.AppBar {
		id: appBar
    }

	property bool backButtonVisible: false

	property bool appbarEllipsisButtonVisible: true

    RetiledStyles.AppBarDrawer {
		id: appbarDrawer
		// Note: these pages here will eventually be replaced
			// with items that would be in a settings app's appbar drawer,
			// and not ones that are now in the main list.
			// TODO: Figure out how to make sure we stay in our app's path
			// instead of trying to get stuff from the RetiledStyles folder.
            drawerItems: ListModel {
				ListElement { title: "start+theme"; navigate: "true"; source: "../RetiledSettings/pages/start-theme.qml" }
				ListElement { title: "about"; navigate: "true"; source: "pages/About.qml" }
				// "debug command" is just a test for now to allow commands
				// to be used from the appbar.
				// An example would be pinning something to Start.
				ListElement { title: "debug command"; navigate: "false"; command: "hello" }
            }
    }

	StackView {
		// Set up the stackview to have page navigation.
		id: stackView
		anchors.fill: parent
	
		initialItem: Page {

			header: RetiledStyles.PlainPageHeader {
				// This is the page header for pages that just have
				// the app name and page name.
				// TODO: Replace this with the Pivot once that's implemented
				// to go between lists.
				appTitleText: "retiledsettings"
				pageTitleText: "system"
			}
		
		id: pane
		
        spacing: 4


// This part is basically just the appbar drawer items moved out into a proper list.
// TODO: Figure out how to have tabbing and arrow keys work correctly.
// TODO 2: Allow pages to actually have appbars that are separate from the emergency
// Back button.
         ListView {
            anchors.fill: parent
            clip: true
            focus: true

            delegate: RetiledStyles.AppBarDrawerEntry {
                width: parent.width
                text: model.title
                onClicked: {
                    stackView.push(model.source)
					// Set the appbar drawer's color to transparent.
					appbarDrawer.backgroundColor = "transparent"
					// Close the appbar drawer.
                    appbarDrawer.close()
					// Show the back button to allow navigating back.
					backButton.visible = true
					// Have the appbar be transparent.
					appBar.backgroundColor = "transparent"
					// Hide the ellipsis button.
					appbarEllipsisButton.visible = false
                }
            }

            model: ListModel {
				ListElement { title: "start+theme"; source: "pages/start-theme.qml" }
				ListElement { title: "about"; source: "pages/About.qml" }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
            }
		} // End of the pane within the StackView for navigation.
	} // End of the StackView.
} // End of the ApplicationWindow.
