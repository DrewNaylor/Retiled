Note: I only copied the main part of the description from the YouTube "Shorts" video in the filename.


Recently I decided to start working on the compositor, and I ended up using Qt's QtWayland library unless there's something better available. Unfortunately, that means this code is under the GPLv3 instead of something better, like the Apache License, Version 2.0.

Due to it being so early on in the development process of this component, I decided to just try to pretty much use the overview compositor example with a few modifications, mainly adding the Start and Search buttons, and moving the "Toggle overview" button to the bottom-left where the Back button goes. I also copied the Ctrl+Alt+Backspace shortcut from another example to make it easier to go back to the terminal.

While I probably should've shown running it from the terminal, the USB cable doesn't reach far enough for me to plug the dock in to use a keyboard, plus my keyboard is really big. The way I ran it was by first switching to an empty TTY and logging in, then I deleted the Wayland lock file from "/run/user/1002/wayland-0.lock" so Kwin didn't interfere. Then, I cd'd into the file with the Python script to run the compositor, and ran "python main.py -platform eglfs" so it would be a fullscreen root window for the rest of the windows.

There are some major bugs that I need to work out of the overview compositor example, mainly that interacting with a window causes it to be impossible to go back to that window after going into multitasking (what I'm calling "overview"). (If I can figure out how to fix that, I'll make sure to re-license the fix under the BSD License that Qt uses for that example file so it can be easily used by anyone who wants to use it/the Qt project if there's a way to submit the change to them properly.) The buttons at the bottom also aren't in their own area, so they end up overlapping the windows. Another issue is that the scaling appears to be 100% for everything instead of 200% like it's supposed to be.

(Update May 21, 2022: turns out that the issue where you can't return to a window after interacting with it was a Qt-related bug, as I did nothing but update my PinePhone and it works now. This is good because it means less for me to do.)

One nice thing I noticed is that it seems really fast, except for how long it takes to open apps. I'm sure things will slow down once other stuff like support for notifications and the Action Center are integrated.

If you'd like to check the code out for yourself, you can find it in this branch for now:
https://github.com/DrewNaylor/Retiled/tree/qml-based-compositor/RetiledCompositor/RetiledCompositor

Playlist:
https://www.youtube.com/watch?v=NpUnrb1wC_8&list=PLW6PgvLJvzAP2g_vueYX6xjhufjZyWj_4
