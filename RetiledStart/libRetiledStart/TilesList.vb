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


Imports YamlDotNet.Serialization

Public Class TilesList

    Public Shared Sub UnpinTile(FilenameProperty As String)
        ' Unpin the tile based on the FilenameProperty.

        Debug.WriteLine(".desktop file: " & FilenameProperty)
    End Sub

    Public Shared Sub ResizeTile(FilenameProperty As String, TileSize As String)
        ' This code may actually be able to be shared with the pinning code, but
        ' there may have to be a boolean that determines whether to edit a tile
        ' or to pin a tile. Actually, maybe unpinning tiles can be done in the same
        ' block, though maybe that'll require a "TileEditMode" string to choose between
        ' pinning, resizing, moving, or unpinning a tile. Not sure how to move tiles yet.
        ' Just pasting the code here for now as a placeholder.

        ' Based on the size of the tile, we'll set different
        ' values in the startlayout.yaml file.
        ' Set up variables to store width and height.
        Dim TileWidth As Integer = 150
        Dim TileHeight As Integer = 150
        Select Case TileSize
            Case "medium"
                TileWidth = 150
                TileHeight = 150
            Case "wide"
                TileWidth = 310
                TileHeight = 150
            Case "small"
                TileWidth = 70
                TileHeight = 70
            Case Else
                ' If there's something else passed in,
                ' just set it to medium, which is the default.
                TileWidth = 150
                TileHeight = 150
        End Select

        ' Now we can start reading the startlayout.yaml file to see
        ' whether it needs to be copied to the user's AppData (or equivalent) folder.
        ' TODO: Implement this.

        ' Write the tile data into the startlayout file so it's resized.
        ' TODO: Implement this.
        Debug.WriteLine(".desktop file: " & FilenameProperty)
        Debug.WriteLine("Width: " & TileWidth)
        Debug.WriteLine("Height: " & TileHeight)
    End Sub

    Public Shared Function GetTilesList() As ObjectModel.ObservableCollection(Of StartScreenTileEntry)
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

        ' Get the startlayout.yaml file.
        Using StartLayoutYamlFile = New IO.StreamReader(AppContext.BaseDirectory & "startlayout.yaml")
            'Debug.WriteLine(StartLayoutYamlFile.ReadToEnd)

            ' May need this:
            ' https://stackoverflow.com/questions/45966647/yaml-object-lists
            ' Deserialize the YAML.
            ' As linked below, newer versions of YamlDotNet use a different deserializer thing.
            ' I had to mostly auto-convert the code from the sample using the Telerik converter because it wouldn't build
            ' and I couldn't figure it out manually.
            Dim YamlDeserializer = New DeserializerBuilder().WithNamingConvention(NamingConventions.CamelCaseNamingConvention.Instance).Build()

            ' I have no clue why this isn't working and I can't figure it out.
            ' Actually, I think I need to deserialize into an array, since
            ' that's what the winget schema uses:
            ' https://raw.githubusercontent.com/microsoft/winget-cli/master/schemas/JSON/manifests/v1.0.0/manifest.installer.1.0.0.json
            ' This part of the documentation might help to an extent where it talks
            ' about "!contact": https://github.com/aaubry/YamlDotNet/wiki/Serialization.Deserializer#withtagmappingstring-type
            ' Also, this .NET Fiddle result could be modified to get to what I need,
            ' as the "items" part has a similar layout to my file: https://dotnetfiddle.net/HD2JXM
            ' Actually, some of this stuff is based on the YamlDotNet deserialization
            ' into an object graph sample: https://github.com/aaubry/YamlDotNet/wiki/Samples.DeserializeObjectGraph
            Dim LocalStartScreenLayout = YamlDeserializer.Deserialize(Of StartScreenLayout)(StartLayoutYamlFile)

            Debug.WriteLine(LocalStartScreenLayout)

            ' Load the file into YamlDotNet to get the tiles.
            ' Mostly basing this code off what I did in guinget,
            ' though I need to use this as well:
            ' https://github.com/aaubry/YamlDotNet/issues/334#issuecomment-421928467
            For Each Entry In LocalStartScreenLayout.Tiles
                ' Add the item.
                ' Using Select Case to make it faster than If/Else.
                Debug.WriteLine(Entry.DotDesktopFilePath)
                Debug.WriteLine(Entry.TileColor)
                Debug.WriteLine(Entry.TileWidth)
                Debug.WriteLine(Entry.TileHeight)

                ' TODO: Make sure the .desktop files exist, and if they don't,
                ' just use the path. Preferably this should have tiles fade out,
                ' but that would take more work. Actually, it would be a good idea
                ' to allow users to use the "Name" key in the .desktop file by default
                ' and let them override that value by specifying something in the
                ' startlayout.yaml file. If the name key in the YAML file is
                ' empty or missing, then it first falls back to the .desktop file's
                ' "Name" key, then if that's missing, it falls back to the .desktop file
                ' path. There should also be an item to allow people to hide the tile text,
                ' and that'll also have the overriding function, but instead the .desktop
                ' files will have an "X-Retiled-" property item thing, in case developers
                ' decide to include support for Retiled.
                If OperatingSystem.IsLinux = True Then
                    TilesList.Add(New StartScreenTileEntry(Entry.DotDesktopFilePath,
                                                       libdotdesktop_standard.desktopEntryStuff.getInfo(Entry.DotDesktopFilePath, "Name"),
                                                       Entry.TileWidth,
                                                       Entry.TileHeight,
                                                       Entry.TileColor))
                Else
                    TilesList.Add(New StartScreenTileEntry(Entry.DotDesktopFilePath,
                                                       Entry.DotDesktopFilePath,
                                                       Entry.TileWidth,
                                                       Entry.TileHeight,
                                                       Entry.TileColor))
                End If
            Next
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
            'TilesList.Add(New StartScreenTileEntry("/usr/share/applications/firefox.desktop", "Firefox", 150, 150, "#0050ef"))
            '    TilesList.Add(New StartScreenTileEntry("/usr/share/applications/org.kde.angelfish.desktop", "Angelfish", 150, 150, "#0050ef"))
            '    TilesList.Add(New StartScreenTileEntry("/usr/share/applications/org.kde.index.desktop", "Index", 310, 150, "#0050ef"))
            '    TilesList.Add(New StartScreenTileEntry("/usr/share/applications/org.kde.discover.desktop", "Discover", 150, 150, "#0050ef"))
            '    TilesList.Add(New StartScreenTileEntry("/usr/share/applications/htop.desktop", "Htop", 70, 70, "#0050ef"))
            '    TilesList.Add(New StartScreenTileEntry("/usr/share/applications/org.kde.kalk.desktop", "Calculator", 70, 70, "#0050ef"))
            '    TilesList.Add(New StartScreenTileEntry("/usr/share/applications/org.kde.nota.desktop", "Nota", 70, 70, "#0050ef"))
            '    TilesList.Add(New StartScreenTileEntry("/usr/share/applications/org.kde.phone.dialer.desktop", "Phone", 70, 70, "Red"))
            '    TilesList.Add(New StartScreenTileEntry("/usr/share/applications/org.kde.okular.desktop", "Okular", 150, 150, "#0050ef"))
        End Using

        ' This is where we actually sort the list.
        ' Stuff here ended up being really useful.
        ' Didn't know list items could have properties.
        ' Maybe one of my other programs that uses a List
        ' could benefit from this.
        ' https://stackoverflow.com/questions/11735902/sort-a-list-of-object-in-vb-net
        ' This answer in particular is what worked I think:
        ' https://stackoverflow.com/a/11736001
        'DotDesktopFilesList = DotDesktopFilesList.OrderBy(Function(x) x.NameKeyValueProperty).ToList()

        ' Define a new ObservableCollection that we'll use to copy the file paths into.
        Dim ObservableTilesList As New ObjectModel.ObservableCollection(Of StartScreenTileEntry)

        ' Add all of the items that are file paths to the new ObservableCollection.
        For Each Item In TilesList
            ObservableTilesList.Add(New StartScreenTileEntry(Item.DotDesktopFilePath, Item.TileAppNameAreaText, Item.TileWidth, Item.TileHeight, Item.TileColor))
        Next



        ' Return the collection.
        Return ObservableTilesList

    End Function

