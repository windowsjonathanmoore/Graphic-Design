using System;
namespace algorithms
{
	
	// Basic node stored in skip lists
	// Note that this class is not accessible outside
	// of package DataStructures
	
	class SkipNode
	{
		// Constructors
		internal SkipNode(Comparable theElement):this(theElement, null, null)
		{
		}
		
		internal SkipNode(Comparable theElement, SkipNode rt, SkipNode dt)
		{
			element = theElement;
			right = rt;
			down = dt;
		}
		
		// Friendly data; accessible by other package routines
		internal Comparable element; // The data in the node
		internal SkipNode right; // Right link 
		internal SkipNode down; // Down link
	}
}