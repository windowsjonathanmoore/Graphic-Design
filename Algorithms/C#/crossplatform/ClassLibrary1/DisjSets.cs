using System;
namespace algorithms
{
	
	// DisjSets class
	//
	// CONSTRUCTION: with int representing initial number of sets
	//
	// ******************PUBLIC OPERATIONS*********************
	// void union( root1, root2 ) --> Merge two sets
	// int find( x )              --> Return set containing x
	// ******************ERRORS********************************
	// No error checking is performed
	
	/// <summary> Disjoint set class. (Package friendly so not used accidentally)
	/// Does not use union heuristics or path compression.
	/// Elements in the set are numbered starting at 0.
	/// </summary>
	/// <author>  Mark Allen Weiss Jonathan Moore
	/// </author>
	/// <seealso cref="DisjSetsFast">
	/// </seealso>
	class DisjSets
	{
		/// <summary> Construct the disjoint sets object.</summary>
		/// <param name="numElements">the initial number of disjoint sets.
		/// </param>
		public DisjSets(int numElements)
		{
			s = new int[numElements];
			for (int i = 0; i < s.Length; i++)
				s[i] = - 1;
		}
		
		/// <summary> Union two disjoint sets.
		/// For simplicity, we assume root1 and root2 are distinct
		/// and represent set names.
		/// </summary>
		/// <param name="root1">the root of set 1.
		/// </param>
		/// <param name="root2">the root of set 2.
		/// </param>
		public virtual void  union(int root1, int root2)
		{
			s[root2] = root1;
		}
		
		/// <summary> Perform a find.
		/// Error checks omitted again for simplicity.
		/// </summary>
		/// <param name="x">the element being searched for.
		/// </param>
		/// <returns> the set containing x.
		/// </returns>
		public virtual int find(int x)
		{
			if (s[x] < 0)
				return x;
			else
				return find(s[x]);
		}
		
		private int[] s;
		
		
		// Test main; all finds on same output line should be identical
		[STAThread]
		public static void  Main(System.String[] args)
		{
			int numElements = 128;
			int numInSameSet = 16;
			
			DisjSets ds = new DisjSets(numElements);
			int set1, set2;
			
			for (int k = 1; k < numInSameSet; k *= 2)
			{
				for (int j = 0; j + k < numElements; j += 2 * k)
				{
					set1 = ds.find(j);
					set2 = ds.find(j + k);
					ds.union(set1, set2);
				}
			}
			
			for (int i = 0; i < numElements; i++)
			{
				System.Console.Out.Write(ds.find(i) + "*");
				if (i % numInSameSet == numInSameSet - 1)
					System.Console.Out.WriteLine();
			}
			System.Console.Out.WriteLine();
		}
	}
}