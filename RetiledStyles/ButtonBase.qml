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
// and are licensed under the LGPLv3.
// Please refer to The Qt Company's copyrights above
// for the copyrights to the original file.
// (Note that the copyright years include the years left out by the hyphen.)
// Windows Phone and all other related copyrights and trademarks are property
// of Microsoft Corporation. All rights reserved.
//
// This file was modified from the original QtQuick Controls source.
// In particular, I took code from the Universal style's "Button.qml" file.
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

T.Button {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 8
    verticalPadding: padding
    spacing: 8
	
	// Scale the button down on pressing it.
	// This is temporary because the nice animation
	// doesn't seem to work anymore in Qt6 and I don't know how to
	// fix it right now.
	scale: control.down ? 0.98 : 1.0
	
	// Transform the button by rotating it toward where
	// the cursor is when pressing it, if desired.
	// Had to watch this video to understand the
	// general concept of how to do it the way
	// I wanted to do it:
	// https://www.youtube.com/watch?v=frC9nZGrLAM
	// TODO: Offer a way to turn off tilting.
	// NOTE: These values are only for testing for now.
	transform: Rotation {
		origin.x: control.width / 2
		origin.y: control.height / 2
		// Set axis and angle values based on
		// the last-pressed x and y values:
		// https://doc.qt.io/qt-6/qml-qtquick-controls2-abstractbutton.html#pressX-prop
		// Not entirely sure what values to use
		// to make it realistic here.
		// Maybe I need to divide the button
		// in half vertically and horizontally
		// to decide if negative or positive values
		// need to be used.
		// Read that on a blog or something I'll paste here
		// later.
		axis.x: control.down ? -pressX : 0
		axis.y: control.down ? -pressY : 0
		axis.z: 0
		angle: 30
	}

    icon.width: 20
    icon.height: 20
    icon.color: Color.transparent(Universal.foreground, enabled ? 1.0 : 0.2)

    property bool useSystemFocusVisuals: true

    contentItem: IconLabel {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display

        icon: control.icon
        text: control.text
        font: control.font
        color: Color.transparent(control.Universal.foreground, enabled ? 1.0 : 0.2)
    }

    background: Rectangle {
        implicitWidth: 32
        implicitHeight: 32
        visible: !control.flat || control.down || control.checked || control.highlighted
        color: control.down ? control.Universal.baseMediumLowColor :
               control.enabled && (control.highlighted || control.checked) ? control.Universal.accent :
                                                                             control.Universal.baseLowColor

        Rectangle {
            width: parent.width
            height: parent.height
            color: "transparent"
            visible: control.hovered
            border.width: 2 // ButtonBorderThemeThickness
            border.color: control.Universal.baseMediumLowColor
        }
    }
}