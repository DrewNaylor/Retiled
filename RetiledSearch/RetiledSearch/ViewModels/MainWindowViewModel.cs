// RetiledSearch - Windows Phone 8.0-like Search app for the
//                 Retiled project.
// Copyright (C) 2021 Drew Naylor
// (Note that the copyright years include the years left out by the hyphen.)
// Windows Phone and all other related copyrights and trademarks are property
// of Microsoft Corporation. All rights reserved.
//
// This file is a part of the Retiled project.
// Neither Retiled nor Drew Naylor are associated with Microsoft
// and Microsoft does not endorse Retiled.
// Any other copyrights and trademarks belong to their
// respective people and companies/organizations.
//
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.




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
                    _SearchTerm = "";
                }
                return _SearchTerm;
            }
            set { _SearchTerm = value; }
        }

    }
}
