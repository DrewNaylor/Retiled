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
	
    header: ToolBar {
    
    // Didn't know this is how you set background colors for
    // controls in QML.
    // Based on this info here:
    // https://stackoverflow.com/a/27619649
    background: Rectangle {
        color: 'black'
    }
	
	//FontLoader {
			//id: opensansLight
			// This is using the Open Sans Light font, which you can
			// find here:
			// https://fonts.google.com/specimen/Open+Sans
			// This font was designed by Steve Matteson and is under the Apache License, Version 2.0:
			// http://www.apache.org/licenses/LICENSE-2.0
			//source: "../../../fonts/open_sans/static/OpenSans/OpenSans-Light.ttf"
		//}
		
	

    RowLayout {
    anchors.left: parent.left

                Item {
                // Adding an empty Item to space the header from the left.
                // TODO: Get this empty item's spacing to be closer to WP's
                // spacing for a given app that uses large headers, like
                // pages in the Settings app.
                height: 50
				// When combined with "12" for the about text main body,
				// this forces the title and the body to line up.
                width: 6
                }

                Label {
                id: titleLabel
                text: "start+theme"
                // Not sure if this is the right font size, but it's closer.
				// pixelSize isn't device-independent.
                font.pointSize: RetiledStyles.FontStyles.extralargeFontSize
				// Set font.
				font.family: RetiledStyles.FontStyles.lightFont
				font.weight: RetiledStyles.FontStyles.lightFontWeight
				// Actually I'm not sure about using letter spacing now.
				//font.letterSpacing: -0.8 * scaleFactor
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            }

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
			id: aboutText
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
            text: "accent color: " + accentColor
    } // End of the accent color label.
		} // End of the ColumnLayout holding everything on the page.
	}
}
