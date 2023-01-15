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

			// Is this correct to do for the pixel width and height?
			// Can't remember if this was just here or if I added it.
			// - Drew Naylor
            property int pixelWidth: width * screen.devicePixelRatio
            property int pixelHeight: height * screen.devicePixelRatio

            visible: true
			// Window size changed under GPLv3 and change Copyright (C) Drew Naylor.
			// Guess it should be the correct size for 2x scaling on the PinePhone.
            width: 360
            height: 720
            
			// accentColor property added for all the controls that use and need this property set.
			// This isn't really copyrightable I don't think, but it's under the GPLv3 and (C) Drew Naylor if necessary.
            property string accentColor: themeSettingsLoader.getThemeSettings()
			// Also set Universal.accent and color, the second one being where the background color used to be set.
			Universal.accent: accentColor
			// Background color changed to use whatever is set as accentColor by Drew Naylor. This change under GPLv3 and change Copyright (C) Drew Naylor.
			// Actually, now it changes to black (or whatever the theme's background color is) when not in multitasking mode so that when a new window is opened
			// from an app, there won't be a flash of the user's Accent color.
			// Please note that this isn't perfect at the moment, as the Accent color doesn't stay visible the entire time
			// we zoom back into an app. Tried to fix it by using the grid.xScale and grid.yScale properties here and checking
			// if they're less than 1.0, but it didn't work and would just display the theme background color instead.
			// TODO: add support for different background colors, like white when in the light theme.
			// That will be supported when the entire light theme is supported, for consistency.
			color:  grid.overview ? accentColor : "black"
			
			// This shortcut copied from the pure QML example here:
			// https://github.com/DrewNaylor/qtwayland/blob/dev/examples/wayland/pure-qml/qml/CompositorScreen.qml
			// That file is Copyright (C) 2017 The Qt Company Ltd. and is being used under the BSD License as
			// described above.
			// Hopefully this'll make testing and using it easier.
			Shortcut {
				sequence: "Ctrl+Alt+Backspace"
				onActivated: Qt.quit()
			}
			
			Shortcut {
				// Shortcut to leave multitasking added by Drew Naylor. Change (C) Drew Naylor 2022 under the GPLv3.
                id: leaveMultitaskingShortcut
                sequence: "esc"
				// We have to only have it active when in multitasking.
                // This also coincidentally allows popups to be closed with
                // the Escape key, similar to how Windows Phone did it
                // with the Back button.
				// The only problem is the Back button conflicts with closing popups when we're
				// in multitasking and exits multitasking with or without closing the popup.
				// LayerShell support may allow this to be fine, but I still need to figure
				// out how to have Qt send the "Escape" key to the compositor, but maybe it'll work?
				// I don't know, because when we're not in multitasking and we have
				// no windows open or we do and it's not correctly focused, Qt says it can't send the "Escape" key.
                enabled: grid.overview == true
                onActivated: {
					// Upon activating it, leave multitasking
                    // and make sure the shortcut is no longer active.
					// Actually we don't need to change "enabled" directly,
                    // because we're setting it to when the grid is in overview.
                    grid.overview = false;
                }
            }
			
			// Popup {
                // This is a test popup added under the GPLv3 and (C) Drew Naylor.
                // Trying to allow the Back button to be used to close message boxes
                // and stuff when in multitasking, but it doesn't quite work,
                // as detailed below in the part where we enter multitasking
                // and call "alertPopup.open();".
				// Here's the page for it in the docs I learned from:
				// https://doc.qt.io/qt-6/qml-qtquick-controls2-popup.html
				// In addition, MessageDialogs will close if they're clicked outside of,
				// even though that's apparently not supposed to happen from what I read
				// at least in the docs. Also having issues with Dialog{} items.
				// Maybe I'll have to temporarily prevent input to the grid/app switcher area where
				// apps are displayed in multitasking when a message is placed on the screen
				// by being displayed in the compositor until LayerShell is supported.
				// I'm also not sure how to send "Escape" when a MessageDialog/Dialog/Popup
				// is displayed while in multitasking, because the Back button currently doesn't
				// send "Escape" when in multitasking and instead leaves multitasking.
				// Wait, I just remembered that I thought of the idea to just keep track of
				// the number of open message boxes and stuff as well as a D-Bus
				// message that'll say to force-send "Escape" to know if we should send "Escape"
				// or not (see this issue comment: https://github.com/DrewNaylor/Retiled/issues/133#issuecomment-1289266037 )
                //     id: alertPopup
                //     contentItem: Text
                //     {
                //         text: "Test message."
                //     }
                //     modal: true
                //     focus: true
                //     closePolicy: Popup.CloseOnEscape
                // }

