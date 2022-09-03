These are some sticky notes I have written down about what I want to do with Retiled, and I figured they should be archived here. Some parts like the Fortun one were heavily modified from the original sticky notes, but only to improve clarification and reflect changes in how I think the best way things can be handled would be as of writing them.

## Fortun

A Live Tile example app where it shows a random quote from fortune output, refreshing every 30 minutes like regular Live Tiles. The cow from cowsay will be on the back of the medium tile to save space if cowsay support is enabled by the user (otherwise it just shows the app icon), with the quote on the front. The quote will be optionally piped to cowsay so that the cow will be next to the quote on the wide tile as an example there, but only if the user wants to use cowsay support. Small tiles and the All Apps list icon will just use the app's icon. Not sure what can go on the back of the wide tile as an example for putting stuff on the back of wide tiles.

The app for Fortun itself has a header that says "fortun" at the top and below that, a button above a textbox. Pressing the button will run fortune and show its output in the textbox, with the quote optionally piped to cowsay to display in the cow's bubble. Opening the app from the Live Tile will display the full output from fortune in the output textbox, optionally with the cow if, again, cowsay support is enabled.

There should be a button to clear its Live Tile cache, along with one to force an update. Those buttons will be in a Settings page for it in its appbar drawer. Clearing the cache will cause wide and medium Live Tiles to just be the icon of the cow (or which is chosen for the .cow files in regards to the cow's appearance) if using cowsay support, or it'll show the app's icon if not, with the app's icon being what the small tile shows regardless of cache status. Forcing a tile update will be done in some way that may involve the app writing to its own Live Tile cache file. To make this easy for everyone, I'll have to make an API to use that forces a tile to update on-demand. The tile for this app will only be refreshed on the next time the app is started if the cache was cleared and a refresh wasn't forced (apps will be able to force-refresh their Live Tiles whenever they want, just I think only doing it on startup if the cache is empty is a good idea for this example app; stuff like weather apps will probably want to force-refresh as soon as they have new weather data when they're open). 

More settings that can be offered include:
- Enable cowsay support
  - Description: Pipes fortune output to cowsay to have the cow show up on the Live Tile.
  - Cowsay support options:
    - Use cowthink instead of cowsay
    - (options for changing the cow's appearance based on the standard parameters, including support for `-f`: https://en.wikipedia.org/wiki/Cowsay#Parameters )
- Custom fortune parameters
  - Description: These get passed to fortune, so you can customize its output to your liking.

This used to be called Cowsay GUI, but then I read that it's fortune that I was thinking of that picks random pieces of text, and not cowsay.

To try to differentiate this app a little from other fortune GUIs (at least one exists), I named it Fortun, as I thought that was a clever name for a sidequest in Xenoblade X, and it's cool to have a reference to that series. X on Switch, please?

## Waiting before having tiles start flipping

Have tiles wait a random amount of time between 2 and 5 seconds (inclusive) before starting to flip when going back to Start. Begin the timer after user touches the screen. Eventually stop flipping if no input is detected for a while (30-45 seconds? 1 minute?).

## Back and Start button stuff

Check if there are any other apps open when the RetiledStart app is activated (active focus, on-screen, on the top of all other apps) and navigate back to the previous one when tapping Back, or just go to the top of the tiles if Start is the only thing open.

May need to figure out an API/D-Bus thing to tie this together, plus other apps could (should, and will have to in order to be an authentic experience) have a way to say if they can still go back or not. If an app doesn't support this, just send Escape. Otherwise, if an app says it can't go back any further, send Alt+F4 to close the app.

Grab the Windows/Meta key when RetiledStart is open and use it to override the navigation bar button so it just acts like Escape/the Back button and goes to the top of the tiles.

## Having tiles flip

Ok, this isn't from a sticky note, but it's relevent to the Cowsay GUI part, so it's going here for now.

I think a basic flipping animation may be able to involve tiles visually shrinking to 0 pixels then growing back to their regular size. The only thing I'm not sure about is I think this will cause issues with the layout because it expects each tile to be an exact size. Hopefully it's simple enough to do 3D rotation in QML.

## Closing the keyboard

Close keyboard with Back button when the keyboard is implemented:

Pseudocode:

```text
if (keyboard open)
    close keyboard
else if (multitasking)
    exit multitasking
else
    send Escape
end if
```
