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




using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using Avalonia.Data.Converters;
using libdotdesktop_standard;
using ReactiveUI;
using FancyStaggeredLayout.Avalonia;
using libRetiledStart;

namespace RetiledStart.ViewModels
{
    class AllAppsViewModel : ViewModelBase
    {

        public void RunApp(string ExecFilename)
        {
            // Send it to the other code.
            //Console.WriteLine(ExecFilename);
            //Console.WriteLine(desktopEntryStuff.getInfo(ExecFilename, "Exec"));
            //Debug.WriteLine(ExecFilename);
            //Debug.WriteLine(desktopEntryStuff.getInfo(ExecFilename, "Exec"));
            AppsList.RunApp(ExecFilename);

        }

        public void PinMediumTile(string FilenameProperty)
        {
            // Send the .desktop file to the more-general tile-pinning code.
            libRetiledStart.AppsList.PinTile(FilenameProperty, "medium");

        }

        public void PinWideTile(string FilenameProperty)
        {
            // Send the .desktop file to the more-general tile-pinning code.
            libRetiledStart.AppsList.PinTile(FilenameProperty, "wide");

        }

        public void PinSmallTile(string FilenameProperty)
        {
            // Send the .desktop file to the more-general tile-pinning code.
            libRetiledStart.AppsList.PinTile(FilenameProperty, "small");

        }

        public string GetText(string DotDesktopFilename)
        {
            // Get .desktop file text for displaying on the button.
            return desktopEntryStuff.getInfo(DotDesktopFilename, "Name");
        }

        // Couldn't figure out how to do this, so I based
        // this code off this SO answer:
        // https://stackoverflow.com/a/64552332

        // This should help make things responsive:
        // https://docs.microsoft.com/en-us/dotnet/api/system.windows.data.bindingoperations.enablecollectionsynchronization?view=net-5.0
        private ObservableCollection<DotDesktopEntryInAllAppsList> _GetDotDesktopFiles = new ObservableCollection<DotDesktopEntryInAllAppsList>(AppsList.GetDotDesktopFiles());

        public ObservableCollection<DotDesktopEntryInAllAppsList> GetDotDesktopFiles
        {
            // Get the list of .desktop files.
            get => _GetDotDesktopFiles;
            set => this.RaiseAndSetIfChanged(ref _GetDotDesktopFiles, value);
            
        }

    }
}
