using System;
namespace algorithms
{
	
	// LeftistHeap class
	//
	// CONSTRUCTION: with a negative infinity sentinel
	//
	// ******************PUBLIC OPERATIONS*********************
	// void insert( x )       --> Insert x
	// Comparable deleteMin( )--> Return and remove smallest item
	// Comparable findMin( )  --> Return smallest item
	// boolean isEmpty( )     --> Return true if empty; else false
	// boolean isFull( )      --> Return false in this implementation
	// void makeEmpty( )      --> Remove all items
	// void merge( rhs )      --> Absorb rhs into this heap
	
	/// <summary> Implements a leftist heap.
	/// Note that all "matching" is based on the compareTo method.
	/// </summary>
	/// <author>  Mark Allen Weiss Jonathan Moore
	/// </author>
	public class LeftistHeap
	{
		/// <summary> Test if the priority queue is logically empty.</summary>
		/// <returns> true if empty, false otherwise.
		/// </returns>
		virtual public bool Empty
		{
			get
			{
				return root == null;
			}
			
		}
		/// <summary> Test if the priority queue is logically full.</summary>
		/// <returns> false in this implementation.
		/// </returns>
		virtual public bool Full
		{
			get
			{
				return false;
			}
			
		}
		/// <summary> Construct the leftist heap.</summary>
		public LeftistHeap()
		{
			root = null;
		}
		
		/// <summary> Merge rhs into the priority queue.
		/// rhs becomes empty. rhs must be different from this.
		/// </summary>
		/// <param name="rhs">the other leftist heap.
		/// </param>
		public virtual void  merge(LeftistHeap rhs)
		{
			if (this == rhs)
			// Avoid aliasing problems
				return ;
			
			root = merge(root, rhs.root);
			rhs.root = null;
		}
		
		/// <summary> Internal static method to merge two roots.
		/// Deals with deviant cases and calls recursive merge1.
		/// </summary>
		private static LeftHeapNode merge(LeftHeapNode h1, LeftHeapNode h2)
		{
			if (h1 == null)
				return h2;
			if (h2 == null)
				return h1;
			if (h1.element.compareTo(h2.element) < 0)
				return merge1(h1, h2);
			else
				return merge1(h2, h1);
		}
		
		/// <summary> Internal static method to merge two roots.
		/// Assumes trees are not empty, and h1's root contains smallest item.
		/// </summary>
		private static LeftHeapNode merge1(LeftHeapNode h1, LeftHeapNode h2)
		{
			if (h1.left == null)
			// Single node
				h1.left = h2;
			// Other fields in h1 already accurate
			else
			{
				h1.right = merge(h1.right, h2);
				if (h1.left.npl < h1.right.npl)
					swapChildren(h1);
				h1.npl = h1.right.npl + 1;
			}
			return h1;
		}
		
		/// <summary> Swaps t's two children.</summary>
		private static void  swapChildren(LeftHeapNode t)
		{
			LeftHeapNode tmp = t.left;
			t.left = t.right;
			t.right = tmp;
		}
		
		/// <summary> Insert into the priority queue, maintaining heap order.</summary>
		/// <param name="x">the item to insert.
		/// </param>
		public virtual void  insert(Comparable x)
		{
			root = merge(new LeftHeapNode(x), root);
		}
		
		/// <summary> Find the smallest item in the priority queue.</summary>
		/// <returns> the smallest item, or null, if empty.
		/// </returns>
		public virtual Comparable findMin()
		{
			if (Empty)
				return null;
			return root.element;
		}
		
		/// <summary> Remove the smallest item from the priority queue.</summary>
		/// <returns> the smallest item, or null, if empty.
		/// </returns>
		public virtual Comparable deleteMin()
		{
			if (Empty)
				return null;
			
			Comparable minItem = root.element;
			root = merge(root.left, root.right);
			
			return minItem;
		}
		
		/// <summary> Make the priority queue logically empty.</summary>
		public virtual void  makeEmpty()
		{
			root = null;
		}
		
		private LeftHeapNode root; // root
		
		[STAThread]
		public static void  Main(System.String[] args)
		{
			int numItems = 100;
			LeftistHeap h = new LeftistHeap();
			LeftistHeap h1 = new LeftistHeap();
			int i = 37;
			
			for (i = 37; i != 0; i = (i + 37) % numItems)
				if (i % 2 == 0)
					h1.insert(new MyInteger(i));
				else
					h.insert(new MyInteger(i));
			
			h.merge(h1);
			for (i = 1; i < numItems; i++)
				if (((MyInteger) (h.deleteMin())).intValue() != i)
					System.Console.Out.WriteLine("Oops! " + i);
		}
	}
}