// RetiledStart - Windows Phone 8.x-like Start screen UI for the
//                Retiled project.
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



using ReactiveUI;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using libRetiledStart;

namespace RetiledStart.ViewModels
{
    class TilesViewModel : ViewModelBase
    {


        // Couldn't figure out how to do this, so I based
        // this code off this SO answer:
        // https://stackoverflow.com/a/64552332
        // Get the tiles list from the library.
        private ObservableCollection<StartScreenTileEntry> _GetTilesList = new ObservableCollection<StartScreenTileEntry>(TilesList.GetTilesList());

        public ObservableCollection<StartScreenTileEntry> GetTilesList
        {
            // Get the list of .desktop files.
            get => _GetTilesList;
            set => this.RaiseAndSetIfChanged(ref _GetTilesList, value);

        }

    }
}
