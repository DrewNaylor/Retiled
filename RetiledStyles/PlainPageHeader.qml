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



import "." as RetiledStyles
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ToolBar {

    // Do properties so the text can be changed.
    property string appTitleText;
    property string pageTitleText;
    
    // Didn't know this is how you set background colors for
    // controls in QML.
    // Based on this info here:
    // https://stackoverflow.com/a/27619649
    background: Rectangle {
        // TODO: Switch to using the theme background color
        // when implemented.
        color: ThemeLoader.getValueFromTheme(themePath, "PageHeader", "BackgroundColor", "black")
    }
	
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

	ColumnLayout {
				Label {
					// I think this is about how the app titles
					// should appear, but it might be off.
					id: appTitleLabel
					text: appTitleText
					font.capitalization: Font.AllUppercase
					// Not sure if this is the right font size, but it's closer.
					// pixelSize isn't device-independent.
					font.pointSize: RetiledStyles.FontStyles.smallFontSize
					// Set font.
					font.family: RetiledStyles.FontStyles.semiboldFont
					font.weight: RetiledStyles.FontStyles.semiboldFontWeight
					// Actually I'm not sure about using letter spacing now.
					//font.letterSpacing: -0.8 * scaleFactor
					elide: Label.ElideRight
					horizontalAlignment: Qt.AlignLeft
					verticalAlignment: Qt.AlignVCenter
					Layout.fillWidth: true
					color: ThemeLoader.getValueFromTheme(themePath, "PageHeader", "TextColor", "white")
					// Set top margin.
					Layout.topMargin: 24
            	} // End of page title
				
                Label {
					id: pageTitleLabel
					text: pageTitleText
					// Not sure if this is the right font size, but it's closer.
					// pixelSize isn't device-independent.
					font.pointSize: RetiledStyles.FontStyles.extralargeFontSize
					// Set font.
					font.family: RetiledStyles.FontStyles.lightFont
					font.weight: RetiledStyles.FontStyles.lightFontWeight
					// Actually I'm not sure about using letter spacing now.
					//font.letterSpacing: -0.8 * scaleFactor
					elide: Label.ElideRight
					horizontalAlignment: Qt.AlignLeft
					verticalAlignment: Qt.AlignVCenter
					Layout.fillWidth: true
					color: ThemeLoader.getValueFromTheme(themePath, "PageHeader", "TextColor", "white")
					// Set top margin.
					Layout.topMargin: -6
            	} // End of page title
			
				Item {
					// Empty item as a spacer for the header.
					// Can't seem to get margins working on the layouts
					// directly.
					height: 12
				}

			} // End of ColumnLayout holding the app and page title labels.
            } // End of RowLayout giving a margin to the app and page title
} // End of the ToolBar containing the header.