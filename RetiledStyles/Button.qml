// RetiledStyles - Windows Phone 8.x-like QML styles for the
//                 Retiled project. Some code was copied from
//                 the official qtdeclarative repo, which you can
//                 access a copy of here:
//                 https://github.com/DrewNaylor/qtdeclarative
// Copyright (C) 2021 Drew Naylor
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
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU Lesser General Public License for more details.
//
//    You should have received a copy of the GNU Lesser General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

// Tried to do import ButtonBase but QML said
// the style wasn't installed, so I'm just
// importing everything in this folder
// until I can figure out a better solution.
import "."
import QtQuick

// Change the button so it's more like WP.
// I took these properties from the button
// in RetiledSearch.
ButtonBase {
	
	id: control
	
	// Usually buttons have text, but if they're images,
	// I'd have to figure something out.
	property int fontSize: 18
	// textColor would usually be white, but it can be
	// changed to black. Actually, maybe adding a way to
	// automatically set the theme with a boolean would
	// be useful.
	property string textColor: "white"
	// pressedBackgroundColor will usually be the accent color.
	property string pressedBackgroundColor: "#0050ef"
	// unpressedBackgroundColor is usually transparent,
	// but it may be useful to specify a color, such as for
	// tiles.
	property string unpressedBackgroundColor: "transparent"
	// Just like the textColor, borderColor would be black
	// in the light theme.
	property string borderColor: "white"
	property int borderWidth: 2
	property int borderRadius: 0
	property int buttonWidth: 50
	property int buttonHeight: 35
	
	
	//// Set the default state.
     // state: "RELEASED"
	
	contentItem: Text {
		// I couldn't figure out why things weren't
		// working, but it turns out that you can't
		// have another contentItem in the button in
		// the window or it'll override this style's
		// contentItem.
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
				// Make the font bigger.
                font.pixelSize: control.fontSize
                text: control.text
                color: control.textColor
            }
			
		// Had to use the contentItem Text thing to change stuff from the "customizing button"
        // page in the QML docs here:
        // https://doc.qt.io/qt-5/qtquickcontrols2-customize.html#customizing-button
        // Also need to change the background and border.
           background: Rectangle {
                implicitWidth: control.buttonWidth
                implicitHeight: control.buttonHeight
                border.color: control.borderColor
				// Set the background color for the button here
				// since the state-changing thing doesn't work
				// anymore in Qt6. This is temporary if I figure
				// out how to fix the animation.
				color: control.down ? control.pressedBackgroundColor : control.unpressedBackgroundColor
                border.width: control.borderWidth
                radius: control.borderRadius
				
				
				//// I think this is the way I'll rotate and shrink the button
                //// when it's held down:
                //// https://doc.qt.io/qt-5/qml-qtquick-animation.html#running-prop
                //// Better stuff on animations:
                //// https://doc.qt.io/qt-5/qtquick-statesanimations-animations.html
                //// Actually, this is what I needed:
                //// https://doc.qt.io/qt-5/qml-qtquick-scaleanimator.html
                //// Wait, this looks better, but is older so I hope it works:
                //// https://forum.qt.io/topic/2712/animating-button-press
                //// TODO: Figure out how to rotate the button toward where it's
                //// pressed, like on WP. Maybe WinUI code will help me figure it
                //// out for Avalonia, then I'll translate it to QML.


                //// We're using MultiPointTouchArea to ensure this'll work with touch.
                //MultiPointTouchArea {
                //    anchors.fill: parent
                 //   onPressed: searchButton.state = "PRESSED"
                  //  onReleased: searchButton.state = "RELEASED"
               // }

                //// Set up the states.
                //// Figure out how to change
                //// the accent color in those style qml files based on what's in a config
                //// file. Maybe I can use JS to read that file and get the user's accent color,
                //// though that may not be possible. Hopefully there's something.
				//// Actually, maybe Python could bind QML properties to the user's accent color
				//// setting in a file.
				//// TODO: Fix the button text so it's in the middle vertically and horizontally.
				//// TODO: Fix this for PySide6/Qt6. For now I'm making the button change
				//// its appearance when it's down, but it's not as smooth as these animations.
              //  states: [
                    //State {
                    //    name: "PRESSED"
                        //// Avalonia used 0.98, and I thought it looked bad in QML,
                        //// but I think it's fine.
                        //// We can actually just scale the whole button down rather than
                        //// the rectangle we're in. Didn't know that, so I decided to see if
                        //// QML allows that because that seems to be what Avalonia does,
                        //// and it works.
                       // PropertyChanges {target: searchButton; scale: 0.98}
                        // Change the button background to Cobalt when pressed.
                     //   PropertyChanges {target: searchButton; color: "#0050ef"}
                   // },
                    //// There's supposed to be a comma there.
                 //   State {
                      //  name: "RELEASED"
                    //    PropertyChanges {target: searchButton; scale: 1.0}
                  //      PropertyChanges {target: searchButton; color: "black"}
                //    }
              //  ]

                //// Set up the transitions.
              //  transitions: [
                  //  Transition {
                    //    from: "PRESSED"
                     //   to: "RELEASED"
                       // NumberAnimation { target: searchButton; duration: 60}
                     //   ColorAnimation { target: searchButton; duration: 60}
                   // },

                    //Transition {
                     //   from: "RELEASED"
                     //   to: "PRESSED"
                      //  NumberAnimation { target: searchButton; duration: 60}
                    //    ColorAnimation { target: searchButton; duration: 60}
                  //  }
                
                //]
				
		   }
	
}