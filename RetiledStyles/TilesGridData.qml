import QtQuick 2.12

QtObject {

    property int rows: 0
    property int columns: 0
    property int undoStackIndex: 0
    property var undoStack: []
    readonly property var tiles: {
        "tilesData": "" // If tiles object is empty it gets optimized away
    }
}
