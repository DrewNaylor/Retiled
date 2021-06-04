using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;

namespace RetiledStart.Views
{
    public partial class TilesView : UserControl
    {
        public TilesView()
        {
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            AvaloniaXamlLoader.Load(this);
        }
    }
}
