' libRetiledStart - Utility library for RetiledStart written in VB.NET so that
'                   I don't have to write everything in C#.
' Copyright (C) 2021 Drew Naylor
' (Note that the copyright years include the years left out by the hyphen.)
' Windows Phone and all other related copyrights and trademarks are property
' of Microsoft Corporation. All rights reserved.
'
' This file is a part of the Retiled project.
' Neither Retiled nor Drew Naylor are associated with Microsoft
' and Microsoft does not endorse Retiled.
' Any other copyrights and trademarks belong to their
' respective people and companies/organizations.
'
'
'   Licensed under the Apache License, Version 2.0 (the "License");
'   you may not use this file except in compliance with the License.
'   You may obtain a copy of the License at
'
'     http://www.apache.org/licenses/LICENSE-2.0
'
'   Unless required by applicable law or agreed to in writing, software
'   distributed under the License is distributed on an "AS IS" BASIS,
'   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
'   See the License for the specific language governing permissions and
'   limitations under the License.



Public Class TilesList

    Public Shared Function GetTilesList() As ObjectModel.ObservableCollection(Of String)
        ' Gets the list of tiles that should be shown on Start.
        ' Currently has the list of tiles hardcoded.

        ' Define a collection of tiles to use.
        Dim TilesList As New List(Of StartScreenTileEntry)
        ' Define a path we'll set later.
        ' We're setting up a fallback, too.
        'Dim DotDesktopFilesPath As String = "/usr/share/applications"

        'If OperatingSystem.IsLinux = True Then
        '    DotDesktopFilesPath = "/usr/share/applications"

        'ElseIf OperatingSystem.IsWindows = True Then
        '    DotDesktopFilesPath = "C:\Users\Drew\Desktop"
        '    'DotDesktopFilesPath = "C:\Users\drewn\Desktop"
        'End If

        'For Each DotDesktopFile As String In FileIO.FileSystem.GetFiles(DotDesktopFilesPath)
        '    ' Check if the file ends with .desktop.
        '    If DotDesktopFile.EndsWith(".desktop") Then

        '        If Not desktopEntryStuff.getInfo(DotDesktopFile, "NoDisplay") = "true" Then
        '            ' Make sure this .desktop file is supposed to be shown.
        '            ' Add its name if it's in the file.
        '            If desktopEntryStuff.getInfo(DotDesktopFile.ToString, "Name") IsNot Nothing Then
        '                DotDesktopFilesList.Add(New DotDesktopEntryInAllAppsList(DotDesktopFile.ToString,
        '                                                                         desktopEntryStuff.getInfo(DotDesktopFile.ToString, "Name")))
        '            Else
        '                ' It's not in the file, so add its filename.
        '                DotDesktopFilesList.Add(New DotDesktopEntryInAllAppsList(DotDesktopFile.ToString,
        '                                                                         DotDesktopFile.ToString))
        '            End If

        '        End If

        '    End If
        'Next

        ' Add hardcoded tiles to the list.
        TilesList.Add(New StartScreenTileEntry("Firefox", 150, 150, "#0050ef"))
        TilesList.Add(New StartScreenTileEntry("Angelfish", 150, 150, "#0050ef"))
        TilesList.Add(New StartScreenTileEntry("Index", 310, 150, "#0050ef"))
        TilesList.Add(New StartScreenTileEntry("Discover", 150, 150, "#0050ef"))
        TilesList.Add(New StartScreenTileEntry("Htop", 70, 70, "#0050ef"))


        ' This is where we actually sort the list.
        ' Stuff here ended up being really useful.
        ' Didn't know list items could have properties.
        ' Maybe one of my other programs that uses a List
        ' could benefit from this.
        ' https://stackoverflow.com/questions/11735902/sort-a-list-of-object-in-vb-net
        ' This answer in particular is what worked I think:
        ' https://stackoverflow.com/a/11736001
        DotDesktopFilesList = DotDesktopFilesList.OrderBy(Function(x) x.NameKeyValueProperty).ToList()

        ' Define a new ObservableCollection that we'll use to copy the file paths into.
        Dim NewDotDesktopFilesList As New ObjectModel.ObservableCollection(Of String)

        ' Add all of the items that are file paths to the new ObservableCollection.
        For Each Item In DotDesktopFilesList
            NewDotDesktopFilesList.Add(Item.FileNameProperty)
        Next

        ' Return the collection.
        Return NewDotDesktopFilesList

    End Function

End Class


Public Class StartScreenTileEntry
    ' Adding a new class so we can get and store
    ' information for tiles.
    ' Details:
    ' https://docs.microsoft.com/en-us/dotnet/visual-basic/programming-guide/concepts/linq/how-to-create-a-list-of-items

    ' Properties:
    ' I'll have to figure out how to implement the
    ' commands for the apps. Actually, I can
    ' temporarily hard-code tiles like I did
    ' with the All Apps list.
    Public Property FileNameProperty As String
    ' Tile width and height are self-explanatory.
    Public Property TileWidth As Integer
    Public Property TileHeight As Integer
    ' For now we'll store tile colors in strings,
    ' but this may be changed eventually if the "Color"
    ' type makes more sense to use. Probably should
    ' look at what properties MahApps.Metro uses
    ' for their tiles.
    Public Property TileColor As String
    ' The text at the bottom of the tile.
    Public Property TileAppNameAreaText As String
    ' Tile image. This isn't used right now as
    ' the code for getting app icons is unimplemented.
    Public Property TileImage As String

    Public Sub New(tileAppNameAreaTextValue As String,
                   tileWidthValue As Integer,
                   tileHeightValue As Integer,
                   tileColorValue As String)

        ' Set the properties to be the parameters.
        ' Not using the filename for now. If using it
        ' later, it'll have to be added back in as
        ' "fileName As String,"
        'FileNameProperty = fileName
        TileWidth = tileWidthValue
        TileHeight = tileHeightValue
        TileColor = tileColorValue
        TileAppNameAreaText = tileAppNameAreaTextValue

    End Sub

End Class