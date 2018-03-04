using System;
namespace algorithms
{
	
	// CursorList class
	//
	// CONSTRUCTION: with no initializer
	// Access is via CursorListItr class
	//
	// ******************PUBLIC OPERATIONS*********************
	// boolean isEmpty( )     --> Return true if empty; else false
	// void makeEmpty( )      --> Remove all items
	// CursorListItr zeroth( )--> Return position to prior to first
	// CursorListItr first( ) --> Return first position
	// void insert( x, p )    --> Insert x after current iterator position p
	// void remove( x )       --> Remove x
	// CursorListItr find( x )
	//                        --> Return position that views x
	// CursorListItr findPrevious( x )
	//                        --> Return position prior to x
	// ******************ERRORS********************************
	// No special errors
	
	/// <summary> Linked list implementation of the list
	/// using a header node; cursor version.
	/// Access to the list is via CursorListItr.
	/// </summary>
	/// <author>  Mark Allen Weiss, Jonathan Moore
	/// </author>
	/// <seealso cref="CursorListItr">
	/// </seealso>
	public class CursorList
	{
		/// <summary> Test if the list is logically empty.</summary>
		/// <returns> true if empty, false otherwise.
		/// </returns>
		virtual public bool Empty
		{
			get
			{
				return cursorSpace[header].next == 0;
			}
			
		}
		private static int alloc()
		{
			int p = cursorSpace[0].next;
			cursorSpace[0].next = cursorSpace[p].next;
			if (p == 0)
				throw new System.OutOfMemoryException();
			return p;
		}
		
		private static void  free(int p)
		{
			cursorSpace[p].element = null;
			cursorSpace[p].next = cursorSpace[0].next;
			cursorSpace[0].next = p;
		}
		
		/// <summary> Construct the list.</summary>
		public CursorList()
		{
			header = alloc();
			cursorSpace[header].next = 0;
		}
		
		/// <summary> Make the list logically empty.</summary>
		public virtual void  makeEmpty()
		{
			while (!Empty)
				remove(first().retrieve());
		}
		
		
		/// <summary> Return an iterator representing the header node.</summary>
		public virtual CursorListItr zeroth()
		{
			return new CursorListItr(header);
		}
		
		/// <summary> Return an iterator representing the first node in the list.
		/// This operation is valid for empty lists.
		/// </summary>
		public virtual CursorListItr first()
		{
			return new CursorListItr(cursorSpace[header].next);
		}
		
		/// <summary> Insert after p.</summary>
		/// <param name="x">the item to insert.
		/// </param>
		/// <param name="p">the position prior to the newly inserted item.
		/// </param>
		public virtual void  insert(System.Object x, CursorListItr p)
		{
			if (p != null && p.current != 0)
			{
				int pos = p.current;
				var tmp = alloc();
				
				cursorSpace[tmp].element = x;
				cursorSpace[tmp].next = cursorSpace[pos].next;
				cursorSpace[pos].next = tmp;
			}
		}
		
		/// <summary> Return iterator corresponding to the first node containing an item.</summary>
		/// <param name="x">the item to search for.
		/// </param>
		/// <returns> an iterator; iterator isPastEnd if item is not found.
		/// </returns>
		public virtual CursorListItr find(System.Object x)
		{
			/* 1*/ int itr = cursorSpace[header].next;
			
			/* 2*/ while (itr != 0 && !cursorSpace[itr].element.Equals(x))
			/* 3*/
				itr = cursorSpace[itr].next;
			
			/* 4*/ return new CursorListItr(itr);
		}
		
		/// <summary> Return iterator prior to the first node containing an item.</summary>
		/// <param name="x">the item to search for.
		/// </param>
		/// <returns> appropriate iterator if the item is found. Otherwise, the
		/// iterator corresponding to the last element in the list is returned.
		/// </returns>
		public virtual CursorListItr findPrevious(System.Object x)
		{
			/* 1*/ int itr = header;
			
			/* 2*/ while (cursorSpace[itr].next != 0 && !cursorSpace[cursorSpace[itr].next].element.Equals(x))
			/* 3*/
				itr = cursorSpace[itr].next;
			
			/* 4*/ return new CursorListItr(itr);
		}
		
		/// <summary> Remove the first occurrence of an item.</summary>
		/// <param name="x">the item to remove.
		/// </param>
		public virtual void  remove(System.Object x)
		{
			CursorListItr p = findPrevious(x);
			int pos = p.current;
			
			if (cursorSpace[pos].next != 0)
			{
				int tmp = cursorSpace[pos].next;
				cursorSpace[pos].next = cursorSpace[tmp].next;
				free(tmp);
			}
		}
		
		// Simple print method
		static public void  printList(CursorList theList)
		{
			if (theList.Empty)
				System.Console.Out.Write("Empty list");
			else
			{
				CursorListItr itr = theList.first();
				for (; !itr.PastEnd; itr.advance())
				{
					//UPGRADE_TODO: The equivalent in .NET for method 'java.lang.Object.toString' may return a different value. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1043'"
					System.Console.Out.Write(itr.retrieve() + " ");
				}
			}
			
			System.Console.Out.WriteLine();
		}
		
		private int header;
		internal static CursorNode[] cursorSpace;
		
		private const int SPACE_SIZE = 100;
		
		[STAThread]
		public static void  Main(System.String[] args)
		{
			CursorList theList = new CursorList();
			CursorListItr theItr;
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
		static CursorList()
		{
			{
				cursorSpace = new CursorNode[SPACE_SIZE];
				for (int i = 0; i < SPACE_SIZE; i++)
					cursorSpace[i] = new CursorNode((System.Object) null, i + 1);
				cursorSpace[SPACE_SIZE - 1].next = 0;
			}
		}
	}
}