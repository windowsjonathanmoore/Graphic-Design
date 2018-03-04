using System;
namespace algorithms
{
	
	// Basic node stored in a linked list -- cursor version
	// Note that this class is not accessible outside
	// of package DataStructures
	
	class CursorNode
	{
		// Constructors
		internal CursorNode(System.Object theElement):this(theElement, 0)
		{
		}
		
		internal CursorNode(System.Object theElement, int n)
		{
			element = theElement;
			next = n;
		}
		
		// Friendly data; accessible by other package routines
		internal System.Object element;
		internal int next;
	}
}