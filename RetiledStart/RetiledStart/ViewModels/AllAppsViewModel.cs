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

        public void RunFirefox()
        {
            // Placeholder code to run Firefox for testing.
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                System.Diagnostics.Process.Start(@"C:\Program Files\Mozilla Firefox\firefox.exe");
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            {
                System.Diagnostics.Process.Start(@"/usr/share/applications/firefox.desktop");
            }
        }

    }
}
