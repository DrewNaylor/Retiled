# Retiled

An attempt at creating a "desktop" environment mainly for Linux phones and tablets that's similar in function to some parts of Microsoft's Windows Phone 8.x, primarily these features and behaviors:
- Start screen
  - This is just tiles minus the "live" part at the moment because that would be a little complicated, though maybe in the future some people or I could figure out a good way to integrate Python scripts to display "live" data
  - There's also the app list to the right of the tiles, and the search box there along with the letter categorization are both essential to Windows Phone and Windows Phone-like environments
  - Tiles by default will use the user's Accent Color, but there needs to be options to either use a custom color for a tile, or get the color from the icon. The custom color is a thing in case people don't like the auto-color feature or they're using monochrome icons.
  - Medium tiles look good at 150x150 and wide tiles look good at 310x150, but small tiles at 70x70 don't properly fill the wide tile's empty space if there are four of them that should go in a box together. This doesn't even include the fact that small tiles need to have their labels hidden, as that's what WP did. Forcing four small tiles onto the same row looks good, though. Three-column view would probably use 35x35 for small tiles, but that's really small unless it gets better with Avalonia under Wayland.
  - 8.1 added a three-column view. Experimentation with changing tile sizes shows that 100x100 medium tiles and 210x100 wide tiles looks almost perfect. There would have to be a way to ensure tiles stay where the user originally put them when going into three-tile mode. Additionally, tile fonts and icon sizes need to be adjusted to look right when they're smaller.
  - Start screen wallpapers will be handled like WP8.1, where the tiles were fully transparent and the wallpaper was visible behind them. Scrolling would have a parallax effect, so that's required to be added, but there should be a way to turn it off so the image doesn't move as you scroll. Maybe some people would want blurred or not-fully-transparent tiles, so that would be something to look into allowing at a much later date. Blurred tiles wouldn't be the default, and the blur intensity would be configurable like KDE. Any other blurring would be handled by third-party themes as I personally don't like blurring, but it might look cool on tiles.
  - Some Live Tiles should have a way to say they work when the tile is small, like the calendar to show the day. This would be a variable in the file that stores tile location, size, color, etc.
  - As one of the few planned features that originated in Windows 10 (I really hope desktop 8.x had this as it'll make me feel better about adding a 10 feature), Live Tiles should have a way to turn them off in case they update too much or the user doesn't like them and prefers to have a static icon.
- Search app
  - Something like the old Bing search app from WP8.0 rather than Cortana
    - Would be cool if someone built something similar to Cortana that used an open-source backend, though
    - Almond has stuff like Cortana where you can ask it the weather and stuff, and would probably work well for this: https://flathub.org/apps/details/edu.stanford.Almond
    - Those that prefer Google Now's assistant could use the unofficial desktop client: https://github.com/Melvin-Abraham/Google-Assistant-Unofficial-Desktop-Client
    - There needs to be a setting for people to choose the default app that runs when you hit the Search button. At the moment, the options would be:
      - RetiledSearch
      - Almond
      - Google Assistant Unofficial Desktop Client
      - Custom command (textbox where the user can type a command to run when pressing Search; it'll be run with the standard Freedesktop program running thing)
  - Currently this is just a textbox and a button that opens Bing with the search term in the default browser
    - Eventually it'll support choosing the default search engine
  - What would be really neat is if it had support for daily images if the user wants to show them, including but not limited to the Bing Image of the Day
    - This would just be the US at the beginning because that's what's easiest for me to test, but eventually it would have the option to use any region that has Bing Image of the Day stuff
    - Not sure if Microsoft would be ok with someone's project having built-in displaying of their images. Probably should have something that either goes to the Bing homepage (or the page of the daily wallpaper source that has image copyright info) or get the image's copyright info from Bing to display it in a popup that shows up when you press the `i` button in the Command Bar. Probably should just have an `i` button that goes to the page with image copyright info.
- Navigation bar
  - Navigation bar always stays on the physical bottom of the phone, unlike what Android does with its software buttons.
  - Software WP navigation bars rotate the icons to the left or the right when the screen is rotated, but some people might not like that so there needs to be a way to lock them in the vertical rotation.
- Action Center
  - Long-pressing the quick action buttons at the top will open the relevant page in Settings, which is something I forgot 8.x lacked. (Thanks to TheMobilizer for the suggestion!)
  - The quick action button panel will be able to scroll horizontally to hold more buttons. [(issue #10)](https://github.com/DrewNaylor/Retiled/issues/10)
  - Dismissing notifications
    - Dismissing a single notification from an app when that app has multiple notifications should only dismiss that one notification. (Again thanks to TheMobilizer for suggesting this!)
    - When an app only has one notification, the line for the app's name and icon gets dragged slightly behind the notification. This will allow the 8.1-style notification dismissal effect to partially continue to exist unless the app has multiple notifications.
    - Dragging an app's notifications with two fingers will dismiss all notifications from that app with the same effect as WP8.1 where the two notifications around the first-selected notification take a bit to slide, then the next two, and so on. Pretty sure that gesture dismissed all of them at once in 10, but not having an easy way to dismiss only one app's notifications without sliding over the name and icon row was painful.
    - Dragging with three fingers will dismiss all notifications, since it could be useful.
  - See `Status bar` for how the Action Center opens in landscape mode.
- Status bar
  - Status bar always stays on the physical top of the phone, unlike iOS. This means the Action Center is opened horizontally when the phone is in landscape mode.
  - Stuff in the status bar rotates according to the phone's rotation and takes up more horizontal space when it's on the side.
- Settings that are relevant to a Windows Phone-style UI. Probably will do a Settings app that looks at settings-related .desktop files and add a few of my own menus.
- WP8.1-style animations (8.1's animations were the best in any version I've used; 8.0's animations made me sick to my stomach after not using it for a long time)
- A window manager may need to be built to hold the navigation bar and status bar and to display the multitasking menu. Hopefully it won't be needed and just a session file and a pre-existing window manager that opens stuff fullscreen will work, but I doubt it because the status bar and navigation bar need to be in a specific place. Not sure exactly where the "Loading..." and "Resuming..." messages would go, but they should be in this project somewhere if it makes sense.
- The screen never goes upside down, unlike Android. A way for the user to allow it may be useful if they like that feature.

There are also some "wishlist" features that I really want but might be too complicated to do.
- Tile folders
  - Not exactly sure how they'd be implemented, but they're useful
  - They kinda flow out of the small preview grid into their area
  - Folder labels can be changed.
- Lock screen
  - Tapping it made the entire thing go up and bounce a few times before landing. If you had a PIN code active, it showed the unlock area, otherwise it just showed what's active.
  - You didn't have to press a button after typing in your pin, as it just automatically unlocked if the combination was correct (will be more difficult than the bounce animation, and not even sure if it'll work or be secure and fast)
  - Wallpapers get darkened slightly on WP, so there should be a way to turn that off if people don't like it.
  - Not exactly sure how this would work in a way that's like the other mobile Linux lockscreens like the one in Plasma Mobile. That's the main thing preventing it from existing besides the fact that .NET/Avalonia apps take a while to start on the PinePhone, so that'll be not fun. Hopefully it'll run stuff faster soon.
  - Probably should allow people to blur the background behind the lock screen text in case they want consistency with their blurred tiles as mentioned above. Blurred backgrounds are not the current focus, though.
- Keyboard since that keyboard was the best in 8.x
  - Basic typing shouldn't be that bad, but having it not interfere too much with what's on screen may be tough, plus it needs multiple language support
  - Swiping to type would be helpful but may be difficult to implement. If it is implemented, it should display the current result in the suggestion bar as you swipe.
  - The suggestions would be difficult to do when it comes to actually predicting text, but showing the text should be fine. It's important to remember that there are a whole bunch of suggestions (at least 10 usually), and that the list scrolls sideways.
  - Words that aren't recognized can be added to the dictionary by selecting them and pressing "+word".
  - The keyboard had a `paste` button at the very left part of the suggestion bar, so that needs to be added as well
  - Text-based emoticons are another thing it needs besides multi-language support (this whole thing needs multi-language support, but I don't really know how to do localization even if I did know multiple languages, so hopefully someone who knows how to do that can help with it)
  - May as well add the text navigation "stick" that Windows 10 Mobile had, since it's one of the few good things that version did. This will be one of the few features from W10M.
- Typing dictionary
  - There was no way to remove individual words, so there should be a menu that allows selecting user-added words to remove.
- Text selection that looks and behaves like WP
  - Tap a word once to select it, and drag the corners to change the selection
  - Surprisingly enough, Plasma Mobile has floating cut/copy/paste buttons that go above the selection, but they aren't quite enough, so I think a hybrid of iOS, Plasma Mobile, and Windows Phone would be the best thing. It would look like the WP buttons where icons are in circles, but there's a button for `cut` like Plasma Mobile and another button for `select all` like iOS because it's useful.
- Firefox theme and customizations to make it look like IE Mobile
  - Some things probably won't be easy/possible, such as a button to show tabs, so it might be more like Windows 8.x's IE when opened from the Start screen. That version just had a tab bar above the address bar and below the controls.
  - This might be the easiest of the wishlist to do, depending on if Mozilla changes stuff in Firefox to not allow something like this.
  - Probably will require making a Windows Phone 8.x GTK theme to make it simple. That in turn may require this project to become GPL'd, which I don't want to have happen but will if it means it'll be successful and work.
- Volume control UI
  - Not sure how it would behave like WP, but there it would open `Ringer + Notifications` when on the Start screen, and default to `Media + Apps` in apps like Bing Search. Changing different volume settings separately like this would probably take a lot of modifications to system-level stuff.
  - At least there should be a toggle button for vibrate if the volume settings are all together, if there's a way to implement that. Not a fan of having to go into Settings just to turn off vibrate.
- If this ever becomes a part of a Linux distro, the shutdown thing will say "goodbye" in lowercase, just like WP. I'd assume this text was translated, so that'll have to be done as well. Maybe it can just be images of text translated for each language.

Development is mainly being done using the PinePhone, so that'll be the main supported device. For now it's in the prototype stage as I don't really know what I'm doing with C#, Avalonia, and .NET 5 on Linux.

## Notes

**NB:** You may need to install the `ttf-ms-fonts` package (name may vary by distro) so that the proper fonts are available to Avalonia, otherwise it'll crash.

## License stuff

>This project (Retiled) is Copyright (C) 2021 Drew Naylor and is licensed under the Apache License 2.0.<br>
Windows Phone and all other related copyrights and trademarks are property of Microsoft Corporation. All rights reserved.<br>
Retiled is not associated with Microsoft in any way, and Microsoft does not endorse Retiled.<br>
Any other copyrights and trademarks belong to their respective people and companies/organizations.<br>
Components of the Retiled project include [AvaloniaUI](https://avaloniaui.net/), [.NET 5](https://docs.microsoft.com/en-us/dotnet/core/dotnet-five). Anything else that's used in the future will be added to this list.

## Building and running

This section will be filled out later, but basically just do `dotnet build (project).sln` and to run do `dotnet (project name in Debug\net5.0).dll` if on Linux, or use Visual Studio on Windows if you have it (never used the `dotnet` CLI on Windows, but I imagine it's similar, except you can just run the EXE rather than the DLL.

- RetiledStart
  - To build, run `dotnet build 
- RetiledSearch

## Video demos

- [RetiledStart prototype running on the PinePhone](https://youtu.be/NpUnrb1wC_8)

## Screenshots
Below are some prototype screenshots in case you want to see how things are going so far. Some may be updated separately from the rest so recent changes might not show up in every screenshot.

RetiledStart running on the PinePhone, less blurry than it is in person:<br>
<img src="/docs/images/retiledstart-running-on-pinephone.png" width="360"><br>
<br>
RetiledStart in a three-column view:<br>
<img src="/docs/images/retiledstart-tiles-that-look-like-wp.png" width="360"><br>
<br>
Simulated PinePhone Xwayland three-column view with 100x100 tiles:<br>
<img src="/docs/images/simulated-three-column-view-on-a-pinephone.png" width="360"><br>
<br>
Search app prototype:<br>
![](/docs/images/search-prototype.png?raw=true)<br>
