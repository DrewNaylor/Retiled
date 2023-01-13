> **Important:** this may not work in Fedora, at least Fedora 36 as it'll probably prevent input. More details in the long paragraph after the steps.

> **Update Jan. 12, 2023:** See the end of this page for updated commands to run this inside another compositor.

Running the custom compositor currently involves these commands:
1. Switch to a new TTY
2. Delete the Wayland lock file from `/run/user/1002/wayland-0.lock` (this path will vary depending on your installation) so Kwin doesn't interfere (if on Plasma Mobile)
3. CD into the folder with the compositor's files and run `python main.py -platform eglfs`

These are copied from my demo video on the compositor here:
https://youtube.com/shorts/jURqf86CS0I

The last command is very important, because using `QT_QPA_PLATFORM=eglfs` before the command makes things break.

Type `QT_SCALE_FACTOR=2` before the rest of the command to have everything at 200% scale, which is way easier to use.

> As of sometime before December 20, 2022, the touch points for the compositor are all in the wrong place as you go down and toward the right side of the display in portrait mode on the PinePhone, and scrolling makes it worse. I have no idea what's going on and can't find any reports about it on Bing, so if anyone who's reading this has any idea, please let me know. It's really annoying and just bad. I know this bug existed at least a month or two before, and I didn't think I did anything so it might be Qt or Manjaro-related. I don't know. Edit: This issue seems like the same problem, but I don't know if Manjaro is on Qt6.4 yet (turns out it's on Qt6.4.1) : https://bugreports.qt.io/browse/QTBUG-105869?jql=project%20%3D%20QTBUG%20AND%20component%20%3D%20%22QPA%3A%20Wayland%22

Please note that as of October 21, 2022, I'm not sure what's going on with the compositor on Fedora 36 KDE as in a TTY it will say it can't get devices and stops accepting input, at least under VMware Workstation. Maybe it would be fine on another desktop distro or under another hypervisor, like QEMU. Need to mainly test it under postmarketOS for now (**update Jan 11, 2023:** it doesn't work on postmarketOS edge right now, and it says something about the freedesktop runtime directory or something before briefly showing the navigation bar then having it disappear, which tells me it needs more investigation before it can run from a TTY by deleting `wayland-0.lock`), because it should be simplest to support that, then I can add support for other distros like Arch and Manjaro. Would be cool to also have Mobian and Fedora support, as well as every other distro intended for phones that's not too locked down from what I can tell like SailfishOS and UBports (nothing against them being locked down, just it could be difficult to change the UI). Eventually it could be used on desktops and laptops, but that's a ways off and would require a "desktop mode" that might be something between Windows 8.1 (maybe? maybe not, as the left-side switcher is more for tablets), Continuum, and full Windows 10. Would also have to add a way to switch between "phone mode", "tablet mode", "Continuum desktop mode", and "full desktop mode", and also have a setting that allows choosing between the "tablet" (because the external/secondary/tertiary/etc display could be a touchscreen and work better that way, or maybe the user prefers the tablet-first experience of Windows 8.x), "Continuum desktop" and "full desktop" modes when connecting a monitor, ideally storing configurations on a per-monitor basis so it's possible to have "phone mode" on the phone, "tablet mode" on an external touchscreen, and "Continuum desktop mode" on another screen. For obvious reasons, there should also be a setting to choose the default mode for the primary monitor when starting the device.

Alternatively, you can try to run these commands to have it run inside another compositor, like Plasma Mobile's Kwin:
1. `cd RetiledCompositor/RetiledCompositor`
2. `python main.py -platform wayland --wayland-socket-name 2 &`
3. `export WAYLAND_DISPLAY=2`
4. `export QT_SCALE_FACTOR=2`
5. `cd ../../RetiledStart/RetiledStart/`
6. `python main.py`

These worked once, but I don't know why they don't work when I try a second time. Also note that I figured that you can probably just use the Start button in the compositor once you set the `WAYLAND_DISPLAY` export.
