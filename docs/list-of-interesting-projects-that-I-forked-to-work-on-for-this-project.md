1. [Abanu Desktop](https://github.com/DrewNaylor/abanu)
<br>This may be able to act as a starting point for figuring out how to make a desktop environment with .NET on Linux. Originally forked from [abanu-desktop/abanu](https://github.com/abanu-desktop/abanu).

2. [FancyStaggeredLayout.Avalonia](https://github.com/DrewNaylor/FancyStaggeredLayout.Avalonia)
<br>A StaggeredLayout control for WinUI that I'll have to port to Avalonia, though [most of the work may already be done](https://github.com/DrewNaylor/Avalonia/tree/feature/staggeredlayout). (I forked the Avalonia repo to ensure the branch that has the code I need is preserved, and I'll delete it when I'm done porting the fancy one to Avalonia and after archiving the code from that branch in the FancyStaggeredLayout repo.) Originally forked from [DL444/DL444.StaggeredLayout](https://github.com/DL444/DL444.StaggeredLayout).

3. [XWindowManager](https://github.com/DrewNaylor/XWindowManager)
<br>An X11/Xorg window manager written in C#. This could form the basis of the Retiled window manager under X11/Xorg, though I'll need another one for Wayland once Avalonia supports it. Originally forked from [flamencist/XWindowManager](https://github.com/flamencist/XWindowManager).

4. [compositor.net](https://github.com/DrewNaylor/compositor.net)
<br>As mentioned above, I'll need something for Retiled to use as a window manager/compositor under Wayland, so this project may help, though it might take some work to get it really usable as it mentions being a barely-function one. Originally forked from [malcolmstill/compositor.net](https://github.com/malcolmstill/compositor.net)

5. [Wayland.NET](https://github.com/DrewNaylor/Wayland.NET)
<br>Having libwayland bindings for .NET will be useful. Originally forked from [malcolmstill/Wayland.NET](https://github.com/malcolmstill/Wayland.NET)
