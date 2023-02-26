# Retiled

An attempt at creating a "desktop" environment mainly for Linux phones and tablets that's similar in function to some parts of Microsoft's Windows Phone 8.x, primarily these features and behaviors:
- Start screen
- Search app
- Navigation bar
- Action Center
- Status bar
- [And more, with an entire list that was too long for the readme](/docs/eventual-feature-and-behavior-list.md)

Development is mainly being done using the PinePhone, so that'll be the main supported device (with support for other devices planned, but not as the main focus because I want to ensure it runs reasonably well on the PinePhone, thereby ensuring it should run way better on devices with better specs; proper support for other devices like hardware stuff and notch support will be added, though). It's still in early development as I don't really know what I'm doing with Python and Qt/QML/PySide6.

Guess you could say it's "Something to fill the Live Tile-shaped hole in your heart", but it's not anywhere near ready yet.

> **Please note:** as of January 18, 2023, I would recommend installing from the `main` branch instead of downloading the v0.1-DP1 release package due to bugs that only appeared well after it was released that I think are a result of changes in Qt. The only drawback to this is that extra, unneeded files may be pulled in that would otherwise be taken care of in a proper release. There are instructions available below, but you'd use the same install script anyway so it's not too bad. Once v0.1 DP2 is released, this message will be removed.

So far, it's been tested on Manjaro Plasma Mobile and postmarketOS (with Plasma Mobile), but I also want to support more distros like NixOS (I like its philosophy), Mobian, and openSUSE, as a few examples (but not limited to these). I'd also like to support operating systems besides Linux such as FreeBSD if possible.

> Note: I'm thinking about just forking Plasma Mobile instead of writing my own compositor, so I will need to relicense the code under the Apache License, 2.0 (except libdotdesktop_py; that'll be MIT Licensed) that is Copyright (C) Drew Naylor, to be under the GPLv3+, or the most compatible license depending on the file. Below is a statement in detail:<br>
If I don't get around it, I, Drew Naylor, hereby declare as of February 26, 2023, that all Apache License, 2.0 files and modifications to files in this repo (except for libdotdesktop_py; that will be under the MIT License if possible; other libraries that are Copyright (C) Drew Naylor and used by the Qt version of Retiled but are not reliant on Qt directly will become under the MIT License and I will change that, but if I don't, I also give permission to change that) that are Copyright (C) Drew Naylor are now under the Gnu GPLv3+ and I give anyone who isn't me permission to change the license in the code to the GPLv3+. Hopefully this is a legal-enough statement. If this is not fully compatible with all of the main Plasma Mobile (and other related projects like Plasma Desktop and the Maliit keyboard and such) code, then I give permission to change to the most-compatible GPL or LGPL version, but this only applies to code Copyright (C) Drew Naylor. There may be instances where the code needs to conform to the license of specific files and programs if it's otherwise not compatible with the GPLv3+, so I also give permission to do that only for code that is Copyright (C) Drew Naylor.

## Required extra packages

