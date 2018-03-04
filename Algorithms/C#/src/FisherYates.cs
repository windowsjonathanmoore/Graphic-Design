using System;

class Program
{
    /// <summary>
    /// Used in Shuffle(T).
    /// </summary>
    static Random _random = new Random();

    /// <summary>
    /// Shuffle the array.
    /// </summary>
    /// <typeparam name="T">Array element type.</typeparam>
    /// <param name="array">Array to shuffle.</param>
    public static void Shuffle<T>(T[] array)
    {
        var random = _random;
        for (int i = array.Length; i > 1; i--)
        {
            // Pick random element to swap.
            int j = random.Next(i); // 0 <= j <= i-1
                                    // Swap.
            T tmp = array[j];
            array[j] = array[i - 1];
            array[i - 1] = tmp;
        }
    }

    public void FisherYates(int[] ary)
    {
        Random rnd = new Random();

        for (int i = ary.Length - 1; i > 0; i--)
        {
            int r = rnd.Next(0, i);

            int tmp = ary[i];
            ary[i] = ary[r];
            ary[r] = tmp;
        }
    }
}
   /*static void Main()
    {
	{
	    int[] array = { 1, 2, 3, 4, 5, 6, 7, 8, 9 };
	    Shuffle(array);
	    foreach (int value in array)
	    {
		Console.WriteLine(value);
	    }
	}
	{
	    string[] array = { "dot", "net", "perls" };
	    Shuffle(array);
	    foreach (string value in array)
	    {
		Console.WriteLine(value);
	    }
	}
    }
}
*/
