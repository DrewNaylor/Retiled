import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts

// This is a somewhat-modified version of this SO answer so kindly written by Albertino80 here:
// https://stackoverflow.com/a/66613024
// Modified by Drew Naylor as an example of showing image files behind buttons in a Flow in a Flickable.
// The background has also been changed to black and the gradient was removed because it's not necessary here.
// The original rectangle and rectangle-moving code was commented out.


ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    color: "black"

    Item {
           width: window.width
           height: window.height
           Rectangle {
               anchors.fill: parent
               color: "transparent"
           }
       }

       Rectangle {
           id: sgfBox
           anchors.fill: parent
           color: "transparent"
         Flickable {
             contentWidth: tilePageContentHolder.width
                     contentHeight: tilePageContentHolder.height
                     // Very important: Lock the flickable to vertical.
                     // I noticed this when I was just trying to find
                     // a way to disengage the flickable if the user
                     // is flicking horizontally in the docs.
                     flickableDirection: Flickable.VerticalFlick
                     width: parent.width
                     height: parent.height
           Flow {
               id: tilePageContentHolder
               width: window.width
			   spacing: 10
            Button {
                // Trying to add text to buttons, but it seems to
                // override the text when using the background
                // image for some reason.
                 text: "testing a button here."
                 width: 150
                 height: 150
                 scale: down ? 0.98 : 1.0
             }
             Button {
                  text: "testing a button here."
                  width: 150
                  height: 150
                scale: down ? 0.98 : 1.0
            }
            Button {
                text: "testing a button here."
                width: 300
                height: 150
                  scale: down ? 0.98 : 1.0
            }
                Button {
                  text: "testing a button here."
                  width: 150
                  height: 150
                  scale: down ? 0.98 : 1.0
           }
         }
           }

//           Rectangle {
//               id: sfg
//               width: 175
//               height: 75
//               color: 'transparent'
//               RowLayout {
//                   width: parent.width
//                   height: parent.height
//                   spacing: 25

//                   Rectangle {
//                       Layout.preferredWidth: 75
//                       Layout.fillWidth: false
//                       Layout.fillHeight: true
//                       color: 'red'
//                   }

//                   Rectangle {
//                       Layout.preferredWidth: 75
//                       Layout.fillWidth: false
//                       Layout.fillHeight: true
//                       color: 'red'
//                   }

//               }
//               MouseArea {
//                   cursorShape: Qt.PointingHandCursor
//                   anchors.fill: parent
//                   drag {
//                       target: sfg
//                   }
//               }
//           }
       }

       Rectangle {
           id: mask
           anchors.fill: parent
           color: "transparent"

           Image {
                                   //id: tileWallpaper
                                   //fillMode: Image.PreserveAspectCrop
                                   //anchors.top: tilesContainer.top
                                   source: "wallpaper.jpg"
                                   // //source: "../RetiledStart/PyRetiledStart/pages/wallpaper.jpg"
                                   //visible: true

                               }

           layer.enabled: true
           layer.effect: OpacityMask {
               maskSource: sgfBox
           }
       }
}
