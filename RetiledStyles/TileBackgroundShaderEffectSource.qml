// RetiledStyles - Windows Phone 8.x-like QML styles for the
//                 Retiled project. Some code was copied from
//                 the official qtdeclarative repo, which you can
//                 access a copy of here:
//                 https://github.com/DrewNaylor/qtdeclarative
// Copyright (C) 2021-2023 Drew Naylor
// (Note that the copyright years include the years left out by the hyphen.)
// Windows Phone and all other related copyrights and trademarks are property
// of Microsoft Corporation. All rights reserved.
//
// This file is a part of the RetiledStyles project, which is used by Retiled.
// Neither Retiled nor Drew Naylor are associated with Microsoft
// and Microsoft does not endorse Retiled.
// Any other copyrights and trademarks belong to their
// respective people and companies/organizations.
//
//
//    RetiledStyles is free software: you can redistribute it and/or modify
//    it under the terms of the GNU Lesser General Public License
//    version 3 as published by the Free Software Foundation.
//    All files in this repo (Retiled) licensed under the Apache License, 2.0,
//    are using RetiledStyles under the LGPLv3.
//
//    Alternatively, this file may be used under the terms of the GNU
//    General Public License version 2.0 or later as published by the Free
//    Software Foundation and appearing in the file LICENSE.GPL included in
//    the packaging of this file. Please review the following information to
//    ensure the GNU General Public License version 2.0 requirements will be
//    met: http://www.gnu.org/licenses/gpl-2.0.html.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU (Lesser) General Public License for more details.
//
//    You should have received a copy of the GNU (Lesser) General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.



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
		// TODO: Fix the image starting to disappear when there are too many tiles.
		sourceRect: Qt.rect(control.x, tilesPageTopSpacer.height + (-tilesFlickable.contentY + tilesFlickable.height / window.height) + control.y - tileWallpaper.y, control.width, control.height)
		// Hide the image source.
		hideSource: true
		
}