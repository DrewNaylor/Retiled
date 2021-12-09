// PyRetiledStart - Windows Phone 8.x-like Start screen UI for the
//                  Retiled project. Once this app reaches
//                  feature-parity with the older Avalonia-based
//                  version, this version will be renamed back to
//                  "RetiledStart".
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
import "../../RetiledStyles" as RetiledStyles


// TODO: Add an About page that says that this app "is powered by Qt, which is used here under the LGPL." I should probably say where to go to get the license, too. Probably should just see what other popular Qt apps do and do something similar. The About page will also have details about this app itself so people know what it is.
// I'll probably just copy some code from my modified version of the Qml.Net example app since I know how it works.

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
	Universal.background: 'black'
	
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
	
	footer: ToolBar {

                id: appBar

        transform: Translate {
        // Move the menu to make it look like WP's ellipsis menu opening.
		// Change "-3" to how far up you want the appbar to move when
		// opening the ellipsis menu.
        y: appbarDrawer.position * appBar.height * -3
         }

        RowLayout {
            spacing: 0
            anchors.fill: parent


            ToolButton {
			id: backButton
			visible: false
			// QML with Python requires you use "file:" before
			// the image path as specified here:
			// https://stackoverflow.com/a/55515136
				// TODO: Figure out a way to use SVG files because
				// this is blurry with HiDPI.
                icon.source: "file:images/back.png"
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
			
            ToolButton {
				id: appbarEllipsisButton
				// TODO: Figure out a way to use SVG files because
				// this is blurry with HiDPI.
                icon.source: "file:images/menu.png"
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

    Drawer {
    // TODO: Figure out a way to allow the drawer to be closed from any
    // page and not just from clicking inside the main page or clicking
    // on any of the items in the drawer.
    // TODO 2: Figure out how to let the user drag the app bar back down
    // on both the right and the left side to close the
    // drawer, like on Windows Phone.
    // TODO 3: Change the app bar icons so they're closer to WP, especially
    // the app bar drawer opening button, as that's more like Windows 10
    // Mobile.
        id: appbarDrawer
        width: window.width
        // Set height to 55 so that the app bar always moves out of the way,
        // even when the window is taller or shorter.
        height: 145
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


        // Removing the shadow from the drawer:
        // https://stackoverflow.com/a/63411102
        Overlay.modal: Rectangle {
                  color: "transparent"
              }

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

            delegate: ItemDelegate {
                width: parent.width
                text: model.title
                onClicked: {
                    stackView.push(model.source)
                    appbarDrawer.close()
					// Show the back button to allow navigating back.
					backButton.visible = true
					// Hide the ellipsis button.
					appbarEllipsisButton.visible = false
                }
            }

            model: ListModel {
				ListElement { title: "about"; source: "pages/About.qml" }
				ListElement { title: "tiles"; source: "pages/Tiles.qml" }
				ListElement { title: "all apps"; source: "pages/AllApps.qml" }
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
				allAppsListViewModel.RunApp(searchBox.text)
			}
			// We also have to have one for onReturnPressed
			// because Qt doesn't consider the Return key to
			// be the same as the Enter key, even though it's
			// literally labeled as "Enter" on my keyboard.
			Keys.onReturnPressed: {
				allAppsListViewModel.RunApp(searchBox.text)
			}
            // I don't know how to get the width to change when the window
            // is resized, so it's hardcoded at 312 for now.
			anchors.margins: 12
			anchors.topMargin: 5
			anchors.top: parent.top
			anchors.right: parent.right
			anchors.left: parent.left
            implicitHeight: 40
            placeholderText: qsTr("enter a .desktop file path here")
            // I don't know if pixelSize is the right property
            // to change for DPI scaling.
            font.pixelSize: 18
         }
		 
         RetiledStyles.Button {
            id: searchButton
			onClicked: {
				allAppsListViewModel.RunApp(searchBox.text)
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
			buttonWidth: 90
			buttonHeight: 40
			
			// Set margins.
			anchors.top: searchBox.bottom
			anchors.margins: 12
			anchors.topMargin: 4
			anchors.left: parent.left
			
			// Set text.
            text: qsTr("run")
            

    } // End of the run button.
	
	
	RetiledStyles.Button {
            id: runButton
			onClicked: {
				allAppsListViewModel.getDotDesktopFiles()
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
			buttonWidth: 200
			buttonHeight: 40
			
			// Set margins.
			anchors.top: searchButton.bottom
			anchors.margins: 12
			anchors.topMargin: 4
			anchors.left: parent.left
			
			// Set text.
            text: qsTr("get all apps .desktop files list")
            

    } // End of the get .desktop files button.
	
		}
	}
}
