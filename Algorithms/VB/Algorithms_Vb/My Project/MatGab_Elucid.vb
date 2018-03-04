Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Text

Namespace Algorithms
	Public Class GCD
		'static void Main(string[] args)
		'{
		'    int x, y;

		'    Console.WriteLine("This program allows calculating the GCD");
		'    Console.Write("Value 1: ");
		'    x = int.Parse(Console.ReadLine());
		'    Console.Write("Value 2: ");
		'    y = int.Parse(Console.ReadLine());

		'    Console.Write("\nThe Greatest Common Divisor of ");
		'    Console.WriteLine("{0} and {1} is {2}", x, y, gcd(x, y));
		'    Console.ReadLine();           
		'}        

		Public Shared Function gcd(a As Integer, b As Integer) As Integer
			Dim Remainder As Integer

			While b <> 0
				Remainder = a Mod b
				a = b
				b = Remainder
			End While

			Return a

		End Function


	End Class
End Namespace
