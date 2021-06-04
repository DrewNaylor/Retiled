using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;

namespace RetiledStart.Views
{
    public partial class TilesList : UserControl
    {
        public TilesList()
        {
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            AvaloniaXamlLoader.Load(this);
        }
    }
}
