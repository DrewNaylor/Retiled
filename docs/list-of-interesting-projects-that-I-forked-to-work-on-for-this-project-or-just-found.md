1. [Abanu Desktop](https://github.com/DrewNaylor/abanu)
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
<br>I didn't fork this project and probably won't need to unless it doesn't work well enough for my needs, but this may be useful if .NET5/Standard doesn't support MEF plugins. Actually, MEF might exist in .NET 5 as System.Composition: https://weblogs.asp.net/ricardoperes/using-mef-in-net-core. Licensed under the MIT License.
