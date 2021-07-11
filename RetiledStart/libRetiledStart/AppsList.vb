Public Class AppsList

    Public Shared Sub RunApp(ExecFilename As String)
        ' Runs what's passed to it.
        System.Diagnostics.Process.Start(ExecFilename)
    End Sub

    Public Shared Function GetDotDesktopFiles() As ObjectModel.ObservableCollection(Of String)
        ' Gets all .desktop files in /usr/share/applications
        ' on Linux or a pre-determined set on Windows.

        ' Define a collection to use.
        Dim DotDesktopFilesList As New ObjectModel.ObservableCollection(Of String)

        If OperatingSystem.IsLinux = True Then
            For Each DotDesktopFile As String In FileIO.FileSystem.GetDirectories("/usr/share/applications")
                ' Check if the file ends with .desktop.
                If DotDesktopFile.EndsWith(".desktop") Then
                    DotDesktopFilesList.Add(DotDesktopFile.ToString)
                End If
            Next
        End If

    End Function

End Class
