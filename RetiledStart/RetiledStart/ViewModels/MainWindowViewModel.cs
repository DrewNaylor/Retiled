using System;
using System.Collections.Generic;
using System.Text;

namespace RetiledStart.ViewModels
{
    public class MainWindowViewModel : ViewModelBase
    {
        public string Greeting => "cobalt-colored tile";
        // Cobalt was #0050ef according to W3Schools, but it doesn't look quite right
        // in Avalonia. Not sure how to make it look exactly like it did on my Lumia 822 and 830,
        // because that's the real version of cobalt to me.
        // #0047ab may be better, as that's what shows up when I type "cobalt" into
        // ColorHexa.
        // Tested the code from ColorHexa and it looks too dull.
    }
}
