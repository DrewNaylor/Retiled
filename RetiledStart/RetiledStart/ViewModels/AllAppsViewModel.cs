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

        private ObservableCollection<string> _GetDotDesktopFiles = new ObservableCollection<string> (libRetiledStart.AppsList.GetDotDesktopFiles());

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
            return desktopEntryStuff.getInfo(DesktopEntryName, "Name");
        }

        public object? ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            return null;
        }
    }
}
