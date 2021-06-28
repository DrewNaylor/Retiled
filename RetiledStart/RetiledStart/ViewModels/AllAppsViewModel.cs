using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

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

    }
}
