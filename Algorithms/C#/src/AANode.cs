using System;
namespace algorithms
{
	
	// Basic node stored in AVL trees
	// Note that this class is not accessible outside
	// of package DataStructures
	
	class AANode
	{
		// Constructors
		public AANode(Comparable theElement):this(theElement, null, null)
		{
		}
		
		public AANode(Comparable theElement, AANode lt, AANode rt)
		{
			element = theElement;
			left = lt;
			right = rt;
			level = 1;
		}
		
		// Friendly data; accessible by other package routines
		internal Comparable element; // The data in the node
		internal AANode left; // Left child
		internal AANode right; // Right child
		internal int level; // Level
	}
}