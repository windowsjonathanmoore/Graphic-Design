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
    public class ElucidTest
    {
        [TestMethod]
        public void ElucidTestMethod()
        {
            int x = 119;
            int y = 544;

            Debug.WriteLine("This method allows calculating the GCD");            
            Debug.WriteLine("\nThe Greatest Common Divisor of " + x + " " + "and" + " " + y);            
            Debug.WriteLine(GCD.gcd(x, y));
                   
        }
    }
}
