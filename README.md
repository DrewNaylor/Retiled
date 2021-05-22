# Retiled

An attempt at creating a "desktop" environment mainly for Linux phones and tablets that's similar in function to some parts of Microsoft's Windows Phone 8.x, primarily the Start screen (tiles minus the "live" part at the moment because that would be a little complicated, though maybe in the future some people or I could figure out a good way to integrate Python scripts to display "live" data; there's also the app list to the right of the tiles, and the search box there along with the letter categorization are both essential to Windows Phone and Windows Phone-like environments), Search app (meaning, not Cortana), navigation bar, notification center, and that bar at the top of the screen I can't remember the name of. For now it's in prototype stage as I don't really know what I'm doing with C#, Avalonia, and .NET 5 on Linux.

>This project (Retiled) is Copyright (C) 2021 Drew Naylor and is licensed under the Apache License 2.0.<br>
Windows Phone and all other related copyrights and trademarks are property of Microsoft Corporation. All rights reserved.<br>
Retiled is not associated with Microsoft in any way, and Microsoft does not endorse Retiled.<br>
Any other copyrights and trademarks belong to their respective people and companies/organizations.<br>
Components of the Retiled project include [AvaloniaUI](https://avaloniaui.net/), [.NET 5](https://docs.microsoft.com/en-us/dotnet/core/dotnet-five). Anything else that's used in the future will be added to this list.

**NB:** You may need to install the `ttf-ms-fonts` package (name may vary by distro) so that the proper fonts are available to Avalonia, otherwise it'll crash.

## Screenshots
Below are some prototype screenshots in case you want to see how things are going so far.

Screenshot of RetiledStart running on the PinePhone:<br>
<img src="/docs/images/retiledstart-running-on-pinephone.png" width="360"><br>
<br>
Screenshot of the search app prototype in Linux Mint:<br>
![](/docs/images/search-prototype.png?raw=true)<br>
<br>
Screenshot of the search app but without the border:<br>
![](/docs/images/search-prototype-no-border.png?raw=true)
