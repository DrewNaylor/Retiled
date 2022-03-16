import QtQuick
import QtQuick.Controls

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Button {
        text: "Search Bing for \"Windows Phone\""
        onClicked: searcher.doSearch("This should work with other terms.")
    }

}
