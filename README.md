# Retiled

An attempt at creating a "desktop" environment mainly for Linux phones and tablets that's similar in function to some parts of Microsoft's Windows Phone 8.x, primarily these features and behaviors:
- Start screen
- Search app
- Navigation bar
- Action Center
- Status bar
- [And more, with an entire list that was too long for the readme](/docs/eventual-feature-and-behavior-list.md)

Development is mainly being done using the PinePhone, so that'll be the main supported device. It's still in early development as I don't really know what I'm doing with C#, Avalonia, and .NET 5 on Linux, though I do know VB.NET, so that helps.

## Required extra packages

You may need to install packages through your distro's package manager, and those are as follows; their names may vary by distro, but most of these are what Arch Linux ARM use:
- Python/PySide6/QML-based components:
  - `python`: Used to glue the Python/QML-based components of Retiled to their .NET libraries; should be Python 3, but I can't remember if the package itself is `python3`, so I'll need to check
  - `pyside6`: Used for the UI of Python/QML-based components of Retiled
  - `qt6-quickcontrols2`: Provides Qt6 QtQuick controls that are used in each component
  - Python.NET: Allows using .NET libraries from .NET; unsure of the exact package name, or if it's in pacman
- Avalonia-based components:
  - `ttf-ms-fonts`: Used for the text in Avalonia-based components of Retiled
- Most components:
  - .NET 5: Most components use .NET 5 in some way, so that's also required; not sure what it's called in Arch Linux ARM

## License stuff

>This project (Retiled) is Copyright (C) 2021 Drew Naylor and is licensed under the Apache License 2.0.<br>
Windows Phone and all other related copyrights and trademarks are property of Microsoft Corporation. All rights reserved.<br>
Retiled is not associated with Microsoft in any way, and Microsoft does not endorse Retiled.<br>
Any other copyrights and trademarks belong to their respective people and companies/organizations.<br>
Components of the Retiled project include [AvaloniaUI](https://avaloniaui.net/), [.NET 5](https://docs.microsoft.com/en-us/dotnet/core/dotnet-five). Anything else that's used in the future will be added to this list.

## Building and running


- Building
  - To build, run `dotnet build Retiled.sln`
  - Please ensure the `dotnet-sdk` is installed first, or building won't work.
  - On Linux, you may need to specify where `dotnet` is located, in case it's somewhere like your home folder.
- Running
  - Windows
    - To run RetiledStart, run `dotnet "RetiledStart\RetiledStart\bin\Debug\net5.0\RetiledStart.dll"`
    - To run RetiledSearch, run `dotnet "RetiledSearch\RetiledSearch\bin\Debug\net5.0\RetiledSearch.dll"`
  - Linux
    - To run RetiledStart, run `dotnet "RetiledStart/RetiledStart/bin/Debug/net5.0/RetiledStart.dll"`
    - To run RetiledSearch, run `dotnet "RetiledSearch/RetiledSearch/bin/Debug/net5.0/RetiledSearch.dll"`
    - You may need to specify where `dotnet` is located, in case it's somewhere like your home folder.

## Video demos

- [RetiledStart prototype running on the PinePhone (demo #1)](https://youtu.be/NpUnrb1wC_8)
- [RetiledStart demo #2: All Apps list prototype + improved tiles](https://youtu.be/GVt1WAN-w04)
- [RetiledStart demo #3: Launching Apps from the All Apps List in Portrait Mode](https://youtu.be/VHvdnHaz9G8)
- [RetiledStart demo #4: Landscape All Apps List](https://youtu.be/FGZ3E5nqb0s)

## Screenshots
Below are some prototype screenshots in case you want to see how things are going so far. Some may be updated separately from the rest so recent changes might not show up in every screenshot. I might not update the screenshots here very often either, so I'd recommend [following me on Twitter](https://twitter.com/DrewTNaylor) as I'll occasionally post screenshots for the feature I'm working on at the moment. It's not always Retiled screenshots, though.

RetiledStart running on the PinePhone, less blurry than it is in person:<br>
<img src="/docs/images/retiledstart-running-on-pinephone.png" width="360"><br>
<br>
Early three-column view:<br>
<img src="/docs/images/retiledstart-tiles-that-look-like-wp.png" width="360"><br>
<br>
All Apps List displaying the names that are in each of the .desktop files while being properly sorted (sorry about the notification area showing up in the screenshot; the screenshot tool hasn't quite been working correctly lately):<br>
<img src="/docs/images/retiledstart-allappslist-with-names-and-sorted.png" width="360"><br>
<br>
Search app prototype:<br>
![](/docs/images/search-prototype.png?raw=true)<br>
