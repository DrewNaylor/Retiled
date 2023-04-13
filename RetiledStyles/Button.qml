// RetiledStyles - Windows Phone 8.x-like QML styles for the
//                 Retiled project. Some code was copied from
//                 the official qtdeclarative repo, which you can
//                 access a copy of here:
//                 https://github.com/DrewNaylor/qtdeclarative
// Copyright (C) 2021-2023 Drew Naylor
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
//    All files in this repo (Retiled) licensed under the Apache License, 2.0,
//    are using RetiledStyles under the LGPLv3.
//
//    Alternatively, this file may be used under the terms of the GNU
//    General Public License version 2.0 or later as published by the Free
//    Software Foundation and appearing in the file LICENSE.GPL included in
//    the packaging of this file. Please review the following information to
//    ensure the GNU General Public License version 2.0 requirements will be
//    met: http://www.gnu.org/licenses/gpl-2.0.html.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU (Lesser) General Public License for more details.
//
//    You should have received a copy of the GNU (Lesser) General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

// Tried to do import ButtonBase but QML said
// the style wasn't installed, so I'm just
// importing everything in this folder
// until I can figure out a better solution.
import "."
import QtQuick
// QtQuick.Controls.Universal is required for Accent color stuff.
import QtQuick.Controls.Universal

