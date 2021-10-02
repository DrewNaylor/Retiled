// PyRetiledSearch - Windows Phone 8.0-like Search app for the
//                   Retiled project. This is a port of the original
//                   RetiledSearch program to Python, though eventually
//                   the name will go back to "RetiledSearch" once it's
//                   done being ported; the "Py" in the name is temporary.
//                   To view "git blame" on this file before it was moved
//                   back to Retiled, see here:
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

    // I'm basically just using this project to
    // figure out how to port Retiled to QML, then I'll bring in Python
    // so it doesn't need QML.NET, which doesn't have ARM builds for
    // the unmanaged library.
    ColumnLayout {
        spacing: 4
        Layout.fillWidth: true

         TextField {
            id: searchBox
            Layout.fillWidth: true
            // I don't know how to get the width to change when the window
            // is resized, so it's hardcoded at 312 for now.
            implicitWidth: 312
            implicitHeight: 40
            placeholderText: qsTr("enter a search term here")
            // I think that's a close-enough color to the watermark
            // color used in Avalonia. Had to use Window Spy to figure it out,
            // since there was no obvious way to figure it out from Avalonia's
            // source.
            placeholderTextColor: searchBox.focus ? "transparent" : "#666666"
            Layout.leftMargin: 24
            Layout.topMargin: 10
            Layout.rightMargin: 24
            Layout.bottomMargin: 0
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
            Layout.leftMargin: 24
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
