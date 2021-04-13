using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;

namespace RetiledSearch.ViewModels
{
    public class MainWindowViewModel : ViewModelBase
    {
        public string Greeting => "Welcome to Avalonia!";

        public void DoSearch()
        {
            // Define ProcessStartInfo.
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
                {
                var SearchRunner = new ProcessStartInfo
                {
                    FileName = "https://bing.com/search?q=" + SearchTerm,
                    UseShellExecute = true
                };

                Process.Start(SearchRunner);
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            {
                Process.Start("xdg-open", "'https://bing.com/search?q=" + SearchTerm.Replace(" ", "%20") + "'");
            }
        }

        private string? _SearchTerm;

        public string SearchTerm
        {
            get { return _SearchTerm; }
            set { _SearchTerm = value; }
        }

    }
}
