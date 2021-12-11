If you are reading this in Notepad or another text editor, it displays best in Word Wrap view. Click on Format>Word Wrap on the top bar. Notepad++ users will find it under View>Word wrap.


Retiled -- Version 0.1 Developer Preview 1 -- 12/12/2021 (MM/DD/YYYY).

If you have any trouble, you might be able to find an answer in the documentation. It's linked at the end of this readme file. If not, you can submit a bug report at the "Report a problem" link at the end of this readme file. Your report will be labeled by the developers accordingly in a reasonable amount of time.


You can use sha256sum to confirm the hash of the files by running
"find . -type f -exec sha256sum {} \;" in the folder you extracted the archive to and comparing the output to my sums listed below. Be sure that you don't copy the quotes. Hopefully this'll work on non-Bash systems, like postmarketOS. I got this command from this Ask Ubuntu answer: https://askubuntu.com/a/486094 . HowToGeek has a nice article on checksums and stuff:
https://www.howtogeek.com/67241/htg-explains-what-are-md5-sha-1-hashes-and-how-do-i-check-them/ .

SHA-256 sum for "guinget.exe" in the archive:
FB549A86AE201AB03FE78641FCF0DD469D8286C424BAC7F1B2D3B397F45BDB2E

SHA-256 sum for "lib\libguinget.dll" in the archive:
63C8959892E2A0EC4AD0E99D9EAF082DE8AE1886E28A83E638E43DCAE30EB860

SHA-256 sum for "lib\libscrollswitchtabs.dll" in the archive:
3F2741B885A3BDD03422E0346542BF4D13384A5287FD3BAF94D05C964ABECB92

SHA-256 sum for "lib\YamlDotNet.dll" in the archive:
A52924C5065FC796B0B6E16A1FE09B34A2AAF7BAB5308BE26EE6D27AE2B127E6


----------------
GENERAL NOTES
~~~~~~~~~~~~~~~~

--> Some packages like CrystalDiskMark and LibreOffice may require administrative permissions to install, so you'll have to check the "Elevate winget with UAC" checkbox in the "Apply changes" window's mini-form version of Options accessible from the "Options..." linklabel before confirming changes. Please don't run guinget itself as an administrator for versions 0.1.3 and above.

Sometimes you'll have to update winget's sources as well since winget doesn't like updating its sources while elevated from a non-administrator account, so you can use "Package list>Update winget sources", or run "winget source update".

Some installations of Windows 10 might have issues with elevating winget, so in that case you'll have to hope it automatically elevates package installers, but I've had a problem with that in the past, and I'm not entirely sure how to fix it without just making yourself an Administrator.

--> Before running guinget, please extract the entire archive to an easy-to-access location. It won't work correctly if it's temporarily extracted without its config file ("guinget.exe.config") and helper libraries (everything in the "lib" folder). You don't have to do this if you used the installer.

--> Some documentation is available in the "/docs" folder included in this archive, while all of it is available online as linked below. Please be aware that it might not be comprehensive.

