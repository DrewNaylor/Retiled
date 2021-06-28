using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RetiledStart.ViewModels
{
    class AllAppsViewModel : ViewModelBase
    {

        public void RunFirefox()
        {
            // Placeholder code to run Firefox for testing.
            System.Diagnostics.Process.Start(@"C:\Program Files\Mozilla Firefox\firefox.exe");
        }

    }
}
