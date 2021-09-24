1. [WeastroShell](https://github.com/DrewNaylor/weastroshell)
<br>This may be able to act as a starting point for figuring out how to make a desktop environment with .NET on Linux. This is under the MIT License. Originally forked from [abanu-desktop/abanu](https://github.com/abanu-desktop/abanu).

2. [FancyStaggeredLayout.Avalonia](https://github.com/DrewNaylor/FancyStaggeredLayout.Avalonia)
<br>A StaggeredLayout control for WinUI that I'll have to port to Avalonia, though [most of the work may already be done](https://github.com/DrewNaylor/Avalonia/tree/feature/staggeredlayout). (I forked the Avalonia repo to ensure the branch that has the code I need is preserved, and I'll delete it when I'm done porting the fancy one to Avalonia and after archiving the code from that branch in the FancyStaggeredLayout repo.) This is under the MIT License. Originally forked from [DL444/DL444.StaggeredLayout](https://github.com/DL444/DL444.StaggeredLayout).

3. [XWindowManager](https://github.com/DrewNaylor/XWindowManager)
<br>An X11/Xorg window manager written in C#. This could form the basis of the Retiled window manager under X11/Xorg, though I'll need another one for Wayland once Avalonia supports it. This is under the MIT License. Originally forked from [flamencist/XWindowManager](https://github.com/flamencist/XWindowManager).

4. [compositor.net](https://github.com/DrewNaylor/compositor.net)
<br>As mentioned above, I'll need something for Retiled to use as a window manager/compositor under Wayland, so this project may help, though it might take some work to get it really usable as it mentions being a barely-functional one. It's licensed under the BSD 3-Clause License. I'll be sure to put the copyright as the original developer since copyright auto-applies in most places and there's a copyright notice in the license file itself, as well as myself for my changes. Hopefully I don't have to use it and can just write my own with the Wayland.NET bindings project to avoid license issues. Originally forked from [malcolmstill/compositor.net](https://github.com/malcolmstill/compositor.net)

5. [Wayland.NET](https://github.com/DrewNaylor/Wayland.NET)
<br>Having libwayland bindings for .NET will be useful. This one is under the BSD 3-Clause License, so I need to check for compatibility, but it should be fine with Apache License 2.0. Not sure about GPL, though. Originally forked from [malcolmstill/Wayland.NET](https://github.com/malcolmstill/Wayland.NET)

6. [X11.Net](https://github.com/DrewNaylor/X11.Net)
<br>It'll probably be really useful to be able to use X11 stuff from .NET, so I forked this one just in case this one has something I need. I think it's under the MIT License. Originally forked from [ajnewlands/X11.Net](https://github.com/ajnewlands/X11.Net).

7. [Cobble](https://github.com/Ceilidh-Team/Cobble)
<br>I didn't fork this project and probably won't need to unless it doesn't work well enough for my needs, but this may be useful if .NET5/Standard doesn't support MEF plugins. Actually, MEF might exist in .NET 5 as System.Composition: https://weblogs.asp.net/ricardoperes/using-mef-in-net-core. Here's the NuGet page: https://www.nuget.org/packages/System.Composition/. Licensed under the MIT License.

8. [XNB](https://github.com/DrewNaylor/XNB)
<br>Not sure if I'll fork this project as I don't know if I'll need it, but I think I will fork it anyway for safe keeping. It's an Xcb wrapper for .NET and is under the MIT License. I forked a fork, interestingly enough. Original project since I did fork it: https://github.com/julian-goldsmith/XNB

9. [HubTileX](https://github.com/DrewNaylor/HubTileX)
<br>While this project is for Silverlight, there may be some useful stuff here, such as XAML styles. This one's licensed under the MIT License. Originally forked from https://github.com/saurabhrajguru/HubTileX

10. [Avalonia.Extensions](https://github.com/DrewNaylor/Avalonia.Extensions)
<br>This project has a bunch of controls that may be useful, such as a GridView control. It's under the MIT license. Original source: https://github.com/DrewNaylor/Avalonia.Extensions

11. [WoWDatabaseEditor](https://github.com/DrewNaylor/WoWDatabaseEditor)
<br>What's interesting about this project is [it has an Avalonia GridView control](https://github.com/BAndysc/WoWDatabaseEditor/blob/master/AvaloniaStyles/Controls/GridView.cs) just like the previous project, except it doesn't seem like its main purpose is to be Avalonia-related. This one is licensed under the Unlicense. I decided to fork it to preserve the Avalonia controls just in case. Original source: https://github.com/BAndysc/WoWDatabaseEditor

12. [Avalonia.Flexbox](https://github.com/DrewNaylor/Avalonia.Flexbox)
<br>I'm trying to use this to get the tiles to display like they do on WP, but it doesn't seem to be working. Licensed under the MIT License. Original code, since I decided to fork it to keep it safe: https://github.com/jp2masa/Avalonia.Flexbox

13. [CompositionProToolkit](https://github.com/DrewNaylor/CompositionProToolkit)
<br>Okay, I'll be honest, these controls are awesome and I really hope they'll be easily ported to Avalonia because I really want to use them, mainly FluidWrapPanel (see the answers here: https://stackoverflow.com/questions/49244408/uwp-variablesizedwrapgrid-spacing-in-gridview-as-itempanel). Licensed under the MIT License and forked from https://github.com/ratishphilip/CompositionProToolkit

14. [DiligentWindows](https://github.com/DrewNaylor/DiligentWindows)
<br>This project is really cool too, and the controls should come in useful when working on the lock screen and action center. I really like the blurred look of the action center here, so I will probably add an option to allow people to blur their Action Center and show their wallpaper behind the blur. In true Windows Phone style, the blur will stay the same amount and more of the image will be shown as it's dragged down. Maybe it would be a good idea to just save a blurred copy of the Start screen wallpaper when the user checks the box to blur the background to save memory. Actually, maybe that would also be useful for the blurred Start screen image, too. Could also offer to have a different image for the Action Center too, if the user wants. Licensed under the MIT License and from here: https://github.com/ratishphilip/DiligentWindows

15. [FluentAvalonia](https://github.com/DrewNaylor/FluentAvalonia)
<br>Shouldn't need to use the fork, but I just did anyway for archival. This project has a bunch of controls and stuff ported to Avalonia that may be useful. Licensed under the MIT License and forked from here: https://github.com/amwx/FluentAvalonia
