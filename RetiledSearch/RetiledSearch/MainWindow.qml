// RetiledSearch - Windows Phone 8.0-like Search app for the
//                 Retiled project.
//                 To view "git blame" on this file before it was moved
//                 back to Retiled, see here:
//                   https://github.com/DrewNaylor/wp-like_qmlnet-examples/blob/retiled-qml-porting-work/src/Features/Main-PyRetiledSearch.qml
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


// TODO: Add an About page that says that this app "is powered by Qt, which is used here under the LGPL." I should probably say where to go to get the license, too. Probably should just see what other popular Qt apps do and do something similar. The About page will also have details about this app itself so people know what it is.
// I'll probably just copy some code from my modified version of the Qml.Net example app since I know how it works.

ApplicationWindow {
    id: window
    width: 360
    height: 720
    visible: true
    title: qsTr("RetiledSearch")

    Universal.theme: Universal.Dark
    Universal.accent: '#0050ef'
	Universal.foreground: 'white'
	// Fun fact: QML supports setting the background to transparent,
	// which shows all the other windows behind the app's window as you'd expect.
	Universal.background: 'black'
	
	// Bring in the shortcut code for the app bar.
	// Copied from my modified version of the Qml.Net example app,
	// but modified for this one.
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
        y: appbarDrawer.position * appBar.height * -1
         }

        RowLayout {
            spacing: 0
            anchors.fill: parent


            ToolButton {
			id: backButton
			visible: false
            // TODO: Hide the back button until it's needed.
			// QML with Python requires you use "file:" before
			// the image path as specified here:
			// https://stackoverflow.com/a/55515136
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
					}
                }
            }

            Item {
            // This empty label is necessary to take up space
            // and push the back button and ellipsis button to both edges.
            // I guess I could've just tweaked things a bit.
                Layout.fillWidth: true
            }
			
            ToolButton {
				id: appbarEllipsisButton
                icon.source: "file:images/menu.png"
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

         TextField {
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
            // I don't know how to get the width to change when the window
            // is resized, so it's hardcoded at 312 for now.
			anchors.margins: 12
			anchors.topMargin: 5
			anchors.top: parent.top
			anchors.right: parent.right
			anchors.left: parent.left
            implicitHeight: 40
            placeholderText: qsTr("enter a search term here")
            // I think that's a close-enough color to the watermark
            // color used in Avalonia. Had to use Window Spy to figure it out,
            // since there was no obvious way to figure it out from Avalonia's
            // source.
            placeholderTextColor: searchBox.focus ? "transparent" : "#666666"
            // I don't know if pixelSize is the right property
            // to change for DPI scaling.
            font.pixelSize: 18
            // Text color needs to be set here.
            color: "black"
            // Selections aren't working for some reason, and I thought it
            // was just a selection color issue.
            selectionColor: "#0050ef"
            // It should be fixed now by using selectByMouse, which is detailed here:
            // https://stackoverflow.com/a/38882378
            selectByMouse: true

            // Changing the style for the textbox. Documentation:
            // https://doc.qt.io/qt-5/qml-qtquick-controls-styles-textfieldstyle.html
            // Apparently that doesn't work. See here:
            // https://stackoverflow.com/a/39052406
                background: Rectangle {
				// TODO: Figure out why the left and bottom areas of the textbox
				// highlight aren't the same thickness as the top and right.
                    radius: 0
                    border.width: searchBox.focus ? 2 : 0
                    // Setting the background seems to work well enough,
                    // but I need to change the placeholder text here so
                    // it disappears when focused.
                    // The left is what I want it to be when focused,
                    // and the right is what it usually is.
                    // TODO: Figure out how to remove focus when the button is
                    // focused.
                    border.color: searchBox.focus ? "#0050ef" : "transparent"
                    color: searchBox.focus ? "white" : "#CCCCCC"
                }

         }
         Button {
            id: searchButton
			onClicked: {
				searchClass.openUrl(searchBox.text)
			}
			// Set the scale here temporarily because the nice animation
			// doesn't seem to work anymore in Qt6 and I don't know how to
			// fix it right now.
			scale: searchButton.down ? 0.98 : 1.0
			// Set the default state.
            state: "RELEASED"
			anchors.top: searchBox.bottom
			anchors.margins: 12
			anchors.topMargin: 4
			anchors.left: parent.left
            font.pixelSize: 18
            text: qsTr("search")
            // Had to use the contentItem Text thing to change stuff from the "customizing button"
            // page in the QML docs here:
            // https://doc.qt.io/qt-5/qtquickcontrols2-customize.html#customizing-button
            contentItem: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 18
                text: qsTr("search")
                color: "white"
            }
           // Also need to change the background and border.
           background: Rectangle {
                id: searchButtonBackgroundArea
                implicitWidth: 90
                implicitHeight: 40
                border.color: "white"
				// Set the background color for the button here
				// since the state-changing thing doesn't work
				// anymore in Qt6. This is temporary if I figure
				// out how to fix the animation.
				color: searchButton.down ? "#0050ef" : "transparent"
                border.width: 2
                radius: 0

                // I think this is the way I'll rotate and shrink the button
                // when it's held down:
                // https://doc.qt.io/qt-5/qml-qtquick-animation.html#running-prop
                // Better stuff on animations:
                // https://doc.qt.io/qt-5/qtquick-statesanimations-animations.html
                // Actually, this is what I needed:
                // https://doc.qt.io/qt-5/qml-qtquick-scaleanimator.html
                // Wait, this looks better, but is older so I hope it works:
                // https://forum.qt.io/topic/2712/animating-button-press
                // TODO: Figure out how to rotate the button toward where it's
                // pressed, like on WP. Maybe WinUI code will help me figure it
                // out for Avalonia, then I'll translate it to QML.


                // We're using MultiPointTouchArea to ensure this'll work with touch.
                MultiPointTouchArea {
                    anchors.fill: parent
                    onPressed: searchButton.state = "PRESSED"
                    onReleased: searchButton.state = "RELEASED"
                }

                // Set up the states.
                // TODO: Move all the style and property changes to separate files
                // so that they can be reused easily. Also, figure out how to change
                // the accent color in those style qml files based on what's in a config
                // file. Maybe I can use JS to read that file and get the user's accent color,
                // though that may not be possible. Hopefully there's something.
				// Actually, maybe Python could bind QML properties to the user's accent color
				// setting in a file.
				// TODO: Fix this for PySide6/Qt6. For now I'm making the button change
				// its appearance when it's down, but it's not as smooth as these animations.
                states: [
                    State {
                        name: "PRESSED"
                        // Avalonia used 0.98, and I thought it looked bad in QML,
                        // but I think it's fine.
                        // We can actually just scale the whole button down rather than
                        // the rectangle we're in. Didn't know that, so I decided to see if
                        // QML allows that because that seems to be what Avalonia does,
                        // and it works.
                        PropertyChanges {target: searchButton; scale: 0.98}
                        // Change the button background to Cobalt when pressed.
                        PropertyChanges {target: searchButton; color: "#0050ef"}
                    },
                    // There's supposed to be a comma there.
                    State {
                        name: "RELEASED"
                        PropertyChanges {target: searchButton; scale: 1.0}
                        PropertyChanges {target: searchButton; color: "black"}
                    }
                ]

                // Set up the transitions.
                transitions: [
                    Transition {
                        from: "PRESSED"
                        to: "RELEASED"
                        NumberAnimation { target: searchButton; duration: 60}
                        ColorAnimation { target: searchButton; duration: 60}
                    },

                    Transition {
                        from: "RELEASED"
                        to: "PRESSED"
                        NumberAnimation { target: searchButton; duration: 60}
                        ColorAnimation { target: searchButton; duration: 60}
                    }
                
                ]
           }

    }
		}
	}
}
