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

namespace RetiledStart.ViewModels
{
    class AllAppsViewModel : ViewModelBase
    {

        public void RunApp(string ExecFilename)
        {
            // Send it to the other code.
                Debug.WriteLine(desktopEntryStuff.getInfo(ExecFilename, "Exec"));
                libRetiledStart.AppsList.RunApp(desktopEntryStuff.getInfo(ExecFilename, "Exec"));

        }

        public string GetText(string DotDesktopFilename)
        {
            // Get .desktop file text for displaying on the button.
            return desktopEntryStuff.getInfo(DotDesktopFilename, "Name");
        }

        // Couldn't figure out how to do this, so I based
        // this code off this SO answer:
        // https://stackoverflow.com/a/64552332

        private ObservableCollection<string> _GetDotDesktopFiles = new ObservableCollection<string>(libRetiledStart.AppsList.GetDotDesktopFiles());

        public ObservableCollection<string> GetDotDesktopFiles
        {
            // Get the list of .desktop files.
            get => _GetDotDesktopFiles;
            set => this.RaiseAndSetIfChanged(ref _GetDotDesktopFiles, value);
            
        }

    }

    // IValueConverter for the app list.
    // Ended up not using IMultiValueConverter because it just didn't
    // work as I needed it to.
    // This is from MSDN:
    // https://docs.microsoft.com/en-us/dotnet/desktop/wpf/data/?view=netdesktop-5.0#data-conversion

    public class AppNameConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            string? DesktopEntryName = value as string;
            //Debug.WriteLine(DesktopEntryName);
            //Debug.WriteLine(desktopEntryStuff.getInfo(DesktopEntryName, "Name"));
            // Check if there's actually a name in the .desktop file.
            // This is using the code in the library to make things easier.
            return libRetiledStart.AppsList.GetDotDesktopNameKey(DesktopEntryName);
        }

        public object? ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            return null;
        }
    }
}
