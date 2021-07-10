using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using libdotdesktop_standard;

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
        }

        public void GetDotDesktopFileText()
        {
            // Get .desktop file text for displaying on the button.
            // Placeholder for now because I don't know how to
            // decide which .desktop file we should read from yet.
        }


        private string? _DotDesktopEntryName = desktopEntryStuff.getInfo(@"C:\Users\Drew\Desktop\Internet Explorer.desktop", "Name");

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

    }
}
