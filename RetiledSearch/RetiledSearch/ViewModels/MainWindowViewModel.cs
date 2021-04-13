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
                FileName = "https://bing.com/search?q=" & SearchTerm,
                UseShellExecute=true
            };

            Process.Start(SearchRunner);
        }

        private string _SearchTerm;

        public string SearchTerm
        {
            get { return _SearchTerm; }

        }

    }
}
