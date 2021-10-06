// PyRetiledStart -  Windows Phone 8.x-like Start screen UI for the
//                   Retiled project. Once this version reaches
//                   feature-parity with the Avalonia version, "Py"
//                   will be removed from the name and the original
//                   will be archived.
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
import QtQuick.Layouts


    Item {
		
		Flickable {
			// The Flickable visibleArea group's properties
			// are often used to draw a scrollbar, which
			// will be useful in the All Apps list.
			// https://doc.qt.io/qt-6/qml-qtquick-flickable.html
			
			Label {
				text: qsTr("All Apps list")
				
			}
			
		}
		
	}
