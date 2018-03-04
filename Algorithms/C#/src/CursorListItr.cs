using System;
namespace algorithms
{
	
	// CursorListItr class; maintains "current position"
	//
	// CONSTRUCTION: Package friendly only, with a CursorNode
	//
	// ******************PUBLIC OPERATIONS*********************
	// void advance( )        --> Advance
	// boolean isPastEnd( )   --> True if at valid position in list
	// Object retrieve        --> Return item in current position
	
	/// <summary> Linked list implementation of the list iterator
	/// using a header node; cursor version.
	/// </summary>
	/// <author>  Mark Allen Weiss, Jonathan Moore
	/// </author>
	/// <seealso cref="CursorList">
	/// </seealso>
	public class CursorListItr
	{
		/// <summary> Test if the current position is past the end of the list.</summary>
		/// <returns> true if the current position is null-equivalent.
		/// </returns>
		virtual public bool PastEnd
		{
			get
			{
				return current == 0;
			}
			
		}
		/// <summary> Construct the list iterator</summary>
		/// <param name="theNode">any node in the linked list.
		/// </param>
		internal CursorListItr(int theNode)
		{
			current = theNode;
		}
		
		/// <summary> Return the item stored in the current position.</summary>
		/// <returns> the stored item or null if the current position
		/// is not in the list.
		/// </returns>
		public virtual System.Object retrieve()
		{
			return PastEnd?null:CursorList.cursorSpace[current].element;
		}
		
		/// <summary> Advance the current position to the next node in the list.
		/// If the current position is null, then do nothing.
		/// </summary>
		public virtual void  advance()
		{
			if (!PastEnd)
				current = CursorList.cursorSpace[current].next;
		}
		
		internal int current; // Current position
	}
}