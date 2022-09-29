import QtQuick
import QtQuick.Controls.Universal
import "../../RetiledStyles" as RetiledStyles

ApplicationWindow {
    id: window
    width: 360
    height: 720
    visible: true
    title: qsTr("RetiledStart")

    Universal.theme: Universal.Dark
    // Property for setting Accent colors so that Universal.accent
    // can in turn be set easily at runtime.
    property string accentColor: "#0050ef"
    Universal.accent: accentColor
    Universal.foreground: 'white'
    // Fun fact: QML supports setting the background to transparent,
    // which shows all the other windows behind the app's window as you'd expect.
    // This will probably be useful when working on stuff like the volume controls and Action Center.
    Universal.background: 'black'

    RetiledStyles.Button {
        text: "test"
    }
}
