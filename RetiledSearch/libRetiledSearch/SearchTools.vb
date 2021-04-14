' libRetiledSearch - Library for the Retiled Search app so I
'                    don't have to use C# for everything.
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




Imports System.Runtime.InteropServices

Public Class SearchTools

    Public Shared Sub BeginSearch(SearchTerm As String)
        If RuntimeInformation.IsOSPlatform(OSPlatform.Windows) Then
            ' Create a process thing for running on Windows.
            Dim SearchRunner As New ProcessStartInfo
            SearchRunner.FileName = "https://bing.com/search?q=" & SearchTerm
            SearchRunner.UseShellExecute = True

            Process.Start(SearchRunner)

        ElseIf RuntimeInformation.IsOSPlatform(OSPlatform.Linux) Then
            ' Do a search on Linux.
            Dim SearchTermFixer As String = "https://bing.com/search?q=" & SearchTerm.Replace(" ", "%20")
            Process.Start("xdg-open", """" & SearchTermFixer & """")
        End If
    End Sub

End Class
