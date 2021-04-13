using System;
using System.Collections.Generic;
using System.Text;

namespace RetiledSearch.ViewModels
{
    public class MainWindowViewModel : ViewModelBase
    {
        public string Greeting => "Welcome to Avalonia!";

        public void DoSearch()
        {
            System.Diagnostics.Process.Start("https://bing.com/search?q=test");
        }

    }
}
