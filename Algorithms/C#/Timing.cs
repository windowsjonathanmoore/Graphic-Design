// <copyright file="Timing.cs" company="My Company Name">
// Copyright (c) 2012 All Rights Reserved
// </copyright>
// <author>Jonatahn Moore</author>
// <date> </date>
// <summary></summary>


using System;
using System.Diagnostics;
using System.Threading.Tasks;

namespace TimingAlgorithm
{
    class Program
    {
        static void Main()
        {

            int[] nums = new int[100000];
            BuildArrayP(nums);
            Stopwatch tobj = new Stopwatch();
            tobj.Start();
            DisplayNumsP(nums);
            HelloWorld();
            tobj.Stop();

            Console.WriteLine("Time elapsed: {0}",tobj.Elapsed);
            Console.Read();

        }

        static void DisplayNums(int[] arr)
        {
            for (int i = 0; i <= arr.GetUpperBound(0);i++)
            {
                Console.WriteLine(arr[i] + " ");
            }
        }

        static void DisplayNumsP(int[] arr)
        {
            try
            {
                Parallel.For(0, arr.GetUpperBound(0), i =>
                {
                    Console.WriteLine(arr[i] + " ");
                });
            }
            catch { }
        }

        static void BuildArray(int[] arr)
        {
            for(int i = 0; i < 100000; i++)
            {
                arr[i] = i;
            }
        }

        static void BuildArrayP(int[] arr)
        {
            Parallel.For(0, 100000, i =>
            {
                arr[i] = i;
            });
        }

        static void HelloWorld()
        {
            Task.Run(async() =>
            {
                Console.WriteLine("Hello World");
                await Task.Delay(0);
            });
            
        }

        static void HelloWorld2()
        {
            Console.WriteLine("Hello World");
        }
    }
}
