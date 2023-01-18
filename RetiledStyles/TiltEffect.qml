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
	origin.x: width / 2
	origin.y: height / 2
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
	// Now we're trying to do more-accurate tilting as described by Metro-UI-CSS's
	// Tile.js item (MIT-licensed, here's my fork):
	// https://github.com/DrewNaylor/Metro-UI-CSS/blob/master/source/components/tile/tile.js
	// License as copied from https://github.com/DrewNaylor/Metro-UI-CSS/blob/master/LICENSE:
		//The MIT License (MIT)
		//
		//Copyright (c) 2012-2020 Serhii Pimenov.
		//
		//Permission is hereby granted, free of charge, to any person obtaining a copy
		//of this software and associated documentation files (the "Software"), to deal
		//in the Software without restriction, including without limitation the rights
		//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		//copies of the Software, and to permit persons to whom the Software is
		//furnished to do so, subject to the following conditions:
		//
		//The above copyright notice and this permission notice shall be included in
		//all copies or substantial portions of the Software.
		//
		//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
		//THE SOFTWARE.
	// TODO: Explain how the (pressX > origin.x + (origin.x * 1/3) || pressX < origin.x - (origin.x *1/3)? ... : 0) : 0) and
	//       (pressY < origin.y - (origin.y * 1/2) || pressY > origin.y + (origin.y * 1/2) ? ... : 0) : 0) parts
	//       add a deadzone to the center of tiltable objects like tiles so that they can tilt more accurately
	//       and do things like tilt only down, only up, only left, or only right, or not tilt at all if in the middle enough.
	// TODO 2: figure out how WP allows you to tilt smoothly on a button so that everywhere on it reacts to you pressing down on it,
	//         rather than having a large deadzone and only 8 directions. So we need an analog stick, not a D-Pad.
	//         Even tiles react like this, so maybe it has to take into account the current
	//         position of the pointer within the element? That would need a MouseArea, though, which would make things a lot
	//         more difficult to have work. We need to expand the active area above and below the graphical button for usability though, anyway.
	axis.y: (down && tilt && hovered ? (pressX > origin.x + (origin.x * 1/3) || pressX < origin.x - (origin.x * 1/3) ? (pressX > origin.x ? pressX + origin.x : -(pressX + origin.x)) : 0) : 0)
	// For the x-axis, we do a similar thing as with the y-axis,
	// only this time we use the y-value of the press and the height
	// of the button divided by 2 stored as the y-origin.
	axis.x: (down && tilt && hovered ? (pressY < origin.y - (origin.y * 1/2) || pressY > origin.y + (origin.y * 1/2) ? (pressY < origin.y ? pressY + origin.y : -(pressY + origin.y)) : 0) : 0)
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
	// Copied the propertyanimation over from what I added to ButtonBase.
	// We need a SequentialAnimation to wrap the animations in or it'll
	// complain that we can't change the animation on a behavior:
	// https://doc.qt.io/qt-6/qml-qtquick-sequentialanimation.html
	// TODO: Solve this in a way that's better than just adding
	// a hard-coded hack to ignore scales of both 1.0 and 0.9.
	// I think this is slightly better than what it was previously,
	// as it also includes a check for scale and to see if the button is currently
	// not "down" (like held down with a mouse or finger) to not always go.
	// NOTE: this can have bugs as sometimes a button will stay tilted when it's not supposed to.
	// Also it seems that going back from tilt "snaps" into place when it's at the end.
	// Turns out it's going to the tilt smoothly, but not smoothly returning.
	// It also happens even without the SequentialAnimation and PauseAnimation.
	// I think this needs proper animations, so they can automatically reverse
	// smoothly when necessary.
	Behavior on axis.y {
		SequentialAnimation {
			PauseAnimation { duration: axis.y != 0 && !down ? 200 : 0 }
			PropertyAnimation { duration: 200;
								easing.type: Easing.InOutQuad
							}
		}
	}
	Behavior on axis.x {
		SequentialAnimation {
			PauseAnimation { duration: axis.x != 0 && !down ? 200 : 0 }
			PropertyAnimation { duration: 200;
								easing.type: Easing.InOutQuad
							}
		}
	}
}