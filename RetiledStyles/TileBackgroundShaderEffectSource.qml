import QtQuick

ShaderEffectSource {
		
		// Trying to use ShaderEffectSource to show tile backgrounds.
		// Docs on ShaderEffectSource:
		// https://doc.qt.io/qt-6/qml-qtquick-shadereffectsource.html
		
		// Use the tile wallpaper for the source to put as the tile background.
		// I tried multiplying the width and height by the parent's scale (the tile's scale, that is),
		// and it's a little weird. There needs to be a way to have the background ignore
		// changes to scale and tilt, but I'm not sure what to do.
		// TODO: Figure out how to have it so that pressing a tile doesn't change
		// the "scale" of the part of the wallpaper shown on a tile
		// and instead "zooms in" and crops the visible part of the shader
		// effect source. Also do this for the tilt.
		sourceItem: tileWallpaper
		// Cut out parts of the wallpaper for each tile.
		// Here we're taking the current tile's X-value for the
		// shader effect source's X-value, then (this is complicated)
		// we add the top spacer above the tiles so that the image
		// at least shows behind all the tiles at the top, then we take
		// that and add it to the result of the height of the tilesFlickable (what you
		// interact with when scrolling through the tiles) divided by the window's height
		// added to the inverse/negative of the tilesFlickable's current contentY-value,
		// then we add all that to the tile's Y-value, and finally subtract the tile wallpaper's
		// current Y-value from it.
		// The last two are simple: just the tile's width and height.
		// This will result in the tile wallpaper (assigned as tileWallpaper.source, usually
		// in "Tiles.qml", but you can use your own Image source if you're using this in
		// your own app) scrolling "through" the tiles as if they were a window, like
		// in Windows Phone 8.1.
		// (This doesn't quite work if the window is too short/wide/skinny/tall and
		// the image isn't the right aspect ratio to fill it in; maybe we can
		// use a different fillMode or make it go slower if the window is smaller/larger?)
		sourceRect: Qt.rect(control.x, tilesPageTopSpacer.height + (-tilesFlickable.contentY + tilesFlickable.height / window.height) + control.y - tileWallpaper.y, control.width, control.height)
		// Hide the image source.
		hideSource: true
		
}