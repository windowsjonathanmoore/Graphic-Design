using System;
namespace algorithms
{
	
	// StackAr class
	//
	// CONSTRUCTION: with or without a capacity; default is 10
	//
	// ******************PUBLIC OPERATIONS*********************
	// void push( x )         --> Insert x
	// void pop( )            --> Remove most recently inserted item
	// Object top( )          --> Return most recently inserted item
	// Object topAndPop( )    --> Return and remove most recently inserted item
	// boolean isEmpty( )     --> Return true if empty; else false
	// boolean isFull( )      --> Return true if full; else false
	// void makeEmpty( )      --> Remove all items
	// ******************ERRORS********************************
	// Overflow and Underflow thrown as needed
	
	/// <summary> Array-based implementation of the stack.</summary>
	/// <author>  Mark Allen Weiss Jonathan Moore
	/// </author>
	public class StackAr
	{
		/// <summary> Test if the stack is logically empty.</summary>
		/// <returns> true if empty, false otherwise.
		/// </returns>
		virtual public bool Empty
		{
			get
			{
				return topOfStack == - 1;
			}
			
		}
		/// <summary> Test if the stack is logically full.</summary>
		/// <returns> true if full, false otherwise.
		/// </returns>
		virtual public bool Full
		{
			get
			{
				return topOfStack == theArray.Length - 1;
			}
			
		}
		/// <summary> Construct the stack.</summary>
		public StackAr():this(DEFAULT_CAPACITY)
		{
		}
		
		/// <summary> Construct the stack.</summary>
		/// <param name="capacity">the capacity.
		/// </param>
		public StackAr(int capacity)
		{
			theArray = new System.Object[capacity];
			topOfStack = - 1;
		}
		
		/// <summary> Make the stack logically empty.</summary>
		public virtual void  makeEmpty()
		{
			topOfStack = - 1;
		}
		
		/// <summary> Get the most recently inserted item in the stack.
		/// Does not alter the stack.
		/// </summary>
		/// <returns> the most recently inserted item in the stack, or null, if empty.
		/// </returns>
		public virtual System.Object top()
		{
			if (Empty)
				return null;
			return theArray[topOfStack];
		}
		
		/// <summary> Remove the most recently inserted item from the stack.</summary>
		/// <exception cref="Underflow">if stack is already empty.
		/// </exception>
		public virtual void  pop()
		{
			if (Empty)
				throw new Underflow();
			theArray[topOfStack--] = null;
		}
		
		/// <summary> Insert a new item into the stack, if not already full.</summary>
		/// <param name="x">the item to insert.
		/// </param>
		/// <exception cref="Overflow">if stack is already full.
		/// </exception>
		public virtual void  push(System.Object x)
		{
			if (Full)
				throw new Overflow();
			theArray[++topOfStack] = x;
		}
		
		/// <summary> Return and remove most recently inserted item from the stack.</summary>
		/// <returns> most recently inserted item, or null, if stack is empty.
		/// </returns>
		public virtual System.Object topAndPop()
		{
			if (Empty)
				return null;
			System.Object topItem = top();
			theArray[topOfStack--] = null;
			return topItem;
		}
		
		private System.Object[] theArray;
		private int topOfStack;
		
		internal const int DEFAULT_CAPACITY = 10;
		
		[STAThread]
		public static void  Main(System.String[] args)
		{
			StackAr s = new StackAr(12);
			
			try
			{
				for (int i = 0; i < 10; i++)
					s.push(new MyInteger(i));
			}
			catch (Overflow e)
			{
				System.Console.Out.WriteLine("Unexpected overflow");
			}
			
			while (!s.Empty)
			{
				//UPGRADE_TODO: Method 'java.io.PrintStream.println' was converted to 'System.Console.Out.WriteLine' which has a different behavior. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1073_javaioPrintStreamprintln_javalangObject'"
				//UPGRADE_TODO: The equivalent in .NET for method 'java.lang.Object.toString' may return a different value. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1043'"
				System.Console.Out.WriteLine(s.topAndPop());
			}
		}
	}
}