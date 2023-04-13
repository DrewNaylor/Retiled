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

    Universal.theme: Universal.Dark
	// Property for setting Accent colors so that Universal.accent
	// can in turn be set easily at runtime.
	property string accentColor: settingsLoader.getSetting("themes", "AccentColor", "#0050ef")
    Universal.accent: accentColor
	Universal.foreground: 'white'
	// Fun fact: QML supports setting the background to transparent,
	// which shows all the other windows behind the app's window as you'd expect.
	Universal.background: 'black'

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
						appBar.backgroundColor = "#212021"
						appbarDrawer.backgroundColor = "#212021"
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
	
	footer: RetiledStyles.AppBar {

                id: appBar

        transform: Translate {
        // Move the menu to make it look like WP's ellipsis menu opening.
        y: appbarDrawer.position * appBar.height * -1
         }

        RowLayout {
            spacing: 0
            anchors.fill: parent


            RetiledStyles.AppBarMoreButton {
			// Usually we won't use the AppBarMoreButton for items here,
			// but the Back button can't have any visual changes.
			id: backButton
			visible: false
			// QML with Python requires you use "file:" before
			// the image path as specified here:
			// https://stackoverflow.com/a/55515136
				// TODO: Figure out a way to use SVG files because
				// this is blurry with HiDPI.
                text: "<b>\ue020</b>"
				font: metroFont.name
                onClicked: {
                    if (stackView.depth > 1) {
                        stackView.pop()
                        }
					if (stackView.depth == 1) {
						// Only hide the back button if we can't
						// go back any further.
						// The double-equals is required rather than
						// a single-equals, as otherwise it'll complain
						// that depth is read-only and won't just compare.
						backButton.visible = false
						// Set the appbar and its drawer background color to the default.
						appBar.backgroundColor = "#212021"
						appbarDrawer.backgroundColor = "#212021"
						// Show the ellipsis button again.
						appbarEllipsisButton.visible = true
						// TODO: Figure out a way to change the appbar's color
						// so it looks like the back button is just floating there
						// rather than being part of the bar.
					}
                }
            }

            Item {
            // This empty item is necessary to take up space
            // and push the back button and ellipsis button to both edges.
            // I guess I could've just tweaked things a bit.
                Layout.fillWidth: true
            }
			
            RetiledStyles.AppBarMoreButton {
				id: appbarEllipsisButton
				width: 20
				// TODO: Figure out a way to use SVG files because
				// this is blurry with HiDPI.
                // icon.source: "../icons/actions/ellipsis_white.svg"
				Image {
			// It's "pressed", not "down", to change images:
			// https://stackoverflow.com/a/30092412
			source: "../../icons/actions/ellipsis_white.svg"
			// Set source size so it's crisp:
			// https://doc.qt.io/qt-5/qml-qtquick-image.html#sourceSize-prop
			sourceSize.width: 40
			sourceSize.height: 15
			anchors.top: parent.top
			anchors.horizontalCenter: parent.horizontalCenter
			// Mipmapping makes it look pretty good.
			mipmap: true
		}
				// For some reason, I can only open the app bar by pulling it
				// up. Fortunately, you can swipe where you're supposed to be
				// able to tap the button at. Unfortunately, that may interfere
				// with other appbar buttons that may be added in the future.
                onClicked: {
                        appbarDrawer.open()
                }
            }


        }
    }

    RetiledStyles.AppBarDrawerBase {
    // TODO: Figure out a way to allow the drawer to be closed from any
    // page and not just from clicking inside the main page or clicking
    // on any of the items in the drawer.
    // TODO 2: Figure out how to let the user drag the app bar back down
    // on both the right and the left side to close the
    // drawer, like on Windows Phone.
    // TODO 3: Change the app bar icons so they're closer to WP, especially
    // the app bar drawer opening button, as that's more like Windows 10
    // Mobile.
	// TODO 4: Move the font-related stuff to another style so that
	// more apps can use this customized appbar drawer.
        id: appbarDrawer
        width: window.width
        // Set height to 50 so that the app bar always moves out of the way,
        // even when the window is taller or shorter.
        height: 55
		// Not sure what Interactive means, but I'll guess it determines
		// if you can interact with the app drawer.
        interactive: stackView.depth === 1
        // Setting edge to Qt.BottomEdge makes the menu
        // kinda look like WP's ellipsis menu, except it
        // doesn't yet move the bar up. Maybe a translation
        // thing will help with that.
        // Edge documentation:
        // https://doc.qt.io/qt-5/qml-qtquick-controls2-drawer.html#edge-prop
        edge: Qt.BottomEdge
		
		// Set font.
		font.family: RetiledStyles.FontStyles.semiboldFont
		font.weight: RetiledStyles.FontStyles.semiboldFontWeight
		// TODO: Move letter spacing into the control.
		font.letterSpacing: -0.8 * scaleFactor


        // Removing the shadow from the drawer:
        // https://stackoverflow.com/a/63411102
        

       Rectangle {
       // You have to set this rectangle's color
       // or else it'll be white.
            anchors.fill: parent
            color: "transparent"
        

        ListView {
            id: appbarDrawerListView
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
				ListElement { title: "about"; source: "pages/About.qml" }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
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