Flickable {
	// Allow the multitasking area to be scrolled up and down
	// with equal-sized window cards
	// until a proper left-right swipe is implemented.
	// Flickable added under GPLv3 and Copyright (C) Drew Naylor.
    id: multitaskingFlickable
    anchors.fill: parent
    interactive: grid.overview
	// We have to tell it how tall its contents are supposed to be or it'll bounce back up:
	// https://forum.qt.io/topic/38640/solved-scrollable-grid-in-qt/3
	// This 125 value is a bit too much, but at least it's more than necessary
	// rather than not enough.
	// TODO: Figure out how to only show exactly what is needed for the windows in multitasking.
	// We're multiplying by 250 now and adding the navbar's height to ensure everything can
	// at least be shown, now that the navbar has its own space (thankfully).
    contentHeight: (toplevels.count * 250) + navBar.height
    contentWidth: grid.width
    flickableDirection: Flickable.VerticalFlick
    // Temporary variable to hold contentY when going into multitasking
    // to ensure we can use the Back button to leave it and not
    // have issues.
    property int tempContentY

            Grid {
                id: grid

                property bool overview: false
                property int selected: 0
                property int selectedColumn: selected % columns
                property int selectedRow: selected / columns
				anchors.fill: parent
				// Enforce only two columns.
				// This prevents windows from getting lost in multitasking,
				// as it was previously calculating the number
				// of columns needed based on the amount of toplevels.
				// Change under the GPLv3 and Copyright (C) Drew Naylor.
                columns: 2
                // ![zoom transform]
                transform: [
                    Scale {
                        // xScale and yScale changed to be 0.5 when in multitasking under GPLv3 and Copyright (C) Drew Naylor.
                        xScale: grid.overview ? 0.5 : 1
                        yScale: grid.overview ? 0.5 : 1
                        Behavior on xScale { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
                        Behavior on yScale { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
                    },
                    Translate {
                        x: grid.overview ? 0 : win.width * -grid.selectedColumn
                        // The subtracting 55 multiplied by the selectedRow or 0 based on the selectedRow was added under the GPLv3 and Copyright (C) Drew Naylor.
                        // It's there to ensure the title text doesn't interfere with the window when
                        // bringing it back into focus so it's in the right spot.
						// Now we're also subtracting navBar.height multiplied by grid.selectedRow
						// to ensure that the navbar area is properly taken care of when exiting multitasking.
                        y: grid.overview ? 0 : win.height * -grid.selectedRow - (grid.selectedRow > 0 ? (55 * grid.selectedRow) - (navBar.height * grid.selectedRow) : 0)
                        Behavior on x { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
                        Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
                    }
                ]
                // ![zoom transform]

                // ![toplevels repeater]
                Repeater {
                    model: toplevels
					ColumnLayout {
                        // ColumnLayout added under GPLv3 and Copyright (C) Drew Naylor
                        // to allow the title text to be displayed for each preview,
                        // like on Windows Phone.
                    Item {
                        width: win.width
						// Subtract the height of the navbar from the height of the
						// item that holds each ShellSurfaceItem, so each window,
						// basically.
						// Change under the GPLv3 and Copyright (C) Drew Naylor.
						// TODO: Figure out why the Angelfish UI doesn't appear
						// (at least when running inside Plasma Mobile)
						// when other apps that use (I think) Kirigami do just fine, such as Index and Koko.
						// TODO 2: Fix GTK apps like Firefox displaying strangely (too tall for the multitasking area and the client-side decorations are all messed up), as well as message boxes being blurry and way too big, and Qt apps like the KDE Settings app being way too small (would lying that I'm KDE fix this, as I'm planning to do? Update: yes, it does fix the KDE Settings app, and it just looks like how it should in Plasma Mobile with a single list at a reasonable size; The full command I'm using is `export XDG_CURRENT_DESKTOP=KDE:X-Retiled`, and apparently KDE apps don't care that there's extra stuff in there, so it ends up being like what Windows Phone 8.1 Update 1 did for IE11 Mobile's user agent string to increase compatibility with websites that want browsers like Chrome, Safari, or Firefox).
                        height: win.height - navBar.height
                        ShellSurfaceItem {
                            anchors.fill: parent
                            shellSurface: xdgSurface
                            onSurfaceDestroyed: toplevels.remove(index)
							// Don't pass input events to clients when
                            // in multitasking. If we didn't do this,
                            // the "Escape" key would get passed
                            // down and register in the app, potentially
                            // causing it to navigate back (because we're using
                            // the "Escape" key as the Back button).
                            // inputEventsEnabled line added under GPLv3 and (C) Drew Naylor 2022.
                            // Learned about doing this from this video:
                            // https://www.youtube.com/watch?v=mIg1P3i2ZfI
							// Not entirely sure how this'll be handled with the volume and Action Center UIs,
							// as they are their own applications and they'll just appear on top once LayerShell
							// is supported.
							inputEventsEnabled: !grid.overview
                        }
						RetiledStyles.RoundButton {
							// Round close button added under GPLv3 and Copyright (C) Drew Naylor.
							anchors.right: parent.right
							anchors.top: parent.top
							text: "X"
							visible: grid.overview
							buttonHeight: 64
							buttonWidth: 64
							unpressedBackgroundColor: "black"
							// Ensure the close button is above the area that the user can click
							// to go back to a window so it's usable.
							z: 2
							// Using margins to make the close button not exactly in the corner:
							// https://asitdhal.medium.com/positioning-with-anchors-in-qml-936183d6c055
							// Using multiples of 6 for positioning like what's recommended for Windows Phone layouts.
							anchors.rightMargin: 12
							anchors.topMargin: 12
							fontSize: 32
							borderWidth: 4
							onClicked: {
								// When clicked, close the window.
								// Information from:
								// https://doc.qt.io/qt-6/qtwaylandcompositor-server-side-decoration-example.html
								// I guess that's the more-correct way to handle it.
								// This is the full file it's contained in:
								// https://code.qt.io/cgit/qt/qtwayland.git/tree/examples/wayland/server-side-decoration/main.qml?h=6.3
								// The file it originates from is Copyright (C) 2018 The Qt Company Ltd.
								// BSD License for this line, but modified slightly by Drew Naylor so it works for this:
								// "Redistribution and use in source and binary forms, with or without
								// modification, are permitted provided that the following conditions are
								// met:
								//   * Redistributions of source code must retain the above copyright
								//     notice, this list of conditions and the following disclaimer.
								//   * Redistributions in binary form must reproduce the above copyright
								//     notice, this list of conditions and the following disclaimer in
								//     the documentation and/or other materials provided with the
								//     distribution.
								//   * Neither the name of The Qt Company Ltd nor the names of its
								//     contributors may be used to endorse or promote products derived
								//     from this software without specific prior written permission.
								//
								//
								// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
								// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
								// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
								// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
								// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
								// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
								// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
								// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
								// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
								// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
								// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
								xdgSurface.toplevel.sendClose()
							}
						}
                        MouseArea {
                            enabled: grid.overview
                            anchors.fill: parent
                            onClicked: {
                                grid.selected = index;
								// Ensure the multitasking flickable has its contentY
                                // set to the y-value of the MouseArea.
                                // Doing the y-value thing under the GPLv3 and is Copyright (C) Drew Naylor.
                                multitaskingFlickable.contentY = parent.y;
                                multitaskingFlickable.tempContentY = parent.y;
                                grid.overview = false;
                            }
                        }
                    }
					Item {
                        height: 50
                        Label {
                            // Adding this label to display the current app under GPLv3 and Copyright (C) Drew Naylor.
							// The idea for this is from Windows Phone. I can't take credit for it.
                            visible: grid.overview
                            color: "white"
                            font.pixelSize: 40
                            // Had to look at this video at 18:57 to figure out how to get the title text,
                            // but even then it was different from the video and I just based it off the
                            // xdgSurface.toplevel.sendClose() call above, because I figured that would
                            // get what we needed:
                            // https://www.youtube.com/watch?v=mIg1P3i2ZfI
                            text: xdgSurface.toplevel.title
                        } // Close the label at the bottom.
                    } // Close the new item holder.
                    } // Close the new ColumnLayout.
                } // Close the repeater.
                // ![toplevels repeater]
                } // Close the grid.
} // Close the flickable.

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
				// Don't focus the Back button.
                focus: false
                // Switching to onPressAndHold for going into multitasking was done by Drew Naylor and falls under the GPLv3 and is Copyright (C) Drew Naylor.
                onPressAndHold:
                {
                    // Go into multitasking and allow the leaveMultitaskingShortcut to be used.
					// Actually, we don't have to directly enable the shortcut, because it's using
					// the grid.overview state.
                    // Set the flickable's tempContentY to the current one.
                    // TODO: Make sure this can update when adding or removing a window.
                    multitaskingFlickable.tempContentY = multitaskingFlickable.contentY;
                    grid.overview = true;
					// Trying to test having a popup open for a message box, but I can't
                    // get MessageDialogs or Dialogs to stay open when clicking outside them,
                    // and having a Popup as modal like here results in not being able
                    // to close it with the Back button (should be fine with LayerShell, though).
                    //alertPopup.open();
                }
                onClicked: {
                            // Had to figure out which seat was expected by Qt, because
                            // just typing "sendKeyEvent();" didn't work, and "seat.sendKeyEvent();"
                            // also didn't work. I guessed that the correct one for situations where
                            // there is no seat manually set up in the code has to be "defaultSeat.sendKeyEvent();",
                            // because the pure QML compositor example uses that for the cursor:
                            // https://github.com/DrewNaylor/qtwayland/blob/ea929b6fa5a90602e6f1fb597e3edfed9e6de3a7/examples/wayland/pure-qml/qml/CompositorScreen.qml#L121
                            // (linking to my own fork to ensure it stays available)
                            // Here's info on sendKeyEvent that helped me figure out where to start looking for QML usage (the full details aren't on the main docs page):
                            // https://github.com/drewnaylor/qtwayland/commit/bd5917025fe7491c9f24e99c20484c7ffce9f172
                            // (again using my fork)
                            // And finally, the docs page for WaylandSeat, which contains this function:
                            // https://doc.qt.io/qt-6.2/qml-qtwayland-compositor-waylandseat.html#sendKeyEvent-method
                            // Pro tip: the "int qKey" thing just means to use one of the key codes as recognized by Qt, such as "Qt.Key_Escape" or "Qt.Key_B". A full list is available here:
                            // https://doc.qt.io/qt-6/qt.html#Key-enum
                            // If there's no app in focus, then the terminal will have a complaint written to it:
                            // "Cannot send Wayland key event, no keyboard focus, fix the compositor"
                            // My only problem is that going back to the main page of Start doesn't work if you're doing it during the animation, but that's a problem with RetiledStart I think rather than this code.
                            // Feel free to use this comment block as documentation if you find it while searching, I'll extract it probably to a blog post or at least a Gist so it's for-sure safe to use without worrying about GPL code.
                            // The original onClicked event was modified by Drew Naylor to instead send the "Escape" key. This change is under the GPLv3 and is Copyright (C) Drew Naylor.
							// We have to only send "Escape" when we're not in multitasking, otherwise we leave multitasking.
                            if (!grid.overview) {
                                defaultSeat.sendKeyEvent(Qt.Key_Escape, true);
                                defaultSeat.sendKeyEvent(Qt.Key_Escape, false);
                            } else {
                                // Restore the flickable's contentY to the temporary one.
                                multitaskingFlickable.contentY = multitaskingFlickable.tempContentY;
                                grid.overview = !grid.overview;
                            }
                           }
            }
			
			
			// These two buttons were copied and modified from the example button to be moved to the correct places, use the RetiledStyles button style (will be navbar), and now launch their actions.
			// The changes to these buttons are under the GPLv3 and Copyright (C) Drew Naylor.
			RetiledStyles.Button {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: "Start";
                onClicked: runAppFromNavbarButton.runApp("retiledstart")
				// Don't focus the Start button.
				focus: false
            }
			
			RetiledStyles.Button {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: "Search";
                onClicked:  runAppFromNavbarButton.runApp("retiledsearch")
				// Don't focus the Search button.
				focus: false
            }
			// End copied and modified buttons.
			} // End of rectangle with buttons.
            
            // Drew Naylor changed the shortcut from "space" to "alt+tab" and commented the rest out. These changes are under GPLv3 and Copyright (C) Drew Naylor.
            Shortcut {
                sequence: "alt+tab"
                onActivated: {
                    // Do the flickable thing under GPLv3 and Copyright (C) Drew Naylor.
                    // Set the flickable's tempContentY to the current one.
                    // TODO: Make sure this can update when adding or removing a window.
                    if (grid.overview == true) {
                        // If we want to go into multitasking, set the tempContentY to the current value.
                        multitaskingFlickable.tempContentY = multitaskingFlickable.contentY;
                    } else {
                        // Otherwise, go back to the temporary one.
                        multitaskingFlickable.contentY = multitaskingFlickable.tempContentY;
                    }
                    grid.overview = !grid.overview }
            }
            //Shortcut { sequence: "right"; onActivated: grid.selected = Math.min(grid.selected+1, toplevels.count-1) }
            //Shortcut { sequence: "left"; onActivated: grid.selected = Math.max(grid.selected-1, 0) }
            //Shortcut { sequence: "up"; onActivated: grid.selected = Math.max(grid.selected-grid.columns, 0) }
            //Shortcut { sequence: "down"; onActivated: grid.selected = Math.min(grid.selected+grid.columns, toplevels.count-1) }
        }
    }

    ListModel { id: toplevels }

    // ![XdgShell]
    // TODO: Update this "onToplevelCreated" code for the "xdgSurface" parameter so we don't inject parameters into signal handlers, as doing so is deprecated.
    // We have to use JS functions instead.
    // Hopefully the example was updated with this change.
    // TODO block added by Drew Naylor. Change is under the GPLv3 and Copyright (C) Drew Naylor.
    XdgShell {
        onToplevelCreated: {
            toplevels.append({xdgSurface});
			// Subtract navBar.height so the pixels are the right shape as we're moving
			// stuff away from the navbar now.
			// Change under the GPLv3 and Copyright (C) Drew Naylor.
            toplevel.sendFullscreen(Qt.size(win.pixelWidth, win.pixelHeight - navBar.height));
        }
    }
    // ![XdgShell]
}
