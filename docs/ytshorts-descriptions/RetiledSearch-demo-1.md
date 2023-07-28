Note: this is just the main part of the description of the video in the filename.

Until now, RetiledSearch couldn't be used properly when running under Plasma Mobile, but I recently started working on a rewrite for the whole project to mostly QML/Python due to Avalonia seemingly lacking support for touch-activated context flyouts. To make things easier, I began with RetiledSearch, as I did originally with the Avalonia version.

The main benefits of the rewrite (aside from being able to fully use the search app with touch) include much faster launch times, significantly reduced memory usage, and proper Wayland support so it doesn't look blurry.

Currently the button's animations aren't working, so I'll have to figure out how to port them from Qt5 to Qt6 (I did a lot of the main work using my fork of the Qml.Net sample app as a QML file loader, and that program uses Qt5). The other major issue that's up to me to solve (the weird thing with backspacing after pressing the spacebar might just be a thing with the keyboard, since it's fine with a physical keyboard under Windows) is having the search bar stretch to the edge of the display when rotated.

The Avalonia-based version will be archived once this one is good enough to replace it, as the code may be useful to some. If you'd like to run this program, there are some details at the bottom of this PR:
https://github.com/DrewNaylor/Retiled/pull/49

Retiled GitHub repo:
https://github.com/DrewNaylor/Retiled

Previous demo:
https://m.youtube.com/watch?v=FGZ3E5nqb0s&list=PLW6PgvLJvzAP2g_vueYX6xjhufjZyWj_4&index=4

Playlist:
https://www.youtube.com/watch?v=NpUnrb1wC_8&list=PLW6PgvLJvzAP2g_vueYX6xjhufjZyWj_4
