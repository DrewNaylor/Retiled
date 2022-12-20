> **Important:** this may not work in Fedora, at least Fedora 36 as it'll probably prevent input. More details in the long paragraph after the steps.

Running the custom compositor currently involves these commands:
1. Switch to a new TTY
2. Delete the Wayland lock file from `/run/user/1002/wayland-0.lock` (this path will vary depending on your installation) so Kwin doesn't interfere (if on Plasma Mobile)
3. CD into the folder with the compositor's files and run `python main.py -platform eglfs`

These are copied from my demo video on the compositor here:
https://youtube.com/shorts/jURqf86CS0I

The last command is very important, because using `QT_QPA_PLATFORM=eglfs` before the command makes things break.

Type `QT_SCALE_FACTOR=2` before the rest of the command to have everything at 200% scale, which is way easier to use.

Please note that as of October 21, 2022, I'm not sure what's going on with the compositor on Fedora 36 KDE as in a TTY it will say it can't get devices and stops accepting input, at least under VMware Workstation. Maybe it would be fine on another desktop distro or under another hypervisor, like QEMU. Need to mainly test it under postmarketOS for now, because it should be simplest to support that, then I can add support for other distros like Arch and Manjaro. Would be cool to also have Mobian and Fedora support, as well as every other distro intended for phones that's not too locked down from what I can tell like SailfishOS and UBports (nothing against them being locked down, just it could be difficult to change the UI). Eventually it could be used on desktops and laptops, but that's a ways off and would require a "desktop mode" that might be something between Windows 8.1 (maybe? maybe not, as the left-side switcher is more for tablets), Continuum, and full Windows 10. Would also have to add a way to switch between "phone mode", "tablet mode", "Continuum desktop mode", and "full desktop mode", and also have a setting that allows choosing between the "tablet" (because the external/secondary/tertiary/etc display could be a touchscreen and work better that way, or maybe the user prefers the tablet-first experience of Windows 8.x), "Continuum desktop" and "full desktop" modes when connecting a monitor, ideally storing configurations on a per-monitor basis so it's possible to have "phone mode" on the phone, "tablet mode" on an external touchscreen, and "Continuum desktop mode" on another screen. For obvious reasons, there should also be a setting to choose the default mode for the primary monitor when starting the device.
