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


// Importing everything in this folder
// until I can figure out a better solution.
import "." as RetiledStyles
import QtQuick
import QtQuick.Layouts

RetiledStyles.AppBarBase {

        id: control

        // Need a property for the height multiplier.
        property real appbarOpenedHeightMultiplier: 3.4

        transform: Translate {
        // Move the menu to make it look like WP's ellipsis menu opening.
		// Turns out we need to have it be multiplied by 3.4 so the items don't
		// overlap the appbar.
        y: appbarDrawer.position * (control.height * appbarOpenedHeightMultiplier) * -1
         }

        RowLayout {
            spacing: 0
            anchors.fill: parent

            RetiledStyles.AppBarMoreButton {
			// Usually we won't use the AppBarMoreButton for items here,
			// but the Back button can't have any visual changes.
			id: backButton
			visible: backButtonVisible
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
                        // We can't set the visibility of the item directly,
                        // or it'll break and mess with the visibility
                        // so it'll sometimes not appear when it should.
                        backButtonVisible = false
						// Set the appbar and its drawer background color to the default.
						// TODO: move this to another file so it can just be referenced
						// along with all the other light and dark theme colors.
						// TODO 2: But really, this needs to be moved to its own file for
						// easy changes and reuse for theme support.
						control.backgroundColor = ThemeLoader.getValueFromTheme(themePath, "AppBar", "BackgroundColor", "#1f1f1f")
						appbarDrawer.backgroundColor = ThemeLoader.getValueFromTheme(themePath, "AppBarDrawerBase", "BackgroundColor", "#1f1f1f")
						// Show the ellipsis button again.
                        // We can't set the visibility of the item directly,
                        // or it'll break and mess with the visibility
                        // so it'll sometimes appear when it shouldn't.
						appbarEllipsisButtonVisible = true
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
                visible: appbarEllipsisButtonVisible
				width: 20
				// TODO: Figure out a way to use SVG files because
				// this is blurry with HiDPI.
                // icon.source: "../icons/actions/ellipsis_white.svg"
				Image {
			// It's "pressed", not "down", to change images:
			// https://stackoverflow.com/a/30092412
			source: "../icons/actions/" + ThemeLoader.getValueFromTheme(themePath, "AppBar", "EllipsisButtonIcon", "ellipsis_white") + ".svg"
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