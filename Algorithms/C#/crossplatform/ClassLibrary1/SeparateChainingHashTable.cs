using System;
namespace algorithms
{
	
	// SeparateChainingHashTable class
	//
	// CONSTRUCTION: with an approximate initial size or default of 101
	//
	// ******************PUBLIC OPERATIONS*********************
	// void insert( x )       --> Insert x
	// void remove( x )       --> Remove x
	// Hashable find( x )     --> Return item that matches x
	// void makeEmpty( )      --> Remove all items
	// int hash( String str, int tableSize )
	//                        --> Static method to hash strings
	// ******************ERRORS********************************
	// insert overrides previous value if duplicate; not an error
	
	/// <summary> Separate chaining table implementation of hash tables.
	/// Note that all "matching" is based on the equals method.
	/// </summary>
	/// <author>  Mark Allen Weiss Jonathan Moore
	/// </author>
	public class SeparateChainingHashTable
	{
		/// <summary> Construct the hash table.</summary>
		public SeparateChainingHashTable():this(DEFAULT_TABLE_SIZE)
		{
		}
		
		/// <summary> Construct the hash table.</summary>
		/// <param name="size">approximate table size.
		/// </param>
		public SeparateChainingHashTable(int size)
		{
			theLists = new LinkedList[nextPrime(size)];
			for (int i = 0; i < theLists.Length; i++)
				theLists[i] = new LinkedList();
		}
		
		/// <summary> Insert into the hash table. If the item is
		/// already present, then do nothing.
		/// </summary>
		/// <param name="x">the item to insert.
		/// </param>
		public virtual void  insert(Hashable x)
		{
			LinkedList whichList = theLists[x.hash(theLists.Length)];
			LinkedListItr itr = whichList.find(x);
			
			if (itr.PastEnd)
				whichList.insert(x, whichList.zeroth());
		}
		
		/// <summary> Remove from the hash table.</summary>
		/// <param name="x">the item to remove.
		/// </param>
		public virtual void  remove(Hashable x)
		{
			theLists[x.hash(theLists.Length)].remove(x);
		}
		
		/// <summary> Find an item in the hash table.</summary>
		/// <param name="x">the item to search for.
		/// </param>
		/// <returns> the matching item, or null if not found.
		/// </returns>
		public virtual Hashable find(Hashable x)
		{
			return (Hashable) theLists[x.hash(theLists.Length)].find(x).retrieve();
		}
		
		/// <summary> Make the hash table logically empty.</summary>
		public virtual void  makeEmpty()
		{
			for (int i = 0; i < theLists.Length; i++)
				theLists[i].makeEmpty();
		}
		
		/// <summary> A hash routine for String objects.</summary>
		/// <param name="key">the String to hash.
		/// </param>
		/// <param name="tableSize">the size of the hash table.
		/// </param>
		/// <returns> the hash value.
		/// </returns>
		public static int hash(System.String key, int tableSize)
		{
			int hashVal = 0;
			
			for (int i = 0; i < key.Length; i++)
				hashVal = 37 * hashVal + key[i];
			
			hashVal %= tableSize;
			if (hashVal < 0)
				hashVal += tableSize;
			
			return hashVal;
		}
		
		private const int DEFAULT_TABLE_SIZE = 101;
		
		/// <summary>The array of Lists. </summary>
		private LinkedList[] theLists;
		
		/// <summary> Internal method to find a prime number at least as large as n.</summary>
		/// <param name="n">the starting number (must be positive).
		/// </param>
		/// <returns> a prime number larger than or equal to n.
		/// </returns>
		private static int nextPrime(int n)
		{
			if (n % 2 == 0)
				n++;
			
			for (; !isPrime(n); n += 2)
				;
			
			return n;
		}
		
		/// <summary> Internal method to test if a number is prime.
		/// Not an efficient algorithm.
		/// </summary>
		/// <param name="n">the number to test.
		/// </param>
		/// <returns> the result of the test.
		/// </returns>
		private static bool isPrime(int n)
		{
			if (n == 2 || n == 3)
				return true;
			
			if (n == 1 || n % 2 == 0)
				return false;
			
			for (int i = 3; i * i <= n; i += 2)
				if (n % i == 0)
					return false;
			
			return true;
		}
		
		
		// Simple main
		[STAThread]
		public static void  Main(System.String[] args)
		{
			SeparateChainingHashTable H = new SeparateChainingHashTable();
			
			//UPGRADE_NOTE: Final was removed from the declaration of 'NUMS '. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1003'"
			int NUMS = 4000;
			//UPGRADE_NOTE: Final was removed from the declaration of 'GAP '. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1003'"
			int GAP = 37;
			
			System.Console.Out.WriteLine("Checking... (no more output means success)");
			
			for (int i = GAP; i != 0; i = (i + GAP) % NUMS)
				H.insert(new MyInteger(i));
			for (int i = 1; i < NUMS; i += 2)
				H.remove(new MyInteger(i));
			
			for (int i = 2; i < NUMS; i += 2)
				if (((MyInteger) (H.find(new MyInteger(i)))).intValue() != i)
					System.Console.Out.WriteLine("Find fails " + i);
			
			for (int i = 1; i < NUMS; i += 2)
			{
				if (H.find(new MyInteger(i)) != null)
					System.Console.Out.WriteLine("OOPS!!! " + i);
			}
		}
	}
}