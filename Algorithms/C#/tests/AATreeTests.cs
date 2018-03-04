using Microsoft.VisualStudio.TestTools.UnitTesting;
using algorithms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace algorithms.Tests
{
    [TestClass()]
    public class AATreeTests
    {
        [TestMethod()]
        public void MainTest()
        {
            AATree t = new AATree();            
            int NUMS = 40000;           
            int GAP = 307;

            System.Console.Out.WriteLine("Checking... (no bad output means success)");

            for (int i = GAP; i != 0; i = (i + GAP) % NUMS)
                t.insert(new MyInteger(i));
            System.Console.Out.WriteLine("Inserts complete");

            for (int i = 1; i < NUMS; i += 2)
                t.remove(new MyInteger(i));
            System.Console.Out.WriteLine("Removes complete");

            if (NUMS < 40)
                t.printTree();
            if (((MyInteger)(t.findMin())).intValue() != 2 || ((MyInteger)(t.findMax())).intValue() != NUMS - 2)
                System.Console.Out.WriteLine("FindMin or FindMax error!");

            for (int i = 2; i < NUMS; i += 2)
                if (((MyInteger)t.find(new MyInteger(i))).intValue() != i)
                    System.Console.Out.WriteLine("Error: find fails for " + i);

            for (int i = 1; i < NUMS; i += 2)
                if (t.find(new MyInteger(i)) != null)
                    System.Console.Out.WriteLine("Error: Found deleted item " + i);

        }
       
    }
}