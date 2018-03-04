using System;
namespace algorithms
{
	
	// StackLi class
	//
	// CONSTRUCTION: with no initializer
	//
	// ******************PUBLIC OPERATIONS*********************
	// void push( x )         --> Insert x
	// void pop( )            --> Remove most recently inserted item
	// Object top( )          --> Return most recently inserted item
	// Object topAndPop( )    --> Return and remove most recent item
	// boolean isEmpty( )     --> Return true if empty; else false
	// boolean isFull( )      --> Always returns false
	// void makeEmpty( )      --> Remove all items
	// ******************ERRORS********************************
	// pop on empty stack
	
	/// <summary> List-based implementation of the stack.</summary>
	/// <author>  Mark Allen Weiss Jonathan Moore
	/// </author>
	public class StackLi
	{
		/// <summary> Test if the stack is logically full.</summary>
		/// <returns> false always, in this implementation.
		/// </returns>
		virtual public bool Full
		{
			get
			{
				return false;
			}
			
		}
		/// <summary> Test if the stack is logically empty.</summary>
		/// <returns> true if empty, false otherwise.
		/// </returns>
		virtual public bool Empty
		{
			get
			{
				return topOfStack == null;
			}
			
		}
		/// <summary> Construct the stack.</summary>
		public StackLi()
		{
			topOfStack = null;
		}
		
		/// <summary> Make the stack logically empty.</summary>
		public virtual void  makeEmpty()
		{
			topOfStack = null;
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
			return topOfStack.element;
		}
		
		/// <summary> Remove the most recently inserted item from the stack.</summary>
		/// <exception cref="Underflow">if the stack is empty.
		/// </exception>
		public virtual void  pop()
		{
			if (Empty)
				throw new Underflow();
			topOfStack = topOfStack.next;
		}
		
		/// <summary> Return and remove the most recently inserted item from the stack.</summary>
		/// <returns> the most recently inserted item in the stack, or null, if empty.
		/// </returns>
		public virtual System.Object topAndPop()
		{
			if (Empty)
				return null;
			
			System.Object topItem = topOfStack.element;
			topOfStack = topOfStack.next;
			return topItem;
		}
		
		/// <summary> Insert a new item into the stack.</summary>
		/// <param name="x">the item to insert.
		/// </param>
		public virtual void  push(System.Object x)
		{
			topOfStack = new ListNode(x, topOfStack);
		}
		
		private ListNode topOfStack;
		
		
		[STAThread]
		public static void  Main(System.String[] args)
		{
			StackLi s = new StackLi();
			
			for (int i = 0; i < 10; i++)
				s.push(new MyInteger(i));
			
			while (!s.Empty)
			{
				//UPGRADE_TODO: Method 'java.io.PrintStream.println' was converted to 'System.Console.Out.WriteLine' which has a different behavior. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1073_javaioPrintStreamprintln_javalangObject'"
				//UPGRADE_TODO: The equivalent in .NET for method 'java.lang.Object.toString' may return a different value. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1043'"
				System.Console.Out.WriteLine(s.topAndPop());
			}
		}
	}
}