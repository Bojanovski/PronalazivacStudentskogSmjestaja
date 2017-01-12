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

using System.Diagnostics;
using System.IO;

namespace PronalazivacStudentskogSmjestaja
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public Mommosoft.ExpertSystem.Environment mEnv;

        public MainWindow()
        {
            InitializeComponent();

            mEnv = new Mommosoft.ExpertSystem.Environment();
            mEnv.AddRouter(new DebugRouter());
            mEnv.Load("Data/studom.clp");
            mEnv.Reset();

            MainFrame.Content = new Main();
        }

        private void Rectangle_MouseDown(object sender, MouseButtonEventArgs e)
        {
            DragMove();
        }
    }
}
