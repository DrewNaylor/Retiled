Note: this is just the main part of the description for the YouTube "Shorts" video in the filename.

Since the last video demo, I've had to move to QML as Avalonia didn't support opening context menus on touchscreens via long-press, at least in any way I could find. Aside from being a lot faster, using less memory, and working correctly under Wayland instead of using Xwayland, it's now possible to swipe anywhere on the tiles or All Apps list items, just by using QML's Flickable.

Other notable progress since last time includes:
- Properly sorting and displaying app names using the "Name" key in the .desktop files
- Loading the tiles list from a config file in the user's home folder at "~/.config/Retiled/RetiledStart/startlayout-modified.yaml" (or a built-in file if the modified one doesn't exist) when starting
- Saving tiles list changes in one of three ways: tapping a tile to exit "global edit mode" once you're done unpinning or resizing tiles (haven't figured out how to get it so you can tap anywhere outside the tiles to exit "global edit mode" yet), unpinning all the tiles so it goes to the All Apps list and keeps you there like Windows Phone, or pinning a tile (note that you have to exit "global edit mode" before you can go to the All Apps list)
- Custom colors for pinned tiles if you modify the start layout config file, though please note that unpinning a tile will lose your color changes
- Launching apps from their tiles
- Each app now has its "Exec" key in its .desktop file cleaned (stuff like "%u" is removed, for example), so you should be able to open any app that shows up in the All Apps list now, though some aren't meant to show up, and I did find a file in a Plasma Mobile repo that said which .desktop files shouldn't be shown; unfortunately, those .desktop files don't have "NoDisplay = true", so there's not really any good way for me to hide them as I'm not trying to make an environment that prefers to show or hide apps from any particular other environment
- Icons that are close enough to the original WP versions have been added for the All Apps button, Search button (not implemented yet, but it'd look weird without it there), resize button, and unpin button. The unpin button was modified from clipart on Open Clipart, and the rest were from the "wp-metro" icon font. Not exactly sure how to make the icon font's images be in the actual center of the buttons so they're not slightly off-center, but I tried.
- Text is now using Open Sans, with a slightly decreased space between the characters to sorta emulate Segoe WP/Segoe UI.
- Tiles have their text clipped off the end properly
- QML's SwipeView allows swiping between the tiles list and the All Apps list, as expected
- Entering "global edit mode" makes the tiles you didn't long-press on smaller and 50% opaque. Additionally, tapping another tile while in this state will give it edit buttons and hide the edit buttons on the tile that was previously being edited (in "local edit mode"), along with setting that last tile to be smaller and 50% opaque, while the new one is scaled to full-size and 100% opaque.

There are some major issues right now, particularly that long-pressing on a tile not in "local edit mode" while in "global edit mode" will cause multiple tiles to be in "local edit mode" with edit buttons at once. This is easy to fix, I just need to add more to the long-press code. I also need to add a scrollbar back to the All Apps list, but it might not look quite right in the first version since I want it to be out soon.

Please see my pinned comment for more information regarding issues and stuff I haven't figured out yet.

Retiled GitHub repo:
https://github.com/DrewNaylor/Retiled

Previous demo:
https://m.youtube.com/watch?v=FGZ3E5nqb0s&list=PLW6PgvLJvzAP2g_vueYX6xjhufjZyWj_4&index=4

Playlist:
https://www.youtube.com/watch?v=NpUnrb1wC_8&list=PLW6PgvLJvzAP2g_vueYX6xjhufjZyWj_4

---

Pinned comment:

More stuff from the description:
I still haven't figured out how to get the small tiles to go on both rows beside a medium tile. I have one idea, but it might not work, and I haven't found anything about masonry layouts in QML as far as I remember. Haven't experimented with moving tiles yet, but that should be doable with work. Icons aren't supported yet, either, but I kinda know how to do it, even though it won't be supported in v0.1-DP1.

One major issue is that unpinning all the tiles then pinning some more will cause all of them to be underneath the first tile in a column, which may be caused by using a Column layout to hold the tiles and the All Apps button, along with various spacer items. Maybe a Grid layout would fix it, but I want to wait for now. A workaround is to resize any tile to wide then medium and exit "global edit mode" so the layout fixes itself.

I also don't have any animations yet except for when going between the tiles and All Apps lists.

The "pin to start" button also doesn't have proper spacing on the left either, but I think I'll wait to add that since it's just one more thing, and I want this to be out soon as I said before.
