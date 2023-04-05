# System Requirements

To run Retiled, your device requires the following:

(Please refer to [the readme](../README.md#required-extra-packages) for up-to-date package requirments; they may change over time and this document may become out of date.)

## Packages
- Python 3.9 or greater
  - Python is used to run most of Retiled.
  - postmarketOS might use `python3` instead of `python` sometimes, but I've noticed just `python` is fine now.
  - Generally speaking, you should already have Python installed, but if you don't, use one of the following commands without quotes:
    - Manjaro ARM: "sudo pacman -Syu python"
  
- pyside6
  - Used for the UI of Python/QML-based components of Retiled.
  - You probably won't have this package already, so you can use one of the following commands to install it, just without the quotes:
    - Manjaro ARM: "sudo pacman -Syu pyside6"
    - postmarketOS: "sudo apk add py3-pyside6"
  
- qt6-declarative
  - Provides Qt6 QtQuick controls that are used in each component.
  - You probably won't have this package already, so you can use one of the following commands to install it, just without the quotes:
    - Manjaro ARM: "sudo pacman -Syu qt6-declarative"
    - postmarketOS: "sudo apk add qt6-qtdeclarative"
    - Please note: I may have forgotten to write this one down for postmarketOS before, and I need to ensure this is the right package.
- qt6-wayland
  - Allows Qt6 apps like the ones included in Retiled to run under Wayland.
  - You probably won't have this package already, so you can use one of the following commands to install it, just without the quotes:
    - Manjaro ARM: "sudo pacman -Syu qt6-wayland"
    - postmarketOS: "sudo apk add qt6-qtwayland"
- pyyaml
  - Helps read yaml files, which are used for configuration.
  - You probably won't have to install this yourself, as I just copied the library's files into my repo. The only case where you'll need to install it manually is if my repo doesn't have the proper compiled library for one of the files. In that case, please let me know. I don't feel comfortable just adding binaries from random people to my repo, so a way for me to acquire that binary will be necessary to specify.
  - If you do need pyyaml's compiled binary built for your specific device, you can install it via "pip":
    - "pip install pyyaml"
    - After installing, copy the file that starts with "_yaml" from the default location pip installs pyyaml to (usually "/usr/lib/python3.9/site-packages/yaml"), and either paste it in "/opt/Retiled/RetiledStart/RetiledStart/libs/pyyaml/yaml" if you can get root permissions easily, or paste it in "(the folder you downloaded Retiled to)/RetiledStart/RetiledStart/libs/pyyaml/yaml", then run "sh Scripts/install-retiled.sh" again so it can copy the new file you just pasted there. Please note: this manual library installation of running the install script again may not always work, so you may need to copy via the command line as root, though that should be easy.
- qt6-svg
  - Allows SVG images to be displayed in Qt6 apps.
  - Should be already installed unless you're running a non-Qt environment, such as Xfce.
  - You can install it using one of these commands:
    - Manjaro: `sudo pacman -Syu qt6-svg`
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
  - Update Dec 15, 2021: I tested this under postmarketOS Plasma Mobile, and things aren't perfect, with the biggest issue being that trying to do a search in the search app gives the error of "Unknown error code 100 Could not find the program 'webbrowser-app' Please send a full bug report at https://bugs.kde.org."
    - Update Apr 5, 2023: RetiledSearch does work in pmOS now as of probably a while ago, but it opens Firefox, which doesn't currently work correctly in my experience. If it were changed to Angelfish, it'd probably be fine.
  - ~~The scripts need to be altered for postmarketOS due to it using "python3" instead of just "python". Hopefully it would work on Manjaro ARM, too.~~ I tried this, but it doesn't need to be done.
- DanctNIX's Arch Linux ARM should also work due to being semi-upstream from Manjaro ARM (I don't know whether Manjaro ARM uses the regular ALARM or the DanctNIX one), but I haven't tested the Plasma Mobile image with this yet.
- Windows support is limited to some debugging and you'll have to manually change paths in the code for it to work in case you don't use the same paths I do. Perhaps I should add the sample .desktop files to the repo so things work.

## Disk space
- On Manjaro ARM with Plasma Mobile
  - Minimum: 250 MB
  - Recommended: 500 MB
  - To be safe, probably like 250 MB would be enough to give space at minimum, as PySide6 and qt6-declarative take up a decent amount of space. Calculating how much both of those packages take up shows they're roughly 192 MB, so I increased the number for comfort.
- Disk space is mostly based on the space that the libraries take up. Retiled itself is quite small, although some config files may take up more space.
