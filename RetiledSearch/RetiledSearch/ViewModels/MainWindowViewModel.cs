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
            // Pass the search stuff to the library.
            libRetiledSearch.SearchTools.BeginSearch(SearchTerm);
        }

        private string? _SearchTerm;

        public string SearchTerm
        {
            get { return _SearchTerm; }
            set { _SearchTerm = value; }
        }

    }
}
