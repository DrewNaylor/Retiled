// RetiledCompositor - Windows Phone 8.x-like compositor for the Retiled project.
//                     Some code was copied from
//                     the official qtwayland repo, which you can
//                     access a copy of here:
//                     https://github.com/DrewNaylor/qtwayland
//                     You can also use that link to access the code for qtwayland
//                     as required by the GPL.
// Copyright (C) 2022 Drew Naylor
// (Note that the copyright years include the years left out by the hyphen.)
// Windows Phone and all other related copyrights and trademarks are property
// of Microsoft Corporation. All rights reserved.
//
// This file is a part of the Retiled project.
// Neither Retiled nor Drew Naylor are associated with Microsoft
// and Microsoft does not endorse Retiled.
// Any other copyrights and trademarks belong to their
// respective people and companies/organizations.
//
//
//    RetiledCompositor is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License
//    version 3 as published by the Free Software Foundation.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//    Some of the code was taken and modified from Qt's qtwayland examples.
//    This code falls under the BSD License, three-clause I think. When this
//    code comes up, I'll state that it was sourced from their code and state the
//    copyright the original code fell under. I'll also provide a link, to show the
//    original. My modifications will fall under the GPLv3.
//    You can read a copy of the BSD License used by those files here:
//        BSD License Usage
//        Alternatively, you may use this file under the terms of the BSD license
//        as follows:
//
//        "Redistribution and use in source and binary forms, with or without
//        modification, are permitted provided that the following conditions are
//        met:
//          * Redistributions of source code must retain the above copyright
//            notice, this list of conditions and the following disclaimer.
//          * Redistributions in binary form must reproduce the above copyright
//            notice, this list of conditions and the following disclaimer in
//            the documentation and/or other materials provided with the
//            distribution.
//          * Neither the name of The Qt Company Ltd nor the names of its
//            contributors may be used to endorse or promote products derived
//            from this software without specific prior written permission.
//
//
//        THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//        "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//        LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
//        A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
//        OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//        SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
//        LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//        DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//        THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//        (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//        OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."



import QtQuick
// Copy the imports. I don't know if imports count as copyrightable, but just to be
// safe, some of these are from the overview compositor example's main.qml file:
// https://github.com/drewnaylor/qtwayland/blob/dev/examples/wayland/overview-compositor/main.qml
// That file is Copyright (C) 2018 The Qt Company Ltd. and is being used under the BSD License
// as described above.
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import QtQuick.Window
// End of the copied imports.
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Universal
import "../../RetiledStyles" as RetiledStyles


// Note: To run this compositor from a TTY, you have to pass "-platform eglfs" to it as specified here:
// https://stackoverflow.com/a/49079459
// Other apps would then be run from it by passing "-plaform wayland", though I think the default is what should be
// used instead, that being wayland-egl.


// Literally all this code is just copied from the example linked above in the "copy the imports"
// paragraph. It'll be modified to fit my use case, and as a result my changes will fall under the GPLv3.
// The original code is Copyright (C) 2018 The Qt Company Ltd. and is being used under the BSD License
// as described above.
WaylandCompositor {
    WaylandOutput {
        sizeFollowsWindow: true
        window: Window {
            id: win

            property int pixelWidth: width * screen.devicePixelRatio
            property int pixelHeight: height * screen.devicePixelRatio

            visible: true
			// Window size changed under GPLv3 and change Copyright (C) Drew Naylor.
            width: 720
            height: 1440
			
			// This shortcut copied from the pure QML example here:
			// https://github.com/DrewNaylor/qtwayland/blob/dev/examples/wayland/pure-qml/qml/CompositorScreen.qml
			// That file is Copyright (C) 2017 The Qt Company Ltd. and is being used under the BSD License as
			// described above.
			// Hopefully this'll make testing and using it easier.
			Shortcut {
				sequence: "Ctrl+Alt+Backspace"
				onActivated: Qt.quit()
			}

            Grid {
                id: grid

                property bool overview: true
                property int selected: 0
                property int selectedColumn: selected % columns
                property int selectedRow: selected / columns
				anchors.fill: parent
                columns: Math.ceil(Math.sqrt(toplevels.count))
                // ![zoom transform]
                transform: [
                    Scale {
                        xScale: grid.overview ? (1.0/grid.columns) : 1
                        yScale: grid.overview ? (1.0/grid.columns) : 1
                        Behavior on xScale { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
                        Behavior on yScale { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
                    },
                    Translate {
                        x: grid.overview ? 0 : win.width * -grid.selectedColumn
                        y: grid.overview ? 0 : win.height * -grid.selectedRow
                        Behavior on x { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
                        Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
                    }
                ]
                // ![zoom transform]

                // ![toplevels repeater]
                Repeater {
                    model: toplevels
                    Item {
                        width: win.width
                        height: win.height
                        ShellSurfaceItem {
                            anchors.fill: parent
                            shellSurface: xdgSurface
                            onSurfaceDestroyed: toplevels.remove(index)
                        }
                        MouseArea {
                            enabled: grid.overview
                            anchors.fill: parent
                            onClicked: {
                                grid.selected = index;
                                grid.overview = false;
                            }
                        }
                    }
                }
                // ![toplevels repeater]
            }

			// Rectangle added under GPLv3 and change Copyright (C) Drew Naylor.
			Rectangle {
				id: navBar
				color: "black"
				anchors.left: parent.left
				anchors.bottom: parent.bottom
				anchors.right: parent.right
				height: 50
            RetiledStyles.Button {
				// This button was moved to the left
				// and had its text changed to "Back". These changes are
				// under the GPLv3 and Copyright (C) Drew Naylor.
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                text: "Back";
                onClicked: grid.overview = !grid.overview
            }
			
			
			// These two buttons were copied and modified from the example buttons.
			// The changes to these buttons are under the GPLv3 and Copyright (C) Drew Naylor.
			RetiledStyles.Button {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: "Start";
                onClicked: runAppFromNavbarButton.runApp("retiledstart")
            }
			
			RetiledStyles.Button {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: "Search";
                onClicked:  runAppFromNavbarButton.runApp("retiledsearch")
            }
			// End copied and modified buttons.
			} // End of rectangle with buttons.
            
            // Drew Naylor changed the shortcut from "space" to "alt+tab" and commented the rest out. These changes are under GPLv3 and Copyright (C) Drew Naylor.
            Shortcut { sequence: "alt+tab"; onActivated: grid.overview = !grid.overview }
            //Shortcut { sequence: "right"; onActivated: grid.selected = Math.min(grid.selected+1, toplevels.count-1) }
            //Shortcut { sequence: "left"; onActivated: grid.selected = Math.max(grid.selected-1, 0) }
            //Shortcut { sequence: "up"; onActivated: grid.selected = Math.max(grid.selected-grid.columns, 0) }
            //Shortcut { sequence: "down"; onActivated: grid.selected = Math.min(grid.selected+grid.columns, toplevels.count-1) }
        }
    }

    ListModel { id: toplevels }

    // ![XdgShell]
    XdgShell {
        onToplevelCreated: {
            toplevels.append({xdgSurface});
            toplevel.sendFullscreen(Qt.size(win.pixelWidth, win.pixelHeight));
        }
    }
    // ![XdgShell]
}
