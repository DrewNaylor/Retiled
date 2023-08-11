import QtQuick 2.12

QtObject {

    id: logic
    signal tileAdded(var tile, int index)
    signal tileMoved(var tile, int fromIndex, int toIndex)
    signal tileRemoved(var tile)
    signal collisionDetected(var model, var tile, var index, var intersections)

    property TilesGridData data: TilesGridData {}

    property alias rows: logic.data.rows
    property alias columns: logic.data.columns

    onTileAdded: (tile, index) => {
                     console.debug(
                         "emit tileAdded(" + tile + ", " + index + ")")
                     printLayout()
                 }

    onTileMoved: (tile, fromIndex, toIndex) => {
                     console.debug(
                         "emit tileMoved(" + tile + ", " + fromIndex + ", " + toIndex + ")")
                     printLayout()
                 }

    onTileRemoved: (tile, index) => {
                       console.debug(
                           "emit tileRemoved(" + tile + ", " + index + ")")
                       printLayout()
                   }

    onDataChanged: {
        console.error("Not implemented")
    }

    onCollisionDetected: (model, tile, index, intersections) => {

                             console.debug(
                                 "emit collisionDetected(" + tile + ", " + index
                                 + ", " + JSON.stringify(intersections) + ")")

                             for (let key in intersections) {
                                 let tileRow = model.toPosition(index).row
                                 let tileColumn = model.toPosition(index).column
                                 let tileMove = intersections[key].tile
                                 let intersection = intersections[key].intersection
                                 let tileRowSpan = Math.min(
                                     Math.max(Math.round(tile.rowSpan), 1),
                                     model.rows)
                                 let tileColumnSpan = Math.min(
                                     Math.max(Math.round(tile.columnSpan), 1),
                                     model.columns)
                                 let tileMoveRowSpan = Math.min(
                                     Math.max(Math.round(tileMove.rowSpan), 1),
                                     model.rows)
                                 let tileMoveColumnSpan = Math.min(
                                     Math.max(Math.round(tileMove.columnSpan),
                                              1), model.columns)
                                 let maxWidthTile = tile.columnSpan
                                 > tileMove.columnSpan ? tile : tileMove
                                 let maxHeightTile = tile.rowSpan
                                 > tileMove.rowSpan ? tile : tileMove

                                 let moveDownIndex = model.toIndex(
                                     tileRow + tileRowSpan, tileMove.column)
                                 let moveUpIndex = model.toIndex(
                                     tileRow - tileMoveRowSpan, tileMove.column)
                                 let moveLeftIndex = model.toIndex(
                                     tileMove.row,
                                     tileColumn - tileMoveColumnSpan)
                                 let moveRightIndex = model.toIndex(
                                     tileMove.row, tileColumn + tileColumnSpan)

                                 // Determine where is enough place to move
                                 let preferedMoveAffinity = []

                                 if (model.canMoveTile(tileMove, moveDownIndex,
                                                       [tile])) {
                                     preferedMoveAffinity.push(moveDownIndex)
                                 }

                                 if (model.canMoveTile(tileMove, moveUpIndex,
                                                       [tile])) {
                                     preferedMoveAffinity.push(moveUpIndex)
                                 }

                                 if (model.canMoveTile(tileMove, moveLeftIndex,
                                                       [tile])) {
                                     preferedMoveAffinity.push(moveLeftIndex)
                                 }

                                 if (model.canMoveTile(tileMove,
                                                       moveRightIndex,
                                                       [tile])) {
                                     preferedMoveAffinity.push(moveRightIndex)
                                 }

                                 // Prefer the smallest move distance
                                 preferedMoveAffinity.sort(
                                     function (leftIndex, rightIndex) {
                                         let leftDistance = Math.abs(
                                                 model.toPosition(
                                                     leftIndex).row - tileMove.row) + Math.abs(
                                                 model.toPosition(
                                                     leftIndex).column - tileMove.column)

                                         let rightDistance = Math.abs(
                                                 model.toPosition(
                                                     rightIndex).row - tileMove.row) + Math.abs(
                                                 model.toPosition(
                                                     rightIndex).column - tileMove.column)

                                         return leftDistance - rightDistance
                                     })

                                 if (preferedMoveAffinity.length > 0) {

                                     model.moveTile(tileMove,
                                                    preferedMoveAffinity[0],
                                                    [tile])
                                 }
                             }
                         }

    function undo() {

        logic._private.undo()
    }

    function redo() {

        logic._private.redo()
    }


    /**
     * Check if at 'targetIndex' is enough space available for the 'tile' without causing a collision with other tiles or leaving the grid
     * This function does not change anything
     *
     * @param type:object tile The tile that should do the hypothetical move
     * @param type:int targetIndex The index where to check if there is enough space for 'tile'
     * @param type:array ignoreTiles An array of tiles that should be ignored while doing the check
     * @return type:boolean The result of the check
     */
    function canMoveTile(tile, targetIndex, ignoreTiles) {

        let hasTile = function (ignore, tiles) {

            let ret = false
            for (var i = 0; i < tiles.length; i++) {
                let otherTile = tiles[i]
                if (otherTile) {
                    let isIgnored = false
                    for (var ii = 0; ii < ignore.length; ii++) {
                        let ignoreTile = ignore[ii]
                        if (ignoreTile) {
                            if (otherTile.equals(ignoreTile)) {
                                isIgnored = true
                                break
                            }
                        }
                    }
                    if (!isIgnored) {
                        ret = true
                        break
                    }
                }
            }

            return ret
        }

        if (tile) {
            let row = logic.toPosition(targetIndex).row
            let column = logic.toPosition(targetIndex).column
            let rowSpan = Math.min(Math.max(Math.round(tile.rowSpan), 1),
                                   logic.data.rows)
            let columnSpan = Math.min(Math.max(Math.round(tile.columnSpan), 1),
                                      logic.data.columns)
            let ignore = [tile]
            if (Array.isArray(ignoreTiles)) {
                ignore = ignore.concat(ignoreTiles)
            }
            let hasSpace = row + rowSpan <= logic.data.rows
                && column + columnSpan <= logic.data.columns
            for (var i = column; i < column + columnSpan && hasSpace; i++) {
                for (var ii = row; ii < row + rowSpan && hasSpace; ii++) {
                    let tileHolder = logic.tileHolderAt(logic.toIndex(ii, i))
                    if (!tileHolder) {
                        hasSpace = false
                    } else if (tileHolder.tiles && hasTile(ignore,
                                                           tileHolder.tiles)) {
                        hasSpace = false
                    }
                }
            }
            return hasSpace
        }
        return false
    }


    /**
     * Add the 'tile' to the grid at 'targetIndex' but only if the check 'canMoveTile()' was successfull (otherwise nothing happens).
     *
     * @param type:object tile The tile that should be added to the grid
     * @param type:int targetIndex The index where to add the 'tile'
     * @param type:array ignoreTiles An array of tiles that should be ignored (passed on to 'canMoveTile()'). This may lead to overlapping tiles
     */
    function addTile(tile, targetIndex, ignoreTiles) {

        let tileHolderTarget = logic.tileHolderAt(targetIndex)

        if (tile && tile.rowOrigin < 0 && tile.columnOrigin < 0
                && tileHolderTarget && logic.canMoveTile(tile, targetIndex,
                                                         ignoreTiles)) {
            let oldIndex = logic.toIndex(tile.row, tile.column)
            logic._private.pushUndoRedoCommand(function () {
                logic._moveTile(tile, targetIndex, ignoreTiles)
            }, function () {
                logic._moveTile(tile, oldIndex, ignoreTiles)
            })
        }
        moveTile(tile, targetIndex, ignoreTiles)
    }


    /**
     * Move the 'tile' to 'targetIndex' but only if the check 'canMoveTile()' was successfull (otherwise nothing happens).
     *
     * @param type:object tile The tile that should be added to the grid
     * @param type:int targetIndex The index where to move the 'tile' to
     * @param type:array ignoreTiles An array of tiles that should be ignored (passed on to 'canMoveTile()'). This may lead to overlapping tiles
     */
    function moveTile(tile, targetIndex, ignoreTiles) {

        let tileHolderTarget = logic.tileHolderAt(targetIndex)

        if (tile && tileHolderTarget && targetIndex !== logic.toIndex(
                    tile.row, tile.column) && logic.canMoveTile(tile,
                                                                targetIndex,
                                                                ignoreTiles)) {
            let oldIndex = logic.toIndex(tile.row, tile.column)
            logic._private.pushUndoRedoCommand(function () {
                logic._moveTile(tile, targetIndex, ignoreTiles)
            }, function () {
                //let movedTile = logic.tileAt(targetIndex)
                logic._moveTile(tile, oldIndex, ignoreTiles)
            })
        }
    }


    /**
     * The given 'tile' is not moved at all but the tile(s) at 'targetIndex' will make place.
     * This function can be called several times in succession for the same tile but you have to finish it off
     * either by calling 'finishProposeMoveTile()' or 'cancelProposeMoveTile()'.
     * The typical use case is if a user drags a tile over another tile which then moves out of the way
     *
     * @param type:object tile The tile that should do the hypothetical move
     * @param type:int targetIndex The index where to move the tile
     * @return type:boolean True if there is enough space for 'tile' to move. False otherwise
     */
    function proposeMoveTile(tile, targetIndex) {

        if (logic._private.proposeMoveTile
                && logic._private.proposeMoveTile.equals(tile)) {
            logic._private.setIndex(logic._private.proposeMoveUndoStackIndex)
        } else {
            logic._private.proposeMoveTile = tile
            logic._private.proposeMoveUndoStackIndex = logic._private.index()
        }

        let detectIntersection = function (tileHolder) {
            if (tile && tileHolder && tileHolder.tiles
                    && tileHolder.tiles.length > 0 && !tile.equals(
                        tileHolder.tiles[0])) {

                let intersections = []
                let tileMove = tileHolder.tiles[0]

                let tileRowSpan = tile.rowSpan
                let tileColumnSpan = tile.columnSpan
                let tileMoveRowSpan = tileMove.rowSpan
                let tileMoveColumnSpan = tileMove.columnSpan

                let targetTop = tileMove.row
                let targetLeft = tileMove.column
                let targetBottom = tileMove.row + tileMoveRowSpan
                let targetRight = tileMove.column + tileMoveColumnSpan

                let srcTop = logic.toPosition(targetIndex).row
                let srcLeft = logic.toPosition(targetIndex).column
                let srcBottom = srcTop + tileRowSpan
                let srcRight = srcLeft + tileColumnSpan

                var leftX = Math.max(srcLeft, targetLeft)
                var rightX = Math.min(srcRight, targetRight)
                var topY = Math.max(srcTop, targetTop)
                var bottomY = Math.min(srcBottom, targetBottom)

                return {
                    "column": leftX,
                    "row": topY,
                    "columnSpan": rightX - leftX,
                    "rowSpan": bottomY - topY
                }
            }
        }

        let row = logic.toPosition(targetIndex).row
        let column = logic.toPosition(targetIndex).column
        let tileRowSpan = tile.rowSpan
        let tileColumnSpan = tile.columnSpan
        let intersections = []

        for (var i = column; i < column + tileColumnSpan; i++) {
            for (var ii = row; ii < row + tileRowSpan; ii++) {
                let tileHolder = logic.tileHolderAt(logic.toIndex(ii, i))
                let intersection = detectIntersection(tileHolder)
                if (intersection) {
                    let newIntersection = true
                    for (var key in intersections) {
                        if (intersections[key].tile.equals(
                                    tileHolder.tiles[0])) {
                            newIntersection = false
                            break
                        }
                    }
                    if (newIntersection) {
                        let intersectionobj = {
                            "tile": tileHolder.tiles[0],
                            "intersection": intersection
                        }
                        intersections.push(intersectionobj)
                    }
                }
            }
        }

        if (intersections.length > 0)
            logic.collisionDetected(d.model, tile, targetIndex, intersections)

        return logic.canMoveTile(tile, targetIndex, [])
    }


    /**
     * The given 'tile' is finally moved and the proposed layout is applyed
     *
     * @param type:object tile The tile object to move
     * @param type:int targetIndex The index where to move the tile
     */
    function finishProposeMoveTile(tile, targetIndex) {

        if (logic._private.proposeMoveTile
                && logic._private.proposeMoveTile.equals(tile)) {
            moveTile(tile, targetIndex, [])
        }
        logic._private.proposeMoveTile = null
        logic._private.proposeMoveUndoStackIndex = 0
    }


    /**
     * The layout is reverted to the state before 'proposeMoveTile()' was called
     */
    function cancelProposeMoveTile() {

        if (logic._private.proposeMoveTile) {
            logic._private.setIndex(logic._private.proposeMoveUndoStackIndex)
        }
        logic._private.proposeMoveTile = null
        logic._private.proposeMoveUndoStackIndex = 0
    }

    // If the tile is a new one (row == -1 && column == -1) it will be added to the layout.
    // If 'targetIndex' is out of bounds the tile will be removed from the layout
    function _moveTile(tile, targetIndex, ignoreTiles) {

        let tileHolderTarget = logic.tileHolderAt(targetIndex)

        if (tile && (logic.canMoveTile(tile, targetIndex,
                                       ignoreTiles) || !tileHolderTarget)) {

            let rowTarget = logic.toPosition(targetIndex).row
            let columnTarget = logic.toPosition(targetIndex).column

            let rowOrigin = tile.row
            let columnOrigin = tile.column
            let rowSpan = Math.min(Math.max(Math.round(tile.rowSpan), 1),
                                   logic.data.rows)
            let columnSpan = Math.min(Math.max(Math.round(tile.columnSpan), 1),
                                      logic.data.columns)
            let isNewTile = rowOrigin < 0 || columnOrigin < 0
            let isRemovedTile = !tileHolderTarget
            if (!(isNewTile && isRemovedTile)) {

                // Detatch the tile from its old tileHolder
                if (!isNewTile) {
                    for (var i = columnOrigin; i < columnOrigin + columnSpan; i++) {
                        for (var ii = rowOrigin; ii < rowOrigin + rowSpan; ii++) {
                            let tiles = logic.data.tiles[logic._private.toModelKey(
                                                             ii, i)]
                            if (Array.isArray(tiles)) {
                                for (var iii = 0; iii < tiles.length; iii++) {
                                    if (tiles[iii].id === tile.id) {
                                        tiles.splice(iii, 1)
                                        break
                                    }
                                }
                            }
                        }
                    }
                }

                let oldRow = tile.row
                let oldColumn = tile.column
                tile.row = rowTarget
                tile.column = columnTarget

                if (!isRemovedTile) {
                    // Attach the tile to its new tileHolder
                    for (var i = rowTarget; i < rowTarget + rowSpan; i++) {
                        for (var ii = columnTarget; ii < columnTarget + columnSpan; ii++) {
                            let tiles = logic.data.tiles[logic._private.toModelKey(
                                                             i, ii)]
                            if (Array.isArray(tiles)) {
                                tiles.push(tile)
                            } else {
                                logic.data.tiles[logic._private.toModelKey(
                                                     i, ii)] = [tile]
                            }
                        }
                    }
                }

                if (isNewTile) {
                    console.debug("Added " + tile + " to " + targetIndex)
                    logic.tileAdded(tile, targetIndex)
                } else if (isRemovedTile) {
                    console.debug("Removed " + tile)
                    logic.tileRemoved(tile)
                } else {
                    console.debug("Moved " + tile + " to " + targetIndex)
                    logic.tileMoved(tile, logic.toIndex(oldRow, oldColumn),
                                    targetIndex)
                }
            } else {
                console.warn("Tile is added and removed at the same time")
            }
        }
    }

    function tileHolderAt(index) {

        if (index < logic.data.rows * logic.data.columns && index >= 0) {
            let position = logic.toPosition(index)

            let tiles = logic.data.tiles[logic._private.toModelKey(
                                             position.row, position.column)]

            return {
                "row": position.row,
                "column": position.column,
                "tiles": Array.isArray(tiles) ? tiles : []
            }
        }
    }

    function tilesAt(index) {

        if (logic.tileHolderAt(index)) {
            return logic.tileHolderAt(index).tiles
        }
    }

    function tileAt(index, z) {

        let zIndex = z != null ? z : 0

        if (logic.tileHolderAt(index)) {
            return logic.tileHolderAt(index).tiles[zIndex]
        }
    }

    function toIndex(row, column) {

        if (row >= 0 && row < logic.data.rows && column >= 0
                && column < logic.data.columns) {
            return row * logic.data.columns + column
        }
        return -1
    }

    function toPosition(index) {

        if (index >= 0 && index < logic.data.columns * logic.data.rows) {
            return {
                "row": Math.floor(index / logic.data.columns),
                "column": index % logic.data.columns
            }
        }
        return {
            "row": -1,
            "column": -1
        }
    }

    function printLayout() {

        for (var i = 0; i < logic.data.rows; i++) {
            let printLine = ""
            for (var ii = 0; ii < logic.data.columns; ii++) {
                let index = logic.toIndex(i, ii)
                let tileHolder = logic.tileHolderAt(index)
                if (tileHolder && tileHolder.tiles.length > 0) {
                    for (var iii = 0; iii < 2; iii++) {
                        if (tileHolder.tiles.length === 1)
                            printLine += "░"
                        else if (tileHolder.tiles.length === 2)
                            printLine += "▓"
                        else if (tileHolder.tiles.length === 3)
                            printLine += "█"
                    }
                    printLine += " "
                } else {
                    let indexString = String(index)
                    for (var iiii = 0; iiii < 2 - indexString.length; iiii++)
                        printLine += "0"
                    printLine += indexString + " "
                }
            }
            console.debug(printLine)
        }
    }

    readonly property QtObject _private: QtObject {

        property TilesGridData data: logic.data

        property int proposeMoveUndoStackIndex: 0
        property var proposeMoveTile: null

        function pushUndoRedoCommand(redoFunctor, undoFunctor) {

            console.assert(typeof redoFunctor === "function",
                           "redoFunctor not a function")
            console.assert(typeof undoFunctor === "function",
                           "undoFunctor not a function")
            console.assert(
                        logic.data.undoStackIndex <= logic.data.undoStack.length,
                        "Current undoStack index (" + logic.data.undoStackIndex
                        + ") is larger than undoStack length (" + logic.data.undoStack.length + ")")
            console.assert(logic.data.undoStackIndex >= 0,
                           "Current undoStack index is < 0")
            if (typeof redoFunctor === "function"
                    && typeof undoFunctor === "function") {
                if (logic.data.undoStackIndex < logic.data.undoStack.length) {
                    let test = logic.data.undoStack.splice(
                            logic.data.undoStackIndex)
                }
                logic.data.undoStack.push({
                                              "undo": undoFunctor,
                                              "redo": redoFunctor
                                          })
                redo()
            }
        }

        function index() {
            return logic.data.undoStackIndex
        }

        function setIndex(index) {

            let currentIndex = logic.data.undoStackIndex
            let toIndex = Math.max(Math.min(logic.data.undoStack.length,
                                            index), 0)

            if (toIndex < currentIndex) {
                console.debug(
                            "Undoing from index " + currentIndex + " to index " + toIndex)
                for (var counter = currentIndex; counter > toIndex; counter--) {
                    undo()
                }
            } else if (toIndex > currentIndex) {
                console.debug(
                            "Redoing from index " + currentIndex + " to index " + toIndex)
                for (var counter = currentIndex; counter < toIndex; counter++) {
                    redo()
                }
            }
        }

        function undo() {
            if (logic.data.undoStackIndex > 0) {

                console.assert(
                            logic.data.undoStackIndex <= logic.data.undoStack.length,
                            "Current undoStack index is larger than undoStack length")
                console.assert(logic.data.undoStackIndex >= 0,
                               "Current undoStack index is < 0")
                logic.data.undoStackIndex--
                console.assert(
                            typeof logic.data.undoStack[logic.data.undoStackIndex].undo
                            === "function", "Undo command not a functor")
                logic.data.undoStack[logic.data.undoStackIndex].undo()
                console.debug("Called undo()")
            }
        }

        function redo() {
            if (logic.data.undoStackIndex < logic.data.undoStack.length) {
                console.assert(
                            logic.data.undoStackIndex <= logic.data.undoStack.length,
                            "Current undoStack index is larger than undoStack length")
                console.assert(logic.data.undoStackIndex >= 0,
                               "Current undoStack index is < 0")
                console.assert(
                            typeof logic.data.undoStack[logic.data.undoStackIndex].redo
                            === "function", "Undo command not a functor")
                logic.data.undoStack[logic.data.undoStackIndex].redo()
                logic.data.undoStackIndex++
                console.debug("Called redo()")
            }
        }

        function toModelKey(row, column) {
            return "row" + row + "-column" + column
        }

        function copyData() {

            let tilesCopy = {}
            if (logic.data.tiles) {
                for (let key in logic.data.tiles) {
                    let tileArray = logic.data.tiles[key]
                    if (Array.isArray(tileArray)) {
                        let tileArrayCopy = []
                        tileArray.forEach(function (tile) {
                            if (tile && tile.hasOwnProperty("id")
                                    && tile.hasOwnProperty("row")
                                    && tile.hasOwnProperty("column")
                                    && tile.hasOwnProperty("rowSpan")
                                    && tile.hasOwnProperty("columnSpan")) {
                                let tileCopy = newTile(tile.row, tile.column,
                                                       tile.rowSpan,
                                                       tile.columnSpan)
                                tileCopy.id = tile.id
                                tileArrayCopy.push(tileCopy)
                            }
                        })
                        tilesCopy[key] = tileArrayCopy
                    }
                }
            }

            let component = Qt.createComponent(Qt.resolvedUrl(
                                                   "TileLayoutData.qml"))
            let data = component.createObject(null, {
                                                  "rows": logic.data.rows,
                                                  "columns": logic.data.columns,
                                                  "undoStackIndex": logic.data.undoStackIndex,
                                                  "undoStack": logic.data.undoStack.slice(
                                                                   ),
                                                  "tiles": tilesCopy
                                              })
            if (data == null) {
                console.error("Error copying tile layout data")
            }

            return data
        }

        function uuidv4() {
            return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g,
                                                                  function (c) {
                                                                      var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8)
                                                                      return v.toString(16)
                                                                  })
        }

        function newTile(row, column, rowSpan, columnSpan) {

            return {
                "id": uuidv4(),
                "row": row,
                "column": column,
                "rowSpan": rowSpan,
                "columnSpan": columnSpan,
                "toString": function () {
                    return "Tile(row " + this.row + ", col " + this.column
                            + ", rowSpan " + this.rowSpan + ", columnSpan "
                            + this.columnSpan + ", id " + this.id + ")"
                },
                "equals": function (other) {
                    return other && this.row === other.row
                            && this.column === other.column
                            && this.rowSpan === other.rowSpan
                            && this.columnSpan === other.columnSpan
                }
            }
        }
    }
}
