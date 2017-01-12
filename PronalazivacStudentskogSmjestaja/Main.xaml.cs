using Mommosoft.ExpertSystem;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace PronalazivacStudentskogSmjestaja
{
    /// <summary>
    /// Interaction logic for Main.xaml
    /// </summary>
    public partial class Main : Page
    {
        public Main()
        {
            InitializeComponent();
        }

        private void btnExit_Click(object sender, RoutedEventArgs e)
        {
            Application.Current.Shutdown();
        }

        private void image_MouseDown(object sender, MouseButtonEventArgs e)
        {
            MainWindow wnd = Window.GetWindow(this) as MainWindow;
            wnd.DragMove();
        }

        private void btnBegin_Click(object sender, RoutedEventArgs e)
        {
            MainWindow wnd = Window.GetWindow(this) as MainWindow;
            wnd.MainFrame.Content = new Query(wnd);
        }
    }
}
