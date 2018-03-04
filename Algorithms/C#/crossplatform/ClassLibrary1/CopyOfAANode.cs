using System;
namespace algorithms
{
	
	// Basic node stored in AVL trees
	// Note that this class is not accessible outside
	// of package DataStructures
	
	class CopyOfAANode
	{
		// Constructors
		internal CopyOfAANode(Comparable theElement):this(theElement, null, null)
		{
		}
		
		internal CopyOfAANode(Comparable theElement, CopyOfAANode lt, CopyOfAANode rt)
		{
			element = theElement;
			left = lt;
			right = rt;
			level = 1;
		}
		
		// Friendly data; accessible by other package routines
		internal Comparable element; // The data in the node
		internal CopyOfAANode left; // Left child
		internal CopyOfAANode right; // Right child
		internal int level; // Level
	}
}