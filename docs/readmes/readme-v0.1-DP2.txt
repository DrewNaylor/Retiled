If you are reading this in Notepad or another text editor, it displays best in Word Wrap view. Click on Format>Word Wrap on the top bar if using Notepad on Windows. Notepad++ users will find it under View>Word Wrap. Word Wrap is automatically done if viewing on GitHub, and should already be used in VS Code (if not, use View>Word Wrap), Kate, and KWrite.


Retiled -- Version 0.1 Developer Preview 2 -- 5/20/2023 (MM/DD/YYYY).

If you have any trouble, you might be able to find an answer in the documentation. It's linked at the end of this readme file. If not, you can submit a bug report at the "Report a problem" link at the end of this readme file. Your report will be labeled by the developers accordingly in a reasonable amount of time.


You can use sha256sum to confirm the hash of the files by running
"find . -type f -exec sha256sum {} \;" in the folder you extracted the archive to and comparing the output to my sums listed below. Be sure that you don't copy the quotes. Hopefully this'll work on non-Bash systems, like postmarketOS. I got this command from this Ask Ubuntu answer: https://askubuntu.com/a/486094 . HowToGeek has a nice article on checksums and stuff:
https://www.howtogeek.com/67241/htg-explains-what-are-md5-sha-1-hashes-and-how-do-i-check-them/ .

There are a lot of them, so you'll find the relevant ones in "sums-v0.1-DP2.txt".

The checksum of that file is (need to do it yet)

You can run a check on individual files by running "sha256sum -b (insert filename here)".

----------------
GENERAL NOTES
~~~~~~~~~~~~~~~~

--> How to upgrade from a previous version: I recommend uninstalling Retiled by running "sh ./Scripts/uninstall-retiled.sh" after CD-ing into "./Scripts" before installing the new version via "sh ./install-retiled.sh". This will ensure nothing is left behind from the old version that may be broken, but please note that this will remove any customizations you've made to the files, as well as anything located in "/opt/Retiled". Your startlayout config file will be left in your home directory.
  - Eventually a better upgrade method will be available via your package manager, ideally.

--> If you know how to use Windows Phone's Start screen, you can pretty much use RetiledStart.

--> RetiledSearch is kinda like the Bing Search app on WP8.0/8.1 without Cortana, except it opens the search results in your browser and there's no image yet.

