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

// Change the context menu button so it's more like WP.
// I took these properties from the button
// in RetiledSearch, but they had to be modified for
// context menus.
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
	property real fontSize: FontStyles.mediumFontSize
	// textColor would usually be white, but it can be
	// changed to black. Actually, maybe adding a way to
	// automatically set the theme with a boolean would
	// be useful.
	// FIXME/TODO: Fix this because the context menu buttons are supposed
	// to be black on white and this appears to be all the wrong values.
	// Some stuff might not appear correctly such as the appbar drawer
	// buttons, so it'll need to be fixed.
	// TODO: Make sure my changes still work in RetiledStart.
	property string textColor: ThemeLoader.getValueFromTheme(themePath, "ContextMenuButton", "TextColor", "black")
	// pressedBackgroundColor will usually be transparent.
	property string pressedBackgroundColor: ThemeLoader.getValueFromTheme(themePath, "ContextMenuButton", "PressedBackgroundColor", "transparent")
	// unpressedBackgroundColor is usually transparent,
	// but it may be useful to specify a color, such as for
	// tiles.
	property string unpressedBackgroundColor: ThemeLoader.getValueFromTheme(themePath, "ContextMenuButton", "UnpressedBackgroundColor", "transparent")
	// BorderColor shouldn't appear unless desired by a theme.
	property string borderColor: ThemeLoader.getValueFromTheme(themePath, "ContextMenuButton", "BorderColor", "transparent")
	// Generally context menu buttons shouldn't have a border
	// when pressed unless requested by a theme.
	property string pressedBorderColor: ThemeLoader.getValueFromTheme(themePath, "ContextMenuButton", "PressedBorderColor", "transparent")
	property int borderWidth: ThemeLoader.getValueFromTheme(themePath, "ContextMenuButton", "BorderWidth", "0")
	// TODO: Reduce the number of places we have to access the
	// theme data like below in case it's unnecessary to check
	// the theme for something, such as when a feature isn't in use,
	// like for border width.
	property int borderRadius: borderWidth > 0 ? ThemeLoader.getValueFromTheme(themePath, "ContextMenuButton", "BorderRadius", "0") : 0
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
	
	// Turning off tilting by default because it can be an issue
	// due to it not being constrained to not be way too much yet,
	// as moving to the edge causes it to flicker.
	// This is an issue on the edges of the control.
	// TODO: Figure out how to make tilting smooth.
	// Now we're trying to bring it back, but it's a bit jittery with
	// the pause animation. Maybe it should be removed?
	//tilt: true
	
	//// Set the default state.
     // state: "RELEASED"
	
	contentItem: Text {
		// I couldn't figure out why things weren't
		// working, but it turns out that you can't
		// have another contentItem in the button in
		// the window or it'll override this style's
		// // contentItem.
                horizontalAlignment: Text.AlignLeft
				// It's not perfectly in the vertical center,
				// but it's close enough I think.
				// At least the horizontalAlignment works
				// better when using buttonWidth.
                verticalAlignment: Text.AlignVCenter
				// Make the font bigger.
				// pixelSize isn't device-independent.
                font.pointSize: control.fontSize
                text: control.text
                color: control.textColor
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
       			// Actually I'm not sure about using letter spacing now.
				//font.letterSpacing: -0.8 * scaleFactor
				// Set font.
				font.family: FontStyles.regularFont
				font.weight: FontStyles.regularFontWeight
            }
			
		// Had to use the contentItem Text thing to change stuff from the "customizing button"
        // page in the QML docs here:
        // https://doc.qt.io/qt-5/qtquickcontrols2-customize.html#customizing-button
        // Also need to change the background and border.
           background: Rectangle {
                implicitWidth: control.buttonWidth
                implicitHeight: control.buttonHeight
                border.color: control.down ? control.pressedBorderColor : control.borderColor
				// Set the background color for the button here
				// since the state-changing thing doesn't work
				// anymore in Qt6. This is temporary if I figure
				// out how to fix the animation.
				color: control.down ? control.pressedBackgroundColor : control.unpressedBackgroundColor
                border.width: control.borderWidth
                radius: control.borderRadius
				
				// Add antialiasing.
				antialiasing: true
				
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