You may need to install packages through your distro's package manager, and those are as follows; their names may vary by distro, but most of these are what Arch Linux ARM (and Manjaro ARM, by extension I guess) use. The ones that say "via pip" are extra ones that developers will have to install if not on something like the PinePhone, otherwise the package name on the left side will have to be installed via the distro's package manager like `pacman`; the packages that aren't listed as being from pip aren't in pip.
<br><br>**Note:** I'll have to probably update some items as they may be unclear.
- `python`: Used to run most of Retiled; should be Python 3 (using Python 3.9.x, specifically, **but my goal is to use the latest version of Python when possible, so it may not be 3.9.x by the time you read this**), but I can't remember if the package itself is `python3`, so I'll need to check
- `pyside6` (`PySide6` via pip, which may be necessary on Fedora; `py3-pyside6` on postmarketOS): Used for the UI of Python/QML-based components of Retiled
- `qt6-declarative` (previously `qt6-quickcontrols2`): Provides Qt6 QtQuick controls that are used in each component
- `qt6-wayland` (`qt6-qtwayland` on Fedora): Allows Qt6 apps like the ones included in Retiled to run under Wayland, and also allows RetiledCompositor to run
- `pyyaml` (`PyYAML` via pip, which is where I got it from and it's just in the repo, so you shouldn't have to worry about it unless you don't have the compiled library for it; Arch Linux ARM wasn't the latest anyway last I checked, but maybe I can put the latest one in my own repo if that's easy enough; I will soon stop providing pyyaml in my package directly (probably in DP2, so it'll break if you don't manually install pyyaml but that's ok early on), so it'll have to be installed manually, whether that be via `pip` [newest] or from your package manager [possibly outdated]): Helps read yaml files, which are used for configuration. You probably won't have to install this yourself, as I just copied the library's files into my repo. The only case where you'll need to install it manually is if my repo doesn't have the proper compiled library for one of the files. In that case, please let me know. I don't feel comfortable just adding binaries from random people to my repo, so a way for me to acquire that binary will be necessary to specify.
- `qt6-svg`: You'll need to install this if using Xfce or another non-Qt environment. Without it, SVG images won't show up anywhere.
- `libopengl0`: Required if you want to run stuff on something like Linux Mint Cinnamon; not sure if this is installed by default on other distros, or if it's something that GTK ones lack; also not sure of the package name on non-Ubuntu distros

## License stuff