// Change the button so it's more like WP.
// I took these properties from the button
// in RetiledSearch.
ButtonBase {
	
	id: control
	
	// Usually buttons have text, but if they're images,
	// I'd have to figure something out.
	// Setting this to 25 because the WP ButtonBase used it:
	// https://github.com/microsoftarchive/WindowsPhoneToolkit/blob/master/PhoneToolkitSample8/App.xaml#L51
	// Or at least, I hope it did and the sample is being accurate.
	// "PhoneFontSizeMediumLarge" is a double at 25.333, but
	// we need to use an integer:
	// https://docs.microsoft.com/en-us/previous-versions/windows/apps/ff769552(v=vs.105)#font-sizes
	// That's too big, let's use 20.
	// Nah, 18.
	// No, 16 is better.
	// We're using the new normalFontSize value from FontStyles.qml.
	property real fontSize: FontStyles.normalFontSize
	// Allow the font family to be overwritten easily.
	property string fontFamily: FontStyles.regularFont
	// Also the font weight.
	property int fontWeight: FontStyles.regularFontWeight
	// textColor would usually be white, but it can be
	// changed to black. Actually, maybe adding a way to
	// automatically set the theme with a boolean would
	// be useful.
	property string textColor: "white"
	property string pressedTextColor: "white"
	// pressedBackgroundColor will usually be the accent color.
	property string pressedBackgroundColor: Universal.accent
	// unpressedBackgroundColor is usually transparent,
	// but it may be useful to specify a color, such as for
	// tiles.
	property string unpressedBackgroundColor: "transparent"
	// Just like the textColor, borderColor would be black
	// in the light theme.
	property string borderColor: "white"
	// Very rarely, buttons will have a different border color
	// when pressed. One example of this is the "unpin tile"
	// button. I still need to check the light theme for this.
	property string pressedBorderColor: "white"
	property int borderWidth: 2
	property int borderRadius: 0
	// Change button size to help with the large font.
	property int buttonWidth: 100
	property int buttonHeight: 40
	
	// Properties for pixel density:
	// https://stackoverflow.com/a/38003760
	// This is what QML told me when I used
	// console.log(Screen.pixelDensity).
	property real mylaptopPixelDensity: 4.4709001084468
	// This is just whatever the device that's running will use.
	property real scaleFactor: Screen.pixelDensity / mylaptopPixelDensity
	
	

	
	contentItem: Text {
		// I couldn't figure out why things weren't
		// working, but it turns out that you can't
		// have another contentItem in the button in
		// the window or it'll override this style's
		// // contentItem.
                horizontalAlignment: Text.AlignHCenter
				// It's not perfectly in the vertical center,
				// but it's close enough I think.
				// At least the horizontalAlignment works
				// better when using buttonWidth.
                verticalAlignment: Text.AlignVCenter
				// Make the font bigger.
				// pixelSize isn't device-independent.
                font.pointSize: control.fontSize
                text: control.text
                //color: control.textColor
				// Qt's docs say to set the text to the width
				// of the parent to get proper centered text,
				// but it doesn't seem to work.
				width: buttonWidth
				height: buttonHeight
				// A letter spacing of -0.8 emulates
				// Segoe WP's letter spacing.
				// However, it's not perfect as I can't
				// get the second "l" in "really" to be
				// in half in a medium tile at the same time
				// as the entirety of the "o" in "Calculator"
				// is showing on a small tile.
				// For some reason, the font spacing is slightly
				// off on the phone.
				// I think they're different because this is
				// based on pixels.
				// Preferably this would multiply against
				// the DPI to determine what number should be used.
				// I think -1.25 is close enough for the PinePhone.
				// This SO answer shows how to multiply against
				// pixel density: https://stackoverflow.com/a/38003760
				// This doesn't help that much, but I think
				// I'll keep it for now to make sure things
				// don't get too out of control.
				font.letterSpacing: -0.8 * scaleFactor
				// Set font.
				font.family: fontFamily
				font.weight: fontWeight
				
				// Copying the transitions from the background
				// color changing so that they can be used for text color.
				// There's probably a better way to do this, but
				// I'm not sure at the moment.
				// Probably could move some stuff into its own file.
				states: [
					State { 
						name: "buttonPress"
						when: pressed
						PropertyChanges { target: contentItem; color: pressedTextColor }
					},
					State {
						name: "buttonUnpressed"
						when: !pressed
						PropertyChanges { target: contentItem; color: textColor }
					}
				]

				transitions: Transition {
					from: "buttonUnpressed"
					to: "buttonPress"
					ParallelAnimation {
						// Also have the text color change immediately
						// by default, because I'm not entirely sure what to
						// do with it.
						PropertyAnimation { property: "color"; duration: 0 }
					}
				}
            }
			
		// Had to use the contentItem Text thing to change stuff from the "customizing button"
        // page in the QML docs here:
        // https://doc.qt.io/qt-5/qtquickcontrols2-customize.html#customizing-button
        // Also need to change the background and border.
           background: Rectangle {
                implicitWidth: control.buttonWidth
                implicitHeight: control.buttonHeight
				// Set the background color for the button here
				// since the state-changing thing doesn't work
				// anymore in Qt6. This is temporary if I figure
				// out how to fix the animation.
				//color: unpressedBackgroundColor
				//border.color: borderColor
                border.width: control.borderWidth
                radius: control.borderRadius
				// Give buttons antialiasing.
				// TODO: Allow buttons to have antialiasing turned
				// off, if desired by the app using this component.
				antialiasing: true
				
				// Copying in and modifying the transitions I modified from Qt's
				// example that's available in ButtonBase.qml.
				// Actually, now I'm trying to use multiple states from this
				// example: https://doc.qt.io/qt-6/qml-qtquick-transition.html#enabled-prop
				states: [
					State { 
						name: "buttonPress"
						when: pressed
						PropertyChanges { target: background; color: pressedBackgroundColor }
						PropertyChanges { target: background; border.color: pressedBorderColor }
					},
					State {
						name: "buttonUnpressed"
						when: !pressed
						PropertyChanges { target: background; color: unpressedBackgroundColor }
						PropertyChanges { target: background; border.color: borderColor }
					}
				]

				transitions: Transition {
					from: "buttonUnpressed"
					to: "buttonPress"
					ParallelAnimation {
						// Set the animation duration to be 0 so it immediately
						// shows up even if briefly pressed.
						// Not sure if this should be changed back to
						// the original "color: pressed ? pressedBackgroundColor : unpressedBackgroundColor"
						// code or not, so it'll just be this for now.
						PropertyAnimation { property: "color"; duration: 0 }
						PropertyAnimation { property: "border.color"; duration: 0 }
					}
				}
				
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
