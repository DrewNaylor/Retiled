using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;

namespace RetiledSearch
{
    public class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
#if DEBUG
            this.AttachDevTools();
#endif
        }

        private void InitializeComponent()
        {
            AvaloniaXamlLoader.Load(this);
        }

        public void DoSearch()
        {
            System.Diagnostics.Process.Start("https://bing.com/search?q=" & SearchBox.Text);
        }
    }
}
