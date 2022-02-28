These are some sticky notes I have written down about what I want to do with Retiled, and I figured they should be archived here. Some parts like the Cowsay GUI one were heavily modified from the original sticky notes, but only to improve clarification and reflect changes in how I think the best way things can be handled would be as of writing them.

## Cowsay GUI

A Live Tile example app where it shows a random quote from Cowsay output, refreshing every 30 minutes like regular Live Tiles. The cow will be on the back of the medium tile to save space, with the quote on the front. The cow will be next to the quote on the wide tile as an example there. I probably will have to use the image of the cow as an icon rather than grabbing it from Cowsay's output. Not sure what can go on the back of the wide tile as an example.

The app for Cowsay GUI itself has a header that says "cowsay gui" at the top and below that, a button above a textbox. Pressing the textbox will run Cowsay and show its output in the textbox.

There should be a button to clear its Live Tile cache, along with one to force an update. Those buttons will be in a Settings page for it in its appbar drawer. Clearing the cache will cause all Live Tile sizes to just be the icon of the cow, which is usually just what the small tile shows. Forcing a tile update will be done in some way that may involve the app writing to its own Live Tile cache file. To make this easy for everyone, I'll have to make an API to use that forces a tile to update on-demand.

## Waiting before having tiles start flipping

Have tiles wait a random amount of time between 2 and 5 seconds (inclusive) before starting to flip when going back to Start. Begin the timer after user touches the screen. Eventually stop flipping if no input is detected for a while (30-45 seconds? 1 minute?).

## Back and Start button stuff

Check if there are any other apps open when the RetiledStart app is activated (active focus, on-screen, on the top of all other apps) and navigate back to the previous one when tapping Back, or just go to the top of the tiles if Start is the only thing open.

May need to figure out an API/D-Bus thing to tie this together, plus other apps could (should, and will have to in order to be an authentic experience) have a way to say if they can still go back or not. If an app doesn't support this, just send Escape. Otherwise, if an app says it can't go back any further, send Alt+F4 to close the app.

Grab the Windows/Meta key when RetiledStart is open and use it to override the navigation bar button so it just acts like Escape/the Back button and goes to the top of the tiles.

## Having tiles flip

Ok, this isn't from a sticky note, but it's relevent to the Cowsay GUI part, so it's going here for now.

I think a basic flipping animation may be able to involve tiles visually shrinking to 0 pixels then growing back to their regular size. The only thing I'm not sure about is I think this will cause issues with the layout because it expects each tile to be an exact size. Hopefully it's simple enough to do 3D rotation in QML.
