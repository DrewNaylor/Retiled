// This file was mostly copied from this SO answer by Amfasis:
// https://stackoverflow.com/a/61804867
// As such, it's under the CC BY-SA 4.0 license.
// More details on the license:
// https://creativecommons.org/licenses/by-sa/4.0/
// Modifications to the original code are Copyright (C) 2023 Drew Naylor where specified,
// but still are available under the above license. I'll state where it differs.
// (Note that the copyright years include the years left out by the hyphen.)
// 
// This file is being used in RetiledStyles, Windows Phone 8.x-like QML styles for the
// Retiled project.
// Windows Phone and all other related copyrights and trademarks are property
// of Microsoft Corporation. All rights reserved.
//
// This file is a part of the RetiledStyles project, which is used by Retiled.
// Neither Retiled nor Drew Naylor are associated with Microsoft
// and Microsoft does not endorse Retiled.
// Any other copyrights and trademarks belong to their
// respective people and companies/organizations.
// As a whole, the RetiledStyles project is available under both the
// LGPLv3 and the GPLv2+ as described below:
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



// Remove the versions (change by Drew Naylor).
import QtQuick
import QtQuick.Layouts

Item {
    id: layout

    // TODO: Allow column and row count to be changeable.
    // Drew Naylor changed this from 1 for each to make it simpler.
    // Still need to set rows dynamically.
    property int columns: 4
    property int rows: 20

    // Spacing property added by Drew Naylor.
    // TODO: Allow spacing to be changeable.
    property int spacing: 10

    onChildrenChanged: updatePreferredSizes()
    onWidthChanged: updatePreferredSizes()
    onHeightChanged: updatePreferredSizes()
    onColumnsChanged: updatePreferredSizes()
    onRowsChanged: updatePreferredSizes()

    function updatePreferredSizes()
    {
        if(layout.children.length === 0)
        {
            return
        }

        // Set cell height and width to 70, which is what I need.
        // (Change by Drew Naylor)
        // TODO: Allow it to be changeable.
        var cellWidth = 70;
        var cellHeight = 70;
        for(var i=0;i<layout.children.length;++i)
        {
            var obj = layout.children[i]

            var c = obj.Layout.column
            var r = obj.Layout.row
            var cs = obj.Layout.columnSpan
            var rs = obj.Layout.rowSpan

            console.log(obj.color);
            console.log(obj.Layout.column);

            // Drew Naylor wrapped this code in an If statement
            // to allow for spacing when not at column 0.
            // Same thing for rows.
            if (c === 0) {
                obj.x = 0;
            } else {
                obj.x = (c * cellWidth) + spacing;
            }
            if (r === 0) {
                obj.y = 0;
            } else {
                obj.y = (r * cellHeight) + spacing;
            }

            // Drew Naylor wrapped this code to handle small tiles.
            // Also height and width were inverted, so it was fixed.
            if (cs === 1) {
                obj.width = cs * cellWidth;
            } else {
                obj.width = (cs * cellWidth) + spacing;
            }
            obj.height = rs * cellHeight;
        }

    }
}