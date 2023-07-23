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
import QtQuick.Controls.Universal

T.ToolBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    
    // When minimized is true, use size 24 appbars, otherwise use 48.
    // We also check to see if the appbar drawer position
    // is 0.0, meaning it's closed, and otherwise we set it to
    // the full height.
    // TODO: Should the appbar drawer position we check for
    // be a different value? Should it be less than 1.0 or something?
    // We also need to override the appbar height if the back button
    // is visible.
    implicitHeight: minimized && appbarDrawer.position === 0.0 && backButtonVisible === false ? 24 : 48

    // Allow appbars to appear minimized.
    property bool minimized: false

	// #212021 is the hex color code for the dark appbar color
	// as sampled from a screenshot.
	// I should probably figure out how to just change the
	// Universal theme directly, so I can use values from it.
	// We're setting this here so apps using the appbar can set its color.
    // Actually that was the wrong color, it's supposed to be
    // #1f1f1f.
    // TODO: move this to another file so it can just be referenced
	// along with all the other light and dark theme colors.
    // This will still be able to be overridden in case an app
    // wants a specific color for the appbar drawer.
	property string backgroundColor: ThemeLoader.getValueFromTheme(themePath, "AppBar", "BackgroundColor", "#1f1f1f")

    background: Rectangle {
        // TODO: figure out how to have different-height appbars when they're closed
        // to support both display styles (where they show buttons and when they
        // don't).
        // When minimized is true, use size 24 appbars, otherwise use 48.
        // We also check to see if the appbar drawer position
        // is 0.0, meaning it's closed, and otherwise we set it to
        // the full height.
        // TODO: Should the appbar drawer position we check for
        // be a different value? Should it be less than 1.0 or something?
        // We also need to override the appbar height if the back button
        // is visible.
        height: minimized && appbarDrawer.position === 0.0 && backButtonVisible === false ? 24 : 48
		// Set background color.
        color: backgroundColor
    }
}
