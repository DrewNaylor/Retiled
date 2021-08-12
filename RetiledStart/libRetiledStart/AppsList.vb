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

        ' Define a collection to use.
        Dim DotDesktopFilesList As New ObjectModel.ObservableCollection(Of String)
        ' Define a path we'll set later.
        ' We're setting up a fallback, too.
        Dim DotDesktopFilesPath As String = "/usr/share/applications"

        If OperatingSystem.IsLinux = True Then
            DotDesktopFilesPath = "/usr/share/applications"

        ElseIf OperatingSystem.IsWindows = True Then
            DotDesktopFilesPath = "C:\Users\Drew\Desktop"
        End If

        For Each DotDesktopFile As String In FileIO.FileSystem.GetFiles(DotDesktopFilesPath)
            ' Check if the file ends with .desktop.
            If DotDesktopFile.EndsWith(".desktop") Then
                ' Add the file to the list if they're supposed to
                ' be shown.
                If Not libdotdesktop_standard.desktopEntryStuff.getInfo(DotDesktopFile, "NoDisplay") = "true" Then
                    DotDesktopFilesList.Add(DotDesktopFile.ToString)
                End If
            End If
        Next

        ' Sort the list of apps according to their Name:
        ' https://stackoverflow.com/a/33970009

        ' Return the list.
        Return DotDesktopFilesList

    End Function

End Class