--> The default accent color is Cobalt (#0050ef) and the default theme is the dark theme. You can change the Accent color in the config file in `./RetiledSettings/configs/themes.config`, and it can be copied to `~/.config/Retiled/RetiledSettings/configs/themes.config` to make editing easier

--> Some documentation is available online as linked below. Please be aware that it might not be comprehensive.

--> There are brief instructions on how to use Retiled available in the "HOW TO USE" section below.

--> Make sure to read the changelog included in this archive. There may be some documentation in this file that's not actually in the /docs documentation since I have a hard time making good documentation unless I know exactly what to talk about. The changelog does have markdown so that it looks nice on GitHub, but it shouldn't be too intrusive.

--> Components and their licenses are listed at the bottom of this document.

--> The source code should be included in this archive in a Zip file called "source-code.zip". I'm just using Notepad++ for development, so the pyproject files haven't been changed for a long time.

--> If you find any bugs, please report them at the GitHub Issues page linked at the end of this document.

--> I am not responsible for any damage using my apps may cause.

----------------
KNOWN ISSUES
~~~~~~~~~~~~~~~~

- Scrolling the All Apps list can be slow/choppy on the PinePhone due to not caching the Icon key value from .desktop files (will be changed in v0.1-DP3). (issue #211 https://github.com/DrewNaylor/Retiled/issues/211)
- App icons aren't crispy like they're supposed to be at 200% scaling until they're reloaded, whether by scrolling the All Apps list far enough to reload them, or by resizing an affected tile. This might be Qt6.5-related because it wasn't an issue until I updated to it on my postmarketOS install, I'm not sure. (issue #210 https://github.com/DrewNaylor/Retiled/issues/210)
- The message that shows up if you have one or more tiles in the old format in the startlayout config file doesn't have animations when being shown or dismissed. (issue #220 https://github.com/DrewNaylor/Retiled/issues/220)
- The initial wallpaper implementation has some issues. (issue #194 https://github.com/DrewNaylor/Retiled/issues/194)
- Moving tiles around isn't possible yet, though it should be possible when TilesGrid is integrated into my code. Hopefully this can be done for v0.1-DP3.
- The scrollbar in the All Apps list is kinda shoved into the side and it looks bad, particularly with regards to the radius on the top and bottom. (issue #212 https://github.com/DrewNaylor/Retiled/issues/212)
- I still haven't figured out how to get the small tiles to go on both rows beside a medium tile. I have one idea involving the GridLayout/Grid/GridView and having tiles fill rectangles that are fixed sizes but have the tiles change their columnspan and rowspan when being resized or something, but it might not work, and I haven't found anything about masonry layouts in QML as far as I remember. Actually, this should be fine with TilesGrid.
- The "pin to start" button in RetiledStart and the "about" button in RetiledSearch's appbar drawer don't have proper spacing on the left. (I don't know if this is fixed or not yet, please let me know if it isn't.)
- In RetiledStart, the tiles list isn't correctly centered in the page. Tried to fix this, but nothing seemed to work. (worked on this a bit for DP2 and it looks fine on a PinePhone in portrait mode [as well as other devices with the same horizontal resolution probably], but it's a bit of a hack as I just increased the width of the empty item I'm using on the left as a spacer)
- The unpin icon is slightly too large (issue #76 https://github.com/DrewNaylor/Retiled/issues/76)
- Currently only .desktop files in "/usr/share/applications" are accessed.
- The search button in the top-left of the All Apps list is unimplemented, but I kept it there because it would probably look weird without it.
- Tiles aren't kept into two/three columns on rotating the phone.
- Nothing checks to ensure a tile isn't pinned before allowing the user to pin it, so you can pin multiple tiles from the same app in the All Apps list until that's fixed.
- Another issue is that pinned tiles get added to the left column, and this doesn't stop happening after pinning the second column by resizing any of the tiles like I thought. Not sure how to fix it. Maybe there's some way with the QML Grid/GridView/GridLayout, but I don't know. (I think this is fixed?)
- Tapping an app in the All Apps list then long-pressing it and leaving your finger on the screen when the app is open then closing the app and tapping "pin to start" won't take you back to the tiles list as it's supposed to. I don't know why this happens or how to fix it.
- Sometimes the tiles list doesn't scroll all the way to the bottom correctly.
- Some button icons, including the All Apps button icon, resize button icon, and the All Apps list search icon are slightly off-position.

Please note that these known issues may not be recorded in the issue tracker, so they won't show up at the link below.

See all known issues: https://github.com/DrewNaylor/Retiled/labels/known%20issue

--------------------
SYSTEM REQUIREMENTS
~~~~~~~~~~~~~~~~~~~~

To run Retiled, your device requires the following:

## Packages
- Python 3.11 or greater
  - Python is used to run most of Retiled.
  - Generally speaking, you should already have Python installed, but if you don't, install one of the following packages (depending on your distro/package manager) without quotes:
    - Manjaro ARM: "python"
    - Should be similar for other distros, or maybe "python3"; just search for it I guess
  - The version of Python I wrote here is just what my distro has as of writing this. I'll change it when future versions of Retiled are released.
  
- pyside6
  - Used for the UI of Python/QML-based components of Retiled.
  - You probably won't have this package already, so you can install one of the following packages (depending on your distro/package manager) without quotes:
    - Manjaro ARM: "pyside6"
    - just Python's pip, which may be necessary on a distro like Fedora: "PySide6"
    - postmarketOS: "py3-pyside6"
  
- qt6-declarative (or maybe it's "qt6-quickcontrols2" now; the package was renamed at some point on some distro)
  - Provides Qt6 QtQuick controls that are used in each component.
  - You probably won't have this package already, so you can install one of the following packages (depending on your distro/package manager) without quotes:
    - Manjaro ARM: "qt6-declarative" or "qt6-quickcontrols2"
    - Other distros should be similar, maybe?

- qt6-wayland
  - Allows Qt6 apps like the ones included in Retiled to run under Wayland.
  - You probably won't have this package already, so you can install one of the following packages (depending on your distro/package manager) without quotes:
    - Manjaro ARM: "sudo pacman -Syu qt6-wayland"

- pyyaml
  - Helps read yaml files, which are used for configuration.
  - I'm not distributing it with my package anymore, so you'll have to install it:
    - Manjaro ARM and probably Arch Linux ARM: "python-yaml"
    - pip: "PyYAML"
    - Alpine and maybe postmarketOS: "py3-yaml"
    - Fedora: "python3-pyyaml"

- libopengl0
  - Required if you want to run stuff on something like Linux Mint Cinnamon, but otherwise not required on Manjaro ARM with Plasma Mobile.
  - Not sure if this is installed by default on other distros, or if it's something that GTK ones lack.
  - Also not sure of the package name on non-Ubuntu distros.

## Architectures
- Tested on x86-64 (Intel/AMD 64-bit) and aarch64 (ARM 64-bit).

## Hardware requirements
- Tested on the 3 GB RAM/32 GB storage PinePhone; other Linux phones may also work if they support Manjaro ARM with Plasma Mobile.
- It is uncertain whether the 2 GB RAM/16 GB storage PinePhone will work, but it should. I bought the one with higher specs mainly for the dock.

## Operating systems
- Manjaro ARM with Plasma Mobile is officially supported and recommended due to Plasma being Qt-based.
- I'd like to also support postmarketOS, but it hasn't been tested there yet.
- DanctNIX's Arch Linux ARM should also work due to being semi-upstream from Manjaro ARM (I don't know whether Manjaro ARM uses the regular ALARM or the DanctNIX one), but I haven't tested the Plasma Mobile image with this yet.
- Windows support is limited to debugging and you'll have to manually change paths in the code for it to work in case you don't use the same paths I do. Perhaps I should add the sample .desktop files to the repo so things work.

## Disk space
- On Manjaro ARM with Plasma Mobile
  - Minimum: 250 MB
  - Recommended: 500 MB
  - To be safe, probably like 250 MB would be enough to give space at minimum, as PySide6 and qt6-declarative take up a decent amount of space. Calculating how much both of those packages take up shows they're roughly 192 MB, so I increased the number for comfort.
- Disk space is mostly based on the space that the libraries take up. Retiled itself is quite small, although some config files may take up more space.

------------
HOW TO USE
~~~~~~~~~~~~

1. Extract this archive to a folder. No package currently exists, though I'd like to make one.

2. Open a terminal in the root of the newly-extracted archive.

3. Run "sh ./Scripts/install-retiled.sh" to begin the installation process. You will be prompted for your password after Python pre-compiles the scripts for installation.

If you'd like to uninstall Retiled, you can run "sh Scripts/uninstall-retiled.sh" and it'll delete the installed files after asking for your password if it's been long enough. Please be aware that any user-made files in "/opt/Retiled" will be deleted, as that's how the uninstall process works right now. Config files in "~/.config/Retiled" will be kept.

4. Once you type in your password, the installer will create a directory in "/opt/Retiled", then it'll copy the main files there, the .desktop files to "/usr/share/applications", and scripts to run things to "/usr/bin". This may take a bit, though the pre-compilation may take longer.

5. Once you return to the prompt, Retiled should be installed, and you can launch RetiledStart and RetiledSearch from your mobile environment's apps list. Plasma Mobile might not properly reload and display the new files, so you may have to restart your phone. You can also run "retiledstart" and "retiledsearch" from the terminal, if you want. That's useful if you're having trouble running them, as any errors or packages that are missing should be displayed.

6. If running RetiledStart, you can pin apps from the All Apps list by long-pressing on the app's name and tapping "pin to start", resize tiles by long-pressing on a tile then tapping the resize button in the bottom-right corner until you're happy with the size (cycling through medium->small->wide->medium), and unpin tiles by long-pressing on a tile then tapping the unpin button in the top-right corner. Once you long-press a tile, you enter "global edit mode", which allows you to tap other tiles to move the edit buttons to that tile. Exiting global edit mode is done by tapping a tile with edit buttons on it (tiles with edit buttons on them are in "local edit mode"). Exiting global edit mode is required to save your layout changes.

7. Just to make sure no one misses it, you have to save your tile layout/size changes by exiting global edit mode, which is done by tapping a tile that has edit buttons on it. Pinning a tile automatically saves the tile to the config file.

8. With RetiledSearch, just tap the textbox and the touch keyboard should show up, allowing you to enter a search term. Pressing "Enter" or tapping "search" will open the Bing search results for the term you entered in your default browser.

Tip: Since moving tiles around isn't supported yet, you can manually change which app is assigned to any pinned tile by opening the config file ("~/.config/Retiled/RetiledStart/startlayout-modified.yaml") after doing anything that forces a save (entering global edit mode and resizing a tile from medium to medium won't cause the file to be saved, to reduce eMMC writes; this is also the reason why you have to exit global edit mode for changes to be saved). Once it's open in your text editor, change any of the .desktop filenames to the app you want that tile to be for. Please note that currently only .desktop files in "/usr/share/applications" are accessed. You'll have to restart RetiledStart for your changes to show up.


----------------------------------
CONTACT AND COPYRIGHT/LICENSING
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Drew's Main Website:      		https://drew-naylor.com/
Drew's GitHub profile:     		https://github.com/DrewNaylor
Retiled GitHub repository:		https://github.com/DrewNaylor/Retiled
Report a problem:	  			https://github.com/DrewNaylor/Retiled/issues/new
Check for updates:				https://github.com/DrewNaylor/Retiled/releases/latest
guinget documentation:			https://github.com/DrewNaylor/Retiled/docs
There isn't much in the documentation other than stuff that may be useful and the to-do list/Windows Phone behavior and appearance research.
As a result, the readme may be more useful. You can get to it from the repo link above.

Email:                    		drewnaylor_apps -AT- outlook.com




Retiled
Version 0.1 Developer Preview 1
Copyright (C) 2021 Drew Naylor. Licensed under the Apache License 2.0.
You can find a copy of this license in "LICENSE".

Begin boilerplate on the Apache License, Version 2.0:
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
End boilerplate on the Apache License, Version 2.0.


RetiledStart is a Windows Phone 8.x-like Start screen UI for the Retiled project.
RetiledSearch is a Windows Phone 8.0-like Search app for the Retiled project.

Windows Phone and all other related copyrights and trademarks are property of Microsoft Corporation. All rights reserved.
Retiled is not associated with Microsoft in any way, and Microsoft does not endorse Retiled.

Retiled uses the RetiledStyles project, which falls under the LGPLv3 for most files (some are modified versions of Qt's styles, so they can fall under the licenses those files fell under). See the files under `./RetiledStyles` to be certain of their licenses and copyrights. Qt's license requires me to host my own copy of the code, and you can find that here (I hope the qtdeclarative repo is enough, as that's where I assume PySide6 gets its styles from, and PySide6 doesn't actually include any of the styles in its repo): https://github.com/DrewNaylor/qtdeclarative

Qt (and I assume PySide6, since The Qt Company owns it) is Copyright (C) The Qt Company Ltd. and Qt6 and PySide6 are both being used under the LGPLv3. You can view a copy of the license here: https://www.gnu.org/licenses/lgpl-3.0.en.html And the regular GPL: https://www.gnu.org/licenses/gpl-3.0.html Copies of the LGPLv3 and GPLv3 are available in "LICENSE.LGPLv3" and "LICENSE.GPLv3", respectively.

Open Sans was designed by Steve Matteson and is used for most of the text in the UI, and is available under the Apache License, Version 2.0. A copy of this license is available in "./fonts/open_sans/LICENSE.txt"
Some glyphs are from the wp-metro font, which was made by AJ Troxell and is available under the SIL OFL 1.1:
http://scripts.sil.org/OFL. A copy of this license is available in "./fonts/wp-metro/OFL.txt", though this version is just the template version from the OFL website as there was no license file in the wp-metro repo (figured just adding the license would be fine, as the font's readme said it was under that license).

These fonts are linked at the end of the copyright list.

PyYAML is licensed under the MIT License. You can find a copy of its license under "./RetiledStart/RetiledStart/libs/pyyaml/PyYAML-6.0.dist-info/LICENSE", with its text copied below:
Copyright (c) 2017-2021 Ingy döt Net
Copyright (c) 2006-2016 Kirill Simonov

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
End PyYAML license.

Python 3.9 copyrights start:
Copyright (c) 2001-2021 Python Software Foundation.
All Rights Reserved.
Copyright (c) 2000 BeOpen.com.
All Rights Reserved.
Copyright (c) 1995-2001 Corporation for National Research Initiatives.
All Rights Reserved.
Copyright (c) 1991-1995 Stichting Mathematisch Centrum, Amsterdam.
All Rights Reserved.
Python 3.9 copyrights end.

Python is licensed under the PSF License Agreement, which you can find a copy of here:
https://docs.python.org/3.9/license.html#psf-license

Any other copyrights and trademarks belong to their respective people and companies/organizations.

Components of the Retiled project include Python, Qt, QML, PySide6, PyYAML, wp-metro (https://github.com/ajtroxell/wp-metro), Open Sans (https://fonts.google.com/specimen/Open+Sans). Anything else that's used in the future will be added to this list.