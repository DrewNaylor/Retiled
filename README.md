# Retiled

An attempt at creating a "desktop" environment mainly for Linux phones and tablets that's similar in function to some parts of Microsoft's Windows Phone 8.x, primarily these features and behaviors:
- Start screen
- Search app
- Navigation bar
- Action Center
- Status bar
- [And more, with an entire list that was too long for the readme](/docs/eventual-feature-and-behavior-list.md)

Development is mainly being done using the PinePhone, so that'll be the main supported device. It's still in early development as I don't really know what I'm doing with Python (currently using 3.9.x) and Qt/QML/PySide6.

## Required extra packages

You may need to install packages through your distro's package manager, and those are as follows; their names may vary by distro, but most of these are what Arch Linux ARM (and Manjaro ARM, by extension I guess) use. The ones that say "via pip" are extra ones that developers will have to install if not on something like the PinePhone, otherwise the package name on the left side will have to be installed via the distro's package manager like `pacman`; the packages that aren't listed as being from pip aren't in pip.
- `python`: Used to run most of Retiled; should be Python 3 (using Python 3.9.x, specifically), but I can't remember if the package itself is `python3`, so I'll need to check
- `pyside6` (`PySide6` via pip): Used for the UI of Python/QML-based components of Retiled
- `qt6-quickcontrols2`: Provides Qt6 QtQuick controls that are used in each component
- `qt6-wayland`: Allows Qt6 apps like the ones included in Retiled to run under Wayland
- `pyyaml` (`PyYAML` via pip, which is where I got it from and it's just in the repo, so you shouldn't have to worry about it unless you don't have the compiled library for it; Arch Linux ARM wasn't the latest anyway last I checked, but maybe I can put the latest one in my own repo if that's easy enough): Helps read yaml files, which are used for configuration. You probably won't have to install this yourself, as I just copied the library's files into my repo. The only case where you'll need to install it manually is if my repo doesn't have the proper compiled library for one of the files. In that case, please let me know. I don't feel comfortable just adding binaries from random people to my repo, so a way for me to acquire that binary will be necessary to specify.
- `libopengl0`: Required if you want to run stuff on something like Linux Mint Cinnamon; not sure if this is installed by default on other distros, or if it's something that GTK ones lack; also not sure of the package name on non-Ubuntu distros

## License stuff

>This project (Retiled) is Copyright (C) 2021 Drew Naylor and is licensed under the Apache License 2.0.<br>
Retiled uses the RetiledStyles project, which falls under the LGPLv3 for most files (some are modified versions of Qt's styles, so they can fall under the licenses those files fell under). See the files under `./RetiledStyles` to be certain of their licenses and copyrights. Qt's license requires me to host my own copy of the code, and you can find that here (I hope the qtdeclarative repo is enough, as that's where I assume PySide6 gets its styles from, and PySide6 doesn't actually include any of the styles in its repo): https://github.com/DrewNaylor/qtdeclarative<br><br>
Windows Phone and all other related copyrights and trademarks are property of Microsoft Corporation. All rights reserved.<br>
Retiled is not associated with Microsoft in any way, and Microsoft does not endorse Retiled.<br>
Qt (and I assume PySide6, since The Qt Company owns it) is Copyright (C) The Qt Company Ltd.<br><br>
Open Sans is used for most of the text in the UI and is available under the Apache License, Version 2.0.<br>
Some glyphs are from the wp-metro font, which was made by AJ Troxell and is available under the SIL OFL 1.1:<br>
http://scripts.sil.org/OFL.<br>
You can find links to these fonts in the components list at the end of this "license stuff" block.<br>
PyYAML is licensed under the MIT License.<br><br>
Python 3.9 copyrights start:<br>
Copyright (c) 2001-2021 Python Software Foundation.<br>
All Rights Reserved.<br>
Copyright (c) 2000 BeOpen.com.<br>
All Rights Reserved.<br>
Copyright (c) 1995-2001 Corporation for National Research Initiatives.<br>
All Rights Reserved.<br>
Copyright (c) 1991-1995 Stichting Mathematisch Centrum, Amsterdam.<br>
All Rights Reserved.<br>
Python 3.9 copyrights end.<br><br>
Any other copyrights and trademarks belong to their respective people and companies/organizations.<br><br>
Components of the Retiled project include [AvaloniaUI](https://avaloniaui.net/), [.NET 5](https://docs.microsoft.com/en-us/dotnet/core/dotnet-five), Python, Qt, QML, PySide6, PyYAML, [wp-metro](https://github.com/ajtroxell/wp-metro), [Open Sans](https://fonts.google.com/specimen/Open+Sans). Anything else that's used in the future will be added to this list.

## Installation, Uninstallation, Building, and Running

> Please note: You'll have to install the dependencies manually, as they're not integrated into the script yet.

- Installation
  1. Install `pyside6`, `qt6-quickcontrols2` (may be the same thing as `qt6-declarative` now, so if the other name doesn't work, try this one), `qt6-wayland`. These packages are what they're named in Arch Linux ARM/Manjaro ARM. I'd like to add support for postmarketOS, but I haven't tested anything there yet. I assume that you'll already have Python 3 installed, but if not, you'll also have to install it.
  2. Clone the repo using `git clone https://github.com/drewnaylor/retiled`
  3. `cd` into `retiled/Scripts`
  4. Run `sh install-retiled.sh`. The Python scripts will be compiled, then you'll be prompted with `sudo` asking your password to install (if you haven't entered it recently).
  5. You should find the items for Retiled Start and Retiled Search in your app list. If not (can happen with Plasma Mobile, which is the UI that this is recommended to be run using due to also using Qt), you'll need to restart your phone.
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
    - To run RetiledSearch, ~~run `dotnet "RetiledSearch\RetiledSearch\bin\Debug\net5.0\RetiledSearch.dll"`~~ set up and activate your venv with Python 3.9 and the pip packages listed above, then refer to the line below regarding running Python/QML apps on Linux.
  - Linux
    - To run RetiledStart, please refer to the line below regarding running Python/QML-based apps.
    - To run RetiledSearch, please refer to the line below regarding running Python/QML-based apps.
    - You may need to specify where `dotnet` is located, in case it's somewhere like your home folder.
    - Running Python/QML-based apps requires installing the relevant packages as described in the `Building` section (desktop Linux can probably use the pip packages), then for 
	  - RetiledSearch:
        - `cd` into `RetiledSearch/RetiledSearch`
        - Run `python main.py`
	  - RetiledStart:
	    - `cd` into `RetiledStart/RetiledStart`
	    - Run `python main.py`
    - If you run the Python/QML-based apps on Phosh without first rebooting after installing the required extra packages, the keyboard may not display the letters properly, and instead show boxes. This doesn't seem to be permanent, as rebooting fixes the issue. **However**, running the Python/QML-based apps after a reboot may have Qt say that it's ignoring Wayland on Gnome, so it'll use Xwayland instead. You'll have to run `QT_QPA_PLATFORM=wayland python main.py` to make it use Wayland. This command will be integrated into a launcher script to make things easy. Additionally, there's a titlebar when running with Wayland under Phosh. I'd like to have it only appear when in docked mode, although some apps may be better to have no window borders in docked mode and instead appear next to the panel, like RetiledStart.

## Video demos

- [RetiledStart prototype running on the PinePhone (demo #1)](https://youtu.be/NpUnrb1wC_8)
- [RetiledStart demo #2: All Apps list prototype + improved tiles](https://youtu.be/GVt1WAN-w04)
- [RetiledStart demo #3: Launching Apps from the All Apps List in Portrait Mode](https://youtu.be/VHvdnHaz9G8)
- [RetiledStart demo #4: Landscape All Apps List](https://youtu.be/FGZ3E5nqb0s)
- [RetiledSearch demo #1: Doing a search on the PinePhone](https://youtu.be/SEua4VDVxM8)
- [RetiledStart demo #5: Pinning, Unpinning, and Resizing Tiles](https://youtu.be/lvbaCgOvsik)

## Screenshots
Below are some screenshots in case you want to see how things are going so far. Some may be updated separately from the rest so recent changes might not show up in every screenshot. I might not update the screenshots here very often either, so I'd recommend [following me on Twitter](https://twitter.com/DrewTNaylor) as I'll occasionally post screenshots for the feature I'm working on at the moment. It's not always Retiled screenshots, though.

A lot of these screenshots are currently pictures I took with my phone then scaled down, due to Plasma Mobile's screenshot program not working correctly right now.

RetiledStart running on the PinePhone:<br>
<img src="/docs/images/tiles.jpg" width="275"><br>
<br>
Tiles in edit mode:<br>
<img src="/docs/images/edit-mode.jpg" width="278"><br>
<br>
All Apps list:<br>
<img src="/docs/images/all-apps.jpg" width="370"><br>
<br>
All Apps list item context menu showing the "pin to start" button:<br>
<img src="/docs/images/pin-to-start-contextmenu.jpg" width="375"><br>
<br>
Early three-column view:<br>
<img src="/docs/images/retiledstart-tiles-that-look-like-wp.png" width="360"><br>
<br>
RetiledSearch running on the PinePhone:<br>
<img src="/docs/images/search-app.jpg" width="290"><br>
<br>
Appbar menu in the search app showing the "about" button:<br>
<img src="/docs/images/search-app-appbar.jpg" width="340"><br>
<br>
"about" page in the search app:<br>
<img src="/docs/images/search-app-about.jpg" width="303">