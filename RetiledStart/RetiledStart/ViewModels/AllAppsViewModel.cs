﻿using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using libdotdesktop_standard;
using ReactiveUI;

namespace RetiledStart.ViewModels
{
    class AllAppsViewModel : ViewModelBase
    {

        //public void RunFirefox()
        //{
        //    // Placeholder code to run Firefox for testing.
        //    if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        //    {
        //        libRetiledStart.AppsList.RunApp(@"C:\Program Files\Mozilla Firefox\firefox.exe");
        //    }
        //    else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
        //    {
        //        libRetiledStart.AppsList.RunApp("/usr/bin/firefox");
        //    }
        //}

        //public void RunAngelfish()
        //{
        //    // Placeholder code to run Angelfish for testing.
        //    if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
        //    {
        //        libRetiledStart.AppsList.RunApp("/usr/bin/angelfish");
        //    }
        //}

        public void RunApp(string ExecFilename)
        {
            // Send it to the other code.
            // The code for Firefox on Windows
            // isn't in here anymore because I want
            // to simplify development for now.
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            {
                libRetiledStart.AppsList.RunApp("/usr/bin/" + ExecFilename);
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                Debug.WriteLine(desktopEntryStuff.getInfo(ExecFilename, "Exec"));
                libRetiledStart.AppsList.RunApp(desktopEntryStuff.getInfo(ExecFilename, "Exec"));
            }

        }

        public void GetDotDesktopFileText()
        {
            // Get .desktop file text for displaying on the button.
            // Placeholder for now because I don't know how to
            // decide which .desktop file we should read from yet.
        }


        private string? _DotDesktopEntryName = desktopEntryStuff.getInfo(@"C:\Users\Drew\Desktop\PowerShell.desktop", "Name");

        public string DotDesktopEntryName
        {
            get
            {
                if (_DotDesktopEntryName is null)
                // Make sure the name variable isn't
                // null, and if it is, replace it with
                // something else.
                {
                    _DotDesktopEntryName = "null";
                }
                return _DotDesktopEntryName;
            }
            set { _DotDesktopEntryName = value; }
        }


        private string? _DotDesktopEntryCommand = desktopEntryStuff.getInfo(@"C:\Users\Drew\Desktop\PowerShell.desktop", "Exec");

        public string DotDesktopEntryCommand
        {
            get
            {
                if (_DotDesktopEntryCommand is null)
                // Make sure the exec variable isn't
                // null, and if it is, replace it with
                // something else.
                {
                    _DotDesktopEntryCommand = "null";
                }
                return _DotDesktopEntryCommand;
            }
            set { _DotDesktopEntryCommand = value; }
        }

        // Couldn't figure out how to do this, so I based
        // this code off this SO answer:
        // https://stackoverflow.com/a/64552332

        private ObservableCollection<string> _AllAppsListItems = new ObservableCollection<string>(new string[] { @"C:\Users\Drew\Desktop\PowerShell.desktop",
        @"C:\Users\Drew\Desktop\Internet Explorer.desktop", @"C:\Users\Drew\Desktop\firefox.desktop", @"C:\Users\Drew\Desktop\vim.desktop", @"C:\Users\Drew\Desktop\mousepad.desktop"});

        public ObservableCollection<string> AllAppsListItems
        {
            get => _AllAppsListItems;
            set => this.RaiseAndSetIfChanged(ref _AllAppsListItems, value);
        }


    }
}
