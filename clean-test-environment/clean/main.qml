import QtQuick
import QtQuick.Controls.Universal
import "../../RetiledStyles" as RetiledStyles

    // NOTE: When running this program, you need to
    // have the working directory be the source directory.
    // So what this means is, change the working directory
    // in Qt Creator's Projects>Build & Run>Run page to
    // be the folder that contains "main.cpp".
    // On Linux, if the build directory is "./build",
    // "cd" into the folder with "main.cpp", then do
    // "./build/appclean", or whatever the path to the
    // executable is. Otherwise, Qt can't find the
    // QML files correctly.
    // There will be a script that handles the working
    // directory properly in the future, and in fact,
    // the plan is to install the compiled binaries
    // in the same folders as the Python ones currently
    // get copied to.

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
