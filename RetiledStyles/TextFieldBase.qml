/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls 2 module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

// RetiledStyles - Windows Phone 8.x-like QML styles for the
//                 Retiled project. Some code was copied from
//                 the official qtdeclarative repo, which you can
//                 access a copy of here:
//                 https://github.com/DrewNaylor/qtdeclarative
// Modifications to this file are Copyright (C) 2021 Drew Naylor
// Please refer to The Qt Company's copyrights above
// for the copyrights to the original file.
// (Note that the copyright years include the years left out by the hyphen.)
// Windows Phone and all other related copyrights and trademarks are property
// of Microsoft Corporation. All rights reserved.
//
// This file was modified from the original QtQuick Controls source.
// In particular, I took code from the Universal style's "TextField.qml" file.
// You can get a copy of the source from here:
// https://github.com/DrewNaylor/qtdeclarative
//
// This file is a part of the RetiledStyles project, which is used by Retiled.
// Neither Retiled nor Drew Naylor are associated with Microsoft
// and Microsoft does not endorse Retiled.
// Any other copyrights and trademarks belong to their
// respective people and companies/organizations.
//
//
//   Please refer to the licensing info above for the licenses this file falls
//   under.

import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import QtQuick.Controls.Universal

T.TextField {
    id: control
	
	// Define some properties that can be set.
	// I'll have to check what the background for
	// textboxes would be in the light theme.
	property string focusedBackgroundColor: "white"
	// Unfocused textboxes.
	property string unfocusedBackgroundColor: "#CCCCCC"
	// Placeholder text color when focused or unfocused.
	// I need to figure out how to handle this when the
	// textfield isn't enabled.
	// I think that's a close-enough color to the watermark
    // color used in Avalonia. Had to use Window Spy to figure it out,
    // since there was no obvious way to figure it out from Avalonia's
    // source.
	property string unfocusedPlaceholderTextColor: "#666666"
	property string focusedPlaceholderTextColor: "transparent"
	// Set selectByMouse to true, detailed here:
	// https://stackoverflow.com/a/38882378
	selectByMouse: true
	
    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                   || Math.max(contentWidth, placeholder.implicitWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    // TextControlThemePadding + 2 (border)
    padding: 12
    topPadding: padding - 7
    rightPadding: padding - 4
    bottomPadding: padding - 5

    Universal.theme: activeFocus ? Universal.Light : undefined

    color: !enabled ? Universal.chromeDisabledLowColor : Universal.foreground
    selectionColor: Universal.accent
    selectedTextColor: Universal.chromeWhiteColor
	// Not sure if I'm doing this right to allow it to change when
		// the textbox isn't enabled.
		// See the property above.
    //placeholderTextColor: !enabled ? Universal.chromeDisabledLowColor :
                                     //activeFocus ? Universal.chromeBlackMediumLowColor :
                                                   //Universal.baseMediumColor
    verticalAlignment: TextInput.AlignVCenter

    PlaceholderText {
        id: placeholder
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)

        text: control.placeholderText
        font: control.font
		// Change the placeholder text color based on focus state.
        color: control.focus ? control.focusedPlaceholderTextColor : control.unfocusedPlaceholderTextColor
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
        verticalAlignment: control.verticalAlignment
        elide: Text.ElideRight
        renderType: control.renderType
    }

    background: Rectangle {
        implicitWidth: 60 // TextControlThemeMinWidth - 4 (border)
        implicitHeight: 28 // TextControlThemeMinHeight - 4 (border)
		// Change the radius so it's square.
		radius: 0

		// Keep the border a width of 0 until it's focused,
		// at which point it's set to 2.
        border.width: control.focus ? 2 : 0 // TextControlBorderThemeThickness
        border.color: !control.enabled ? control.Universal.baseLowColor :
                       control.activeFocus ? control.Universal.accent :
                       control.hovered ? control.Universal.baseMediumColor : control.Universal.chromeDisabledLowColor
		// TODO: Ensure the textfield has the correct styling when it's not enabled.
		// Setting the background seems to work well enough,
        // but I need to change the placeholder text color/visibility so
        // it disappears when focused.
		color: control.focus ? control.focusedBackgroundColor : control.unfocusedBackgroundColor
        //color: control.enabled ? control.Universal.background : control.Universal.baseLowColor
    }
}
