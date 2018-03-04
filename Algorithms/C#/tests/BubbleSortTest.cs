using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Algorithms;

namespace UnitTests
{
    [TestClass]
    public class BubbleSortTest
    {
        [TestMethod]
        public void TestMethod1()
        {
            // create test array and fill it with random values
            int[] array = new int[1024];
            Random rnd = new Random(Environment.TickCount);
            for (int i = 0; i < array.Length; i++) array[i] = rnd.Next();

            // sort our array
            BubbleSort bbsrt = new BubbleSort();
            bbsrt.bubble_sort_generic(array);

            // check if it really sorted now
            bool sorted = true;
            for (int i = 0; sorted && (i < array.Length - 1); i++)
            {
                if (array[i] > array[i + 1]) sorted = false;
            }

            Debug.Write(sorted ? "array sorted" : "something wrong");
        }
    }
}
