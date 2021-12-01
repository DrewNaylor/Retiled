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
import QtQuick.Controls

ButtonBase {
	// We need to change things to make it into a tile.
	id: control
	
	// Add properties.
	property string tileText: "tile"
	// A fontSize of 12 is pretty close to the real sizing.
	property int fontSize: 12
	property string textColor: "white"
	// Fun fact: if you change the color value here
	// to #990050ef (or anything else with numbers in front of "0050ef"),
	// you'll get transparent tile backgrounds, with different values
	// depending on the first two numbers (replacing "99").
	// This may be useful for customization, if people want W10M-style
	// semi-transparent tiles.
	property string tileBackgroundColor: "#0050ef"
	// We have to add a property for the button's exec key
	// so that we can add an event handler:
	// https://stackoverflow.com/a/22605752
	property string execKey;
	signal clicked(string execKey);
	
	
	
	// Add signals for the context menu.
	property string dotDesktopFilePath;
	property bool showContextMenu: false
	// Signal for opening the context menu.
	signal pressAndHold(bool showContextMenu);
	// Signals for unpinning and resizing tiles.
	signal unpinTile(string dotDesktopFilePath);
	signal resizeTile(string dotDesktopFilePath, int newTileWidth, int newTileHeight);
	
	// Set padding values.
	// These values and the fontSize may be incorrect, at least with WP7:
	// https://stackoverflow.com/a/8430030
	// Or maybe it's right, and it's just a font issue.
	// I looked at Avalonia's default font size for buttons, and
	// it's 14:
	// https://github.com/AvaloniaUI/Avalonia/blob/master/src/Avalonia.Themes.Fluent/Controls/Button.xaml#L24
	// That line references "ControlContentThemeFontSize", which is defined to be "14" here:
	// https://github.com/AvaloniaUI/Avalonia/blob/master/src/Avalonia.Themes.Fluent/Accents/Base.xaml#L17
	// Changing leftPadding to 7 makes the second "l" in the test string
	// ("WP8.1 app with a really long name for testing", though I didn't keep the full thing) be in half properly.
	// I would prefer to use 8, but Open Sans isn't close enough together.
	// Forking it could improve that.
	// Actually, Segoe WP's spacing can be emulated by setting the pixel spacing to -8.
	// It would still be best to fork Open Sans, though, as that's how it can be fixed
	// properly, along with fixing the J and Q.
	leftPadding: 8
	topPadding: 0
	rightPadding: 0
	bottomPadding: 6
	
	RoundButton {
		id: unpinButton
		visible: false
		Image {
			// It's pressed, not down, to change images:
			// https://stackoverflow.com/a/30092412
			source: parent.pressed ? "../icons/actions/unpin.svg" : "../icons/actions/unpin_white.svg"
			anchors.fill: parent
			fillMode: Image.Stretch
			mipmap: true
		}
		rotation: 45
		// Anchor the horizontal and vertical
		// center to the right and top
		// respectively so that the unpin
		// button is in the top-right.
		anchors.horizontalCenter: control.right
		anchors.verticalCenter: control.top
		// Set z value to above the tile so that
		// tapping the button works even if
		// it's done in the tile area.
		z: control.z + 1
		// Remove the border.
		borderWidth: 0
		// Change the pressed background color.
		// TODO: Check if it's the same under the light theme.
		pressedBackgroundColor: "white"
		onClicked: {
			// Reset the z-index for the tile and hide the buttons.
			// NOTE: Unpinning a tile removes the buttons, so this
			// is ok, unlike when resizing the tile.
			control.z = control.z - 1;
			resizeButton.visible = false;
			unpinButton.visible = false;
		}
	}
	
	RoundButton {
		id: resizeButton
		visible: false
		text: "<b>\ue021</b>"
		font: metroFont.font
		// Anchor the horizontal and vertical
		// center to the right and bottom
		// respectively so that the resize
		// button is in the bottom-right.
		anchors.horizontalCenter: control.right
		anchors.verticalCenter: control.bottom
		// Set z value to above the tile so that
		// tapping the button works even if
		// it's done in the tile area.
		z: control.z + 1
		// Change the pressed background color.
		// TODO: Check if it's the same under the light theme.
		pressedBackgroundColor: "white"
		// Change pressed text color.
		// TODO: Check if this is also the same under the light theme.
		pressedTextColor: "black"
		onClicked: {
			// Reset the z-index for the tile and hide the buttons.
			// TODO: Figure out how to make it so that tapping any other
			// tile or area on the start screen will hide the
			// resize button so that the user can
			// resize multiple times at once.
			control.z = control.z - 1;
			resizeButton.visible = false;
			unpinButton.visible = false;
			// Resize the tile based on its current width.
			// Using an if statement to determine what to
			// change the button rotation to:
			// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/if...else
			// Use "&&" for "and":
			// https://stackoverflow.com/a/12364825
			if ((control.width == 150) && (control.height == 150)) {
				// If button is medium, resize to small.
				resizeTile(dotDesktopFilePath, 70, 70);
				// Visually change the size here.
				control.width = 70;
				control.height = 70;
				// Change the resize button's rotation as well.
				// -135 points the arrow in the top-left corner.
				resizeButton.rotation = 45;
			} else if ((control.width == 70) && (control.height == 70)) {
				// If button is small, resize to wide.
				resizeTile(dotDesktopFilePath, 310, 150);
				// Visually change the size here.
				control.width = 310;
				control.height = 150;
				// Change the resize button's rotation as well.
				// -180 points the arrow backward.
				resizeButton.rotation = -180;
			} else if ((control.width == 310) && (control.height == 150)) {
				// If button is wide, resize to medium.
				resizeTile(dotDesktopFilePath, 150, 150);
				// Visually change the size here.
				control.width = 150;
				control.height = 150;
				// Change the resize button's rotation as well.
				resizeButton.rotation = -135;
			} else {
				// If nothing matches, resize to medium, just
				// in case.
				resizeTile(dotDesktopFilePath, 150, 150);
				// Visually change the size here.
				control.width = 150;
				control.height = 150;
				// Change the resize button's rotation as well.
				// We're changing it to -135 so it points in the top-left.
				resizeButton.rotation = -135;
			}
		}
	}
	
	// Properties for pixel density:
	// https://stackoverflow.com/a/38003760
	// This is what QML told me when I used
	// console.log(Screen.pixelDensity).
	property real mylaptopPixelDensity: 4.4709001084468
	// This is just whatever the device that's running will use.
	property real scaleFactor: Screen.pixelDensity / mylaptopPixelDensity
	
	// Add a mousearea to allow for clicking it.
	MouseArea {
		anchors.fill: parent
		onClicked: {
		parent.clicked(parent.execKey);
		// Reset the scale to 1.0.
		// This, along with setting the scale
		// in various events below, probably
		// isn't the best way to do this, but
		// it's approximately the same thing
		// as before the MouseArea was used.
		// I'd prefer to just use
		// control.scale: control.down ? 0.98 : 1.0
		// but I can't seem to get that to work
		// with a MouseArea.
		// TODO: Make this less janky.
		control.scale = 1.0;
		
		}
		// Scaling the buttons down then back up
		// is done by setting scale values for both
		// onPressed and onReleased.
		// If only one is set, the button won't come
		// back up and will stay depressed, like me
		// during most of 2020.
		// See the comment block above for how we're
		// setting it back to 1.0 after the clicked
		// signal is processed.
		// Also, please fix this. It's really janky,
		// but at least it's not as janky as it was
		// before adding onCanceled and resetting
		// the scale in the click handler.
		onPressed: control.scale = 0.98
		onReleased: control.scale = 1.0
		onCanceled: control.scale = 1.0
		
		// Trying to do a press and hold for the menu.
		onPressAndHold: {
			// TODO: Figure out how to have it enter a
			// "tile modification" mode so that users can
			// scroll and tap on different tiles to modify
			// them instead of having to long-press on each
			// tile.
			// This would also allow moving tiles around
			// if I can figure out how to initiate a grab
			// and let the user scroll up and down by dragging
			// the tile.
			// Pressing a tile, using the back button, or tapping
			// anywhere outside the resize and unpin buttons
			// on the start screen will also exit the modification
			// mode.
			// Note that you can also just have no tile selected so
			// they're all in the "background", smaller, and less
			// visible (darker/dimmer?).
			control.z = control.z + 1;
			resizeButton.visible = true;
			unpinButton.visible = true;
			// tilemenu.open();
		}
	}
	

	
	// Adding the context menus:
	// https://doc.qt.io/qt-6/qml-qtquick-controls2-popup.html
	Popup {
		id: tilemenu
		modal: true
		visible: showContextMenu
		// We're using the column layout.
		Column {
			anchors.fill: parent
			ButtonBase {
				text: qsTr("unpin")
				// Apparently we have to use "font.family"
				// instead of "font: ..." in secondary QML
				// files, or it doesn't seem to work.
				font.family: "Open Sans"
				font.weight: Font.Normal
				// TODO: Move letter spacing into the control.
				font.letterSpacing: -0.8 * scaleFactor
				onClicked: unpinTile(dotDesktopFilePath)
			}
			ButtonBase {
				text: qsTr("resize (medium)")
				font.family: "Open Sans"
				font.weight: Font.Normal
				font.letterSpacing: -0.8 * scaleFactor
				onClicked: resizeTile(dotDesktopFilePath, 150, 150)
			}
			ButtonBase {
				text: qsTr("resize (small)")
				font.family: "Open Sans"
				font.weight: Font.Normal
				font.letterSpacing: -0.8 * scaleFactor
				onClicked: resizeTile(dotDesktopFilePath, 70, 70)
			}
			ButtonBase {
				text: qsTr("resize (wide)")
				font.family: "Open Sans"
				font.weight: Font.Normal
				font.letterSpacing: -0.8 * scaleFactor
				onClicked: resizeTile(dotDesktopFilePath, 310, 150)
			}
		}
	}
	
	// Override the contentItem using the one from Button.
	contentItem: Text {
		// I couldn't figure out why things weren't
		// working, but it turns out that you can't
		// have another contentItem in the button in
		// the window or it'll override this style's
		// contentItem.
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
				// Make the font bigger.
				// pixelSize isn't device-independent.
                font.pointSize: control.fontSize
				// Set the font weight:
				// https://doc.qt.io/qt-5/qml-font.html
				// Windows Phone 7 used SemiBold, but I hope
				// DemiBold is close enough:
				// https://stackoverflow.com/a/8430030
				// Funny enough, DemiBold is 63, which was
				// my favorite number in 6th grade due to
				// Super Mario 63.
				// I did find a link to Microsoft's documentation
				// showing what various measurements for Windows Phone 8
				// are:
				// https://docs.microsoft.com/en-us/previous-versions/windows/apps/ff769552(v=vs.105)
				// Something else interesting is that Microsoft has a page with the names and
				// hex values for each of the accent colors. One thing on this page says
				// you can get the styles from C:\Program Files (x86)\Microsoft SDKs\Windows Phone\v8.0\Design
				// Here's the link:
				// https://docs.microsoft.com/en-us/previous-versions/windows/apps/ff402557(v=vs.105)
				//font.weight: Font.DemiBold
				// Font weight changes don't look that good.
                text: control.tileText
                color: control.textColor
				// Turn off ellipsis.
				elide: Text.ElideNone
				// Ensure that text doesn't just go out of
				// the tiles.
				clip: true
				// Set font style to opensans.
				font.family: "Open Sans"
				font.weight: Font.Normal
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
				// You know what, I'm just not going to do this
				// because it'll introduce difficult-to-fix bugs
				// and inconsistencies.
				// I wasn't going to do it, but then I went back
				// and I really don't like how Open Sans looks by default.
            }
	
	background: Rectangle {
		// Change tile color and stuff.
				color: control.tileBackgroundColor
                border.width: 0
                radius: 0
	}
	
}