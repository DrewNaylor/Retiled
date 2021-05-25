using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;

namespace RetiledSearch.ViewModels
{
    public class MainWindowViewModel : ViewModelBase
    {
        public void DoSearch()
        {
            // Pass the search stuff to the library.
            libRetiledSearch.SearchTools.BeginSearch(SearchTerm);
        }

        private string? _SearchTerm;

        public string SearchTerm
        {
            get {
                if (_SearchTerm is null)
                    // Make sure the search term variable isn't
                    // null, and if it is, replace it with
                    // something else.
                {
                    _SearchTerm = "enter search term and press search";
                }
                return _SearchTerm;
            }
            set { _SearchTerm = value; }
        }

    }
}
