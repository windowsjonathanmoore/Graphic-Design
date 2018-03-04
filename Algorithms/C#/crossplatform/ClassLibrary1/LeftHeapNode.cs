using System;
namespace algorithms
{
	
	// Basic node stored in leftist heaps
	// Note that this class is not accessible outside
	// of package DataStructures
	
	class LeftHeapNode
	{
		// Constructors
		internal LeftHeapNode(Comparable theElement):this(theElement, null, null)
		{
		}
		
		internal LeftHeapNode(Comparable theElement, LeftHeapNode lt, LeftHeapNode rt)
		{
			element = theElement;
			left = lt;
			right = rt;
			npl = 0;
		}
		
		// Friendly data; accessible by other package routines
		internal Comparable element; // The data in the node
		internal LeftHeapNode left; // Left child
		internal LeftHeapNode right; // Right child
		internal int npl; // null path length
	}
}