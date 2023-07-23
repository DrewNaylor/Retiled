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



RetiledStyles.AppBarBase {

                id: appBar

        transform: Translate {
        // Move the menu to make it look like WP's ellipsis menu opening.
		// Turns out we need to have it be multiplied by 3.4 so the items don't
		// overlap the appbar.
        y: appbarDrawer.position * (appBar.height * 3.4) * -1
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
						// TODO 2: But really, this needs to be moved to its own file for
						// easy changes and reuse for theme support.
						appBar.backgroundColor = ThemeLoader.getValueFromTheme(themePath, "AppBar", "BackgroundColor", "#1f1f1f")
						appbarDrawer.backgroundColor = ThemeLoader.getValueFromTheme(themePath, "AppBarDrawerBase", "BackgroundColor", "#1f1f1f")
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

    RetiledStyles.AppBarDrawerBase {
    // TODO: Figure out a way to allow the drawer to be closed from any
    // page and not just from clicking inside the main page or clicking
    // on any of the items in the drawer.
    // TODO 2: Figure out how to let the user drag the app bar back down
    // on both the right and the left side to close the
    // drawer, like on Windows Phone.
	// TODO 3: Move the customizations to AppBarDrawer.qml so that
	// more apps can use this customized appbar drawer.
	// TODO 4: Prevent the appbar drawer from being able to be closed
	// by dragging downward on the items in it or by clicking anywhere
	// on the appbar other than the ellipsis/more button or the empty
	// spot on the left side of the appbar.
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
        

// TODO: Figure out how to have tabbing and arrow keys work correctly in the appbar drawer
// and the appbar itself, once that's implemented.
        ListView {
            id: appbarDrawerListView
            anchors.fill: parent
            clip: true
            focus: true

            delegate: RetiledStyles.AppBarDrawerEntry {
                width: parent.width
                text: model.title
                onClicked: {
					// Only navigate to another page if the item says to.
					// Sometimes you don't want to navigate, so that's why
					// it has to be specified.
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

			// TODO: Improve the shape of the scrollbar
			// so it's closer to WP.
            ScrollIndicator.vertical: ScrollIndicator { }
            }
        }
    }