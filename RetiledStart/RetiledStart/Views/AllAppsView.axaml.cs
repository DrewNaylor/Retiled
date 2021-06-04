using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;

namespace RetiledStart.Views
{
    public partial class AllAppsView : UserControl
    {
        public AllAppsView()
        {
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            AvaloniaXamlLoader.Load(this);
        }
    }
}
