package com.numerical;

public class Euclid {
	
	static public int gcd(int a, int b)
    {
        int Remainder;

        while (b != 0)
        {
            Remainder = a % b;
            a = b;
            b = Remainder;
        }

        return a;
        
    }

}
