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

// This file has font data that we'll use in the apps so they don't
// have to be hardcoded everywhere.
// Using singletons (approach 2):
// https://wiki.qt.io/Qml_Styling
// Check the qmldir for this singleton's import stuff.
// We're also getting that example qmldir contents from here:
// https://doc.qt.io/qt-6/qtqml-modules-qmldir.html
pragma Singleton
import QtQuick

QtObject {
    // These font properties are basically the values for Windows Phone,
    // but translated to be used in QML. See also:
    // https://learn.microsoft.com/en-us/previous-versions/windows/apps/ff769552(v=vs.105)#font-names
    // That link goes to the font names, but scrolling down will show
    // font sizes and text styles (font families and font sizes combined usually it
    // appears, but sometimes margins and colors are included).
    // I'm not entirely sure yet how to put them together into text styles.
    // TODO: Put them together into text styles.
    property string regularFont: "Inter Display"
    property string lightFont: "Inter Display Light"
    property string semiboldFont: "Inter Display Semi Bold"
    // Inter doesn't have a Semi/DemiLight font style.
    //property string semilightFont: "Inter Display Semi Light"

    // Font weight is an enum:
    // https://doc.qt.io/qt-6/qml-font.html
    // We have to use "int" or "var" when referring to
    // enums in QML:
    // https://doc.qt.io/qt-6/qml-enumeration.html#using-the-enumeration-type-in-qml
    property int lightFontWeight: Font.Light
    property int regularFontWeight: Font.Normal
    property int semiboldFontWeight: Font.DemiBold
    // Inter doesn't have a Semi/DemiLight weight, but Noto
    // does for at least one version.
    //property enumeration semilightFontWeight: Font.DemiLight
    
    // Font sizes for pointSize as reals.
    // See the MSDN link above for the font sizes we're using
    // under the "Font sizes" section, hope they don't mind.
    // Apparently "real" is double-precision, like actual doubles,
    // so we should be fine:
    // https://stackoverflow.com/questions/42308147/is-double-now-fully-equivalent-to-real-in-qml
    // Also add extrasmallFontSize, for anything that needs a smaller value than 12.
    // I've also added extraextrasmallFontSize for the action buttons in
    // the Action Center mainly.
    // Will probably need to change these to more realistic values
    // as they're integrated.
    property real extraextrasmallFontSize: 8
    property real extrasmallFontSize: 10
    property real smallFontSize: 12
    property real normalFontSize: 16
    property real mediumFontSize: 18
    property real mediumlargeFontSize: 25.333
    property real largeFontSize: 32
    property real extralargeFontSize: 42.667
    property real extraextralargeFontSize: 72
    property real hugeFontSize: 186.667







}