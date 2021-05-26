# Retiled

An attempt at creating a "desktop" environment mainly for Linux phones and tablets that's similar in function to some parts of Microsoft's Windows Phone 8.x, primarily these features:
- Start screen
  - This is just tiles minus the "live" part at the moment because that would be a little complicated, though maybe in the future some people or I could figure out a good way to integrate Python scripts to display "live" data
  - There's also the app list to the right of the tiles, and the search box there along with the letter categorization are both essential to Windows Phone and Windows Phone-like environments
- Search app
  - Something like the old Bing search app from WP8.0 rather than Cortana
    - Would be cool if someone built something similar to Cortana that used an open-source backend, though
  - Currently this is just a textbox and a button that opens Bing with the search term in the default browser
    - Eventually it'll support choosing the default search engine
  - What would be really neat is if it had support for daily images if the user wants to show them, including but not limited to the Bing Image of the Day
    - This would just be the US at the beginning because that's what's easiest for me to test, but eventually it would have the option to use any region that has Bing Image of the Day stuff
    - Not sure if Microsoft would be ok with someone's project having built-in displaying of their images. Probably should have something that either goes to the Bing homepage (or the page of the daily wallpaper source that has image copyright info) or get the image's copyright info from Bing to display it in a popup that shows up when you press the `i` button in the Command Bar. Probably should just have an `i` button that goes to the page with image copyright info.
- Navigation bar
- Action Center
- Status bar
- Settings that are relevant to a Windows Phone-style UI. Probably will do a Settings app that looks at settings-related .desktop files and add a few of my own menus.
- WP8.1-style animations (8.1's animations were the best in any version I've used; 8.0's animations made me sick to my stomach after not using it for a long time)

There are also some "wishlist" features that I really want but might be too complicated to do.
- Lock screen
  - Tapping it makes the entire thing go up and bounce a few times before landing. If you have a PIN code active, it shows the unlock area, otherwise it just shows what's active.
  - You don't have to press a button after typing in your pin, as it just automatically unlocks if the combination is correct (will be more difficult than the bounce animation, and not even sure if it'll work or be secure and fast)
  - Not exactly sure how this would work in a way that's like the other mobile Linux lockscreens like the one in Plasma Mobile. That's the main thing preventing it from existing besides the fact that .NET/Avalonia apps take a while to start on the PinePhone, so that'll be not fun. Hopefully it'll run stuff faster soon
- Keyboard since that keyboard was the best in 8.x
  - Basic typing shouldn't be that bad, but having it not interfere too much with what's on screen may be tough
  - The suggestions would be difficult to do when it comes to actually predicting text, but showing the text should be fine
  - Text-based emoticons are another thing it needs besides multi-language support (this whole thing needs multi-language support, but I don't really know how to do localization even if I did know multiple languages, so hopefully someone who knows how to do that can help with it)

Development is mainly being done using the PinePhone, so that'll be the main supported device. For now it's in the prototype stage as I don't really know what I'm doing with C#, Avalonia, and .NET 5 on Linux.

## Notes

**NB:** You may need to install the `ttf-ms-fonts` package (name may vary by distro) so that the proper fonts are available to Avalonia, otherwise it'll crash.

## License stuff

>This project (Retiled) is Copyright (C) 2021 Drew Naylor and is licensed under the Apache License 2.0.<br>
Windows Phone and all other related copyrights and trademarks are property of Microsoft Corporation. All rights reserved.<br>
Retiled is not associated with Microsoft in any way, and Microsoft does not endorse Retiled.<br>
Any other copyrights and trademarks belong to their respective people and companies/organizations.<br>
Components of the Retiled project include [AvaloniaUI](https://avaloniaui.net/), [.NET 5](https://docs.microsoft.com/en-us/dotnet/core/dotnet-five). Anything else that's used in the future will be added to this list.

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
