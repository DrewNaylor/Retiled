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

Page {
		// I mostly copied this from my modified version of the Qml.Net example app.
        Label {
            width: parent.width
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHLeft
			anchors.margins: 10
            text: "RetiledSearch is a Windows Phone 8.0-like Search app for the Retiled project.\n" +
			"Copyright (C) 2021 Drew Naylor. Licensed under the Apache License 2.0.\n" +
			"Windows Phone and all other related copyrights and trademarks are property of Microsoft Corporation. All rights reserved.\n\n" +
			"RetiledSearch is powered by Python, as well as Qt6/QML thanks to the PySide6 project. Qt6 and PySide6 are both being used under the LGPLv3. You can view a copy of the license here:\n" +
			"https://www.gnu.org/licenses/lgpl-3.0.en.html \n" +
			"I'm also supposed to provide a link to the standard GPL:\n" +
			"https://www.gnu.org/licenses/gpl-3.0.html \n"
    }
}