>This project (Retiled) is Copyright (C) 2021-2023 Drew Naylor and is licensed under the Apache License 2.0.<br>
Retiled uses the RetiledStyles project, which falls under the LGPLv3 for most files (some are modified versions of Qt's styles, so they can fall under the licenses those files fell under). See the files under `./RetiledStyles` to be certain of their licenses and copyrights. Qt's license requires me to host my own copy of the code, and you can find that here (I hope the qtdeclarative repo is enough, as that's where I assume PySide6 gets its styles from, and PySide6 doesn't actually include any of the styles in its repo): https://github.com/DrewNaylor/qtdeclarative<br>
Code relating to qtwayland, which is the module used for the project in the RetiledCompositor folder, can be found here: https://github.com/DrewNaylor/qtwayland<br>
RetiledCompositor is the compositor used for Retiled for such things as the multitasking area and giving a place for the navigation bar, etc., and is sadly licensed under the Gnu GPLv3 due to qtwayland also being under the GPLv3 (I think it's GPLv3+ with the "+" being for any version that's ok'd by the KDE Free Qt Foundation, according to some source files in the repo) now. Any files that do not use GPL'd libraries directly will be licensed under one of these three licenses for as much flexibility as possible: the Apache License, Version 2.0; the BSD License according to what Qt uses in the QML files; or the LGPLv3, which is what the RetiledStyles project's files are under.<br><br>
Windows Phone and all other related copyrights and trademarks are property of Microsoft Corporation. All rights reserved.<br>
Retiled is not associated with Microsoft in any way, and Microsoft does not endorse Retiled.<br>
Qt (and I assume PySide6, since The Qt Company owns it) is Copyright (C) The Qt Company Ltd.<br><br>
Open Sans is used for most of the text in the UI and is available under the Apache License, Version 2.0.<br>
Some glyphs are from the wp-metro font, which was made by AJ Troxell and is available under the SIL OFL 1.1:<br>
http://scripts.sil.org/OFL.<br>
You can find links to these fonts in the components list at the end of this "license stuff" block.<br>
libdotdesktop_py is Copyright (C) Drew Naylor and is licensed under the Apache License, Version 2.0. This library is from the DotDesktop4Win project.<br>
PyYAML is licensed under the MIT License and is Copyright (c) 2017-2021 Ingy döt Net and Copyright (c) 2006-2016 Kirill Simonov.<br><br>
Python 3.9 copyrights start:<br>
Copyright (c) 2001-2021 Python Software Foundation.<br>
All Rights Reserved.<br>
Copyright (c) 2000 BeOpen.com.<br>
All Rights Reserved.<br>
Copyright (c) 1995-2001 Corporation for National Research Initiatives.<br>
All Rights Reserved.<br>
Copyright (c) 1991-1995 Stichting Mathematisch Centrum, Amsterdam.<br>
All Rights Reserved.<br>
Python 3.9 copyrights end.<br>
Python is licensed under the PSF License Agreement, which you can find a copy of here:<br>
https://docs.python.org/3.9/license.html#psf-license<br><br>
Any other copyrights and trademarks belong to their respective people and companies/organizations.<br><br>
Components of the Retiled project include [libdotdesktop_py from DotDesktop4Win](https://github.com/drewnaylor/dotdesktop4win), Python, Qt, QML, PySide6, PyYAML, [wp-metro](https://github.com/ajtroxell/wp-metro), [Open Sans](https://fonts.google.com/specimen/Open+Sans). Anything else that's used in the future will be added to this list.

## Installation, Uninstallation, Building, and Running

> Please note: You'll have to install the dependencies manually, as they're not integrated into the script yet.

> **These instructions aren't up to date with the zip file in the releases**, so I'd recommend [checking the "how to use" guide](https://github.com/DrewNaylor/Retiled/blob/main/docs/changelogs/v0.1-DP1.md#how-to-use) for installation instructions for released versions. One thing I do need to say to comply with the (L)GPL is that you can replace the files in the `RetiledStyles` directory if you want to use different files than what I provide, either by switching them out of the package then running the install script, or by replacing them as root when installed by changing the files in `/opt/Retiled/RetiledStyles`.

> **Actually, these instructions may be more up-to-date than what's in the v0.1 DP1's package (even though I don't recommend that version anymore as if I remember correctly, it has major bugs fixed, those being mainly in the All Apps list and they showed up well after it was released due to what I think is a change in Qt)**, so if you can't figure out what's going on with those files, check these instructions. The instructions will be unified for v0.1 DP2.

- Installation
  1. Install `pyside6` (`py3-pyside6` on postmarketOS), `qt6-quickcontrols2` (may be the same thing as `qt6-declarative` now, so if the other name doesn't work, try this one), `qt6-wayland`. These packages are what they're named in Arch Linux ARM/Manjaro ARM. I assume that you'll already have Python 3 installed, but if not, you'll also have to install it.
  2. Install `git` if you haven't, and clone the repo using `git clone https://github.com/DrewNaylor/Retiled`
  3. `cd` into `Retiled/Scripts`
  4. Run `sh install-retiled.sh`. The Python scripts will be compiled, then you'll be prompted with `sudo` asking your password to install (if you haven't entered it recently).
  5. You should find the items for RetiledStart and RetiledSearch in your app list. If not (can happen with Plasma Mobile, which is the UI that this is recommended to be run using until RetiledCompositor is ready for use due to also using Qt), you'll need to restart your phone.
- Uninstallation
  1. `cd` back into `retiled/Scripts` in the repo you cloned earlier, or clone it again if you deleted it.
  2. Run `sh uninstall-retiled.sh`. You'll be prompted for your password by `sudo` so that it can delete the files and folders used by Retiled, mainly `/opt/Retiled/*`, `/usr/share/applications/retiledstart.desktop`, and `/usr/share/applications/retiledsearch.desktop`.
- Building
  - You shouldn't have to build Python scripts, but if you want to, `cd` into `Scripts`, then run `sh build-retiledstart.sh` or `sh build-retiledsearch.sh`, depending on which you want to build.
  - Please ensure Python 3 is installed first, or building (and running) won't work.
  - Building is only intended for the step before installing on the destination device, which is typically expected to run Linux or another OS with `sh` scripting capability. As a result, there's no `.bat` script, nor is there support for building on Windows. This may change in the future if there's something that ends up using it on Windows or a Windows-compatible system.
- Running
  - Windows
    - To run RetiledStart, follow the instructions for running RetiledSearch, but use the `RetiledStart/RetiledStart` directory instead.
    - To run RetiledActionCenter, follow the instructions for running RetiledSearch, but use the `RetiledActionCenter` directory instead.
    - To run RetiledSearch, set up and activate your venv with Python 3.9 (or later, which is preferred if it doesn't break things) and the pip packages listed above, then refer to the line below regarding running Python/QML apps on Linux.
  - Linux
    - To run RetiledStart, RetiledSearch, or RetiledActionCenter, please refer to the line below regarding running Python/QML-based apps.
	- To run RetiledCompositor, please refer to the [instructions on running the compositor in /docs](/docs/running-the-compositor.md).
    - Running Python/QML-based apps requires installing the relevant packages as described in the `Building` section (desktop Linux can probably use the pip packages), then for 
	  - RetiledSearch:
        - `cd` into `RetiledSearch/RetiledSearch`
        - Run `python main.py`
	  - RetiledStart:
	    - `cd` into `RetiledStart/RetiledStart`
	    - Run `python main.py`
	  - RetiledActionCenter:
	    - `cd` into `RetiledActionCenter`
	    - Run `python main.py`
    - If you run the Python/QML-based apps on Phosh without first rebooting after installing the required extra packages, the keyboard may not display the letters properly, and instead show boxes. This doesn't seem to be permanent, as rebooting fixes the issue. **However**, running the Python/QML-based apps after a reboot may have Qt say that it's ignoring Wayland on Gnome, so it'll use Xwayland instead. You'll have to run `QT_QPA_PLATFORM=wayland python main.py` to make it use Wayland. This command will be integrated into a launcher script to make things easy (actually, not sure about that now, as that could make things more difficult and my goal is to focus on running the apps on Wayland even on Plasma Mobile...). Additionally, there's a titlebar when running with Wayland under Phosh. I'd like to have it only appear when in docked mode, although some apps may be better to have no window borders in docked mode and instead appear next to the panel, like RetiledStart.

## Video demos

- [RetiledStart prototype running on the PinePhone (demo #1)](https://youtu.be/NpUnrb1wC_8)
- [RetiledStart demo #2: All Apps list prototype + improved tiles](https://youtu.be/GVt1WAN-w04)
- [RetiledStart demo #3: Launching Apps from the All Apps List in Portrait Mode](https://youtu.be/VHvdnHaz9G8)
- [RetiledStart demo #4: Landscape All Apps List](https://youtu.be/FGZ3E5nqb0s)
- [RetiledSearch demo #1: Doing a search on the PinePhone](https://youtu.be/SEua4VDVxM8)
- [RetiledStart demo #5: Pinning, Unpinning, and Resizing Tiles](https://youtu.be/lvbaCgOvsik)
- [RetiledCompositor demo #1: Early Compositor Demo](https://www.youtube.com/watch?v=jURqf86CS0I)
- [RetiledActionCenter demo #1: Flashlight Toggle Showcase](https://m.youtube.com/watch?v=_xcpuhhv5TE)

## Screenshots
Below are some screenshots in case you want to see how things are going so far. Some may be updated separately from the rest so recent changes might not show up in every screenshot. I might not update the screenshots here very often either, so I'd recommend [following me on Mastodon](https://mastodon.online/@DrewNaylor) as I'll occasionally post screenshots for the feature I'm working on at the moment. It's not always Retiled screenshots, though.

RetiledStart showing a set of tiles of various sizes while running in Plasma Mobile on the PinePhone:<br>
<img src="/docs/images/tiles.png" width="360"><br>
<br>
Tiles in edit mode:<br>
<img src="/docs/images/edit-mode.png" width="360"><br>
<br>
All Apps list:<br>
<img src="/docs/images/all-apps.png" width="360"><br>
<br>
All Apps list item context menu showing the "pin to start" button:<br>
<img src="/docs/images/pin-to-start-contextmenu.png" width="360"><br>
<br>
RetiledSearch running on the PinePhone:<br>
<img src="/docs/images/search-app.png" width="360"><br>
<br>
Appbar menu in the search app showing the "about" button:<br>
<img src="/docs/images/search-app-appbar.png" width="360"><br>
<br>
"about" page in the search app:<br>
<img src="/docs/images/search-app-about.png" width="360"><br>
<br>
Three-column layout test:<br>
<img src="/docs/images/three-column-layout-test.png" width="360">
