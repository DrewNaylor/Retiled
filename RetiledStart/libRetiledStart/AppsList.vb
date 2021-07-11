Public Class AppsList

    Public Shared Sub RunApp(ExecFilename As String)
        ' Runs what's passed to it.
        System.Diagnostics.Process.Start(ExecFilename)
    End Sub

    Public Shared Function GetDotDesktopFiles() As ObjectModel.ObservableCollection(Of String)
        ' Gets all .desktop files in /usr/share/applications
        ' on Linux or a pre-determined set on Windows.

    End Function

End Class
