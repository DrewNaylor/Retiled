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
// Modifications to this file are Copyright (C) 2021-2023 Drew Naylor
// and are overall licensed under the LGPLv3 and the GPLv2+ as described in
// Qt's license block above, so you can choose which you use this under.
// Any file in this repo (Retiled) that is licensed under the Apache License, 2.0, and
// uses this file is using it under the LGPLv3.
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
	scale: control.down ? 0.98 : 1.0
	
	// Use behaviors to change the scale speed
	// instead of full animations.
	// Copied and modified from the one in the tilt effect file.
	Behavior on scale {
		// Using InOutQuad:
		// https://doc.qt.io/qt-6/qml-qtquick-propertyanimation.html#easing-prop
		// Got the idea from this SO answer:
		// https://stackoverflow.com/a/15042294
		// We need a SequentialAnimation to wrap the animations in or it'll
		// complain that we can't change the animation on a behavior:
		// https://doc.qt.io/qt-6/qml-qtquick-sequentialanimation.html
		SequentialAnimation {
			// If the scale isn't 1.0, then we pause for a duration
			// of 200 to delay going back to 1.0 scale similar to
			// what Windows Phone does, otherwise if it is 1.0, that
			// implies that the button isn't pressed down.
			// Only problem is this affects the edit mode in RetiledStart.
			// TODO: Solve this in a way that's better than just adding
			// a hard-coded hack to ignore scales of both 1.0 and 0.9.
			// I think this is slightly better than what it was previously,
			// as it also includes a check to see if the button is currently
			// not "down" (like held down with a mouse or finger) to not always go.
			PauseAnimation { duration: scale != 1.0 && scale != 0.9 && !down ? 200 : 0 }
			PropertyAnimation { duration: 200; easing.type: Easing.InOutQuad }
		}
	}
	
	// Property to control tilting.
	//property bool tilt: allowTilt
	// Allow setting tilt angle.
	property int tiltAngle: 15
	
	// Have buttons tilt toward the cursor or
	// touch point when pressed, like Windows Phone.
	// The code was moved to TiltEffect.qml so it can be
	// easily shared with other elements that don't
	// inherit from ButtonBase.
	transform: TiltEffect {}


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
