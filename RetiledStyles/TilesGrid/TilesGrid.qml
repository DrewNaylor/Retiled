// See LICENSE in this folder for copyright info.
// Assuming this file falls under the MIT License based
// on that file, this file's modifications are Copyright (C)
// 2023 Drew Naylor and are available under the MIT License.
// See the original repo here:
// https://github.com/Tereius/TilesGrid
// My fork here:
// https://github.com/DrewNaylor/TilesGrid



import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml.Models 2.12

Control {

    id: control

    property alias rows: grid.rows
    property alias columns: grid.columns
    property alias rowSpacing: grid.rowSpacing
    property alias columnSpacing: grid.columnSpacing
    // This is the width of the smallest tile (the tiles columnSpan equals 1)
    // Modification by Drew Naylor: Changed the name to "monadicWidth" and "monadicHeight"
    // as monads are indivisible but atoms aren't.
    // Also set size to 70.
    property real monadicWidth: 70
    // This is the height of the smallest tile (the tiles rowSpan equals 1)
    property real monadicHeight: 70

    property int count: {

        let count = 0
        for (var i = 0; i < repeater.count; i++) {
            count += repeater.itemAt(i).tiles.length
        }
        return count
    }

    // Modification by Drew Naylor: Update event names.
    onMonadicHeightChanged: {
        grid.monadicHeight = control.monadicHeight
    }

    onMonadicWidthChanged: {
        grid.monadicWidth = control.monadicWidth
    }

    // Modification by Drew Naylor: Update property names.
    implicitWidth: control.leftPadding + control.rightPadding + control.monadicWidth
                   * control.columns + (control.columns - 1) * control.columnSpacing
    implicitHeight: control.topPadding + control.bottomPadding + control.monadicHeight
                    * control.rows + (control.rows - 1) * control.rowSpacing

    focusPolicy: Qt.StrongFocus
    focus: true

    Shortcut {
        sequence: StandardKey.Undo
        onActivated: d.model.undo()
    }

    Shortcut {
        sequence: StandardKey.Redo
        onActivated: d.model.redo()
    }

    property Transition add: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1.0
            duration: 400
            alwaysRunToEnd: true
        }
        NumberAnimation {
            property: "scale"
            from: 0
            to: 1.0
            duration: 400
            alwaysRunToEnd: true
        }
    }

    property Transition move: Transition {
        NumberAnimation {
            properties: "x,y"
            duration: 1000
        }
    }

    property Component highlightDelegate: Rectangle {

        color: "red"
        opacity: 0.5
    }

    contentItem: Grid {

        id: grid

        // Modification by Drew Naylor: Update property names and values.
        property real monadicWidth: 70
        property real monadicHeight: 70

        readonly property int maxIndex: toIndex(rows - 1, columns - 1)

        horizontalItemAlignment: Grid.AlignHCenter
        verticalItemAlignment: Grid.AlignVCenter
        padding: 0
        columnSpacing: 0
        rowSpacing: 0
        rows: 1
        columns: 1

        //add: control.add

        //move: control.move
        function tileHolderAtPosition(x, y) {

            return grid.childAt(x, y)
        }

        function tileHolderAt(index) {

            return repeater.itemAt(index)
        }

        function tileAt(index) {

            if (tileHolderAt(index))
                return tileHolderAt(index).tile
        }

        function toIndex(row, column) {
            if (row < grid.rows && column < grid.columns) {
                return row * grid.columns + column
            }
            return -1
        }

        function toPosition(index) {
            return {
                "row": Math.floor(index / grid.columns),
                "column": index % grid.columns
            }
        }

        QtObject {
            id: d
            property var dragTile: null
            property var dragModelTile: null
            property bool dragActive: false

            onDragActiveChanged: {
                grid.dragCanceled()
            }

            property var visualTiles: null

            Component.onCompleted: {
                d.visualTiles = {}
            }

            property TilesGridLogic model: TilesGridLogic {
                data: TilesGridData {
                    rows: grid.rows
                    columns: grid.columns
                }

                onTileAdded: function (tile, index) {

                    let visualTile = d.visualTiles[tile.id]
                    let tileHolderTarget = grid.tileHolderAt(index)
                    console.assert(visualTile, "Missing visual tile")
                    console.assert(tileHolderTarget, "Missing tileHolder")
                    if (visualTile) {
                        visualTile.visible = true
                        visualTile.reparent(tileHolderTarget)

                        visualTile.width = Qt.binding(function () {

                            let columnSpan = Math.min(
                                    Math.max(Math.round(this.columnSpan), 1),
                                    grid.columns)
                            // Modification by Drew Naylor: Update property names.
                            return columnSpan * grid.monadicWidth
                                    + (columnSpan - 1) * grid.columnSpacing
                        })

                        visualTile.height = Qt.binding(function () {

                            let rowSpan = Math.min(Math.max(Math.round(
                                                                this.rowSpan),
                                                            1), grid.rows)
                            // Modification by Drew Naylor: Update property names.
                            return rowSpan * grid.monadicHeight + (rowSpan - 1) * grid.rowSpacing
                        })
                    }
                }

                onTileMoved: function (tile, fromIndex, toIndex) {

                    let visualTile = d.visualTiles[tile.id]
                    let tileHolderTarget = grid.tileHolderAt(toIndex)
                    console.assert(visualTile, "Missing visual tile")
                    console.assert(tileHolderTarget, "Missing tileHolder")
                    if (visualTile && tileHolderTarget) {
                        visualTile.reparent(tileHolderTarget)
                    }
                }

                onTileRemoved: function (tile) {

                    let visualTile = d.visualTiles[tile.id]
                    console.assert(visualTile, "Missing visual tile")
                    if (visualTile) {
                        visualTile.visible = false
                    }
                }
            }
        }

        Repeater {

            id: repeater

            model: ListModel {

                id: tileModel

                property int columns: grid.columns
                property int rows: grid.rows

                property int currentRows: 0
                property int currentColumns: 0

                onColumnsChanged: {

                    if (tileModel.columns < 0)
                        return

                    let currentNumColumns = tileModel.currentColumns

                    tileModel.currentColumns = tileModel.columns

                    console.info(
                                "Number of columns changed from "
                                + currentNumColumns + " to " + tileModel.columns
                                + " (current number of rows " + tileModel.currentRows + ")")

                    if (currentNumColumns < tileModel.columns) {
                        // We have to add columns
                        let numColumnsToAdd = tileModel.columns - currentNumColumns
                        console.info("Adding " + numColumnsToAdd + " columns to model")
                        for (var i = currentNumColumns; i < tileModel.columns; i++) {
                            for (var ii = 0; ii < tileModel.currentRows; ii++) {
                                let indexToAdd = ii * tileModel.columns + i
                                console.info("Adding intex " + indexToAdd + " to model (row: "
                                             + ii + ", column: " + i + ")")
                                tileModel.insert(indexToAdd, {})
                            }
                        }
                    } else if (currentNumColumns > tileModel.columns) {
                        // we have to remove columns
                        let numColumnsToRemove = currentNumColumns - tileModel.columns
                        console.info("Removing " + numColumnsToRemove + " columns from model")
                        for (var i = currentNumColumns - 1; i >= tileModel.columns; i--) {
                            for (var ii = tileModel.currentRows - 1; ii >= 0; ii--) {
                                let indexToRemove = ii * currentNumColumns + i
                                console.info("Removing intex " + indexToRemove
                                             + " from model (row: " + ii + ", column: " + i + ")")
                                tileModel.remove(indexToRemove)
                            }
                        }
                    }
                }

                onRowsChanged: {

                    if (tileModel.rows < 0)
                        return

                    let currentNumRows = tileModel.currentRows

                    tileModel.currentRows = tileModel.rows

                    console.info("Number of rows changed from " + currentNumRows
                                 + " to " + tileModel.rows + " (current number of columns "
                                 + tileModel.currentColumns + ")")

                    if (currentNumRows < tileModel.rows) {
                        // we have to add rows
                        let numRowsToAdd = tileModel.rows - currentNumRows
                        console.info(
                                    "Adding " + numRowsToAdd + " rows to model")
                        for (var i = currentNumRows; i < tileModel.rows; i++) {
                            for (var ii = 0; ii < tileModel.currentColumns; ii++) {
                                let intexToAdd = i * tileModel.currentColumns + ii
                                console.info("Adding intex " + intexToAdd + " to model (row: "
                                             + i + ", column: " + ii + ")")
                                tileModel.insert(intexToAdd, {})
                            }
                        }
                    } else if (currentNumRows > tileModel.rows) {
                        // we have to remove rows
                        let numRowsToRemove = currentNumRows - tileModel.rows
                        console.info("Removing " + numRowsToRemove + "rows from model")
                        for (var i = currentNumRows - 1; i >= tileModel.rows; i--) {
                            for (var ii = tileModel.currentColumns - 1; ii >= 0; ii--) {
                                let indexToRemove = i * tileModel.currentColumns + ii
                                console.info("Removing intex " + indexToRemove
                                             + " from model (row: " + i + ", column: " + ii + ")")
                                tileModel.remove(indexToRemove)
                            }
                        }
                    }
                }
            }

            delegate: Rectangle {

                id: tileHolder
                //border.width: 1
                //border.color: "black"
                color: "transparent"

                property var tiles: {

                    let list = []
                    for (var i = 0; i < tileHolder.children.length; i++) {
                        let child = tileHolder.children[i]
                        if (child instanceof Tile) {
                            if (child.visible) {
                                list.push(child)
                            }
                        }
                    }
                    return list
                }

                property bool ownsTile: tileHolder.tiles.length > 0

                readonly property int modelIndex: index
                property int row: grid.toPosition(index).row
                property int column: grid.toPosition(index).column

                z: (tileHolder.ownsTile ? 1 : 0)
                   + (tileHolder.ownsTile && drop.drag.source
                      && drop.drag.source === tileHolder.tiles[0] ? 1 : 0)

                // Modification by Drew Naylor: Update property names.
                implicitHeight: grid.monadicHeight
                implicitWidth: grid.monadicWidth

                property var highlightItem: null

                property bool containsDrag: drop.containsDrag
                                            && drop.currentTileHolder == tileHolder

                onContainsDragChanged: {
                    // Modification by Drew Naylor: Update property names.
                    let highlightItemWidth = grid.monadicWidth
                    let highlightItemHeight = grid.monadicHeight
                    let tile = drop.drag.source
                    let tileModel = null

                    if (tile) {
                        tileModel = d.model.tileAt(d.model.toIndex(tile.row,
                                                                   tile.column))
                        if (!tileModel)
                            tileModel = tile

                        let rowSpan = Math.min(Math.max(Math.round(
                                                            tile.rowSpan), 1),
                                               grid.rows)
                        let columnSpan = Math.min(
                                Math.max(Math.round(tile.columnSpan), 1),
                                grid.columns)
                        // Modification by Drew Naylor: Update property names.
                        highlightItemWidth = columnSpan * grid.monadicWidth
                                + (columnSpan - 1) * grid.columnSpacing
                        highlightItemHeight = rowSpan * grid.monadicHeight
                                + (rowSpan - 1) * grid.rowSpacing
                    }

                    if (tileHolder.containsDrag) {
                        if (control.highlightDelegate) {
                            highlightItem = control.highlightDelegate.createObject(
                                        tileHolder, {
                                            "width": highlightItemWidth,
                                            "height": highlightItemHeight,
                                            "z": -1
                                        })
                        }
                    } else {
                        if (highlightItem)
                            highlightItem.destroy()
                    }
                }

                Label {
                    visible: false
                    text: index + " - " + tileHolder.z
                    anchors.top: parent.top
                    anchors.left: parent.left
                }

                Label {
                    visible: false
                    text: tileHolder.tiles.length > 0 ? "To" : ""
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                }


                /*
                Behavior on implicitWidth {
                    enabled: true
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InCubic
                    }
                }

                Behavior on implicitHeight {
                    enabled: true
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InCubic
                    }
                }*/
                Behavior on scale {
                    enabled: true
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InCubic
                    }
                }
            }
        }
    }

    DropArea {
        id: drop
        keys: ["tile"]
        anchors.fill: parent

        property var currentTileHolder: null

        function handleDrag(drag) {

            let tileHolder = null
            let canMove = false
            if (drag.source && drag.source instanceof Tile) {

                tileHolder = grid.tileHolderAtPosition(drag.x, drag.y)

                if (tileHolder) {
                    var tile = drag.source

                    let modelTile = d.model.tileAt(d.model.toIndex(tile.row,
                                                                   tile.column))

                    if (!modelTile) {
                        // A new tile
                        modelTile = d.model._private.newTile(
                                    -1, -1, drag.source.rowSpan,
                                    drag.source.columnSpan)
                    }

                    canMove = d.model.proposeMoveTile(modelTile,
                                                      d.model.toIndex(
                                                          tileHolder.row,
                                                          tileHolder.column))
                    if (!canMove) {
                        tileHolder = null
                    }
                }
            } else {
                d.model.cancelProposeMoveTile()
                drag.accepted = false
            }

            drop.currentTileHolder = tileHolder
            return canMove
        }

        onPositionChanged: drag => {
                               handleDrag(drag)
                           }

        onEntered: drag => {
                       handleDrag(drag)
                   }

        onDropped: drop => {

                       let canMove = handleDrag(drop)

                       let tileHolder = grid.tileHolderAtPosition(drag.x,
                                                                  drag.y)

                       if (tileHolder && drop.source && canMove
                           && drop.source instanceof Tile) {
                           var tile = drop.source

                           let modelTile = d.model.tileAt(
                               d.model.toIndex(tile.row, tile.column))

                           if (!modelTile) {
                               // A new tile
                               modelTile = d.model._private.newTile(
                                   -1, -1, tile.rowSpan, tile.columnSpan)

                               d.visualTiles[modelTile.id] = tile
                           }

                           if (d.model.toIndex(
                                   modelTile.row,
                                   modelTile.column) !== d.model.toIndex(
                                   tileHolder.row, tileHolder.column)) {
                               drop.accept(Qt.MoveAction)
                           }

                           d.model.finishProposeMoveTile(modelTile,
                                                         d.model.toIndex(
                                                             tileHolder.row,
                                                             tileHolder.column))
                       } else {
                           d.model.cancelProposeMoveTile()
                           drop.accepted = false
                       }
                   }

        onExited: {
            drop.currentTileHolder = null
            d.model.cancelProposeMoveTile()
        }
    }
}
