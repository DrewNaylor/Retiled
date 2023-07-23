// RetiledSettings - Windows Phone 8.0-like Settings app for the
//                   Retiled project.
// Copyright (C) 2021-2023 Drew Naylor
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

import "../../RetiledStyles" as RetiledStyles
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
	
    header: RetiledStyles.PlainPageHeader {
		// This is the page header for pages that just have
		// the app name and page name.
		appTitleText: "retiledsettings"
		pageTitleText: "start+theme"
	}

	Flickable {
		// Gotta set a bunch of properties so the Flickable looks right.
		// TODO: Change the scrolling so it's more loose and doesn't feel like
		// it's dragging as much.
		// TODO 2: Fix "QML Flickable: Binding loop detected for property "contentWidth""
		// error that shows up on the PinePhone.
		anchors.left: parent.left
		anchors.right: parent.right
		// Don't set contentWidth to allow the text to properly flow and wrap when
		// the window is resized. This also deals with the horizontal scrolling
		// issue that happens when dragging the text around after the window gets resized.
		//contentWidth: aboutText.width
		contentHeight: pageContent.height
		width: parent.width
		height: parent.height
		clip: true
		// I mostly copied this from my modified version of the Qml.Net example app.
		// Code for the About.qml file here:
		// https://github.com/DrewNaylor/wp-like_qmlnet-examples/blob/master/src/Features/pages/About.qml
        ColumnLayout {
			id: pageContent
			Label {
				wrapMode: Label.Wrap
				horizontalAlignment: Qt.AlignHLeft
				// Setting this to 12 will make it line up with the title label.
				// The only potential issue is it won't be scrollable directly on the edge, but it might not be an issue.
				Layout.margins: 12
				// Set the top margin to 0 so that it's right at the top of the page
				// directly under the header area.
				// TODO: Be sure to check if this is correct.
				Layout.topMargin: 0
				// Set font style to Inter Display.
				// Might need to change the size so it's slightly larger
				// as this is a little difficult to read, and maybe change some
				// of the text color to be the dimmer variant.
					font.family: RetiledStyles.FontStyles.regularFont
					font.weight: RetiledStyles.FontStyles.regularFontWeight
					font.pointSize: RetiledStyles.FontStyles.smallFontSize
					// Actually I'm not sure about using letter spacing now.
					//font.letterSpacing: -0.8 * scaleFactor
				// TODO: Add a styled version of the label for easier reuse.
				textFormat: Text.StyledText
				// This is how we'll have to display text in the user's accent color,
				// unless there's an easier way to do so.
				// Remember to add the single-quotes directly after color=
				// and right before the greater-than symbol.
				// Had to look here for the docs:
				// https://doc.qt.io/qt-6/qml-qtquick-text.html#textFormat-prop
				// That link also says stuff on StyledText as used above.
				// Accent colors are used to highlight text that's important for the user
				// to be aware of, as well as linklabels, in various apps.
				// For now it won't know what the name of a color is,
				// but I'll have a way to specify a list of colors via a theme-related
				// file, and that'll display color names instead of the HTML color
				// code when available. That lookup will be done based on the current
				// color theme in use, so an accent color that's not a part of the current
				// set (or the set it's inheriting from) will show up as just the color
				// code if it's not available in the current set or what it inherits from.
				text: "accent color: " + accentColor
				// This is commented out but kept because I'm going to need to know
				// how to display accent-colored text.
				//text: "accent color: <font color='" + accentColor + "'>" + accentColor + "</font>"
				Rectangle {
					// We can show a preview of the user's accent color next to the label.
					// This'll be added to the left side of the accent color
					// dropdown once that's implemented.
					// TODO: Center the rectangle better when it's added to the
					// dropdown.
					anchors.left: parent.right
					height: 24
					width: 24
					anchors.leftMargin: 6
					color: accentColor
					Accessible.name: "accent color preview rectangle"
				} // End of the accent color preview rectangle.
			} // End of the accent color label.
			Label {
				wrapMode: Label.Wrap
				horizontalAlignment: Qt.AlignHLeft
				// Setting this to 12 will make it line up with the title label.
				// The only potential issue is it won't be scrollable directly on the edge, but it might not be an issue.
				Layout.margins: 12
				// Set font style to Inter Display.
				// Might need to change the size so it's slightly larger
				// as this is a little difficult to read, and maybe change some
				// of the text color to be the dimmer variant.
					font.family: RetiledStyles.FontStyles.regularFont
					font.weight: RetiledStyles.FontStyles.regularFontWeight
					font.pointSize: RetiledStyles.FontStyles.smallFontSize
					// Actually I'm not sure about using letter spacing now.
					//font.letterSpacing: -0.8 * scaleFactor
				// TODO: Add a styled version of the label for easier reuse.
				text: "theme family: " + settingsLoader.getSetting("themes", "ThemeFamily", "Retiled-Metro")
			} // End of the theme type label.
			Label {
				wrapMode: Label.Wrap
				horizontalAlignment: Qt.AlignHLeft
				// Setting this to 12 will make it line up with the title label.
				// The only potential issue is it won't be scrollable directly on the edge, but it might not be an issue.
				Layout.margins: 12
				// Set font style to Inter Display.
				// Might need to change the size so it's slightly larger
				// as this is a little difficult to read, and maybe change some
				// of the text color to be the dimmer variant.
					font.family: RetiledStyles.FontStyles.regularFont
					font.weight: RetiledStyles.FontStyles.regularFontWeight
					font.pointSize: RetiledStyles.FontStyles.smallFontSize
					// Actually I'm not sure about using letter spacing now.
					//font.letterSpacing: -0.8 * scaleFactor
				// TODO: Add a styled version of the label for easier reuse.
				// TODO 2: Set ThemeName to "MetroDark" or "MetroLight" if the
				// config file has "dark" or "light" in it for ThemeType when loading.
				// Of course, we're not going to set ThemeType when saving.
				text: "theme name: " + settingsLoader.getSetting("themes", "ThemeName", "MetroDark")
			} // End of the theme type label.
			Label {
				wrapMode: Label.Wrap
				horizontalAlignment: Qt.AlignHLeft
				// Setting this to 12 will make it line up with the title label.
				// The only potential issue is it won't be scrollable directly on the edge, but it might not be an issue.
				Layout.margins: 12
				// Set font style to Inter Display.
				// Might need to change the size so it's slightly larger
				// as this is a little difficult to read, and maybe change some
				// of the text color to be the dimmer variant.
					font.family: RetiledStyles.FontStyles.regularFont
					font.weight: RetiledStyles.FontStyles.regularFontWeight
					font.pointSize: RetiledStyles.FontStyles.smallFontSize
					// Actually I'm not sure about using letter spacing now.
					//font.letterSpacing: -0.8 * scaleFactor
				// TODO: Add a styled version of the label for easier reuse.
				text: "display background wallpaper: " + settingsLoader.getSetting("themes", "DisplayBackgroundWallpaper", "false")
			} // End of the display background wallpaper label.
			Label {
				wrapMode: Label.Wrap
				horizontalAlignment: Qt.AlignHLeft
				// Setting this to 12 will make it line up with the title label.
				// The only potential issue is it won't be scrollable directly on the edge, but it might not be an issue.
				Layout.margins: 12
				// Set font style to Inter Display.
				// Might need to change the size so it's slightly larger
				// as this is a little difficult to read, and maybe change some
				// of the text color to be the dimmer variant.
					font.family: RetiledStyles.FontStyles.regularFont
					font.weight: RetiledStyles.FontStyles.regularFontWeight
					font.pointSize: RetiledStyles.FontStyles.smallFontSize
					// Actually I'm not sure about using letter spacing now.
					//font.letterSpacing: -0.8 * scaleFactor
				// TODO: Add a styled version of the label for easier reuse.
				text: "use tile background wallpaper: " + settingsLoader.getSetting("themes", "UseTileBackgroundWallpaper", "false")
			} // End of the use tile background wallpaper label.
			Label {
				// Ensure the label wraps with long paths so the
				// image preview stays visible. We're also giving
				// a margin on the right side.
				Layout.maximumWidth: window.width - 144
				wrapMode: Label.Wrap
				horizontalAlignment: Qt.AlignHLeft
				// Setting this to 12 will make it line up with the title label.
				// The only potential issue is it won't be scrollable directly on the edge, but it might not be an issue.
				Layout.margins: 12
				Layout.bottomMargin: 90
				// Set font style to Inter Display.
				// Might need to change the size so it's slightly larger
				// as this is a little difficult to read, and maybe change some
				// of the text color to be the dimmer variant.
					font.family: RetiledStyles.FontStyles.regularFont
					font.weight: RetiledStyles.FontStyles.regularFontWeight
					font.pointSize: RetiledStyles.FontStyles.smallFontSize
					// Actually I'm not sure about using letter spacing now.
					//font.letterSpacing: -0.8 * scaleFactor
				// TODO: Add a styled version of the label for easier reuse.
				text: "wallpaper path: " + settingsLoader.getSetting("themes", "WallpaperPath", "wallpaper.jpg")
				Image {
					// Display a preview image for the wallpaper.
					// Right now it's not perfect and looks a little
					// sharp.
					source: {
						let wallpaperSettingPath = settingsLoader.getSetting("themes", "WallpaperPath", "wallpaper.jpg");
						// This allows exact or relative paths.
						// TODO: Allow the ~ (tilda) for home path.
						if (wallpaperSettingPath.startsWith("/")) {
							return wallpaperSettingPath;
						} else {
							return "../../RetiledStart/RetiledStart/pages/" + wallpaperSettingPath;
						}
					}
					height: 120
					width: 120
					// Chsnge sourceSize so it's not awful-looking.
					// Thought it was sourceHeight and sourceWidth but it's not:
					// https://doc.qt.io/qt-6/qml-qtquick-image.html#sourceSize-prop
					sourceSize.height: 120
					sourceSize.width: 120
					anchors.leftMargin: 6
					anchors.left: parent.right
					Accessible.name: "wallpaper preview image"
				} // End of the wallpaper preview image.
			} // End of the wallpaper path label.
			Label {
				wrapMode: Label.Wrap
				horizontalAlignment: Qt.AlignHLeft
				// Setting this to 12 will make it line up with the title label.
				// The only potential issue is it won't be scrollable directly on the edge, but it might not be an issue.
				Layout.margins: 12
				// Set font style to Inter Display.
				// Might need to change the size so it's slightly larger
				// as this is a little difficult to read, and maybe change some
				// of the text color to be the dimmer variant.
					font.family: RetiledStyles.FontStyles.regularFont
					font.weight: RetiledStyles.FontStyles.regularFontWeight
					font.pointSize: RetiledStyles.FontStyles.smallFontSize
					// Actually I'm not sure about using letter spacing now.
					//font.letterSpacing: -0.8 * scaleFactor
				// TODO: Add a styled version of the label for easier reuse.
				text: "wallpaper overlay color: " + settingsLoader.getSetting("themes", "WallpaperOverlayLayerColor", "black")
			} // End of the wallpaper overlay color label.
			Label {
				wrapMode: Label.Wrap
				horizontalAlignment: Qt.AlignHLeft
				// Setting this to 12 will make it line up with the title label.
				// The only potential issue is it won't be scrollable directly on the edge, but it might not be an issue.
				Layout.margins: 12
				// Set font style to Inter Display.
				// Might need to change the size so it's slightly larger
				// as this is a little difficult to read, and maybe change some
				// of the text color to be the dimmer variant.
					font.family: RetiledStyles.FontStyles.regularFont
					font.weight: RetiledStyles.FontStyles.regularFontWeight
					font.pointSize: RetiledStyles.FontStyles.smallFontSize
					// Actually I'm not sure about using letter spacing now.
					//font.letterSpacing: -0.8 * scaleFactor
				// TODO: Add a styled version of the label for easier reuse.
				text: "wallpaper overlay layer opacity: " + (settingsLoader.getSetting("themes", "WallpaperOverlayLayerOpacity", "0.20")) * 100 + "%"
			} // End of the wallpaper overlay layer opacity label.
			Label {
				wrapMode: Label.Wrap
				horizontalAlignment: Qt.AlignHLeft
				// Setting this to 12 will make it line up with the title label.
				// The only potential issue is it won't be scrollable directly on the edge, but it might not be an issue.
				Layout.margins: 12
				// Set font style to Inter Display.
				// Might need to change the size so it's slightly larger
				// as this is a little difficult to read, and maybe change some
				// of the text color to be the dimmer variant.
					font.family: RetiledStyles.FontStyles.regularFont
					font.weight: RetiledStyles.FontStyles.regularFontWeight
					font.pointSize: RetiledStyles.FontStyles.smallFontSize
					// Actually I'm not sure about using letter spacing now.
					//font.letterSpacing: -0.8 * scaleFactor
				// TODO: Add a styled version of the label for easier reuse.
				text: "icon theme: " + settingsLoader.getSetting("themes", "IconTheme", "breeze-dark")
			} // End of the icon theme label.
			Item {
				// 95 pixel tall item as a bottom spacer to comply
				// with Microsoft guidelines:
				// https://learn.microsoft.com/en-us/archive/blogs/africaapps/uxui-guidelines-for-windows-phone-8
				height: 95
			}
		} // End of the ColumnLayout holding everything on the page.
	}
}
