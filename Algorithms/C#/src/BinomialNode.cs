using System;
namespace algorithms
{
	
	// Basic node stored in binomial queues
	// Note that this class is not accessible outside
	// of package DataStructures
	
	class BinomialNode
	{
		// Constructors
		internal BinomialNode(Comparable theElement):this(theElement, null, null)
		{
		}
		
		internal BinomialNode(Comparable theElement, BinomialNode lt, BinomialNode nt)
		{
			element = theElement;
			leftChild = lt;
			nextSibling = nt;
		}
		
		// Friendly data; accessible by other package routines
		internal Comparable element; // The data in the node
		internal BinomialNode leftChild; // Left child
		internal BinomialNode nextSibling; // Right child
	}
}