End Class


Public Class StartScreenLayout
    ' Need to have a class to refer to the layout file
    ' when deserializing the tile entries.
    ' Start layout schema version, which starts at 0.1.
    <YamlMember([Alias]:="StartLayoutSchemaVersion", ApplyNamingConventions:=False)>
    Public Property StartLayoutSchemaVersion As Version
    ' Get a list of the tiles specified in the YAML file.
    ' Forgot to have it be shared.
    <YamlMember([Alias]:="Tiles", ApplyNamingConventions:=False)>
    Public Property Tiles As List(Of StartScreenTileEntry)
End Class


Public Class StartScreenTileEntry
    ' Adding a new class so we can get and store
    ' information for tiles.
    ' Details:
    ' https://docs.microsoft.com/en-us/dotnet/visual-basic/programming-guide/concepts/linq/how-to-create-a-list-of-items

    ' Properties:
    ' Specify an alias for the class based on this code:
    ' https://stackoverflow.com/a/37809414
    ' It has to be right above the property it's using.
    ' I converted the code using the Telerik C# to VB.NET Code Converter:
    ' https://converter.telerik.com/
    ' Property to store the .desktop file path for
    ' the tiles.
    <YamlMember([Alias]:="DotDesktopFilePath", ApplyNamingConventions:=False)>
    Public Property DotDesktopFilePath As String
    ' Tile width and height are self-explanatory.
    <YamlMember([Alias]:="TileWidth", ApplyNamingConventions:=False)>
    Public Property TileWidth As Integer
    <YamlMember([Alias]:="TileHeight", ApplyNamingConventions:=False)>
    Public Property TileHeight As Integer
    ' For now we'll store tile colors in strings,
    ' but this may be changed eventually if the "Color"
    ' type makes more sense to use. Probably should
    ' look at what properties MahApps.Metro uses
    ' for their tiles.
    <YamlMember([Alias]:="TileColor", ApplyNamingConventions:=False)>
    Public Property TileColor As String
    ' The text at the bottom of the tile.
    Public Property TileAppNameAreaText As String
    ' Tile image. This isn't used right now as
    ' the code for getting app icons is unimplemented.
    Public Property TileImage As String

    ' Required due to "Your custom class must be public and support a default (parameterless) public constructor."
    ' https://docs.microsoft.com/en-us/dotnet/desktop/wpf/advanced/xaml-and-custom-classes-for-wpf?view=netframeworkdesktop-4.8
    Public Sub New()

    End Sub

    Public Sub New(tileDotDesktopFileValue As String,
                       tileAppNameAreaTextValue As String,
                       tileWidthValue As Integer,
                       tileHeightValue As Integer,
                       tileColorValue As String)

        ' Set the properties to be the parameters.
        ' Not using the filename for now. If using it
        ' later, it'll have to be added back in as
        ' "fileName As String,"
        DotDesktopFilePath = tileDotDesktopFileValue
        TileWidth = tileWidthValue
        TileHeight = tileHeightValue
        TileColor = tileColorValue
        TileAppNameAreaText = tileAppNameAreaTextValue

    End Sub

End Class