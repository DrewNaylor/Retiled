Public Class AppsList

    Public Shared Sub RunApp(ExecFilename As String)
        ' Runs what's passed to it.
        Process.Start(ExecFilename.Replace(" %u", String.Empty))
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
                If libdotdesktop_standard.desktopEntryStuff.getInfo(DotDesktopFile, "NoDisplay") = "False" Then
                    DotDesktopFilesList.Add(DotDesktopFile.ToString)
                End If
            End If
        Next

        ' Return the list.
        Return DotDesktopFilesList

    End Function

End Class
