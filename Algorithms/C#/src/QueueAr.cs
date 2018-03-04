using System;
namespace algorithms
{
	
	// QueueAr class
	//
	
	// CONSTRUCTION: with or without a capacity; default is 10
	//
	// ******************PUBLIC OPERATIONS*********************
	// void enqueue( x )      --> Insert x
	// Object getFront( )     --> Return least recently inserted item
	// Object dequeue( )      --> Return and remove least recent item
	// boolean isEmpty( )     --> Return true if empty; else false
	// boolean isFull( )      --> Return true if capacity reached
	// void makeEmpty( )      --> Remove all items
	// ******************ERRORS********************************
	// Overflow thrown for enqueue on full queue
	
	/// <summary> Array-based implementation of the queue.</summary>
	/// <author>  Mark Allen Weiss Jonathn Moore
	/// </author>
	public class QueueAr
	{
		/// <summary> Test if the queue is logically empty.</summary>
		/// <returns> true if empty, false otherwise.
		/// </returns>
		virtual public bool Empty
		{
			get
			{
				return currentSize == 0;
			}
			
		}
		/// <summary> Test if the queue is logically full.</summary>
		/// <returns> true if full, false otherwise.
		/// </returns>
		virtual public bool Full
		{
			get
			{
				return currentSize == theArray.Length;
			}
			
		}
		/// <summary> Get the least recently inserted item in the queue.
		/// Does not alter the queue.
		/// </summary>
		/// <returns> the least recently inserted item in the queue, or null, if empty.
		/// </returns>
		virtual public System.Object Front
		{
			get
			{
				if (Empty)
					return null;
				return theArray[front];
			}
			
		}
		/// <summary> Construct the queue.</summary>
		public QueueAr():this(DEFAULT_CAPACITY)
		{
		}
		
		/// <summary> Construct the queue.</summary>
		public QueueAr(int capacity)
		{
			theArray = new System.Object[capacity];
			makeEmpty();
		}
		
		/// <summary> Make the queue logically empty.</summary>
		public virtual void  makeEmpty()
		{
			currentSize = 0;
			front = 0;
			back = - 1;
		}
		
		/// <summary> Return and remove the least recently inserted item from the queue.</summary>
		/// <returns> the least recently inserted item in the queue, or null, if empty.
		/// </returns>
		public virtual System.Object dequeue()
		{
			if (Empty)
				return null;
			currentSize--;
			
			System.Object frontItem = theArray[front];
			theArray[front] = null;
			front = increment(front);
			return frontItem;
		}
		
		/// <summary> Insert a new item into the queue.</summary>
		/// <param name="x">the item to insert.
		/// </param>
		/// <exception cref="Overflow">if queue is full.
		/// </exception>
		public virtual void  enqueue(System.Object x)
		{
			if (Full)
				throw new Overflow();
			back = increment(back);
			theArray[back] = x;
			currentSize++;
		}
		
		/// <summary> Internal method to increment with wraparound.</summary>
		/// <param name="x">any index in theArray's range.
		/// </param>
		/// <returns> x+1, or 0, if x is at the end of theArray.
		/// </returns>
		private int increment(int x)
		{
			if (++x == theArray.Length)
				x = 0;
			return x;
		}
		
		private System.Object[] theArray;
		private int currentSize;
		private int front;
		private int back;
		
		internal const int DEFAULT_CAPACITY = 10;
		
		
		[STAThread]
		public static void  Main(System.String[] args)
		{
			QueueAr q = new QueueAr();
			
			try
			{
				for (int i = 0; i < 10; i++)
					q.enqueue(new MyInteger(i));
			}
			catch (Overflow e)
			{
				System.Console.Out.WriteLine("Unexpected overflow");
			}
			
			while (!q.Empty)
			{
				//UPGRADE_TODO: Method 'java.io.PrintStream.println' was converted to 'System.Console.Out.WriteLine' which has a different behavior. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1073_javaioPrintStreamprintln_javalangObject'"
				//UPGRADE_TODO: The equivalent in .NET for method 'java.lang.Object.toString' may return a different value. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1043'"
				System.Console.Out.WriteLine(q.dequeue());
			}
		}
	}
}