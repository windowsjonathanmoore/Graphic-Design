using System;
namespace algorithms
{
	
	// Basic node stored in a linked list
	// Note that this class is not accessible outside
	// of package DataStructures
	
	class ListNode
	{
		// Constructors
		internal ListNode(System.Object theElement):this(theElement, null)
		{
		}
		
		internal ListNode(System.Object theElement, ListNode n)
		{
			element = theElement;
			next = n;
		}
		
		// Friendly data; accessible by other package routines
		internal System.Object element;
		internal ListNode next;
	}
}