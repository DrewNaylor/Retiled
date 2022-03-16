// RetiledSearch - Windows Phone 8.0-like Search app for the
//                 Retiled project.
// Copyright (C) 2021 Drew Naylor
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

import QtQuick
import QtQuick.Controls
// Apparently you have to import Universal here, too.
import QtQuick.Controls.Universal
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

        FontLoader {
            id: opensansLight
            // This is using the Open Sans Light font, which you can
            // find here:
            // https://fonts.google.com/specimen/Open+Sans
            // This font was designed by Steve Matteson and is under the Apache License, Version 2.0:
            // http://www.apache.org/licenses/LICENSE-2.0
            source: "../../../../../../../fonts/open_sans/static/OpenSans/OpenSans-Light.ttf"
        }



        RowLayout {
            anchors.left: parent.left

            Item {
                // Adding an empty Item to space the header from the left.
                // TODO: Get this empty item's spacing to be closer to WP's
                // spacing for a given app that uses large headers, like
                // pages in the Settings app.
                height: 50
                width: 25
            }

            Label {
                id: titleLabel
                text: "about"
                // Not sure if this is the right font size, but it's closer.
                // pixelSize isn't device-independent.
                font.pointSize: 50
                // Set font.
                font.family: "Open Sans Light"
                font.weight: Font.Light
                // TODO: Move letter spacing into the control.
                font.letterSpacing: -0.8 * scaleFactor
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
        contentWidth: aboutText.width
        contentHeight: aboutText.height
        width: parent.width
        height: parent.height
        clip: true
        // I mostly copied this from my modified version of the Qml.Net example app.
        // Code for the About.qml file here:
        // https://github.com/DrewNaylor/wp-like_qmlnet-examples/blob/master/src/Features/pages/About.qml
        Label {
            id: aboutText
            anchors.left: parent.left
            anchors.right: parent.right
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHLeft
            anchors.margins: 10
            // Set font style to opensans.
            font.family: "Open Sans"
            font.weight: Font.Normal
            // Not sure why this is necessary when using C++ but not with Python.
            // Font size will be too small if it's not set to 11.
            font.pointSize: 11
            // TODO: Move letter spacing into the control.
            font.letterSpacing: -0.8 * scaleFactor
            text: "RetiledSearch v0.1 Developer Preview 1\n" +
                  "RetiledSearch is a Windows Phone 8.0-like Search app for the Retiled project.\n" +
                  "Copyright (C) 2021 Drew Naylor. Licensed under the Apache License 2.0.\n" +
                  "Windows Phone and all other related copyrights and trademarks are property of Microsoft Corporation. All rights reserved.\n\n" +
                  "License notice:\n" +
                  "Licensed under the Apache License, Version 2.0 (the ''License'')\n" +
                  "you may not use this file except in compliance with the License.\n" +
                  "You may obtain a copy of the License at\n\n" +
                  "    http://www.apache.org/licenses/LICENSE-2.0 \n\n" +
                  "Unless required by applicable law or agreed to in writing, software\n" +
                  "distributed under the License is distributed on an ''AS IS'' BASIS,\n" +
                  "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n" +
                  "See the License for the specific language governing permissions and\n" +
                  "limitations under the License.\n\n" +
                  "RetiledSearch is powered by Python 3, as well as Qt6/QML thanks to the PySide6 project.\n\n" +
                  "The ''back'' button in this app is provided by the wp-metro font, made by AJ Troxell, licensed under the SIL OFL 1.1 (http://scripts.sil.org/OFL), and available here:\n"+
                  "https://github.com/ajtroxell/wp-metro \n\n" +
                  "Text in this app uses Open Sans, designed by Steve Matteson, licensed under the Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0), and available here:\n"+
                  "https://fonts.google.com/specimen/Open+Sans \n\n" +
                  "Qt (and I think PySide6 as well, since it's owned by The Qt Company) is copyright The Qt Company Ltd. and Qt6 and PySide6 are both being used under the LGPLv3. You can view a copy of the license here:\n" +
                  "https://www.gnu.org/licenses/lgpl-3.0.en.html \n" +
                  "I'm also supposed to provide a link to the standard GPL:\n" +
                  "https://www.gnu.org/licenses/gpl-3.0.html \n\n"+
                  "Some files were taken and modified from the Qt6 QtQuick2 source, in particular styles. I'm supposed to provide a way to download Qt's source according to its license, so I hope a fork of the qtdeclarative repo is enough (there are so many repos in the Qt organization account that I didn't know which one to fork, so I figured that the main one my code uses would be a safe bet):\n" +
                  "https://github.com/DrewNaylor/qtdeclarative \n" +
                  "Please be aware that although I kept the original licensing stuff for the styles, Retiled is using them under the LGPLv3.\n\n" +
                  "I will also provide a link to the PySide6 project, though I didn't take or modify any code from it and I'm not distributing any part of it, so I don't think I have to host it myself:\n" +
                  "https://code.qt.io/cgit/pyside/pyside-setup.git/about/ \n\n" +
                  "Python copyrights are below:\n" +
                  "Copyright (c) 2001-2021 Python Software Foundation.\n" +
                  "All Rights Reserved.\n" +
                  "Copyright (c) 2000 BeOpen.com.\n" +
                  "All Rights Reserved.\n" +
                  "Copyright (c) 1995-2001 Corporation for National Research Initiatives.\n" +
                  "All Rights Reserved.\n" +
                  "Copyright (c) 1991-1995 Stichting Mathematisch Centrum, Amsterdam.\n" +
                  "All Rights Reserved.\n" +
                  "And that's the end of the Python copyrights, at least for 3.9.\n" +
                  "Python is licensed under the PSF License Agreement:\n" +
                  "https://docs.python.org/3.9/license.html#psf-license \n\n" +
                  "You can access the Retiled source code here:\n" +
                  "https://github.com/DrewNaylor/Retiled"
        }
    }
}
