// RetiledSearch - Windows Phone 8.0-like Search app for the
//                 Retiled project.
//                 To view "git blame" on this file before it was moved
//                 back to Retiled, see here:
//                   https://github.com/DrewNaylor/wp-like_qmlnet-examples/blob/retiled-qml-porting-work/src/Features/Main-PyRetiledSearch.qml
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
import "../../RetiledStyles" as RetiledStyles


ApplicationWindow {
    id: window
    width: 360
    height: 720
    visible: true
    title: qsTr("RetiledSearch")

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
						backButtonVisible = false
						// Show the ellipsis button again.
						appbarEllipsisButtonVisible = true
						// Set the appbar and its drawer background color to the default.
						// TODO: move this to another file so it can just be referenced
						// along with all the other light and dark theme colors.
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
			source: "../../fonts/wp-metro/WP-Metro.ttf"
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
	
	// Put the appbar on the footer.
	footer: RetiledStyles.AppBar {
		// We need an ID for this because it's referred to from the appbar drawer's code.
		// It has to be "appBar" for it to work.
		// TODO: Make it not require an ID.
		id: appBar
		// Note: we need to add the appbar buttons eventually instead of just having nothing here.
    }

	// Appbar stuff for the emergency back button and ellipsis button to be visible.
	property bool backButtonVisible: false
	property bool appbarEllipsisButtonVisible: true

	// Get the app root path for the appbar and appbar drawer pages.
	readonly property string appRootPath: AppRootPath.getAppRootPath()

    RetiledStyles.AppBarDrawer {
		// We need an ID for this because it's referred to from the appbar's code.
		// It has to be "appbarDrawer" for it to work.
		// TODO: Make it not require an ID.
		id: appbarDrawer
		// Note: There will eventually be more items than just an about page here.
		// TODO: Figure out how to make sure we stay in our app's path
		// instead of using the current working directory.
		// We have to use Component.onCompleted and ListModel.append
		// in order to grab stuff from the app's root path:
		// https://stackoverflow.com/a/33161093
		drawerItems: ListModel {

			// Now add stuff to the ListModel.
			// See the SO answer above the drawerItems line
			// for more details.
			Component.onCompleted: {
				append({ title: "about", navigate: "true", source: appRootPath + "/pages/About.qml" });
			}
		}
    }

	StackView {
		// Set up the stackview to have page navigation.
		id: stackView
		anchors.fill: parent
	
		initialItem: Pane {
		
		id: pane
		
        spacing: 4


// The rest of this isn't from the modified Qml.Net example app, or at least shouldn't be.
         RetiledStyles.TextFieldBase {
            id: searchBox
			// Allow the user to use the Enter key to search.
			Keys.onEnterPressed: {
				searchClass.openUrl(searchBox.text)
			}
			// We also have to have one for onReturnPressed
			// because Qt doesn't consider the Return key to
			// be the same as the Enter key, even though it's
			// literally labeled as "Enter" on my keyboard.
			Keys.onReturnPressed: {
				searchClass.openUrl(searchBox.text)
			}
			// Anchor the search box to the left and right of the window.
			anchors.margins: 12
			anchors.topMargin: 5
			anchors.top: parent.top
			anchors.right: parent.right
			anchors.left: parent.left
            implicitHeight: 40
            placeholderText: qsTr("enter a search term here")
            // I don't know if pixelSize is the right property
            // to change for DPI scaling.
			// pixelSize isn't device-independent.
			// Forgot to add the prefix.
            font.pointSize: RetiledStyles.FontStyles.normalFontSize
			// Set font style to opensans.
			font.family: RetiledStyles.FontStyles.regularFont
			font.weight: RetiledStyles.FontStyles.regularFontWeight
			
			// There are some additional properties you can set:
			// Change the textfield's background color when focused.
			//   focusedBackgroundColor: "white"
			// Change the textfield's background color when unfocused.
			//   unfocusedBackgroundColor: "#CCCCCC"
			// Set the unfocused placeholder text.
			// This was as close as I could get to what Avalonia's
			// placeholder text color was at the opacity I set.
			//   unfocusedPlaceholderTextColor: "#666666"
			// Set the focused placeholder text color.
			// This is mostly used to make it disappear
			// when focused so it doesn't interfere with
			// the text.
			//   focusedPlaceholderTextColor: "transparent"
			// Additionally, "selectByMouse" is set to true
			// by default now.
			// "color" is now also set to "black" so the text shows
			// up with the white background.
			// Border width also changes from 0 when unfocused to 2
			// when focused. There isn't a property to change that yet.
         }
		 
		 
         RetiledStyles.Button {
            id: searchButton
			onClicked: {
				searchClass.openUrl(searchBox.text)
			}
			
			// Pro-tip: set these properties rather than
			// putting in a contentItem or it'll override
			// the style's contentItem.
			// I'm not setting them because they're already
			// set.
			//fontSize: 18
			//textColor: "white"
			//pressedBackgroundColor: "#0050ef"
			//unpressedBackgroundColor: "transparent"
			//borderColor: "white"
			//borderWidth: 2
			//borderRadius: 0
			
			// However, I will set these properties.
			buttonWidth: 100
			buttonHeight: 40
			
			// Set margins and anchors.
			anchors.top: searchBox.bottom
			anchors.margins: 12
			anchors.topMargin: 4
			anchors.left: parent.left
			
			// Set the text.
            text: qsTr("search")
			// Set font style to opensans.
			// Apparently ButtonBase uses SemiBold:
			// https://github.com/microsoftarchive/WindowsPhoneToolkit/blob/master/PhoneToolkitSample8/App.xaml#L51
			// Hope it works, but I can't really tell a difference.
			// It actually is noticeable on the PinePhone, but I don't
			// know if I'll keep it SemiBold in the button template.
			// Windows Phone uses PhoneFontSizeMediumLarge for ButtonBase,
			// which is a double and has the value of 25.333.
			// This is a problem for QML's pixelSize, because that's
			// an integer, so we have to round down to 25.
			// Had to change the width above.
			// 25 was too big.
			// I'm just setting this in the Button control file.
            

		} // End of the Search button.
		RetiledStyles.Button {
			visible: false
			// This button changes the Accent color for the app.
			onClicked: {
				accentColor = "Maroon";
			}
		}
		} // End of the pane within the StackView for navigation.
	} // End of the StackView.
} // End of the ApplicationWindow.
