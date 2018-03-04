using System;
namespace algorithms
{
	
	// LinkedList class
	//
	// CONSTRUCTION: with no initializer
	// Access is via LinkedListItr class
	//
	// ******************PUBLIC OPERATIONS*********************
	// boolean isEmpty( )     --> Return true if empty; else false
	// void makeEmpty( )      --> Remove all items
	// LinkedListItr zeroth( )--> Return position to prior to first
	// LinkedListItr first( ) --> Return first position
	// void insert( x, p )    --> Insert x after current iterator position p
	// void remove( x )       --> Remove x
	// LinkedListItr find( x )
	//                        --> Return position that views x
	// LinkedListItr findPrevious( x )
	//                        --> Return position prior to x
	// ******************ERRORS********************************
	// No special errors
	
	/// <summary> Linked list implementation of the list
	/// using a header node.
	/// Access to the list is via LinkedListItr.
	/// </summary>
	/// <author>  Mark Allen Weiss Jonathan Moore
	/// </author>
	/// <seealso cref="LinkedListItr">
	/// </seealso>
	public class LinkedList
	{
		/// <summary> Test if the list is logically empty.</summary>
		/// <returns> true if empty, false otherwise.
		/// </returns>
		virtual public bool Empty
		{
			get
			{
				return header.next == null;
			}
			
		}
		/// <summary> Construct the list</summary>
		public LinkedList()
		{
			header = new ListNode((System.Object) null);
		}
		
		/// <summary> Make the list logically empty.</summary>
		public virtual void  makeEmpty()
		{
			header.next = null;
		}
		
		
		/// <summary> Return an iterator representing the header node.</summary>
		public virtual LinkedListItr zeroth()
		{
			return new LinkedListItr(header);
		}
		
		/// <summary> Return an iterator representing the first node in the list.
		/// This operation is valid for empty lists.
		/// </summary>
		public virtual LinkedListItr first()
		{
			return new LinkedListItr(header.next);
		}
		
		/// <summary> Insert after p.</summary>
		/// <param name="x">the item to insert.
		/// </param>
		/// <param name="p">the position prior to the newly inserted item.
		/// </param>
		public virtual void  insert(System.Object x, LinkedListItr p)
		{
			if (p != null && p.current != null)
				p.current.next = new ListNode(x, p.current.next);
		}
		
		/// <summary> Return iterator corresponding to the first node containing an item.</summary>
		/// <param name="x">the item to search for.
		/// </param>
		/// <returns> an iterator; iterator isPastEnd if item is not found.
		/// </returns>
		public virtual LinkedListItr find(System.Object x)
		{
			/* 1*/ ListNode itr = header.next;
			
			/* 2*/ while (itr != null && !itr.element.Equals(x))
			/* 3*/
				itr = itr.next;
			
			/* 4*/ return new LinkedListItr(itr);
		}
		
		/// <summary> Return iterator prior to the first node containing an item.</summary>
		/// <param name="x">the item to search for.
		/// </param>
		/// <returns> appropriate iterator if the item is found. Otherwise, the
		/// iterator corresponding to the last element in the list is returned.
		/// </returns>
		public virtual LinkedListItr findPrevious(System.Object x)
		{
			/* 1*/ ListNode itr = header;
			
			/* 2*/ while (itr.next != null && !itr.next.element.Equals(x))
			/* 3*/
				itr = itr.next;
			
			/* 4*/ return new LinkedListItr(itr);
		}
		
		/// <summary> Remove the first occurrence of an item.</summary>
		/// <param name="x">the item to remove.
		/// </param>
		public virtual void  remove(System.Object x)
		{
			LinkedListItr p = findPrevious(x);
			
			if (p.current.next != null)
				p.current.next = p.current.next.next; // Bypass deleted node
		}
		
		// Simple print method
		public static void  printList(LinkedList theList)
		{
			if (theList.Empty)
				System.Console.Out.Write("Empty list");
			else
			{
				LinkedListItr itr = theList.first();
				for (; !itr.PastEnd; itr.advance())
				{
					//UPGRADE_TODO: The equivalent in .NET for method 'java.lang.Object.toString' may return a different value. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1043'"
					System.Console.Out.Write(itr.retrieve() + " ");
				}
			}
			
			System.Console.Out.WriteLine();
		}
		
		private ListNode header;
		
		
		[STAThread]
		public static void  Main(System.String[] args)
		{
			LinkedList theList = new LinkedList();
			LinkedListItr theItr;
			int i;
			
			theItr = theList.zeroth();
			printList(theList);
			
			for (i = 0; i < 10; i++)
			{
				theList.insert(new MyInteger(i), theItr);
				printList(theList);
				theItr.advance();
			}
			
			for (i = 0; i < 10; i += 2)
				theList.remove(new MyInteger(i));
			
			for (i = 0; i < 10; i++)
				if ((i % 2 == 0) != (theList.find(new MyInteger(i)).PastEnd))
					System.Console.Out.WriteLine("Find fails!");
			
			System.Console.Out.WriteLine("Finished deletions");
			printList(theList);
		}
	}
}