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




Public Class AppsList

    Public Shared Sub RunApp(ExecFilename As String)
        ' Runs what's passed to it.
        ' Temporary Try/Catch so that it doesn't crash.
        Try
            Process.Start(ExecFilename.Replace(" %u", String.Empty))
        Catch ex As Exception
        End Try
    End Sub

    Public Shared Function GetDotDesktopFiles() As ObjectModel.ObservableCollection(Of String)
        ' Gets all .desktop files in /usr/share/applications
        ' on Linux or my desktop on Windows.

        ' Define a collection of filenames to use.
        Dim DotDesktopFilesList As New List(Of DotDesktopEntryInAllAppsList)
        ' Define a path we'll set later.
        ' We're setting up a fallback, too.
        Dim DotDesktopFilesPath As String = "/usr/share/applications"

        If OperatingSystem.IsLinux = True Then
            DotDesktopFilesPath = "/usr/share/applications"

        ElseIf OperatingSystem.IsWindows = True Then
            'DotDesktopFilesPath = "C:\Users\Drew\Desktop"
            DotDesktopFilesPath = "C:\Users\drewn\Desktop"
        End If

        For Each DotDesktopFile As String In FileIO.FileSystem.GetFiles(DotDesktopFilesPath)
            ' Check if the file ends with .desktop.
            If DotDesktopFile.EndsWith(".desktop") Then

                If Not libdotdesktop_standard.desktopEntryStuff.getInfo(DotDesktopFile, "NoDisplay") = "true" Then
                    ' Add the file to the list if they're supposed to
                    ' be shown.
                    ' Add its name if it's in the file.
                    If libdotdesktop_standard.desktopEntryStuff.getInfo(DotDesktopFile.ToString, "Name") IsNot Nothing Then
                        DotDesktopFilesList.Add(New DotDesktopEntryInAllAppsList(DotDesktopFile.ToString,
                                                                                 libdotdesktop_standard.desktopEntryStuff.getInfo(DotDesktopFile.ToString, "Name")))
                    Else
                        ' It's not in the file, so add its filename.
                        DotDesktopFilesList.Add(New DotDesktopEntryInAllAppsList(DotDesktopFile.ToString,
                                                                                 DotDesktopFile.ToString))
                    End If

                End If

            End If
        Next

        ' Sort the list of apps according to their Name:
        ' https://stackoverflow.com/a/33970009

        ' Define the current index.
        Dim CurrentIndex As Integer = 0

        ' Not exactly sure what all of this is doing, but
        ' it should be sorting the list.
        ' Found a new way of doing this here:
        ' https://stackoverflow.com/a/19113072
        ' Actually, something here may be useful:
        ' https://stackoverflow.com/questions/11735902/sort-a-list-of-object-in-vb-net
        ' This answer in particular might work:
        ' https://stackoverflow.com/a/11736001
        DotDesktopFilesList = DotDesktopFilesList.OrderBy(Function(x) x.NameKeyValueProperty).ToList()

        ' Define a new collection for the files list after
        ' it's sorted.
        Dim NewDotDesktopFilesList As New ObjectModel.ObservableCollection(Of String)

        ' Add everything in the list to the observable collection.
        For i As Integer = 0 To DotDesktopFilesList.Count - 1
            ' This currently just outputs one char, in this case "C".
            NewDotDesktopFilesList.Add(DotDesktopFilesPath(i))
        Next

        ' Return the collection.
        Return NewDotDesktopFilesList

    End Function

End Class

Public Class DotDesktopEntryInAllAppsList
    ' Adding a new class so we can add them to a list
    ' so that sorting the list is easy.
    ' Details:
    ' https://docs.microsoft.com/en-us/dotnet/visual-basic/programming-guide/concepts/linq/how-to-create-a-list-of-items

    ' Properties:
    Public Property FileNameProperty As String
    Public Property NameKeyValueProperty As String

    ' Not exactly sure why this is required.
    Public Sub New()

    End Sub

    Public Sub New(ByVal fileName As String,
                   ByVal nameKeyValue As String)
        ' Set the properties to be the parameters.
        FileNameProperty = fileName
        NameKeyValueProperty = nameKeyValue

    End Sub

End Class
