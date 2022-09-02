// RetiledStyles - Windows Phone 8.x-like QML styles for the
//                 Retiled project. Some code was copied from
//                 the official qtdeclarative repo, which you can
//                 access a copy of here:
//                 https://github.com/DrewNaylor/qtdeclarative
// Copyright (C) 2021-2022 Drew Naylor
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



import QtQuick
// Transform buttons and other stuff by rotating it toward where
// the cursor is when pressing it, if desired.
// Had to watch this video to understand the
// general concept of how to do it the way
// I wanted to do it:
// https://www.youtube.com/watch?v=frC9nZGrLAM
// TODO: Offer a way to turn off tilting via a setting,
// as it could be a bit much.
// Probably should link the QtQuick page on Rotation, too:
// https://doc.qt.io/qt-6/qml-qtquick-rotation.html
// This code was moved from ButtonBase so it can be shared
// across more controls more broadly.
Rotation {
	// Set the x and y origins by dividing
	// the button in half horizontally and
	// vertically. This allows the button to
	// be split into quadrants, which are
	// used to know which direction the button
	// is supposed to tilt in.
	origin.x: control.width / 2
	origin.y: control.height / 2
	// Set axis and angle values based on
	// the last-pressed x and y values:
	// https://doc.qt.io/qt-6/qml-qtquick-controls2-abstractbutton.html#pressX-prop
	// Maybe I need to divide the button
	// in half vertically and horizontally
	// to decide if negative or positive values
	// need to be used.
	// Read that here: https://letsbuildui.dev/articles/a-3d-hover-effect-using-css-transforms
	// Here's how buttons are tilted:
	// For the y-axis, we check if the control is being pressed
	// down, then if so, we check if the x-value for where
	// the button is being pressed at is greater than the width
	// of the button divided by 2, which is the origin.
	// (We're using the origin directly below for simplification
	// and to prevent typos.) Dividing the width like this
	// allows us to split the button into quadrants, which
	// makes it easy to know which direction the button
	// is supposed to tilt in. Moving on, if the button is being
	// pressed on the right side of the button's center
	// (stored as the origin.x value above, calculated from
	// the button's width divided by 2), then we set the y-axis
	// to the x-value of the press added to the x-origin of the
	// button (this ensures it's in the right place, or else
	// it might not quite look right). However, if the x-value
	// of the press is on the left side of the x-origin, then
	// we multiply the result of the x-value of the press added
	// to the x-origin with negative 1, thereby making the result
	// negative and thus placing it on the left side of the
	// button's center.
	// If the button is un-pressed, the y-axis is reset to 0.
	axis.y: (down && tilt && hovered ? (pressX > origin.x ? pressX + origin.x : -(pressX + origin.x)) : 0)
	// For the x-axis, we do a similar thing as with the y-axis,
	// only this time we use the y-value of the press and the height
	// of the button divided by 2 stored as the y-origin.
	axis.x: (down && tilt && hovered ? (pressY < origin.y ? pressY + origin.y : -(pressY + origin.y)) : 0)
	// We don't need the z-axis changed from 0.
	axis.z: 0
	// An angle of 15 seems pretty good.
	// This is the limit of how far the button "tilts" when pressed.
	angle: tiltAngle
	
	// IMPORTANT: For some reason, pressing the spacebar causes
	// it to tilt toward the left instead of just going in.
	// Adding "hovered" makes it only tilt when the mouse
	// cursor is over it, but it still tilts to the left
	// when moving the mouse over it.
	// Got the idea for "hovered" from here:
	// https://stackoverflow.com/a/62929325
	
	// Use a Behavior to slow down tilting to a more-reasonable level:
	// https://doc.qt.io/qt-6/qml-qtquick-behavior.html
	// Learned about this from this tutorial:
	// https://www.pythonguis.com/tutorials/pyside6-qml-animations-transformations/
	Behavior on axis.y {
		SmoothedAnimation { duration: 100 }
	}
	Behavior on axis.x {
		SmoothedAnimation { duration: 100 }
	}
}