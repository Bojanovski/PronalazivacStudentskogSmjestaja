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
    /// Interaction logic for Query.xaml
    /// </summary>
    public partial class Query : Page
    {
        private MainWindow mMainWnd;

        public Query(MainWindow mainWnd)
        {
            InitializeComponent();
            mMainWnd = mainWnd;
            mMainWnd.mEnv.Reset();
            RunExpertSystem();
        }

        private void RunExpertSystem()
        {
            stckPnl.Children.Clear();
            mMainWnd.mEnv.Run();

            // Get the state-list.
            String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
            using (FactAddressValue allFacts = (FactAddressValue)((MultifieldValue)mMainWnd.mEnv.Eval(evalStr))[0])
            {
                string currentID = allFacts.GetFactSlot("current").ToString();
                evalStr = "(find-all-facts ((?f UI-state)) " + "(eq ?f:id " + currentID + "))";
            }

            using (FactAddressValue evalFact = (FactAddressValue)((MultifieldValue)mMainWnd.mEnv.Eval(evalStr))[0])
            {
                string state = evalFact.GetFactSlot("state").ToString();
                if (state.Equals("initial"))
                {

                }
                else if (state.Equals("final"))
                {

                }
                else
                {

                }

                using (MultifieldValue codedAnswers = (MultifieldValue)evalFact.GetFactSlot("coded-answers"))
                {
                    using (MultifieldValue validAnswers = (MultifieldValue)evalFact.GetFactSlot("valid-answers"))
                    {
                        if (validAnswers.Count > 0)
                        {
                            for (int i = 0; i < validAnswers.Count; i++)
                            {
                                Button btn = new Button();
                                btn.FontSize = 14;
                                btn.Content = ((SymbolValue)validAnswers[i]).ToString().Replace("\"", "");
                                btn.Tag = ((IntegerValue)codedAnswers[i]).ToString();
                                btn.Click += new RoutedEventHandler(btn_Click);
                                stckPnl.Children.Add(btn);
                            }
                        }
                        else // add reset button
                        {
                            Button btn = new Button();
                            btn.FontSize = 14;
                            btn.Content = "ponovi";
                            btn.Click += new RoutedEventHandler(btnReset_Click);
                            stckPnl.Children.Add(btn);
                        }
                    }
                    txtBoxQuery.Text = GetString((SymbolValue)evalFact.GetFactSlot("display"));
                }
            }
        }

        private void btnReset_Click(object sender, RoutedEventArgs e)
        {
            mMainWnd.mEnv.Reset();
            RunExpertSystem();
        }

        private void btn_Click(object sender, RoutedEventArgs e)
        {
            Button button = sender as Button;
            // Get the state-list.
            String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
            using (FactAddressValue f = (FactAddressValue)((MultifieldValue)mMainWnd.mEnv.Eval(evalStr))[0])
            {
                string currentID = f.GetFactSlot("current").ToString();
                if (button == null)
                {
                    mMainWnd.mEnv.AssertString("(next " + currentID + ")");
                }
                else
                {
                    mMainWnd.mEnv.AssertString("(next " + currentID + " " + (string)button.Tag + ")");
                }
                RunExpertSystem();
            }
        }


        private string GetString(string name)
        {
            return name;
            //return SR.ResourceManager.GetString(name);
        }

        private void btnExit_Click(object sender, RoutedEventArgs e)
        {
            Application.Current.Shutdown();
        }
    }
}