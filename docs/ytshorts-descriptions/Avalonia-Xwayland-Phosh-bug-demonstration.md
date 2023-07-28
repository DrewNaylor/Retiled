Note: this is just the main part of the description of the video in the filename and I abbreviated it so it may take longer to find.

While testing my Retiled project on the PinePhone, I discovered a bug on Phosh where only the most recently-opened app will be responsive. Once that app closes, the previous app is responsive again. This may be due to how Xwayland is implemented on Phosh, as Avalonia currently doesn't support Wayland, and this bug doesn't seem to affect Plasma Mobile. It's also possible that this is just how Phosh handles multiple copies of one process running at once, in this case dotnet, though I can't easily test this theory as dotnet doesn't run when renamed to, say, netdot. I'd report this issue, but I don't know which project to report it to.

I've described this issue on GitHub as well:
https://github.com/DrewNaylor/Retiled/issues/38
