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
						// TODO: move this to another file so it can just be referenced
						// along with all the other light and dark theme colors.
						appBar.backgroundColor = "#1f1f1f"
						appbarDrawer.backgroundColor = "#1f1f1f"
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

        transform: Translate {
        // Move the menu to make it look like WP's ellipsis menu opening.
        y: appbarDrawer.position * (appBar.height * 3) * -1
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
				// Set accessibility stuff:
				// https://doc.qt.io/qt-6/qml-qtquick-accessible.html
				// Didn't know this was a thing, but I learned about it
				// from a Mastodon post.
				// Partially copying from that page.
				Accessible.role: Accessible.Button
				Accessible.name: "Back button"
    			Accessible.description: "Goes back to the main page of RetiledSearch."
    			Accessible.onPressAction: {
        			// Click the button with the accessibility press feature:
					// https://stackoverflow.com/a/34332489
					// I really hope this works, because I don't really
					// have any way to test it as far as I know.
					clicked()
    			}
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
						// TODO: move this to another file so it can just be referenced
						// along with all the other light and dark theme colors.
						appBar.backgroundColor = "#1f1f1f"
						appbarDrawer.backgroundColor = "#1f1f1f"
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
			source: "../icons/actions/ellipsis_white.svg"
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
	// TODO 3: Move the customizations to AppBarDrawer.qml so that
	// more apps can use this customized appbar drawer.
        id: appbarDrawer
        width: window.width
        // Set height to 165 so that there's enough space for the pages.
        height: 165
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
		//font.letterSpacing: -0.8 * scaleFactor


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
					if (model.navigate === "true"){
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
					} else {
						// This is just a test for now to allow commands
						// to be used from the appbar.
						// An example would be pinning something to Start.
						console.log(model.command)
						// We should also close the appbar drawer.
						appbarDrawer.close()
					}

                }
            }

			// Note: these pages here will eventually be replaced
			// with items that would be in a settings app's appbar drawer,
			// and not ones that are now in the main list.
            model: ListModel {
				ListElement { title: "start+theme"; navigate: "true"; source: "pages/start-theme.qml" }
				ListElement { title: "about"; navigate: "true"; source: "pages/About.qml" }
				// "debug command" is just a test for now to allow commands
				// to be used from the appbar.
				// An example would be pinning something to Start.
				ListElement { title: "debug command"; navigate: "false"; command: "hello" }
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


// This part is basically just the appbar drawer items moved out into a proper list.
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
