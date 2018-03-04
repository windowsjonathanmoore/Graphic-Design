using System;
namespace algorithms
{
	
	// LinkedListItr class; maintains "current position"
	//
	// CONSTRUCTION: Package friendly only, with a ListNode
	//
	// ******************PUBLIC OPERATIONS*********************
	// void advance( )        --> Advance
	// boolean isPastEnd( )   --> True if at "null" position in list
	// Object retrieve        --> Return item in current position
	
	/// <summary> Linked list implementation of the list iterator
	/// using a header node.
	/// </summary>
	/// <author>  Mark Allen Weiss Jonathan Moore
	/// </author>
	/// <seealso cref="LinkedList">
	/// </seealso>
	public class LinkedListItr
	{
		/// <summary> Test if the current position is past the end of the list.</summary>
		/// <returns> true if the current position is null.
		/// </returns>
		virtual public bool PastEnd
		{
			get
			{
				return current == null;
			}
			
		}
		/// <summary> Construct the list iterator</summary>
		/// <param name="theNode">any node in the linked list.
		/// </param>
		internal LinkedListItr(ListNode theNode)
		{
			current = theNode;
		}
		
		/// <summary> Return the item stored in the current position.</summary>
		/// <returns> the stored item or null if the current position
		/// is not in the list.
		/// </returns>
		public virtual System.Object retrieve()
		{
			return PastEnd?null:current.element;
		}
		
		/// <summary> Advance the current position to the next node in the list.
		/// If the current position is null, then do nothing.
		/// </summary>
		public virtual void  advance()
		{
			if (!PastEnd)
				current = current.next;
		}
		
		internal ListNode current; // Current position
	}
}