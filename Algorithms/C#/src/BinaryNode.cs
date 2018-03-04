using System;
namespace algorithms
{
	
	// Basic node stored in unbalanced binary search trees
	// Note that this class is not accessible outside
	// of package DataStructures
	
	class BinaryNode
	{
		// Constructors
		internal BinaryNode(Comparable theElement):this(theElement, null, null)
		{
		}
		
		internal BinaryNode(Comparable theElement, BinaryNode lt, BinaryNode rt)
		{
			element = theElement;
			left = lt;
			right = rt;
		}
		
		// Friendly data; accessible by other package routines
		internal Comparable element; // The data in the node
		internal BinaryNode left; // Left child
		internal BinaryNode right; // Right child
	}
}