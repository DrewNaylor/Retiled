Imports System.Runtime.InteropServices

Public Class Class1

    Public Shared Sub BeginSearch(SearchTerm As String)
        If RuntimeInformation.IsOSPlatform(OSPlatform.Windows) Then

        End If
    End Sub

    ' //if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
    '//    {
    '//    var SearchRunner = new ProcessStartInfo
    '//    {
    '//        FileName = "https://bing.com/search?q=" + SearchTerm,
    '//        UseShellExecute = true
    '//    };

    '//    Process.Start(SearchRunner);
    '//}
    '//else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
    '//{
    '//    Process.Start("xdg-open", "'https://bing.com/search?q=" + SearchTerm.Replace(" ", "%20") + "'");
    '//}

End Class
