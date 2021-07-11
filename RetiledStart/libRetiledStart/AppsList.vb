Public Class AppsList

    Public Shared Sub RunApp(ExecFilename As String)
        ' Runs what's passed to it.
        System.Diagnostics.Process.Start(ExecFilename)
    End Sub

    Public Shared Function GetDotDesktopFiles() As ObjectModel.ObservableCollection(Of String)
        ' Gets all .desktop files in /usr/share/applications
        ' on Linux or a pre-determined set on Windows.

        If OperatingSystem.IsLinux = True Then
            For Each DotDesktopFile As String In FileIO.FileSystem.GetDirectories("/usr/share/applications")

            Next
        End If

    End Function

End Class
