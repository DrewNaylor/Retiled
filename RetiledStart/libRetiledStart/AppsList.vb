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

        ' Return the list.
        Return DotDesktopFilesList

    End Function

End Class
