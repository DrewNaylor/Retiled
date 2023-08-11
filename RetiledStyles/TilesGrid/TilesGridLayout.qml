// See LICENSE in this folder for copyright info.
// Assuming this file falls under the MIT License based
// on that file, this file's modifications are Copyright (C)
// 2023 Drew Naylor and are available under the MIT License.
// See the original repo here:
// https://github.com/Tereius/TilesGrid
// My fork here:
// https://github.com/DrewNaylor/TilesGrid



import QtQuick 2.12
import TilesGrid 1.0

TilesGrid {

    id: layout

    onWidthChanged: {

        if (layout.contentItem)
        // Modification by Drew Naylor: Change atomicWidth/height to
        // monadicWidth/height.
            layout.contentItem.monadicWidth
                    = (layout.width - layout.leftPadding - layout.rightPadding
                       - (layout.columns - 1) * layout.columnSpacing) / layout.columns
    }

    onHeightChanged: {
        if (layout.contentItem)
            layout.contentItem.monadicHeight
                    = (layout.height - layout.topPadding - layout.bottomPadding
                       - (layout.rows - 1) * layout.rowSpacing) / layout.rows
    }
}
