using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;

namespace RetiledSearch.ViewModels
{
    public class MainWindowViewModel : ViewModelBase
    {
        public string Greeting => "Welcome to Avalonia!";

        public void DoSearch()
        {
            // Define ProcessStartInfo.
            var SearchRunner = new ProcessStartInfo
            {
                FileName = "https://bing.com/search?q=test",
                UseShellExecute=true
            };

            Process.Start(SearchRunner);
        }

    }
}
