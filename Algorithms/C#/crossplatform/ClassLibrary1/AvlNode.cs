using System;
namespace algorithms
{
	
	// Basic node stored in AVL trees
	// Note that this class is not accessible outside
	// of package DataStructures
	
	class AvlNode
	{
		// Constructors
		internal AvlNode(Comparable theElement):this(theElement, null, null)
		{
		}
		
		internal AvlNode(Comparable theElement, AvlNode lt, AvlNode rt)
		{
			element = theElement;
			left = lt;
			right = rt;
			height = 0;
		}
		
		// Friendly data; accessible by other package routines
		internal Comparable element; // The data in the node
		internal AvlNode left; // Left child
		internal AvlNode right; // Right child
		internal int height; // Height
	}
}