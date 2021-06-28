Public Class AppsList

    Public Shared Sub RunApp(ExecFilename As String)
        ' Runs what's passed to it.
        System.Diagnostics.Process.Start(ExecFilename)
    End Sub

End Class