--> There are brief instructions on how to use guinget available in the "HOW TO USE" section below, with more detailed ones available in the usage guide (https://drew-naylor.com/guinget/How-to-use), in "How to use guinget.html" located in the "/docs" folder, or linked from "Help>How to use guinget".

--> Make sure to read the changelog included in this archive. There may be some documentation in this file that's not actually in the /docs (and online) documentation since I have a hard time making good documentation unless I know exactly what to talk about. The changelog does have markdown so that it looks nice on GitHub, but it shouldn't be too intrusive.

--> Version 0.1.2 and newer uses .NET Framework 4.8, so you'll have to install that as described in the System Requirements section if it's not already installed on your system. Windows 10 versions 1903 and newer already have this version of the .NET Framework installed, so you don't need to do anything in that case.

--> guinget uses YamlDotNet to read package manifests, and its license is available in "LICENSE-YamlDotNet.txt"

--> Reading SQLite databases is done using Microsoft.Data.Sqlite, which falls under the Apache License 2.0.

--> Switching tab control tabs with the mouse scroll wheel is provided by libscrollswitchtabs.

--> The source code should be included in this archive in a Zip file called "source-code.zip". Visual Studio 2019 is required to open this project as it uses NuGet packages, and there were changes in the past where older Visual Studio versions can't use newer NuGet packages or something.

--> If you find any bugs, please report them at the GitHub Issues page linked at the end of this document.

--> I am not responsible for any damage using my app may cause.

----------------
KNOWN ISSUES
~~~~~~~~~~~~~~~~

- The only fancy animations that exist are the ones that happen when going to/from the All Apps list via the All Apps button or when unpinning all the tiles/when pinning a tile, respectively.
- Moving tiles around isn't possible yet, though it should be possible with some work, even though I haven't experimented with it yet.
- Icons are not yet supported, but I know how to make them work I think, so it shouldn't be too long for them.
- Changing accent colors and switching to the light theme requires directly modifying code, mostly QML.
- The All Apps list doesn't have a scrollbar yet. I was going to add that to this version, but couldn't find anything that work work immediately and I wanted to save it for later so this would be out sooner.
- I still haven't figured out how to get the small tiles to go on both rows beside a medium tile. I have one idea involving the GridLayout/Grid/GridView and having tiles fill rectangles that are fixed sizes but have the tiles change their columnspan and rowspan when being resized or something, but it might not work, and I haven't found anything about masonry layouts in QML as far as I remember.
- One major issue is that unpinning all the tiles then pinning some more will cause all of them to be underneath the first tile in a column, which may be caused by using a Column layout to hold the tiles and the All Apps button, along with various spacer items. Maybe a Grid layout would fix it, but I want to wait for now. A workaround is to long-press a tile to go into "global edit mode", resize any tile to wide then medium, and exit "global edit mode" (single-tap a tile that has editing buttons on it) so the layout fixes itself.
- The "pin to start" button in RetiledStart and the "about" button in RetiledSearch's appbar drawer don't have proper spacing on the left.
- In RetiledStart, the tiles list isn't correctly centered in the page. Tried to fix this, but nothing seemed to work.
- The unpin icon is slightly too large (issue #76 https://github.com/DrewNaylor/Retiled/issues/76)
- Currently only .desktop files in "/usr/share/applications" are accessed.

Please note that these known issues may not be recorded in the issue tracker, so they won't show up at the link below.

See all known issues: https://github.com/DrewNaylor/Retiled/labels/known%20issue

--------------------
SYSTEM REQUIREMENTS
~~~~~~~~~~~~~~~~~~~~

To run Retiled, your device requires the following:

- Python 3.9 or greater
  - Python is used to run most of Retiled.
  - Generally speaking, you should already have Python installed, but if you don't, use one of the following commands without quotes:
    - Manjaro ARM: "sudo pacman -Syu python"
  
- pyside6
  - Used for the UI of Python/QML-based components of Retiled.
  - You probably won't have this package already, so you can use one of the following commands to install it, just without the quotes:
    - Manjaro ARM: "sudo pacman -Syu pyside6"
  
- qt6-declarative
  - Provides Qt6 QtQuick controls that are used in each component.
  - You probably won't have this package already, so you can use one of the following commands to install it, just without the quotes:
    - Manjaro ARM: "sudo pacman -Syu qt6-declarative"

- qt6-wayland
  - Allows Qt6 apps like the ones included in Retiled to run under Wayland.
  - You probably won't have this package already, so you can use one of the following commands to install it, just without the quotes:
    - Manjaro ARM: "sudo pacman -Syu qt6-wayland"

- pyyaml
  - Helps read yaml files, which are used for configuration.
  - You probably won't have to install this yourself, as I just copied the library's files into my repo. The only case where you'll need to install it manually is if my repo doesn't have the proper compiled library for one of the files. In that case, please let me know. I don't feel comfortable just adding binaries from random people to my repo, so a way for me to acquire that binary will be necessary to specify.
  - If you do need pyyaml's compiled binary built for your specific device, you can install it via "pip":
    - "pip install pyyaml"
    - After installing, copy the file that starts with "_yaml" from the default location pip installs pyyaml to (usually "/usr/lib/python3.9/site-packages/yaml"), and either paste it in "/opt/Retiled/RetiledStart/RetiledStart/libs/pyyaml/yaml" if you can get root permissions easily, or paste it in "(the folder you downloaded Retiled to)/RetiledStart/RetiledStart/libs/pyyaml/yaml", then run "sh Scripts/install-retiled.sh" again so it can copy the new file you just pasted there. Please note: this manual library installation of running the install script again may not always work, so you may need to copy via the command line as root, though that should be easy.

- libopengl0
  - Required if you want to run stuff on something like Linux Mint Cinnamon, but otherwise not required on Manjaro ARM with Plasma Mobile.
  - Not sure if this is installed by default on other distros, or if it's something that GTK ones lack.
  - Also not sure of the package name on non-Ubuntu distros.

- Architectures: Tested on x86-64 (Intel/AMD 64-bit) and aarch64 (ARM 64-bit).

- Hardware requirements: 
  - Tested on the 3 GB RAM/32 GB storage PinePhone; other Linux phones may also work if they support Manjaro ARM with Plasma Mobile.
  - It is uncertain whether the 2 GB RAM/16 GB storage PinePhone will work, but it should. I bought the one with higher specs mainly for the dock.

- Operating systems:
  - Manjaro ARM with Plasma Mobile is officially supported and recommended due to Plasma being Qt-based.
  - I'd like to also support postmarketOS, but it hasn't been tested there yet.
  - DanctNIX's Arch Linux ARM should also work due to being semi-upstream from Manjaro ARM (I don't know whether Manjaro ARM uses the regular ALARM or the DanctNIX one), but I haven't tested the Plasma Mobile image with this yet.

- Disk space:
  - On Manjaro ARM with Plasma Mobile
    - Minimum: 250 MB
    - Recommended: 500 MB
    - To be safe, probably like 250 MB would be enough to give space at minimum, as PySide6 and qt6-declarative take up a decent amount of space. Calculating how much both of those packages take up shows they're roughly 192 MB, so I increased the number for comfort.

- Disk space is mostly based on the space that the libraries take up. Retiled itself is quite small, although some config files may take up more space.

------------
HOW TO USE
~~~~~~~~~~~~

1. Extract this archive to a folder. No package currently exists, though I'd like to make one.

2. Open a command shell.

3. Run "sh Scripts/install-retiled.sh" to begin the installation process. You will be prompted for your password after Python pre-compiles the scripts for installation.

4. Once you type in your password, the installer will create a directory in "/opt/Retiled", then it'll copy the files there and copy the .desktop files to the "/usr/share/applications". This may take a bit, though the pre-compilation may take longer.

5. Once you return to the prompt, Retiled should be installed, and you can launch Retiled Start and Retiled Search from your mobile environment's apps list. Plasma Mobile might not properly reload and display the new files, so you may have to restart your phone.

6. If running Retiled Start, you can pin apps from the All Apps list by long-pressing on the app's name and tapping "pin to start", resize tiles by long-pressing on a tile then tapping the resize button in the bottom-right corner until you're happy with the size (cycling through medium->small->wide->medium), and unpin tiles by long-pressing on a tile then tapping the unpin button in the top-right corner. Once you long-press a tile, you enter "global edit mode", which allows you to tap other tiles to move the edit buttons to that tile. Exiting global edit mode is done by tapping a tile with edit buttons on it (tiles with edit buttons on them are in "local edit mode"). Exiting global edit mode is required to save your layout changes.

7. Just to make sure no one misses it, you have to save your tile layout/size changes by exiting global edit mode, which is done by tapping a tile that has edit buttons on it. Pinning a tile automatically saves the tile to the config file.

8. With Retiled Search, just tap the textbox and the touch keyboard should show up, allowing you to enter a search term. Pressing "Enter" or tapping "search" will open the Bing search results for the term you entered in your default browser.

Tip: Since moving tiles around isn't supported yet, you can manually change which app is assigned to any pinned tile by opening the config file ("~/.config/Retiled/RetiledStart/startlayout-modified.yaml") after doing anything that forces a save (entering global edit mode and resizing a tile from medium to medium won't cause the file to be saved, to reduce eMMC writes; this is also the reason why you have to exit global edit mode for changes to be saved). Once it's open in your text editor, change any of the .desktop filenames to the app you want that tile to be for. Please note that currently only .desktop files in "/usr/share/applications" are accessed. You'll have to restart Retiled Start for your changes to show up.


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


Retiled Start is a Windows Phone 8.x-like Start screen UI for the Retiled project.
Retiled Search is a Windows Phone 8.0-like Search app for the Retiled project.

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